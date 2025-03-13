import 'package:dartz/dartz.dart';
import 'package:promts_application_1/features/user/data/models/user_response_dto.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, UserResponseDTO>> loginUser({required String token}) async {
    try {
      final userResponseDTO = await remoteDataSource.loginUser(token: token);
      return Right(userResponseDTO); // все данные в одном DTO
    } catch (e) {
      return Left(e.toString()); // или какую-то свою ошибку
    }
  }
}

