import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/message/cubits/message_state.dart';
import 'package:promts_application_1/features/message/data/models/message_model.dart';
import 'package:promts_application_1/features/shared/widgets/widget_snack_bar.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';
import '../domain/entities/message_entity.dart';
import '../domain/repositories/message_repository.dart';

class MessageCubit extends Cubit<MessageState> {
  // Меняем DataCubit на Cubit<MessageState>
  final MessageRepository repo;
  MessageCubit({required this.repo})
      : super(const MessageInitial()); // Начальное состояние
  int? _lastChatId;
  int _reqToken = 0;

  void fetch(int chatId, {bool force = false}) {
    if (!force &&
        _lastChatId == chatId &&
        (state is MessageLoaded && !(state as MessageLoaded).isGenerating)) {
      return;
    }

    _lastChatId = chatId;
    final myToken = ++_reqToken;

    emit(const MessageLoadingHistory());

    repo.fetchMessages(chatId).then((msgs) {
      if (myToken != _reqToken) return;
      emit(MessageLoaded(msgs, isGenerating: false));
    }).catchError((e) {
      if (myToken != _reqToken) return;
      emit(MessageError(e.toString()));
    });
  }

  int? get currentChatId => _lastChatId;

  void removeMessages() {
    List<MessageEntity> msgs = [];
    emit(MessageLoaded(msgs, isGenerating: false));
  }

  // Этот метод может быть не нужен, или его логика должна быть пересмотрена.
  // Если сообщение добавляется локально перед отправкой, то isGenerating должно быть false.
  void addFirstMessage(MessageEntity message) {
    List<MessageEntity> msgs = [message];
    emit(MessageLoaded(msgs, isGenerating: false));
  }

  Future<void> send({
    required int chatId,
    required int modelUriId,
    required String text,
    required BuildContext context,
  }) async {
    final draft = MessageEntity(
      id: -DateTime.now().millisecondsSinceEpoch,
      chatId: chatId,
      modelUriId: modelUriId,
      oldMessage: false,
      role: 'USER',
      text: text,
      type: 'MESSAGE', // В соответствии с GET /messages/{chatId}/new
      dateCreate: DateTime.now(),
    );

    List<MessageEntity> messagesBeforeSending;
    if (state is MessageLoaded) {
      messagesBeforeSending =
          List<MessageEntity>.from((state as MessageLoaded).messages);
    } else {
      // Если state не MessageLoaded (e.g., MessageInitial, MessageLoadingHistory, MessageError),
      // начинаем с пустого списка или списка только с draft.
      // Для случая первого сообщения в новом чате (после removeMessages), messagesBeforeSending будет пустым.
      messagesBeforeSending = <MessageEntity>[];
    }

    // Эмитим состояние с сообщением пользователя и индикатором загрузки
    emit(MessageLoaded([...messagesBeforeSending, draft], isGenerating: true));

    try {
      final userCubit = context.read<UserCubit>();
      String? prevMemory;
      final userState = userCubit.state;
      if (userState is DataLoaded<UserEntity>) {
        // Используем DataLoaded от UserCubit
        prevMemory = userState.data.memory;
      }

      final res = await repo.sendMessage(chatId, modelUriId, text);

      final msgData = res['messageRequest'] as Map<String, dynamic>;
      final assistantMessage = MessageModel.fromJson({
        'id': msgData['id'],
        'chatId': chatId,
        'modelUriId': modelUriId,
        'oldMessage': false,
        'role': 'assistant',
        'type': 'MESSAGE', // В соответствии с GET /messages/{chatId}/new
        'text': msgData['text'],
        'dateCreate': msgData['dateCreate'],
      });

      final userData = res['user'] as Map<String, dynamic>;
      if (userState is DataLoaded<UserEntity>) {
        // Используем DataLoaded от UserCubit
        userCubit.applyMessageUserData(userData);
        if (userData['memoryUpdated'] == true && prevMemory != null) {
          WidgetSnackBar.showMemoryChange(
            context: context,
            oldMemory: prevMemory,
            newMemory: userData['newMemory'] as String? ?? '',
          );
        }
      }

      final finalMessages = List<MessageEntity>.from(messagesBeforeSending)
        ..add(draft) // Добавляем сообщение пользователя
        ..add(assistantMessage); // Добавляем ответ ассистента

      emit(MessageLoaded(finalMessages, isGenerating: false));
    } catch (e) {
      emit(MessageLoaded([...messagesBeforeSending, draft],
          isGenerating: false));
      WidgetSnackBar.showError(context, e.toString());
    }
  }
}
