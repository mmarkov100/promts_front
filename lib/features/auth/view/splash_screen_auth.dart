import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/auth/cubits/auth_cubit.dart';
import 'package:promts_application_1/features/auth/domain/entities/token_check_entity.dart';
import 'package:promts_application_1/features/auth/view/login_page_screen.dart';
import 'package:promts_application_1/features/main/view/widgets/widget_main_screen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, DataState<TokenCheckEntity>>(
      listener: (context, state) {
        if (state is DataLoaded<TokenCheckEntity>) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const WidgetMainScreen()),
          );
        } else if (state is DataError<TokenCheckEntity>) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPageScreen()),
          );
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}