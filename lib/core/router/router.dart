// lib/router.dart
import 'dart:async';
import 'package:flutter/foundation.dart' show ChangeNotifier, kDebugMode;
import 'package:go_router/go_router.dart';
import 'package:promts_application_1/features/auth/cubits/auth_cubit.dart';
import 'package:promts_application_1/features/auth/cubits/auth_status.dart';
import 'package:promts_application_1/features/auth/cubits/login_cubit.dart';
import 'package:promts_application_1/features/auth/view/login_page_screen.dart';
import 'package:promts_application_1/features/auth/view/splash_screen_auth.dart';
import 'package:promts_application_1/features/main/view/widgets/main_screen.dart';

class MultiStreamNotifier extends ChangeNotifier {
  MultiStreamNotifier(List<Stream<dynamic>> streams) {
    for (final s in streams) {
      _subs.add(s.listen((_) => notifyListeners()));
    }
  }
  final _subs = <StreamSubscription<dynamic>>[];
  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }
}

GoRouter buildRouter(AuthCubit authCubit, LoginCubit loginCubit) {
  return GoRouter(
    refreshListenable: MultiStreamNotifier([
      authCubit.stream,
      loginCubit.stream,
    ]),
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPageScreen()),
      GoRoute(
        path: '/chat',
        builder: (_, __) => const MainScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, state) {
              final id = int.tryParse(state.pathParameters['id']!);
              return MainScreen(openChatId: id);
            },
          ),
        ],
      ),
    ],
    redirect: (ctx, state) {
      print("REDIRECT-------------------------------------------------");
      final status = authStatus(authCubit.state);

      final atSplash = state.matchedLocation == '/';
      final atLogin = state.matchedLocation == '/login';
      

      if (status == AuthStatus.unknown) {
        return atSplash
            ? null
            : '/?from=${Uri.encodeComponent(state.matchedLocation)}';
      }

      if (status == AuthStatus.unauthenticated) {
        return atLogin ? null : '/login';
      }

      // authenticated
      if (atSplash || atLogin) {
        return state.uri.queryParameters['from'] ?? '/chat';
      }
      return null;
    },
  );
}
