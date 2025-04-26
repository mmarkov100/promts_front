import 'package:promts_application_1/core/service/network_service.dart';
import 'package:promts_application_1/di/locator.dart';
import 'package:promts_application_1/features/auth/data/models/token_check_model.dart';

abstract class AuthRemoteDataSource {
  Future<TokenCheckModel> tokenCheck();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService api = getIt<ApiService>();

  AuthRemoteDataSourceImpl();

  @override
  Future<TokenCheckModel> tokenCheck() async {
    return api.post<TokenCheckModel>(
      '/auth/tokencheck',
      fromJson: (json) => TokenCheckModel.fromJson(json),
    );
  }
}
