import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/di/locator.dart';
import 'package:promts_application_1/features/auth/cubits/auth_cubit.dart';
import 'package:promts_application_1/features/auth/view/splash_screen_auth.dart';
import 'package:promts_application_1/features/neuro/cubits/neuro_cubit.dart';

void main() {
  
  // 0 - продовый, 1 - тестовый (вообще пока не работает)
  //setup(0, "https://1042-104-253-187-142.ngrok-free.app", "1234jwt");
  setup(0, "http://localhost:8090", "1234jwt");
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<NeuroCubit>()),
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
