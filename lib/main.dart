import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:promts_application_1/features/auth/data/implimintations/auth_repository_impl.dart';
import 'package:promts_application_1/features/auth/view/cubits/auth_cubit.dart';
import 'package:promts_application_1/features/auth/view/splash_screen_auth.dart';
import 'package:promts_application_1/features/neuro/data/datasources/neuro_datasource.dart';
import 'package:promts_application_1/features/neuro/data/implimintations/neuro_repository_impl.dart';
import 'package:promts_application_1/features/neuro/view/cubits/neuro_cubit.dart';
import 'package:http/http.dart' as http;

void main() {
  // Настраиваем зависимости для NeuroCubit
  final neuroRemote = NeuroRemoteDataSource(client: http.Client());
  final neuroRepo = NeuroRepositoryImpl(remoteDataSource: neuroRemote);

  // Настраиваем зависимости для AuthCubit (пример)
  final authRemote = AuthRemoteDataSourceImpl(client: http.Client());
  final authRepo = AuthRepositoryImpl(remoteDataSource: authRemote);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(repository: authRepo)
            ..checkToken(),
        ),
        BlocProvider<NeuroCubit>(
          create: (_) => NeuroCubit(repository: neuroRepo)
            ..fetchNeuroData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Promts',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
