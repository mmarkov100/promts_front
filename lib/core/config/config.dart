class AppConfig {

  final String _baseUrl = "http://localhost:8090";
  //final String _baseUrl = "https://1042-104-253-187-142.ngrok-free.app";
  final String _jwtToken = "1234jwt";
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