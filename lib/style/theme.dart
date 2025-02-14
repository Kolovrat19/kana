import 'package:flutter/material.dart';
import 'package:gaijingo/utils/constants.dart';

final theme = ThemeData(
  useMaterial3: true,
  primaryColorDark: const Color(0xFF000000),
  primaryColorLight: const Color(0xFFB2EBF2),
  primaryColor: const Color(0xFF189B8D),
  // colorScheme: const ColorScheme.light(),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.black,
    primary: Colors.black,
  ),
  scaffoldBackgroundColor: Constants.mainBackgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0XFF0F2042),
    iconTheme: IconThemeData(
      color: Colors.black54,
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Constants.titleFontColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: Color(0XFF0F2042)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10.0),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8.0),
    ),
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(
      fontFamily: Constants.circularFontFamily,
      color: Constants.titleFontColor,
      fontWeight: FontWeight.w400,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: Constants.mainButtonMaterialColor,
      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0, bottom: 10.0),
      ),
      // overlayColor: WidgetStateProperty.resolveWith(
      //   (states) => ColorConstant.inputHintColor,
      // ),
      side: WidgetStateProperty.all<BorderSide>(
        const BorderSide(
          width: 2.0,
          color: Constants.buttonColor,
        ),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      backgroundColor: Constants.mainButtonMaterialColor,
      // overlayColor: WidgetStateProperty.resolveWith(
      //   (states) => ColorConstant.inputHintColor,
      // ),
      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.only(
          left: 16.0,
          top: 10.0,
          right: 16.0,
          bottom: 10.0,
        ),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    ),
  ),
);
