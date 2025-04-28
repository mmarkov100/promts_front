import '../../domain/entities/register_entity.dart';
import '../../domain/repositories/register_repository.dart';
import '../datasources/register_remote_data_source.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RegisterEntity> register(String email, String password) {
    return remoteDataSource.register(email, password);
  }
}