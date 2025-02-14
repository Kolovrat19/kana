import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijingo/core/blocs/auth/auth_bloc.dart';
import 'package:gaijingo/core/blocs/auth/auth_state.dart';
import 'package:gaijingo/screens/draw_kana_screen.dart';
import 'package:gaijingo/screens/home_screen.dart';
import 'package:gaijingo/screens/login_screen.dart';
import 'package:gaijingo/screens/signup_screen.dart';
import 'package:gaijingo/screens/splash_screen.dart';
import 'package:gaijingo/screens/start_screen.dart';

enum Routes {
  splash('/splash'),
  start('/start'),
  login('/login'),
  signup('/signup'),
  home('/home'),
  draw('/draw'),
  resetPassword('/resetPassword'),
  authError('/authError'),
  qrScanner('/qrScanner');

  const Routes(this.path);
  final String path;
}

class AppRouter {
  final GlobalKey<NavigatorState>? navigatorKey;
  final AuthBloc authBloc;
  AuthStatus? _previousStatus;
  AppRouter({required this.authBloc, required this.navigatorKey});

  late final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.splash.path,
    routes: [
      GoRoute(
        path: Routes.splash.path,
        name: Routes.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.start.path,
        name: Routes.start.name,
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: Routes.signup.path,
        name: Routes.signup.name,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.home.path,
        name: Routes.home.name,
        builder: (context, state) => const HomeScreen(title: 'GaijinGo'),
      ),
      GoRoute(
        path: Routes.draw.path,
        name: Routes.draw.name,
        builder: (context, state) => const DrawKanaScreen(),
      ),
    ],
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      if (authBloc.state.status == _previousStatus) {
        return null;
      }
      _previousStatus = authBloc.state.status;
      // if (kDebugMode) {
      print('STATE: ${authBloc.state.status}');
      // }
      switch (authBloc.state.status) {
        case AuthStatus.logout:
          return Routes.start.path;
        case AuthStatus.unauthenticated:
          return Routes.start.path;
        case AuthStatus.authenticated:
          return Routes.home.path;
        // case AuthStatus.loading:
        //   return Routes.loading.path;
        case AuthStatus.error:
        return Routes.login.path;
        case AuthStatus.initial:
          return Routes.splash.path;
        case AuthStatus.networkError:
        // return Routes.networkError.path;
      }
      return null;
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
