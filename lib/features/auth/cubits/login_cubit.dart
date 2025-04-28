import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/auth/domain/entities/login_entity.dart';
import 'package:promts_application_1/features/auth/domain/repositories/auth_repository.dart';

class LoginCubit extends DataCubit<LoginEntity> {
  final AuthRepository repository;

  LoginCubit({required this.repository}) : super();

  Future<void> login(String email, String password) async {
    await load(() => repository.login(email, password));
  }
  Future<void> register(String email, String password) async {
  await load(() => repository.register(email, password));
}
}