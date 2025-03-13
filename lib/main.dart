import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/main/view/widgets/widget_main_screen.dart';
import 'package:promts_application_1/features/user/data/datasources/user_remote_data_source.dart';
import 'package:promts_application_1/features/user/data/implimintations/user_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:promts_application_1/features/user/domain/usecases/login_user_usecase.dart';
import 'package:promts_application_1/features/user/view/cubit/user_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(
            loginUserUseCase: LoginUserUseCase(UserRepositoryImpl(UserRemoteDataSourceImpl(client: http.Client()))),
          )..loadUserOnAppStart(), 
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetMainScreen(),
    );
  }
}
