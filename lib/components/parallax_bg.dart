import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';


class ParallaxBg extends FlameGame {
  @override
  Future<void> onLoad() async {
    add(MyParallaxComponent());
  }
}

class MyParallaxComponent extends ParallaxComponent<ParallaxBg> {
  @override
  Future<void> onLoad() async {
    parallax = await game.loadParallax(
      [
        ParallaxImageData('main_parallax/bg.png'),
        ParallaxImageData('main_parallax/mountain-far.png'),
        ParallaxImageData('main_parallax/mountains.png'),
        ParallaxImageData('main_parallax/trees.png'),
        ParallaxImageData('main_parallax/foreground-trees.png'),
      ],
      baseVelocity: Vector2(2, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
      filterQuality: FilterQuality.none,
    );
  }
}