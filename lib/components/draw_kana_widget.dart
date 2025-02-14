import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gaijingo/painters/all_stroke_painter.dart';
import 'package:gaijingo/painters/current_stroke_painter.dart';
import 'package:gaijingo/painters/kana_box_border_painter.dart';
import 'package:gaijingo/painters/svg_painter/svg_kana_helper.dart';
import 'package:gaijingo/painters/svg_painter/svg_kana_painter.dart';
import 'package:gaijingo/painters/svg_painter/svg_kana_parser.dart';
import 'package:gaijingo/providers/message_provider.dart';
import 'package:gaijingo/providers/stroke_provider.dart';
import 'package:gaijingo/utils/constants.dart';
import 'package:provider/provider.dart';

class DrawKanaWidget extends StatefulWidget {
  DrawKanaWidget.svg(
    this.assetPath, {
    super.key,
    this.color = Constants.darkBlueColor,
    this.strokeWidth = 4.0,
    this.scaleToViewport = true,
  }) {
    assert(assetPath.isNotEmpty);
  }

  final String assetPath;

  final bool scaleToViewport;
  final Color color;
  final double strokeWidth;

  @override
  State<DrawKanaWidget> createState() => _DrawKanaState();
}

class _DrawKanaState extends State<DrawKanaWidget>
    with TickerProviderStateMixin {
  int lastPaintedPathIndex = -1;
  List<PathSegment> pathSegments = [];
  List<PathSegment> pathSegmentsToAnimate = [];
  List<List<Offset>> kanaControlPoints = [];
  Rect pathBoundingBox = Rect.zero;
  ScaleFactor scale = ScaleFactor(0, 0, [1, 1]);
  Size kanaSize = Size.zero;
  // Size kanaRatioSize = Size.zero;

  late AnimationController _animationController;
  late AnimationController _animationController2;
  double iconSize = 50.0;
  double mainContainerSize = 0;
  double paddingMainContainer = 32.0;
  double paddingForWriter = 64.0;
  double maxKanaContainerSize = 400.0;
  double drawKanaSize = 0;
  List<List<Offset>> controlPoints = [];

  @override
  void initState() {
    super.initState();
    _getScreenSize();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 0), vsync: this);
    _animationController2 = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    _animationController.forward();
    _animationController2.repeat();
    _updatePathData();
    _addListenersToAnimationController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  void _addListenersToAnimationController() {
    _animationController.view.addListener(() {
      setState(() {});
    });
    _animationController2.view.addListener(() {
      setState(() {});
    });
  }

  _getScreenSize() {
    List<double> sizesList = [];
    final double physicalWidht = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.width;
    final double physicalHeight = WidgetsBinding
        .instance.platformDispatcher.views.first.physicalSize.height;
    final double devicePixelRatio =
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final double width = physicalWidht / devicePixelRatio;
    final double height = physicalHeight / devicePixelRatio;
    sizesList.add(width);
    sizesList.add(height);
    mainContainerSize = sizesList.reduce(min) - paddingMainContainer;
    if (mainContainerSize > maxKanaContainerSize) {
      mainContainerSize = maxKanaContainerSize;
    }
    drawKanaSize = mainContainerSize - paddingForWriter;
    kanaSize = Size(drawKanaSize, drawKanaSize);
  }

  Future<void> _updatePathData() async {
    await _parseFromSvgAsset();
    if (pathSegments.isEmpty) return;
    pathSegmentsToAnimate = pathSegments;
  }

  _getBoundingBox() {
    pathBoundingBox =
        SvgKanaHelper.calculateBoundingBox(pathSegments, widget.strokeWidth);
  }

  _getScaleFactor() {
    scale = SvgKanaHelper.calculateScaleFactor(kanaSize, pathBoundingBox);
  }

  _getControlPointsWithScaleFactor() {
    Offset offsetBoundingBox = Offset.zero - pathBoundingBox.topLeft;

    double leftShiftAfterScale =
        ((kanaSize.width - (kanaSize.width / scale.aspectRatio[0])) / 2) +
            paddingForWriter / 2;
    double topShiftAfterScale =
        ((kanaSize.width - (kanaSize.height / scale.aspectRatio[1])) / 2) +
            paddingForWriter / 2;
    final points = SvgKanaHelper.getControlPointsWithScaleFactor(
        scale,
        offsetBoundingBox,
        kanaControlPoints,
        leftShiftAfterScale,
        topShiftAfterScale);
    controlPoints = points;
  }

  Future<void> _parseFromSvgAsset() async {
    SvgParser parser = SvgParser();
    kanaControlPoints = await parser.loadFromFile(
        widget.assetPath, widget.color, widget.strokeWidth);

    setState(() {
      pathSegments = parser.getPathSegments();
    });
    _getBoundingBox();
    _getScaleFactor();
    _getControlPointsWithScaleFactor();
  }

  void _startStroke(
      DragStartDetails details, BuildContext context, double size) {
    // _animationController.reset();
    // _animationController.stop();
    final strokeProvider = Provider.of<StrokeProvider>(context, listen: false);
    strokeProvider.resetPoints();
    // currentStrokeProvider.setLimit(paddingForWriter, size - paddingForWriter);
    strokeProvider.setLimit(0, size);
    strokeProvider.addPoint(details.localPosition);
  }

  void _updateStroke(DragUpdateDetails details, BuildContext context) {
    final strokeProvider = Provider.of<StrokeProvider>(context, listen: false);
    strokeProvider.addPoint(details.localPosition);
  }

  void _finishStroke(BuildContext context) {
    final strokeProvider = Provider.of<StrokeProvider>(context, listen: false);
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    strokeProvider.addControlPoints(controlPoints);
    strokeProvider.addStroke(strokeProvider.points);

    //  currentStrokeProvider.resetPoints();

    if (messageProvider.isTheLastStroke) {
      messageProvider.updateMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mainContainerSize,
      height: mainContainerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(spreadRadius: 0, blurRadius: 80, offset: Offset(0, 0))
        ],
      ),
      child: Stack(
        children: [
          CustomPaint(
              painter: KanaBoxBorderPainter(),
              size: Size.square(mainContainerSize)),
          CustomPaint(
            painter: OneByOnePainter(
                _animationController,
                pathSegmentsToAnimate,
                widget.scaleToViewport,
                widget.strokeWidth,
                Constants.lightGrey,
                null,
                pathBoundingBox,
                scale),
            size: Size.copy(MediaQuery.of(context).size),
          ),
          CustomPaint(
            painter: OneByOnePainter(
                _animationController2,
                pathSegmentsToAnimate,
                widget.scaleToViewport,
                widget.strokeWidth,
                widget.color,
                0,
                pathBoundingBox,
                scale),
            size: Size.copy(MediaQuery.of(context).size),
          ),
          SizedBox(
            height: drawKanaSize,
            width: drawKanaSize,
            child: Consumer<StrokeProvider>(
              builder: (context, provider, child) {
                return RepaintBoundary(
                  child: CustomPaint(
                      isComplex: true,
                      painter: AllStrokesPainter(
                          provider.strokes, widget.strokeWidth)),
                );
              },
            ),
          ),
          SizedBox(
            height: drawKanaSize,
            width: drawKanaSize,
            child: GestureDetector(
              onPanStart: (details) =>
                  _startStroke(details, context, mainContainerSize),
              onPanUpdate: (details) => _updateStroke(details, context),
              onPanEnd: (details) => _finishStroke(context),
              child: Consumer<StrokeProvider>(
                builder: (context, provider, child) {
                  return RepaintBoundary(
                    child: CustomPaint(
                      isComplex: true,
                      painter: CurrentStrokePainter(
                          provider.points, widget.strokeWidth),
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
