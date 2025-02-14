import 'package:flutter/material.dart';
import 'package:gaijingo/components/top_box_message.dart';
import 'package:gaijingo/utils/constants.dart';

class WtiteBox extends StatefulWidget {
  final Widget innerCenterWidget;
  final double boxHeight;

  const WtiteBox(
      {super.key, required this.innerCenterWidget, this.boxHeight = 150.0});

  @override
  State<WtiteBox> createState() => _WtiteBoxState();
}

class _WtiteBoxState extends State<WtiteBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            height: widget.boxHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Constants.mainCornerRadius),
                topRight: Radius.circular(Constants.mainCornerRadius),
              ),
              boxShadow: [
                BoxShadow(
                    color: Constants.navBarShadowColor.withOpacity(0.4),
                    spreadRadius: 0,
                    blurRadius: 80,
                    offset: const Offset(0, -50),),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 35.0),
              child: Center(child: widget.innerCenterWidget),
            ),
          ),
          const Positioned(
              top: -15,
              child: TopBoxMessage(
                text: 'New word',
              ))
        ]);
  }
}
