import 'package:flutter/material.dart';

class Constants {
  // FONT FAMILY
  static const String circularFontFamily = 'Circular';

  // FONT SIZE
  static const double fontSize46 = 46.0;
  // static const double fontSize32 = 32.0;
  static const double fontSize25 = 25.0;
  static const double fontSize20 = 20.0;
  static const double fontSize16 = 16.0;
  static const double fontSize14 = 14.0;

  static const double mainCornerRadius = 16.0;
  static const Color mainBackgroundColor = Color(0xFFFFFFFF);

  static const Color darkBlueColor = Color(0xFF5C657C);
  static const Color mainBlueColor = Color(0xFF686BFF);
  static const Color mainFontColor = Color(0xFF525F7F);
  static const Color navBarShadowColor = Color(0xFFBAC6DC);
  static const Color dividerColor = Color(0xFFC5C8D8);
  static const Color lightGrey = Color(0xFFEEF0F7);
  static const Color pinkColor = Color(0xFF7D7EFF);
  static const Color titleFontColor = Color(0xFF686C80);
  static const Color snackbarColor = Color(0xFFDEE3F4);
  static const Color buttonColor = Color(0xFF8B8FA4);
  static WidgetStateProperty<Color> mainButtonMaterialColor =
      WidgetStateProperty.all<Color>(buttonColor);

  // ##################### KANA #######################
  static const Color backgroundKanaColor = Color(0xFFEEF0F7);
  static const Color mainHiraganaColor = Color(0xFF525F7F);

  // ##################### LOCAL STORAGE KEYS #######################
  static const USER_STORAGE = 'user_storage';
}
