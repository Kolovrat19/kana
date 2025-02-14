import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaijingo/components/parallax_bg.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: ParallaxBg(),
          ),
          CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(50),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 50,
                  mainAxisSpacing: 50,
                  crossAxisCount: 2,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/a_icon.svg',
                    ),
                    SvgPicture.asset(
                      'assets/icons/su_icon.svg',
                    ),
                    SvgPicture.asset(
                      'assets/icons/hyaku_icon.svg',
                    ),
                    SvgPicture.asset(
                      'assets/icons/gaku_icon.svg',
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.green[400],
                      child: const Text('Who scream'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.green[500],
                      child: const Text('Revolution is coming...'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.green[600],
                      child: const Text('Revolution, they...'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.green[400],
                      child: const Text('Who scream'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.green[500],
                      child: const Text('Revolution is coming...'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.green[600],
                      child: const Text('Revolution, they...'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
