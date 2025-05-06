import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/message/data/models/message_model.dart';
import 'package:promts_application_1/features/shared/widgets/widget_snack_bar.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';
import '../domain/entities/message_entity.dart';
import '../domain/repositories/message_repository.dart';

class MessageCubit extends DataCubit<List<MessageEntity>> {
  final MessageRepository repo;
  MessageCubit({required this.repo}) : super();
  int? _lastChatId;
  int _reqToken = 0; // 🔸 счётчик запросов

  /// Загрузка истории чата
  void fetch(int chatId, {bool force = false}) {
    // повторно не дёргаем, если данные уже есть
    if (!force &&
        _lastChatId == chatId &&
        state is DataLoaded<List<MessageEntity>>) return;

    _lastChatId = chatId;
    final myToken = ++_reqToken; // для этого запроса

    emit(DataLoading()); // очищаем экран / показываем спиннер

    repo.fetchMessages(chatId).then((msgs) {
      if (myToken != _reqToken) return; // ⚠️ устарело — просто игнорируем
      emit(DataLoaded(msgs));
    }).catchError((e) {
      if (myToken != _reqToken) return; // тоже устарело
      emit(DataError(e.toString()));
    });
  }

  /// Текущий чат (может пригодиться в UI)
  int? get currentChatId => _lastChatId;

  void removeMessages() {
    List<MessageEntity> msgs = [];
    emit(DataLoaded(msgs));
  }

  void addFirstMessage(MessageEntity message) {
    List<MessageEntity> msgs = [];
    msgs.add(message);
    emit(DataLoaded(msgs));
  }

  /// Отправка нового сообщения
  Future<void> send({
    required int chatId,
    required int modelUriId,
    required String text,
    required BuildContext context,
  }) async {
    // добавляем сообщение‑черновик пользователя сразу
    final draft = MessageEntity(
      id: -DateTime.now().millisecondsSinceEpoch, // временный id
      chatId: chatId,
      modelUriId: modelUriId,
      oldMessage: false,
      role: 'user',
      type: 'User',
      text: text,
      dateCreate: DateTime.now(),
    );

    // ⬇️ NEW — формируем актуальный список независимо от текущего стейта
    final current = state is DataLoaded<List<MessageEntity>>
        ? List<MessageEntity>.from((state as DataLoaded).data)
        : <MessageEntity>[];

    emit(DataLoaded([...current, draft]));

    // if (state is DataLoaded<List<MessageEntity>>) {
    //   emit(DataLoaded([...(state as DataLoaded).data, draft]));
    // }

    try {
      final userCubit = context.read<UserCubit>();
      final prevMemory =
          (userCubit.state as DataLoaded<UserEntity>).data.memory;

      final res = await repo.sendMessage(chatId, modelUriId, text);

      // 1. Ответ нейросети
      final msg = res['messageRequest'] as Map<String, dynamic>;
      final assistant = MessageModel.fromJson({
        'id': msg['id'],
        'chatId': chatId,
        'modelUriId': modelUriId,
        'oldMessage': false,
        'role': 'ASSISTANT',
        'type': 'Assistant',
        'text': msg['text'],
        'dateCreate': msg['dateCreate'],
      });

      // 2. Память / баланс
      final user = res['user'] as Map<String, dynamic>;

      context.read<UserCubit>().applyMessageUserData(user);

      if (user['memoryUpdated'] == true) {
        WidgetSnackBar.showMemoryChange(
          context: context,
          oldMemory: prevMemory,
          newMemory: user['newMemory'] as String? ?? '',
        );
      }

      // 3. Обновляем список
      final updated = current
          .where((m) => m.id != draft.id) // убрали черновик‑placeholder
          .toList()
        ..addAll([
          MessageModel.fromEntity(
              draft), // финальная копия сообщения пользователя
          assistant, // ответ нейросети
        ]);

      emit(DataLoaded(updated));
    } catch (e) {
      WidgetSnackBar.showError(context, e.toString());
    }
  }
}
