import 'package:promts_application_1/features/auth/domain/entities/token_check_entity.dart';
import 'package:promts_application_1/features/auth/domain/repositories/auth_repository.dart';

class CheckTokenUseCase {
  final AuthRepository repository;

  CheckTokenUseCase({required this.repository});

  Future<TokenCheckEntity> call(String jwtToken) async {
    return await repository.checkToken(jwtToken);
  }
}
