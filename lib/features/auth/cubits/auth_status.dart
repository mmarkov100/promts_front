import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/auth/domain/entities/token_check_entity.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

AuthStatus authStatus(DataState<TokenCheckEntity> state) {
  return switch (state) {
    DataInitial<TokenCheckEntity>() ||
    DataLoading<TokenCheckEntity>() =>
      AuthStatus.unknown,
    DataLoaded<TokenCheckEntity>() => AuthStatus.authenticated,
    DataError<TokenCheckEntity>() => AuthStatus.unauthenticated,
    // TODO: Handle this case.
    DataState<TokenCheckEntity>() => throw UnimplementedError(),
  };
}
