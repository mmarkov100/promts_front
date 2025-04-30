import 'package:promts_application_1/features/auth/domain/entities/token_check_entity.dart';
import '../entities/login_entity.dart';

abstract class AuthRepository {
  Future<TokenCheckEntity> checkToken();
  Future<LoginEntity> login(String email, String password);
}
