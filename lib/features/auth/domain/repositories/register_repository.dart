import '../entities/register_entity.dart';

abstract class RegisterRepository {
  Future<RegisterEntity> register(String email, String password);
}