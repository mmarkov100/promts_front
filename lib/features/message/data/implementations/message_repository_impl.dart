import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_datasource.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remote;

  MessageRepositoryImpl({required this.remote});

  @override
  Future<List<MessageEntity>> fetchMessages(int chatId) =>
      remote.fetchMessages(chatId);

  @override
  Future<Map<String, dynamic>> sendMessage(
          int chatId, int modelUriId, String text) =>
      remote.sendMessage(chatId: chatId, modelUriId: modelUriId, text: text);

  @override
  Future<Map<String, dynamic>> regenerateMessage(
          int messageId, int modelUriId) =>
      remote.regenerateMessage(messageId: messageId, modelUriId: modelUriId);
}
