import 'dart:ui';

import 'package:flutter/material.dart';

class AllStrokesPainter extends CustomPainter {
  const AllStrokesPainter(this.strokes, this.strokeWidth);

  final List<List<Offset>> strokes;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final allStrokePaint = Paint()
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.amber;

    for (final points in strokes) {
      canvas.drawPoints(PointMode.polygon, points, allStrokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
