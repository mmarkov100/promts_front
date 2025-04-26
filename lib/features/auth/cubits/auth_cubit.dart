// ignore: depend_on_referenced_packages
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/auth/domain/entities/token_check_entity.dart';
import 'package:promts_application_1/features/auth/domain/repositories/auth_repository.dart';

class AuthCubit extends DataCubit<TokenCheckEntity> {
  final AuthRepository repository;
  AuthCubit({required this.repository}) : super(){
    fetch();
  }

  void fetch() => load(() => repository.checkToken());
}
