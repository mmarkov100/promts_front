// lib/di/locator.dart
import 'package:get_it/get_it.dart';
import 'package:promts_application_1/core/config/config.dart';
import 'package:promts_application_1/core/service/network_service.dart';
import 'package:promts_application_1/features/auth/cubits/auth_cubit.dart';
import 'package:promts_application_1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:promts_application_1/features/auth/data/implimintations/auth_repository_impl.dart';
import 'package:promts_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:promts_application_1/features/neuro/cubits/neuro_cubit.dart';
import 'package:promts_application_1/features/neuro/data/datasources/neuro_datasource.dart';
import 'package:promts_application_1/features/neuro/data/implimintations/neuro_repository_impl.dart';
import 'package:promts_application_1/features/neuro/domain/repositories/neuro_repository.dart';
import 'package:http/http.dart' as http;
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
import 'package:promts_application_1/features/user/data/datasources/user_data_source.dart';
import 'package:promts_application_1/features/user/data/implimintations/user_repository_impl.dart';
import 'package:promts_application_1/features/user/domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

void setup(int appMode, String baseUrl, String jwtToken) {
  getIt.registerLazySingleton(() => AppConfig(baseUrl, jwtToken));
  getIt.registerLazySingleton(() => http.Client());

  //NetworkService
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(),
  );

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerFactory(() => AuthCubit(repository: getIt()));

  // Neuro
  getIt.registerLazySingleton<NeuroRemoteDataSource>(
      () => NeuroRemoteDataSourceImpl());
  getIt.registerLazySingleton<NeuroRepository>(
      () => NeuroRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerFactory(() => NeuroCubit(repository: getIt()));

  // User
  getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl());
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerFactory(() => UserCubit(repository: getIt()));
}
