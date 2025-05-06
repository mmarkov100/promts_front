import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/chat/domain/repositories/chat_repository.dart';

class ChatCubit extends DataCubit<List<ChatEntity>> {
  final ChatRepository repository;
  ChatCubit({required this.repository}) : super() {
    fetchChats();
  }

  void fetchChats() => load(() => repository.fetchChats());

  Future<void> saveSettings(Map<String, dynamic> body) async {
    try {
      final updated = await repository.updateChat(body);

      if (state is DataLoaded<List<ChatEntity>>) {
        final currentChats = (state as DataLoaded<List<ChatEntity>>).data;
        final newChats = currentChats.map((chat) {
          return chat.id == updated.id ? updated : chat;
        }).toList();

        emit(DataLoaded<List<ChatEntity>>(newChats));
      }
    } catch (e, st) {
      print("Ошибка при обновлении чата: $e\n$st");
      emit(DataError<List<ChatEntity>>(e.toString()));
    }
  }

  Future<ChatEntity> createChat(Map<String, dynamic> body) async {
    final newChat = await repository.createChat(body);

    if (state is DataLoaded<List<ChatEntity>>) {
      final current =
          List<ChatEntity>.from((state as DataLoaded<List<ChatEntity>>).data)
            ..add(newChat);
      emit(DataLoaded<List<ChatEntity>>(current));
    }
    return newChat;
  }

  void addLocalChat(ChatEntity chat) {
    if (state is DataLoaded<List<ChatEntity>>) {
      final current = (state as DataLoaded<List<ChatEntity>>).data;
      if (current.any((c) => c.id == chat.id)) return;
      emit(DataLoaded([...current, chat]));
    }
  }

  void patchModel(int chatId, int modelUriId) {
    if (state is! DataLoaded<List<ChatEntity>>) return;

    final updated = (state as DataLoaded<List<ChatEntity>>)
        .data
        .map((c) => c.id == chatId
            ? ChatEntity(
                id: c.id,
                userId: c.userId,
                chatBotId: c.chatBotId,
                chatName: c.chatName,
                temperature: c.temperature,
                context: c.context,
                starredChat: c.starredChat,
                useMemory: c.useMemory,
                updateMemory: c.updateMemory,
                canUseMemory: c.canUseMemory,
                canUpdateMemory: c.canUpdateMemory,
                canEditModelUri: c.canEditModelUri,
                canEditContext: c.canEditContext,
                dateEdit: c.dateEdit,
                dateCreate: c.dateCreate,
                modelUriId: modelUriId,
              )
            : c)
        .toList();

    emit(DataLoaded(updated));
  }
}
