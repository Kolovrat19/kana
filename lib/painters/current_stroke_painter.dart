import 'dart:ui';

import 'package:flutter/material.dart';

class CurrentStrokePainter extends CustomPainter {
  const CurrentStrokePainter(this.points, this.strokeWidth);

  final List<Offset> points;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final currentStrokePaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.blue;
    canvas.drawPoints(PointMode.polygon, points, currentStrokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
