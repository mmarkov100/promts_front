class AppConfig {
  final String _baseUrl;
  late String _jwtToken;
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

  void setJwtToken(String token) {
  _jwtToken = token;
}

}