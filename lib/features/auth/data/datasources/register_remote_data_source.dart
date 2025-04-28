import 'package:promts_application_1/core/service/network_service.dart';
import 'package:promts_application_1/di/locator.dart';
import '../models/register_model.dart';

abstract class RegisterRemoteDataSource {
  Future<RegisterModel> register(String email, String password);
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final ApiService api = getIt<ApiService>();

  @override
  Future<RegisterModel> register(String email, String password) {
    return api.post<RegisterModel>(
      '/auth/reg',
      body: {
        'email': email,
        'password': password,
      },
      fromJson: (json) => RegisterModel.fromJson(json),
    );
  }
}