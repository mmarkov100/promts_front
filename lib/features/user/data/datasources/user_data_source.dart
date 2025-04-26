import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:promts_application_1/core/config/config.dart';
import 'package:promts_application_1/di/locator.dart';
import 'package:promts_application_1/features/user/data/models/user_model.dart';

class UserRemoteDataSource {
  final http.Client client;
  final AppConfig datasourceConfig = getIt<AppConfig>();

  UserRemoteDataSource({required this.client});

  Future<UserModel> getUserModel(String jwtToken) async {
    //TODO Обратно поменять на гет запрос, а то нгрок хуета какая-то
    final response = await client.post(
      Uri.parse('${datasourceConfig.getBaseUrl()}/user'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return UserModel.fromJson(jsonMap);
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? 'Ошибка');
    }
  }
}
