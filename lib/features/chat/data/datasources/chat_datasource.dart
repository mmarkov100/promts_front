import 'package:promts_application_1/core/service/network_service.dart';
import 'package:promts_application_1/di/locator.dart';
import 'package:promts_application_1/features/chat/data/models/chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> fetchChats();
  Future<ChatModel> updateChatSettings(Map<String, dynamic> body);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiService _api = getIt<ApiService>();

  @override
  Future<List<ChatModel>> fetchChats() {
    return _api.postList<ChatModel>(
      '/chats/get',
      fromJsonItem: (json) => ChatModel.fromJson(json),
    );
  }

  @override
  Future<ChatModel> updateChatSettings(Map<String, dynamic> body) {
    return _api.put<ChatModel>(
      '/chats/new',
      body: body,
      fromJson: ChatModel.fromJson,
    );
  }
}
