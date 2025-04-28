// ignore: depend_on_referenced_packages
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/user/domain/repositories/user_repository.dart';
import '../domain/entities/user_entity.dart';

class UserCubit extends DataCubit<UserEntity> {
  final UserRepository repository;
  UserCubit({required this.repository}) : super() {
    fetch();
  }

  void fetch() => load(() => repository.getUser());

  /// Обновить настройки на сервере
  Future<void> updateSettings(Map<String, dynamic> body) {
    return load(() => repository.updateSettings(body));
  }
}
