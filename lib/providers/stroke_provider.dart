import 'package:flutter/material.dart';
import 'package:kana/controllers/kana_controller.dart';

class StrokeProvider extends ChangeNotifier {
  StrokeProvider(this._kanaControler);

  final KanaControler _kanaControler;

  List<Offset> points = [];
  bool _canAdd = true;
  double _startSquareLimit = 0.0;
  double _endSquareLimit = 0.0;

  List<List<Offset>> get strokes => _kanaControler.strokes;

  void setLimit(double startSquareLimit, double endSquareLimit) {
    _startSquareLimit = startSquareLimit;
    _endSquareLimit = endSquareLimit;
    _kanaControler.startSquareLimit = startSquareLimit;
    _kanaControler.endSquareLimit = endSquareLimit;
  }

  void addPoint(Offset point) {
    if (_startSquareLimit < point.dx &&
        point.dx < _endSquareLimit &&
        _startSquareLimit < point.dy &&
        point.dy < _endSquareLimit &&
        _canAdd) {
      points.add(point);
      notifyListeners();
    } else {
      _canAdd = false;
    }
  }

  void resetPoints() {
    points.clear();
    _canAdd = true;
    notifyListeners();
  }

  void addStroke(List<Offset> stroke) {
    _kanaControler.addStroke(stroke);
    notifyListeners();
  }

  void addControlPoints(List<List<Offset>> points) {
    _kanaControler.addControlPoints(points);
    notifyListeners();
  }

  void clearStrokes() {
    _kanaControler.clearStrokes();
    notifyListeners();
  }

  void undoTheLastStroke() {
    _kanaControler.undoTheLastStroke();
    notifyListeners();
  }
}
