import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserDataUseCase {
  final UserRepository repository;

  GetUserDataUseCase({required this.repository});

  Future<UserEntity> call(String token) async {
    return await repository.getUser(token);
  }
}
