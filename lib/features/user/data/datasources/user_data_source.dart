import 'package:promts_application_1/core/service/network_service.dart';
import 'package:promts_application_1/di/locator.dart';
import 'package:promts_application_1/features/user/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserModel();
  Future<UserModel> updateUserSettings(Map<String, dynamic> body);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiService api = getIt<ApiService>();

  UserRemoteDataSourceImpl();

  @override
  Future<UserModel> getUserModel() async {
    //TODO Обратно поменять на гет запрос, а то нгрок хуета какая-то
    return api.post<UserModel>(
      '/user',
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  Future<UserModel> updateUserSettings(Map<String, dynamic> body) {
    return api.put<UserModel>(
      '/user/settings', // PUT на конкретный ресурс
      body: body,
      fromJson: (json) => UserModel.fromJson(json),
    );
  }
}
