import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaijingo/utils/svg/path_parsing.dart';
import 'package:xml/xml.dart' as xml;

class SvgParser {
  final List<PathSegment> _pathSegments = [];

  void addPathSegments(Path path, int index) {
    int firstPathSegmentIndex = _pathSegments.length;
    int relativeIndex = 0;
    path.computeMetrics().forEach((pp) {
      PathSegment segment = PathSegment()
        ..path = pp.extractPath(0, pp.length)
        ..length = pp.length
        ..firstSegmentOfPathIndex = firstPathSegmentIndex
        ..pathIndex = index
        ..relativeIndex = relativeIndex;

      _pathSegments.add(segment);
      relativeIndex++;
    });
  }

  Future<List<List<Offset>>> loadFromFile(
      String file, Color color, double strokeWidth) async {
    List<List<Offset>> controlPoints = [];
    _pathSegments.clear();
    String svgString = await rootBundle.loadString(file);
    int index = 0;
    var doc = xml.XmlDocument.parse(svgString);

    doc
        .findAllElements("path")
        .map((node) => node.attributes)
        .forEach((attributes) {
      var dPath = attributes.firstWhere(
        (attr) => attr.name.local == "d",
      );
      if (dPath != null) {
        Path path = Path();
        List<Offset> segmentControlPoints =
            writeSvgPathDataToPath(dPath.value, PathModifier(path));
        addPathSegments(path, index);
        controlPoints.add(segmentControlPoints);
        index++;
      }
    });
    // print('CONTROLPOINTS: ${controlPoints}');
    return controlPoints;
  }

  List<PathSegment> getPathSegments() {
    // final first = _pathSegments.removeAt(0);
    // _pathSegments.add(first);
    return _pathSegments;
  }
}

/// Represents a segment of path, as returned by path.computeMetrics() and the associated painting parameters for each Path
class PathSegment {
  PathSegment();

  /// A continuous path/segment
  Path? path;

  /// Length of the segment path
  double? length;

  /// Denotes the index of the first segment of the containing path when PathOrder.original
  int firstSegmentOfPathIndex = 0;

  /// Corresponding containing path index
  int pathIndex = 0;

  /// Denotes relative index to  firstSegmentOfPathIndex
  int relativeIndex = 0;
}

/// A [PathProxy] that saves Path command in path
class PathModifier extends PathProxy {
  PathModifier(this.path);

  final Path path;

  @override
  void close() {
    path.close();
  }

  @override
  void cubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  void lineTo(double x, double y) {
    path.lineTo(x, y);
  }

  @override
  void moveTo(double x, double y) {
    path.moveTo(x, y);
  }
}
