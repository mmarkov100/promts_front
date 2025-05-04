import 'package:promts_application_1/core/service/network_service.dart';
import 'package:promts_application_1/di/locator.dart';
import '../models/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageModel>> fetchMessages(int chatId);

  // NEW ↓
  Future<Map<String, dynamic>> sendMessage({
    required int chatId,
    required int modelUriId,
    required String text,
  });

  Future<Map<String, dynamic>> regenerateMessage({
    required int messageId,
    required int modelUriId,
  });
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final ApiService _api = getIt<ApiService>();

  @override
  Future<List<MessageModel>> fetchMessages(int chatId) {
    // TODO Обратно поменять на гет запрос, а то нгрок хуета какая-то
    return _api.postList<MessageModel>(
      '/messages/$chatId',
      fromJsonItem: MessageModel.fromJson,
    );
  }

  // NEW ↓
  @override
  Future<Map<String, dynamic>> sendMessage({
    required int chatId,
    required int modelUriId,
    required String text,
  }) =>
      _api.post<Map<String, dynamic>>(
        '/messages',
        body: {
          'chatId': chatId,
          'modelUriId': modelUriId,
          'text': text,
        },
        fromJson: (json) => json,
      );

  @override
  Future<Map<String, dynamic>> regenerateMessage({
    required int messageId,
    required int modelUriId,
  }) =>
      _api.post<Map<String, dynamic>>(
        '/messages/regenerate',
        body: {
          'messageId': messageId,
          'modelUriId': modelUriId,
        },
        fromJson: (json) => json,
      );
}
