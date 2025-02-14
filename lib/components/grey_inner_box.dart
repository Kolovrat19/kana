import 'package:flutter/material.dart';
import 'package:gaijingo/utils/constants.dart';

class GreyInnerBox extends StatefulWidget {
  const GreyInnerBox({super.key, required this.char});

  final String char;

  @override
  State<GreyInnerBox> createState() => _GreyInnerBoxState();
}

class _GreyInnerBoxState extends State<GreyInnerBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Constants.lightGrey,
          borderRadius: BorderRadius.circular(Constants.mainCornerRadius)),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text(
          widget.char,
          style: TextStyle(
              fontSize: 36.0,
              color: Constants.mainFontColor,
              fontWeight: FontWeight.bold,
              fontFamily: Constants.circularFontFamily),
        ),
      ),
    );
  }
}
