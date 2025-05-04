import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_datasource.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remote;

  MessageRepositoryImpl({required this.remote});

  @override
  Future<List<MessageEntity>> fetchMessages(int chatId) =>
      remote.fetchMessages(chatId);
}
