import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kana/components/draw_kana_widget.dart';
import 'package:kana/utils/constants.dart';


class DrawKanaScreen extends StatefulWidget {
  const DrawKanaScreen({super.key});

  @override
  State<DrawKanaScreen> createState() => _DrawKanaScreenState();
}

class _DrawKanaScreenState extends State<DrawKanaScreen> {
  double iconSize = 50.0;

  @override
  Widget build(BuildContext buildContext) {
    bool isPortrait =
        MediaQuery.of(buildContext).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Constants.lightGrey,
      body: Center(
        child: Flex(
          direction: isPortrait ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DrawKanaWidget.svg('assets/images/あ.svg'),
            const SizedBox(width: 40, height: 40),
            SvgPicture.asset(
              'assets/icons/speed_snail.svg',
              width: iconSize,
              height: iconSize,
            ),

            // TextButton(
            //     child: Text('Redraw'),
            //     onPressed: () {
            //       _animationController.reset();
            //       _animationController.forward();
            //     })
          ],
        ),
      ),
    );
  }
}
