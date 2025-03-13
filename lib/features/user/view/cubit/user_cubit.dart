import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/user/domain/usecases/login_user_usecase.dart';
import 'package:promts_application_1/features/user/view/cubit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final LoginUserUseCase loginUserUseCase;

  UserCubit({
    required this.loginUserUseCase,
  }) : super(UserInitial());

  Future<void> loadUserOnAppStart() async {
    emit(UserLoading());

    const token = "myFakeBearerToken";

    final eitherResult = await loginUserUseCase(
      token: token,
    );

    eitherResult.fold(
      (failure) {
        // Пришло ошибочное состояние
        emit(UserError(failure.toString()));
      },
      (loginResult) {
        // Здесь loginResult содержит user, chats, neuralNetworks и т.д.
        emit(UserLoaded(
          user: loginResult.user,
          chats: loginResult.chats,
          networks: loginResult.neuralNetworks,
        ));
      },
    );
  }
}
