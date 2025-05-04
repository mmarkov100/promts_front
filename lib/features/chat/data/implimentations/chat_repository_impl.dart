import 'package:promts_application_1/features/chat/data/datasources/chat_datasource.dart';
import 'package:promts_application_1/features/chat/domain/entities/chat_entity.dart';
import 'package:promts_application_1/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChatEntity>> fetchChats() async {
    return await remoteDataSource.fetchChats();
  }

  @override
  Future<ChatEntity> updateChat(Map<String, dynamic> body) =>
      remoteDataSource.updateChatSettings(body);

  @override
  Future<ChatEntity> createChat(Map<String, dynamic> body) =>
      remoteDataSource.createChat(body);
}
