import 'dart:ui';

import 'package:kana/painters/svg_painter/svg_kana_painter.dart';
import 'package:kana/painters/svg_painter/svg_kana_parser.dart';

class SvgKanaHelper {
  static Rect calculateBoundingBox(
      List<PathSegment> pathSegments, double strokeWidth) {
    Rect pathBoundingBox = Rect.zero;
    if (pathSegments.isNotEmpty) {
      Rect bb = pathSegments.first.path!.getBounds();

      for (var e in pathSegments) {
        bb = bb.expandToInclude(e.path!.getBounds());
      }
      pathBoundingBox = bb.inflate(strokeWidth / 2);
    }
    return pathBoundingBox;
  }

  static ScaleFactor calculateScaleFactor(Size viewBox, Rect pathBoundingBox) {
    double dx = (viewBox.width) / pathBoundingBox.width;
    double dy = (viewBox.height) / pathBoundingBox.height;
    List<double> aspectRatio = _getAspectRatio(dx, dy);

    double? ddx = 0, ddy = 0;
    assert(!(dx == 0 && dy == 0));
    if (!viewBox.isEmpty) {
      ddx = dx;
      ddy = dy;
    } else if (dx == 0) {
      ddx = ddy = dy;
    } else if (dy == 0) {
      ddx = ddy = dx;
    }
    return ScaleFactor(
        (ddx / aspectRatio[0]), (ddy / aspectRatio[1]), aspectRatio);
  }

  static List<double> _getAspectRatio(double dx, double dy) {
    List<double> ratioList = [];
    double ratioX = 1;
    double ratioY = 1;
    if (dx > dy) {
      ratioX = dx / dy;
    } else if (dx < dy) {
      ratioY = dy / dx;
    }
    ratioList.add(ratioX);
    ratioList.add(ratioY);
    return ratioList;
  }

  static List<List<Offset>> getControlPointsWithScaleFactor(
      ScaleFactor scale,
      Offset offset,
      List<List<Offset>> controlPoints,
      double leftShiftAfterScale,
      double topShiftAfterScale) {
    List<List<Offset>> formatedControlPoints = [];
    for (var segment in controlPoints) {
      List<Offset> formatedSegment = [];
      for (var point in segment) {
        Offset shiftOffset = point + offset;
        Offset finalControlPoint = Offset(
            (shiftOffset.dx * scale.x) + leftShiftAfterScale,
            (shiftOffset.dy * scale.y) + topShiftAfterScale);
        formatedSegment.add(finalControlPoint);
      }
      formatedControlPoints.add(formatedSegment);
    }
    return formatedControlPoints;
  }
}
