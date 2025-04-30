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
      } else {
        // если список не был загружен, загрузим его заново
        fetchChats();
      }
    } catch (e, st) {
      print("Ошибка при обновлении чата: $e\n$st");
      emit(DataError<List<ChatEntity>>(e.toString()));
    }
  }
}
