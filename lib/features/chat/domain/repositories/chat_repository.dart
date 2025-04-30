import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';

abstract class ChatRepository {
  Future<List<ChatEntity>> fetchChats();
  Future<ChatEntity> updateChat(Map<String, dynamic> body);
}