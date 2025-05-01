import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/auth/domain/entities/login_entity.dart';

enum LoginStatus { unknown, authenticated, unauthenticated }

LoginStatus loginStatus(DataState<LoginEntity> state) {
  return switch (state) {
    DataInitial<LoginEntity>() ||
    DataLoading<LoginEntity>() =>
      LoginStatus.unknown,
    DataLoaded<LoginEntity>() => LoginStatus.authenticated,
    DataError<LoginEntity>() => LoginStatus.unauthenticated,
    // TODO: Handle this case.
    DataState<LoginEntity>() => throw UnimplementedError(),
  };
}