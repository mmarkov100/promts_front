class AppConfig {
  final String _baseUrl;
  final String _jwtToken;
  AppConfig(this._baseUrl, this._jwtToken);

  final int _userId = 2;

  String getBaseUrl(){

    return _baseUrl;
  }

  String getJwtToken(){

    return _jwtToken;
  }

  int getUserId(){

    return _userId;
  }
}