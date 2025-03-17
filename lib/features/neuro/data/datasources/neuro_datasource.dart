import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:promts_application_1/features/neuro/data/models/neuro_model.dart';


class NeuroRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  NeuroRemoteDataSource({
    required this.baseUrl,
    required this.client,
  });

  Future<List<NeuroModel>> getNeuroData(String token, int userId) async {
    final url = Uri.parse('$baseUrl/neuro');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'id': '$userId',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => NeuroModel.fromJson(json)).toList();
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? 'Ошибка авторизации');
    }
  }
}
