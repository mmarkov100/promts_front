// core/network/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:promts_application_1/di/locator.dart';
import 'package:promts_application_1/core/config/config.dart';

class ApiService {
  final http.Client _client = getIt<http.Client>();
  final AppConfig _config = getIt<AppConfig>();

  ApiService();
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${_config.getJwtToken()}',
  };

  Uri _makeUri(String path, [Map<String, dynamic>? query]) {
    final base = Uri.parse(_config.getBaseUrl());
    return base.replace(path: '${base.path}$path', queryParameters: query);
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final res = await _client.get(_makeUri(path, query), headers: _headers);
    return _decodeSingle(res, fromJson);
  }

  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final res = await _client.post(
      _makeUri(path, query),
      headers: _headers,
      body: body == null ? null : json.encode(body),
    );
    return _decodeSingle(res, fromJson);
  }

  Future<List<T>> getList<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic>) fromJsonItem,
  }) async {
    final res = await _client.get(_makeUri(path, query), headers: _headers);
    return _decodeList(res, fromJsonItem);
  }

  Future<List<T>> postList<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    required T Function(Map<String, dynamic>) fromJsonItem,
  }) async {
    final res = await _client.post(
      _makeUri(path, query),
      headers: _headers,
      body: body == null ? null : json.encode(body),
    );
    return _decodeList(res, fromJsonItem);
  }

  T _decodeSingle<T>(
    http.Response res,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final decodedString = utf8.decode(res.bodyBytes);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> jsonMap = json.decode(decodedString);
      return fromJson(jsonMap);
    }
    final Map<String, dynamic> err = json.decode(decodedString);
    throw Exception(err['message'] ?? 'Ошибка ${res.statusCode}');
  }

  List<T> _decodeList<T>(
    http.Response res,
    T Function(Map<String, dynamic>) fromJsonItem,
  ) {
    final decodedString = utf8.decode(res.bodyBytes);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final List<dynamic> jsonList = json.decode(decodedString);
      return jsonList
          .map((e) => fromJsonItem(e as Map<String, dynamic>))
          .toList();
    }
    final Map<String, dynamic> err = json.decode(decodedString);
    throw Exception(err['message'] ?? 'Ошибка ${res.statusCode}');
  }
}
