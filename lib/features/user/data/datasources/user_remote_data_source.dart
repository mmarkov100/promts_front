import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:promts_application_1/features/user/data/models/user_response_dto.dart';

abstract class UserRemoteDataSource {
  Future<UserResponseDTO> loginUser({required String token});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final urlBack = "http://localhost:8090/user";

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserResponseDTO> loginUser({required String token}) async {
    final url = Uri.parse("$urlBack/login"); 
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      // Теперь парсим через ваш DTO
      final userResponse = UserResponseDTO.fromJson(decoded);
      return userResponse;
    } else {
      throw Exception("Ошибка при загрузке: ${response.body}");
    }
  }
}

