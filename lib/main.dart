// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double slider_Value = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SliderTheme(
          data: SliderThemeData(
              //track
              activeTrackColor: Colors.blue,
              inactiveTrackColor: Colors.grey[400],
              trackHeight: 30,
              //thumb overlay
              // overlayShape: SliderComponentShape.noOverlay,
              overlayShape: RoundSliderOverlayShape(
                overlayRadius: 15,
              ),
              overlayColor: Colors.white,
              //thumb
              thumbShape: SliderThumbShape(),
              thumbColor: Colors.blue,
              //tick
              tickMarkShape: LineSliderTickMarkShape(tickMarkRadius: 9)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  value: slider_Value,
                  min: 0,
                  max: 60,
                  divisions: 6,
                  onChanged: (value) {
                    setState(() {
                      slider_Value = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(slider_Value.toString())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SliderThumbShape extends SliderComponentShape {
  const SliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius = 0,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });
  final double enabledThumbRadius;

  /// [enabledThumbRadius]
  final double disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius;
  final double elevation;
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);
    assert(!sizeWithOverflow.isEmpty);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );

    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);

    {
      final Path path = Path()
        ..addArc(
            Rect.fromCenter(
                center: center, width: 1 * radius, height: 1 * radius),
            0,
            math.pi * 2);

      Paint paint = Paint()..color = Colors.white;
      paint.strokeWidth = 10;
      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(
        center,
        radius,
        paint,
      );
      {
        Paint paint = Paint()..color = Colors.blue;
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(
          center,
          radius,
          paint,
        );
      }
    }
  }
}

class LineSliderTickMarkShape extends SliderTickMarkShape {
  const LineSliderTickMarkShape({
    this.tickMarkRadius,
  });

  final double? tickMarkRadius;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) {
    assert(sliderTheme.trackHeight != null);
    return Size.fromRadius(tickMarkRadius ?? sliderTheme.trackHeight! / 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    // Color? begin;
    // Color? end;
    final Paint paint = Paint()
      ..strokeWidth = 1.5
      ..color = ColorTween(begin: Colors.white, end: Colors.white)
          .evaluate(enableAnimation)!;

    // final double tickMarkRadius = getPreferredSize(
    //       isEnabled: isEnabled,
    //       sliderTheme: sliderTheme,
    //     ).width /
    //     4;
    // if (tickMarkRadius! >= 0) {
    // context.canvas.drawLine(Offset(center.dx - 10, center.dy - 10),
    //     Offset(center.dx + 9, center.dy + 10), paint);
    context.canvas.drawLine(Offset(center.dx - 10, center.dy - 10),
        Offset(center.dx + 10, center.dy + 10), paint);
  }
}
