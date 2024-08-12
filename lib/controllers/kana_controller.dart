import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kana/mixins/text_to_speech_mixin.dart';
import 'package:kana/models/point_model.dart';
import 'package:kana/models/triangle_point_model.dart';
import 'package:kana/services/stroke_reducer_service.dart';

class KanaControler with TextToSpeechMixin {
  KanaControler() {
    _strokeReducer = StrokeReducerService(limitPointsToReduce: 20);
    // initTts();
  }

  late final StrokeReducerService _strokeReducer;

  double startSquareLimit = 0.0;
  double endSquareLimit = 100.0;
  bool _isCorrect = false;
  String _charWrote = '';

  List<List<Offset>> strokes = [];
  List<List<Offset>> controlPoints = [];


  void addStroke(List<Offset> stroke) {
    strokes.add(_strokeReducer.reduce(stroke));
  }

  void addControlPoints(List<List<Offset>> points) {
    controlPoints = points;
  }

  void clearStrokes() {
    strokes.clear();
  }

  void undoTheLastStroke() {
    if (strokes.isNotEmpty) {
      strokes.removeLast();
    }
  }

  bool get isTheLastStroke => strokes.length >= controlPoints.length;

  String get showMessageTop => 'Write: ';

  String get showMessageBottom => _isCorrect
      ? 'Wrote correct: $_charWrote'
      : _charWrote.isNotEmpty
          ? 'Wrote wrong: $_charWrote'
          : '';

  void updateKana() {
    if (controlPoints.isNotEmpty && strokes.isNotEmpty) {
      compareCurves(controlPoints.first, strokes.first);
    }
  }

  // Point getClosestPointInDrawingList(
  //     List<Point> optimizedDrawingPoints,
  //     double comperatedDistance,
  //     Point controlPoint,
  //     List<Offset> drawingOffsets) {
  //   double closestDistance = optimizedDrawingPoints.first.dist;
  //   Point closestPoint = optimizedDrawingPoints.first;
  //   double bestCloseness = (closestDistance - comperatedDistance).abs();

  //   for (Point element in optimizedDrawingPoints.skip(1)) {
  //     // print('ELEMENT: ${element.offset}');
  //     _getTriangleHeight(controlPoint, drawingOffsets);
  //     double closeness = (element.dist - comperatedDistance).abs();
  //     if (closeness < bestCloseness) {
  //       closestDistance = element.dist;
  //       bestCloseness = closeness;
  //       closestPoint = element;
  //     }
  //     print('++++++++++++++++++');
  //   }
  //   return closestPoint;
  // }

  double _getTriangleHeight(Point controlPoint, List<Offset> drawingOffsets) {
    List<TrianglePoint> allDistances = [];
    for (Offset item in drawingOffsets) {
      double dist = (controlPoint.offset - item).distance;
      allDistances.add(TrianglePoint(dist, item));
    }

    double sideAB;
    double sideBC;
    double sideCA;
    TrianglePoint minPointB = allDistances
        .reduce((curr, next) => curr.distance < next.distance ? curr : next);
    sideAB = minPointB.distance;
    allDistances.removeWhere((item) => item == minPointB);
    TrianglePoint minPointC = allDistances
        .reduce((curr, next) => curr.distance < next.distance ? curr : next);
    sideCA = minPointC.distance;
    sideBC = (minPointB.offset - minPointC.offset).distance;

    double semiPerimeter = (sideAB + sideCA + sideBC) / 2;
    double triangleSQRT = math.sqrt(semiPerimeter *
        (semiPerimeter - sideAB) *
        (semiPerimeter - sideCA) *
        (semiPerimeter - sideBC));
    double triangleHeigth = (2 * triangleSQRT) / sideBC;
    print('RES: ${triangleHeigth}');
    return triangleHeigth;
  }

