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

  /// PATCH‑метод: подливаем баланс / память из ответа /messages
  void applyMessageUserData(Map<String, dynamic> json) {
    if (state is! DataLoaded<UserEntity>) return;
    final cur = (state as DataLoaded<UserEntity>).data;

    final updatedMoney = (json['money'] as num?)?.toDouble() ?? cur.money;
    final updatedMemory = (json['memoryUpdated'] == true)
        ? (json['newMemory'] as String? ?? cur.memory)
        : cur.memory;

    // Ничего не изменилось — просто выходим
    if (updatedMoney == cur.money && updatedMemory == cur.memory) return;

    emit(DataLoaded(UserEntity(
      id: cur.id,
      email: cur.email,
      role: cur.role,
      money: updatedMoney,
      memory: updatedMemory,
      memoryEnabled: cur.memoryEnabled,
      aiCanUpdateMemory: cur.aiCanUpdateMemory,
      standartModelUriId: cur.standartModelUriId,
    )));
  }

  /// Обновить настройки на сервере
  Future<void> updateSettings(Map<String, dynamic> body) {
    return load(() => repository.updateSettings(body));
  }
}
