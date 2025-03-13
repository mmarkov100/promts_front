import 'package:dartz/dartz.dart';
import 'package:promts_application_1/features/user/data/models/user_response_dto.dart';

abstract class UserRepository {
  Future<Either<String, UserResponseDTO>> loginUser({required String token});
}

