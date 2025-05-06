import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promts_application_1/di/locator.dart';
import 'package:promts_application_1/features/auth/cubits/auth_cubit.dart';
import 'package:promts_application_1/features/auth/cubits/login_cubit.dart';
import 'package:promts_application_1/features/auth/cubits/register_cubit.dart';
import 'package:promts_application_1/features/auth/domain/entities/login_entity.dart';
import 'package:promts_application_1/features/auth/domain/entities/register_entity.dart';
import 'package:promts_application_1/core/config/config.dart';
import 'package:promts_application_1/core/cubits/data_cubit.dart';
import 'package:promts_application_1/features/shared/widgets/widget_snack_bar.dart';
import 'package:animated_gradient_background/animated_gradient_background.dart';

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _passwordVisible = false;

  Future<void> _onLoginPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      WidgetSnackBar.showError(context, "Заполните все поля");
      return;
    }

    final loginCubit = context.read<LoginCubit>();
    await loginCubit.login(email, password);
  }

  Future<void> _onRegisterPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      WidgetSnackBar.showError(context, "Заполните все поля");
      return;
    }

    if (password != confirmPassword) {
      WidgetSnackBar.showError(context, "Пароли не совпадают");
      return;
    }

    final registerCubit = context.read<RegisterCubit>();
    await registerCubit.register(email, password);
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<LoginCubit, DataState<LoginEntity>>(
            listener: (context, state) {
              if (state is DataLoading<LoginEntity>) {
                setState(() {
                  _isLoading = true;
                });
              } else if (state is DataLoaded<LoginEntity>) {
                final token = state.data.token;
                getIt<AppConfig>().setJwtToken(token);
                context.read<AuthCubit>().fetch();
                context.go('/chat');
              } else if (state is DataError<LoginEntity>) {
                WidgetSnackBar.showError(context, state.message);
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
          BlocListener<RegisterCubit, DataState<RegisterEntity>>(
            listener: (context, state) {
              if (state is DataLoading<RegisterEntity>) {
                setState(() {
                  _isLoading = true;
                });
              } else if (state is DataLoaded<RegisterEntity>) {
                WidgetSnackBar.showSuccess(context, state.data.message);
                setState(() {
                  _isLogin = true;
                  _isLoading = false;
                });
              } else if (state is DataError<RegisterEntity>) {
                WidgetSnackBar.showError(context, state.message);
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
        ],
        child: AnimatedGradientBackground(
          colors: const [
            Color.fromARGB(255, 183, 183, 183),
            Color.fromARGB(255, 48, 66, 93),
            Color.fromARGB(255, 0, 0, 0),
          ],
          duration: const Duration(seconds: 5),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isLogin ? "Вход в систему" : "Регистрация",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Почта",
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.white54),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Пароль",
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.white54),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        if (!_isLogin) ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: !_passwordVisible,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Подтверждение пароля",
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.white54),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            onPressed: _isLoading
                                ? null
                                : _isLogin
                                    ? _onLoginPressed
                                    : _onRegisterPressed,
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    _isLogin ? "Войти" : "Зарегистрироваться"),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading ? null : _toggleMode,
                          child: Text(
                            _isLogin
                                ? "Нет аккаунта? Зарегистрироваться"
                                : "Уже есть аккаунт? Войти",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
