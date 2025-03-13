import 'package:dartz/dartz.dart';
import 'package:promts_application_1/features/user/data/models/user_response_dto.dart';
import '../repositories/user_repository.dart';

class LoginUserUseCase {
  final UserRepository repository;

  LoginUserUseCase(this.repository);

  Future<Either<String, UserResponseDTO>> call({required String token}) {
    return repository.loginUser(token: token);
  }
}

