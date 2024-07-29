import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kana/main.dart';
import 'package:kana/screens/draw_kana_screen.dart';
import 'package:kana/screens/home_screen.dart';

enum Routes {
  splash('/splash'),
  loading('/loading'),
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

  AppRouter({required this.navigatorKey});
  late final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.home.path,
    routes: [
      GoRoute(
        path: Routes.home.path,
        name: Routes.home.name,
        builder: (context, state) => const HomePage(title: 'Kana'),
      ),
      GoRoute(
        path: Routes.draw.path,
        name: Routes.draw.name,
        builder: (context, state) => const DrawKanaScreen(),
      ),
    ],
    // refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      // if (authBloc.state.status == _previousStatus) {
      //   return null;
      // }
      // _previousStatus = authBloc.state.status;
      // if (kDebugMode) {
      //   print('STATE: ${authBloc.state.status}');
      // }
      // switch (authBloc.state.status) {
      //   case AuthStatus.logout:
      //   case AuthStatus.noProtocol:
      //     return Routes.intro.path;
      //   case AuthStatus.unauthenticated:
      //     return Routes.login.path;
      //   case AuthStatus.authenticated:
      //     return Routes.home.path;
      //   case AuthStatus.loading:
      //     return Routes.loading.path;
      //   case AuthStatus.error:
      //   // return Routes.login.path;
      //   case AuthStatus.initial:
      //     return Routes.loading.path;
      //   case AuthStatus.networkError:
      //     return Routes.networkError.path;
      // }
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
