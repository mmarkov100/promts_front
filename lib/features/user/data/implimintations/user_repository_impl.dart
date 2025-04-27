import 'package:promts_application_1/features/user/data/datasources/user_data_source.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';
import 'package:promts_application_1/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> getUser() async {
    final res = await remoteDataSource.getUserModel();
    return res;
  }

  @override
  Future<UserEntity> updateSettings(Map<String, dynamic> body) async {
    final model = await remoteDataSource.updateUserSettings(body);
    return model;
  }
}
