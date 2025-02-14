import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaijingo/controllers/kana_controller.dart';
import 'package:gaijingo/core/blocs/auth/auth_bloc.dart';
import 'package:gaijingo/core/blocs/auth/auth_event.dart';
import 'package:gaijingo/providers/message_provider.dart';
import 'package:gaijingo/providers/stroke_provider.dart';
import 'package:gaijingo/router.dart';
import 'package:gaijingo/style/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    Provider<AuthBloc>(create: (_) => AuthBloc()..add(AuthInitialEvent())),
    ChangeNotifierProvider(create: (_) => StrokeProvider(KanaControler())),
    ChangeNotifierProvider(create: (_) => MessageProvider(KanaControler())),
  ], child: const GaijinGoApp()));
}

class GaijinGoApp extends StatefulWidget {
  const GaijinGoApp({super.key});

  @override
  State<GaijinGoApp> createState() => _GaijinGoAppState();
}

class _GaijinGoAppState extends State<GaijinGoApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(context);
    AppRouter appRouter = AppRouter(
      authBloc: authBloc,
      navigatorKey: navigatorKey,
    );
    return MaterialApp.router(
      title: 'GaijinGo',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: appRouter.router,
    );
  }
}
