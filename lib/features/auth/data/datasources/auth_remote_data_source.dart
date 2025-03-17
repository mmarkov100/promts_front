// auth_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:promts_application_1/features/auth/data/models/token_check_model.dart';

abstract class AuthRemoteDataSource {
  Future<TokenCheckModel> tokenCheck(String jwtToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<TokenCheckModel> tokenCheck(String jwtToken) async {
    final url = Uri.parse('https://bc7f-104-253-187-142.ngrok-free.app/user/tokencheck');
    final response = await client.post(
      url,
      headers: {
        'Authorization': jwtToken,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return TokenCheckModel.fromJson(jsonData);
    } else {
      // Обработка ошибки: можно выбросить исключение или вернуть модель с ошибкой
      throw Exception('Ошибка запроса: ${response.statusCode}');
    }
  }
}
