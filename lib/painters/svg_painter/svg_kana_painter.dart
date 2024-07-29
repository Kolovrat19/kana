import 'dart:ui';

import 'package:flutter/material.dart';
import 'svg_kana_parser.dart';

class OneByOnePainter extends CustomPainter {
  OneByOnePainter(
      this.animation,
      this.pathSegments,
      this.scaleToViewport,
      this.strokeWidth,
      this.color,
      this.pathIndex,
      this.pathBoundingBox,
      this.scale) {
    for (var segment in pathSegments) {
      totalPathSum += segment.length!;
    }
  }
  int? pathIndex;
  final Animation<double> animation;
  List<PathSegment> pathSegments;
  bool scaleToViewport;
  double totalPathSum = 0;
  int paintedSegmentIndex = 0;
  double _paintedLength = 0.0;
  bool canAnimationPaint = false;
  Rect pathBoundingBox;
  double strokeWidth;
  Color color;
  List<PathSegment> toPaint = [];
  ScaleFactor scale;

  void viewBoxToCanvas(Canvas canvas, Size size) {
    if (scaleToViewport) {
      canvas.scale(scale.x, scale.y);
      Offset offset = Offset.zero - pathBoundingBox.topLeft;
      canvas.translate(offset.dx, offset.dy);
      Offset center = Offset((size.width / scale.x - pathBoundingBox.width) / 2,
          (size.height / scale.y - pathBoundingBox.height) / 2);
      canvas.translate(center.dx, center.dy);
    }
    canvas.clipRect(pathBoundingBox);
  }

  drawAllPaths(Canvas canvas) {
    double upperBound = animation.value * totalPathSum;
    while (paintedSegmentIndex < pathSegments.length - 1) {
      if (_paintedLength + pathSegments[paintedSegmentIndex].length! <
          upperBound) {
        toPaint.add(pathSegments[paintedSegmentIndex]);
        _paintedLength += pathSegments[paintedSegmentIndex].length!;
        paintedSegmentIndex++;
      } else {
        break;
      }
    }

    double subPathLength = upperBound - _paintedLength;
    PathSegment lastPathSegment = pathSegments[paintedSegmentIndex];

    Path subPath = lastPathSegment.path!
        .computeMetrics()
        .first
        .extractPath(0, subPathLength);

    Path tmp = Path();
    if (animation.value == 1.0) {
      toPaint.clear();
      toPaint.addAll(pathSegments);
    } else {
      tmp = Path.from(lastPathSegment.path!);
      lastPathSegment.path = subPath;
      toPaint.add(lastPathSegment);
    }

    Paint paint;
    for (var segment in toPaint) {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt
        ..color = color
        ..strokeWidth = strokeWidth;

      canvas.drawPath(segment.path!, paint);
    }
    // for (var segmentPoints in controlPoints) {
    //   paint = Paint()
    //     ..strokeWidth = 2.0
    //     ..style = PaintingStyle.stroke
    //     ..color = Colors.red;
    //   canvas.drawPoints(PointMode.points, segmentPoints, paint);
    // }

    if (animation.value != 1.0) {
      toPaint.remove(lastPathSegment);
      lastPathSegment.path = tmp;
    }
  }

  drawOnePath(Canvas canvas, int index) {
    final animationPercent = animation.value;

    final path =
        createAnimatedPath(pathSegments[index].path!, animationPercent);

    Paint paint;
    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canAnimationPaint = animation.status == AnimationStatus.forward ||
        animation.status == AnimationStatus.completed;

    viewBoxToCanvas(canvas, size);
    if (canAnimationPaint) {
      if (pathIndex != null) {
        drawOnePath(canvas, pathIndex!);
        return;
      }
      drawAllPaths(canvas);
    } else {
      paintedSegmentIndex = 0;
      _paintedLength = 0.0;
      toPaint.clear();
    }
  }

  @override
  bool shouldRepaint(OneByOnePainter oldDelegate) => true;
}

Path createAnimatedPath(
  Path originalPath,
  double animationPercent,
) {
  // ComputeMetrics can only be iterated once!
  final totalLength = originalPath
      .computeMetrics()
      .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

  final currentLength = totalLength * animationPercent;

  return extractPathUntilLength(originalPath, currentLength);
}

Path extractPathUntilLength(
  Path originalPath,
  double length,
) {
  var currentLength = 0.0;

  final path = Path();

  var metricsIterator = originalPath.computeMetrics().iterator;

  while (metricsIterator.moveNext()) {
    var metric = metricsIterator.current;

    var nextLength = currentLength + metric.length;

    final isLastSegment = nextLength > length;
    if (isLastSegment) {
      final remainingLength = length - currentLength;
      final pathSegment = metric.extractPath(0.0, remainingLength);

      path.addPath(pathSegment, Offset.zero);
      break;
    } else {
      // There might be a more efficient way of extracting an entire path
      final pathSegment = metric.extractPath(0.0, metric.length);
      path.addPath(pathSegment, Offset.zero);
    }

    currentLength = nextLength;
  }

  return path;
}

class ScaleFactor {
  ScaleFactor(this.x, this.y, this.aspectRatio);
  final double x;
  final double y;
  List<double> aspectRatio = [1,1];
}
