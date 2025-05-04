import 'package:promts_application_1/core/service/network_service.dart';
import 'package:promts_application_1/di/locator.dart';
import '../models/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<MessageModel>> fetchMessages(int chatId);
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
}
