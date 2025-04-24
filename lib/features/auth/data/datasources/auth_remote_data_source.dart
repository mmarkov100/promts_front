import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:promts_application_1/core/config/config.dart';
import 'package:promts_application_1/features/auth/data/models/token_check_model.dart';

abstract class AuthRemoteDataSource {
  Future<TokenCheckModel> tokenCheck(String jwtToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final AppConfig datasourceConfig = AppConfig();

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<TokenCheckModel> tokenCheck(String jwtToken) async {
    print("Attempting request to /auth/tokencheck");
    final url = Uri.parse('${datasourceConfig.getBaseUrl()}/auth/tokencheck');
    //TODO Обратно поменять на гет запрос, а то нгрок хуета какая-то
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    final decodedBody = utf8.decode(response.bodyBytes);
    print("Got response: ${response.statusCode}, body: $decodedBody");

    if (response.statusCode == 200) {
      final jsonData = json.decode(decodedBody);
      return TokenCheckModel.fromJson(jsonData);
    } else {
      final Map<String, dynamic> errorResponse = json.decode(decodedBody);
      throw Exception(errorResponse['message'] ?? 'Ошибка');
    }
  }
}
