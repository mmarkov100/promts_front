// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:promts_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(AuthInitial());

  Future<void> checkToken() async {
    emit(AuthLoading());
    try {
      final result = await repository.checkToken();
      if (result.success) {
        emit(AuthSuccess(result.message));
      } else {
        emit(AuthFailure(result.error ?? 'Ошибка авторизации'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
