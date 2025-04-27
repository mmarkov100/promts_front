import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser();
  Future<UserEntity> updateSettings(Map<String, dynamic> body);
}
