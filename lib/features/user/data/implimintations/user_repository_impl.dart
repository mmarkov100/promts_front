import 'package:promts_application_1/features/user/data/datasources/user_data_source.dart';
import 'package:promts_application_1/features/user/domain/entities/user_entity.dart';
import 'package:promts_application_1/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> getUser(String token) async {
    return await remoteDataSource.getUserModel(token);
  }
}
