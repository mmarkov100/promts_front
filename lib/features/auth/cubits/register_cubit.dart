import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/auth/domain/entities/register_entity.dart';
import 'package:promts_application_1/features/auth/domain/repositories/register_repository.dart';


class RegisterCubit extends DataCubit<RegisterEntity> {
  final RegisterRepository repository;

  RegisterCubit({required this.repository}) : super();

  Future<void> register(String email, String password) async {
    await load(() => repository.register(email, password));
  }
}