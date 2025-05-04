class AppConfig {
  final String _baseUrl;
  late String _jwtToken;
  AppConfig(this._baseUrl, this._jwtToken);

  String getBaseUrl() {
    return _baseUrl;
  }

  String getJwtToken() {
    return _jwtToken;
  }

  void setJwtToken(String token) {
    _jwtToken = token;
  }
}
