import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
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

  // void fetch(int chatId) => load(() => repo.fetchMessages(chatId));

  void fetch(int chatId) {
    // Если уже загружали этот чат и данные есть – повторный запрос не нужен
    if (_lastChatId == chatId && state is DataLoaded<List<MessageEntity>>) {
      return;
    }
    _lastChatId = chatId;
    load(() => repo.fetchMessages(chatId));
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
      role: 'USER',
      type: 'User',
      text: text,
      dateCreate: DateTime.now(),
    );
    if (state is DataLoaded<List<MessageEntity>>) {
      emit(DataLoaded([...(state as DataLoaded).data, draft]));
    }

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
      if (state is DataLoaded<List<MessageEntity>>) {
        final current = (state as DataLoaded<List<MessageEntity>>)
            .data
            .where((m) => m.id != draft.id)
            .toList()
          ..addAll([
            MessageModel.fromEntity(draft), // сам пользователь
            assistant // ассистент
          ]);
        final modelId = modelUriId; // тот, с которым мы отправляли
        // ignore: use_build_context_synchronously
        context.read<ChatCubit>().patchModel(chatId, modelId);
        emit(DataLoaded(current));
      }
    } catch (e) {
      WidgetSnackBar.showError(context, e.toString());
      fetch(chatId); // откатим список
    }
  }
}
