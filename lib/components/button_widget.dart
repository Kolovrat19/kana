import 'package:flutter/material.dart';
import 'package:gaijingo/utils/constants.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final String type;
  final dynamic Function(dynamic) onPressed;
  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.title,
    this.type = 'primary',
  });

  @override
  Widget build(BuildContext context) {
    if (type == 'outline') {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            onPressed(true);
          },
          child: Text(
            title,
            style: const TextStyle(
              leadingDistribution: TextLeadingDistribution.even,
              height: 1.5,
              fontFamily: Constants.circularFontFamily,
              fontSize: Constants.fontSize20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          onPressed(true);
        },
        child: Text(
          title,
          style: const TextStyle(
            leadingDistribution: TextLeadingDistribution.even,
            height: 1.5,
            fontFamily: Constants.circularFontFamily,
            fontSize: Constants.fontSize20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
