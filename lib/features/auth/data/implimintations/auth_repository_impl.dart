import 'package:promts_application_1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:promts_application_1/features/auth/domain/entities/token_check_entity.dart';
import 'package:promts_application_1/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TokenCheckEntity> checkToken() async {
    final tokenCheckModel = await remoteDataSource.tokenCheck();
    return tokenCheckModel;
  }
}
