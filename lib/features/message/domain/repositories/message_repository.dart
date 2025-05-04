import '../entities/message_entity.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>> fetchMessages(int chatId);
  // NEW ↓
  Future<Map<String, dynamic>> sendMessage(
      int chatId, int modelUriId, String text);

  Future<Map<String, dynamic>> regenerateMessage(int messageId, int modelUriId);
}
