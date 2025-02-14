import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijingo/components/button_widget.dart';
import 'package:gaijingo/router.dart';
import 'package:gaijingo/utils/constants.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: Image.asset(
                'assets/images/gaijin_logo.png',
                width: 100,
                height: 100,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(
                      fontFamily: Constants.circularFontFamily,
                      fontSize: Constants.fontSize20,
                      color: Constants.titleFontColor,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  'Please enter',
                  style: TextStyle(
                    fontFamily: Constants.circularFontFamily,
                    fontSize: Constants.fontSize14,
                    color: Constants.titleFontColor,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ButtonWidget(
                  title: 'Login',
                  onPressed: (_) {
                    context.go(Routes.login.path);
                  },
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Divider(
                  color: Constants.dividerColor,
                  height: 2,
                ),
                const SizedBox(
                  height: 60.0,
                ),
                const Text(
                  'Are you new here?',
                  style: TextStyle(
                      fontFamily: Constants.circularFontFamily,
                      fontSize: Constants.fontSize20,
                      color: Constants.titleFontColor,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  'Start learning today',
                  style: TextStyle(
                    fontFamily: Constants.circularFontFamily,
                    fontSize: Constants.fontSize14,
                    color: Constants.titleFontColor,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ButtonWidget(
                  title: 'Start',
                  type: 'outline',
                  onPressed: (_) {
                    context.go(Routes.signup.path);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
