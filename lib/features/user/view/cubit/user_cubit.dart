// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:promts_application_1/features/user/domain/use_cases/get_user_data_use_case.dart';
import 'user_state.dart';
import '../../domain/entities/user_entity.dart';


class UserCubit extends Cubit<UserState> {
  final GetUserDataUseCase getUserDataUseCase;

  UserCubit({required this.getUserDataUseCase}) : super(UserInitial());

  void fetchUser(String token) async {
    emit(UserLoading());
    try {
      final UserEntity user = await getUserDataUseCase(token);
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(error: e.toString()));
    }
  }
}
