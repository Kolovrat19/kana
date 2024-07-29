import 'dart:ui';
import 'package:kana/painters/svg_painter/svg_kana_parser.dart';
import 'package:kana/utils/svg/path_parsing.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  Path path = Path();
  List<Offset> controlPoints = [];
  Future<Path> loadFromFile(
      String file, Color color, double strokeWidth) async {
    String svgString = await rootBundle.loadString(file);

    var doc = xml.XmlDocument.parse(svgString);

    final node = doc.findAllElements("path").map((node) => node.attributes);
    var dPath = node.last.firstWhere(
      (attr) => attr.name.local == "d",
    );

    if (dPath != null) {
      controlPoints = writeSvgPathDataToPath(dPath.value, PathModifier(path));
      print('controlPoints: ${controlPoints}');
    }

    setState(() {});
    return path;
  }

  @override
  void initState() {
    loadFromFile("assets/images/04ea2.svg", Colors.amber, 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        isComplex: true,
        painter: TextPainter(path,controlPoints),
      ),
    );
  }
}

class TextPainter extends CustomPainter {
  const TextPainter(this.path, this.controlPoints);

  final Path path;
  final List<Offset> controlPoints;

  @override
  void paint(Canvas canvas, Size size) {
    final currentStrokePaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = Colors.blue;
          final controlPaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = Colors.red;
    canvas.drawPath(path, currentStrokePaint);
    canvas.drawPoints(PointMode.points, controlPoints, controlPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