  compareCurves(List<Offset> controlCurve, List<Offset> drawingCurve) {
    print('CONTROLCURVE: ${controlCurve}');
    print('DRAWINGCURVE: ${drawingCurve}');
    if (controlCurve.isEmpty) {
      print('Control curve is empty');
      return;
    }
    if (drawingCurve.isEmpty) {
      print('Drawing curve is empty');
      return;
    }
    final startPointControlCurve = controlCurve.first;
    final startPointDrawingCurve = drawingCurve.first;
    final endPointDrawingCurve = drawingCurve.last;

    final mod1 = (startPointControlCurve.dx - startPointDrawingCurve.dx) *
            (startPointControlCurve.dx - startPointDrawingCurve.dx) +
        (startPointControlCurve.dy - startPointDrawingCurve.dy) *
            (startPointControlCurve.dy - startPointDrawingCurve.dy);

    final mod2 = (startPointControlCurve.dx - endPointDrawingCurve.dx) *
            (startPointControlCurve.dx - endPointDrawingCurve.dx) +
        (startPointControlCurve.dy - endPointDrawingCurve.dy) *
            (startPointControlCurve.dy - endPointDrawingCurve.dy);

    Curve controlCurveData = Curve(controlCurve);
    Curve drawingCurveData = Curve(drawingCurve, asc: mod1 <= mod2);

    List<Point> optimizedControlPoints = controlCurveData.resultPoints;
    // List<Point> optimizedDrawingPoints = drawingCurveData.resultPoints;
    List<Offset> drawingOffsets = drawingCurveData.coordinates;

    List<double> pointDifferentList = [];

    for (var i = 0; i < optimizedControlPoints.length; i++) {
      // double controlDistance = optimizedControlPoints[i].dist;
      double diff =
          _getTriangleHeight(optimizedControlPoints[i], drawingOffsets);
      pointDifferentList.add(diff);
      // Point closestPoint = getClosestPointInDrawingList(optimizedDrawingPoints,
      //     controlDistance, optimizedControlPoints[i], drawingOffsets);
      // double distance =
      //     (optimizedControlPoints[i].offset - closestPoint.offset).distance;
      // pointDifferentList.add(distance);
      // print('DISTANCE: ${distance}');
    }
    double maxDiff = pointDifferentList.reduce(math.max);

    // final average =
    //     pointDifferentList.reduce((value, element) => value + element) /
    //         pointDifferentList.length;

    Iterator<Point> controlCurvePoints = controlCurveData.points.iterator;
    Iterator<Point> drawingCurvePoints = drawingCurveData.points.iterator;

    Point controlCurvePoint = Point(const Offset(0, 0), 0, 0);
    Point drawingCurvePoint = Point(const Offset(0, 0), 0, 0);
    if (controlCurvePoints.moveNext()) {
      controlCurvePoint = controlCurvePoints.current;
    }
    if (drawingCurvePoints.moveNext()) {
      drawingCurvePoint = drawingCurvePoints.current;
    }
    double diff = 0.0;
    double currentDistance =
        math.min(controlCurvePoint.dist, drawingCurvePoint.dist);
    double prevDistance = 0.0;

    while (currentDistance <= 1.0) {
      var distance = currentDistance - prevDistance;
      diff += deltaAngles(controlCurvePoint.angle, drawingCurvePoint.angle) *
          distance;

      if (currentDistance == 1.0) break;

      if (controlCurvePoint.dist <= currentDistance &&
          controlCurvePoints.moveNext()) {
        controlCurvePoint = controlCurvePoints.current;
      }
      if (drawingCurvePoint.dist <= currentDistance &&
          drawingCurvePoints.moveNext()) {
        drawingCurvePoint = drawingCurvePoints.current;
      }

      prevDistance = currentDistance;
      currentDistance =
          math.min(controlCurvePoint.dist, drawingCurvePoint.dist);
    }

    List<double> result = [];
    result.add(1 - diff / math.pi);
    result.add(1 -
        ((controlCurveData.length - drawingCurveData.length).abs()) /
            controlCurveData.length);
    result.add(maxDiff);
    print('RESULT: ${result}');
  }

  double deltaAngles(double alpha1, double alpha2) {
    double dAlpha = (alpha1 - alpha2).abs();
    if (dAlpha > math.pi) dAlpha = 2.0 * math.pi - dAlpha;
    return dAlpha;
  }
}

class Curve {
  List<Offset> coordinates;
  bool asc;
  List<Point> points = [];
  List<Point> resultPoints = [];
  double length = 0;

  Curve(this.coordinates, {this.asc = true}) {
    init();
  }

  init() {
    Iterator<Offset> offsetIterator =
        asc ? coordinates.iterator : coordinates.reversed.iterator;
    List<double> prevPoint = [];
    if (asc) {
      if (offsetIterator.moveNext()) {
        prevPoint.add(offsetIterator.current.dx);
        prevPoint.add(offsetIterator.current.dy);
      }
    } else {
      if (offsetIterator.moveNext()) {
        prevPoint.add(offsetIterator.current.dy);
        prevPoint.add(offsetIterator.current.dx);
      }
    }

    List<double> point = [];
    resultPoints.add(Point(
        Offset(offsetIterator.current.dx, offsetIterator.current.dy),
        0.0,
        0.0));

    while (offsetIterator.moveNext()) {
      point.clear();
      if (asc) {
        point.add(offsetIterator.current.dx);
        point.add(offsetIterator.current.dy);
      } else {
        point.add(offsetIterator.current.dy);
        point.add(offsetIterator.current.dx);
      }
      var distance = calcDistance(prevPoint, point);
      if (distance < 10) continue;
      length += distance;
      var angle =
          math.atan2((point[1] - prevPoint[1]), (point[0] - prevPoint[0]));
      if (angle < 0.0) {
        angle = angle.abs();
      }
      points.add(Point(Offset(point[0], point[1]), length, angle));
      prevPoint[0] = point[0];
      prevPoint[1] = point[1];
    }

    Iterator<Point> pointsIterator = points.iterator;
    while (pointsIterator.moveNext()) {
      pointsIterator.current.dist /= length;
    }
    resultPoints.addAll(points);
  }

  double calcDistance(List<double> prevPoint, List<double> point) {
    double px = (prevPoint[0] - point[0]);
    double py = (prevPoint[1] - point[1]);
    return math.sqrt(px * px + py * py);
  }
}
