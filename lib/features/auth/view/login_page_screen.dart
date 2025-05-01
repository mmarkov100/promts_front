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
import 'package:promts_application_1/features/main/view/widgets/widget_snack_bar.dart';

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

  bool _isLogin = true; // true — экран входа, false — экран регистрации
  bool _isLoading = false;
  bool _passwordVisible = false; // для скрытия/показа пароля

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

              context.read<AuthCubit>().fetch(); // 🔄 быстрый повторный check
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
                _isLogin = true; // Переходим на экран входа
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
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isLogin ? "Вход в систему" : "Регистрация",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Почта",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: "Пароль",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                        decoration: InputDecoration(
                          labelText: "Подтверждение пароля",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                        onPressed: _isLoading
                            ? null
                            : _isLogin
                                ? _onLoginPressed
                                : _onRegisterPressed,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(_isLogin ? "Войти" : "Зарегистрироваться"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isLoading ? null : _toggleMode,
                      child: Text(
                        _isLogin
                            ? "Нет аккаунта? Зарегистрироваться"
                            : "Уже есть аккаунт? Войти",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
