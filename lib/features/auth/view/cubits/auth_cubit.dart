// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:promts_application_1/features/auth/domain/usecases/check_token_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final CheckTokenUseCase checkTokenUseCase;

  AuthCubit({required this.checkTokenUseCase}) : super(AuthInitial());

  Future<void> checkToken(String jwtToken) async {
    emit(AuthLoading());
    try {
      final result = await checkTokenUseCase(jwtToken);
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
