import 'dart:math';

import 'package:flutter/material.dart';

class CustomerIndicator extends Decoration {
  final double radius;
  final double distanceFromCenter;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  const CustomerIndicator({
    this.paintingStyle = PaintingStyle.stroke,
    this.radius = 15,
    this.distanceFromCenter = 4,
    this.strokeWidth = 4,
  });

  @override
  _CustomPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      this,
      onChanged,
      radius,
      paintingStyle,
      distanceFromCenter,
      strokeWidth,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final CustomerIndicator decoration;
  final double radius;
  final double distanceFromCenter;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  _CustomPainter(
    this.decoration,
    VoidCallback? onChanged,
    this.radius,
    this.paintingStyle,
    this.distanceFromCenter,
    this.strokeWidth,
  ) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    assert(strokeWidth >= 0 &&
        strokeWidth < configuration.size!.width / 2 &&
        strokeWidth < configuration.size!.height / 2);

    final Paint paint = Paint();
    double xAxisPos = offset.dx + configuration.size!.width / 2;
    double yAxisPos =
        offset.dy + configuration.size!.height / 2 + distanceFromCenter;
    paint.style = paintingStyle;
    paint.strokeWidth = strokeWidth;

    var rect =
        Rect.fromCircle(center: Offset(xAxisPos, yAxisPos), radius: radius);
    paint.shader = const SweepGradient(colors: <Color>[
      Color(0xffD2C3AA),
      Color(0xff94846B),
    ]).createShader(rect);
    canvas.drawArc(rect, 40 * (pi / 180), 100 * (pi / 180), false, paint);
  }
}

class CustomTabIndicator extends Decoration {
  final Color color;
  final double width;
  final double height;

  const CustomTabIndicator({
    this.color = const Color(0xFFC69E6D),
    this.width = 20,
    this.height = 3,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(this, onChanged);
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomTabIndicatorPainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.fill;

    final center = offset +
        Offset(configuration.size!.width / 2,
            configuration.size!.height - decoration.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: decoration.width,
      height: decoration.height,
    );

    final roundedRect = RRect.fromRectAndRadius(rect, const Radius.circular(4));

    canvas.drawRRect(roundedRect, paint);
  }
}
