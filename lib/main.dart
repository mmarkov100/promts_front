import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/router/router.dart';
import 'package:promts_application_1/di/locator.dart';
import 'package:promts_application_1/features/auth/cubits/auth_cubit.dart';
import 'package:promts_application_1/features/auth/cubits/login_cubit.dart';
import 'package:promts_application_1/features/auth/cubits/register_cubit.dart';
import 'package:promts_application_1/features/chat/cubits/chat_cubit.dart';
import 'package:promts_application_1/features/message/cubits/message_cubit.dart';
import 'package:promts_application_1/features/neuro/cubits/neuro_cubit.dart';
import 'package:promts_application_1/features/user/cubit/user_cubit.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  // Вот эта хуйня отвечает за решетку, если решетка не будет, значит любой переход по ссылке будто снова на сайт заходишь
  setUrlStrategy(PathUrlStrategy());
  // 0 - продовый, 1 - тестовый (вообще пока не работает)
  setup(0, "http://localhost:8090", "1234jwt");
  //setup(0, "https://a610-104-253-187-142.ngrok-free.app", "1234jwt");
  final authCubit = getIt<AuthCubit>();
  final loginCubit = getIt<LoginCubit>();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: loginCubit),
        BlocProvider(create: (_) => getIt<MessageCubit>()),
        BlocProvider(create: (_) => getIt<RegisterCubit>()),
        BlocProvider(create: (_) => getIt<UserCubit>()),
        BlocProvider(create: (_) => getIt<ChatCubit>()),
        BlocProvider(create: (_) => getIt<NeuroCubit>()),
      ],
      child: MyApp(
        authCubit: authCubit,
        loginCubit: loginCubit,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;
  final LoginCubit loginCubit;
  const MyApp({super.key, required this.authCubit, required this.loginCubit});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Promts',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: buildRouter(authCubit, loginCubit),
    );
  }
}
