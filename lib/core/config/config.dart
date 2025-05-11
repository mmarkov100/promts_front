// lib/core/config/config.dart
import '../storage/token_storage.dart';

class AppConfig {
  final String _baseUrl;
  String _jwtToken;
  final TokenStorage _storage;

  AppConfig(this._baseUrl, this._jwtToken, this._storage);

  String getBaseUrl() => _baseUrl;
  String getJwtToken() => _jwtToken;

  Future<void> setJwtToken(String token) async {
    _jwtToken = token;
    await _storage.write(token);          // сохраняем диск/Keychain
  }

  Future<void> clearJwtToken() => setJwtToken('');
}
