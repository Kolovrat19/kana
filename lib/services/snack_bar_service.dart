import 'package:flutter/material.dart';
import 'package:gaijingo/utils/constants.dart';

class SnackBarService {
  static SnackBar show({
    required String text,
    bool hasAction = false,
    String actionLabel = '',
    Color backgroundColor = Constants.snackbarColor,
    Color actionLabelColor = Colors.white,
    int duration = 5,
  }) {
    return SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        text,
      ),
      duration: Duration(seconds: duration),
      action: hasAction
          ? SnackBarAction(
              label: actionLabel,
              textColor: actionLabelColor,
              onPressed: () {},
            )
          : null,
    );
  }
}
