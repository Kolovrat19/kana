import 'package:flutter/material.dart';
import 'package:kana/utils/constants.dart';

class TopBoxMessage extends StatefulWidget {
  final String text;
  const TopBoxMessage({super.key, required this.text});

  @override
  State<TopBoxMessage> createState() => _TopBoxMessageState();
}

class _TopBoxMessageState extends State<TopBoxMessage> {
  @override
  Widget build(BuildContext context) {
    return widget.text != '' ? Container(
      height: 30.0,
      decoration: BoxDecoration(
        color: Constants.mainBlueColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: Constants.circularFontFamily,
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ) : Container();
  }
}
