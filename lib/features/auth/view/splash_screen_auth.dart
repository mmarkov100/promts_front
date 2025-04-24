import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promts_application_1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:promts_application_1/features/auth/data/implimintations/auth_repository_impl.dart';
import 'package:promts_application_1/features/auth/domain/usecases/check_token_use_case.dart';
import 'package:promts_application_1/features/auth/view/cubits/auth_cubit.dart';
import 'package:promts_application_1/features/auth/view/cubits/auth_state.dart';
import 'package:promts_application_1/features/auth/view/login_page_screen.dart';
import 'package:promts_application_1/features/main/view/widgets/widget_main_screen.dart';
import 'package:http/http.dart' as http;


class SplashScreen extends StatefulWidget {
  final String jwtToken;
  const SplashScreen({super.key, required this.jwtToken});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    final client = http.Client();
    final remoteDataSource = AuthRemoteDataSourceImpl(client: client);
    final repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);
    final useCase = CheckTokenUseCase(repository: repository);
    authCubit = AuthCubit(checkTokenUseCase: useCase);
    authCubit.checkToken(widget.jwtToken);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: authCubit,
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const WidgetMainScreen()),
          );
        } else if (state is AuthFailure) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPageScreen()),
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}