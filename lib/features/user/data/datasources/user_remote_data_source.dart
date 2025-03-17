import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSource({required this.client});

  Future<UserModel> fetchUser(String token) async {
    final response = await client.post(
      Uri.parse('https://yourapi.com/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      return UserModel.fromJson(jsonMap);
    } else {
      // Можно обработать ошибку подробнее или выбросить исключение
      throw Exception('AUTH_FAILED: ${response.body}');
    }
  }
}
