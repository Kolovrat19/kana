import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kana/components/grey_inner_box.dart';
import 'package:kana/components/white_box.dart';
import 'package:kana/controllers/kana_controller.dart';
import 'package:kana/providers/message_provider.dart';
import 'package:kana/providers/stroke_provider.dart';
import 'package:kana/router.dart';
import 'package:kana/screens/home_screen.dart';
import 'package:kana/style/theme.dart';
import 'package:kana/utils/constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const KanaApp());
}

class KanaApp extends StatefulWidget {
  const KanaApp({super.key});

  @override
  State<KanaApp> createState() => _KanaAppState();
}

class _KanaAppState extends State<KanaApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    AppRouter appRouter = AppRouter(
      navigatorKey: navigatorKey,
    );
    KanaControler kanaControler = KanaControler();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StrokeProvider(kanaControler)),
        ChangeNotifierProvider(create: (_) => MessageProvider(kanaControler)),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: theme,
        routerConfig: appRouter.router,
      ),
    );
  }
}
