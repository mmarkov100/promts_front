import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:promts_application_1/core/config/config.dart';
import 'package:promts_application_1/features/neuro/data/models/neuro_model.dart';

class NeuroRemoteDataSource {
  final http.Client client;
  final AppConfig datasourceConfig = AppConfig();

  NeuroRemoteDataSource({
    required this.client,
  });

  Future<List<NeuroModel>> getNeuroModelList() async {
    final url = Uri.parse('${datasourceConfig.getBaseUrl()}/neuro');
    print("Attempting request to /neuro");
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${datasourceConfig.getJwtToken()}',
      },
    );

    final decodedBody = utf8.decode(response.bodyBytes);
    print("Got response: ${response.statusCode}, body: $decodedBody");

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(decodedBody);
      return jsonList.map((json) => NeuroModel.fromJson(json)).toList();
    } else {
      final Map<String, dynamic> errorResponse = json.decode(decodedBody);
      throw Exception(errorResponse['message'] ?? 'Ошибка');
    }
  }
}
