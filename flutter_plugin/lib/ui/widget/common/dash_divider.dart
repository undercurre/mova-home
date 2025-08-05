import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final double strokeWidth;
  final double dashLength;
  final double spaceLength;
  final Color color;
  final double? indent;
  final double? endIndent;

  const DashedDivider({
    super.key,
    this.strokeWidth = 2.0,
    this.dashLength = 5.0,
    this.spaceLength = 5.0,
    this.color = const Color(0xFF000000),
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomPaint(
        painter: DashedPainter(
          color: color,
          strokeWidth: strokeWidth,
          dashLength: dashLength,
          spaceLength: spaceLength,
          indent: indent,
          endIndent: endIndent,
        ),
      ),
    );
  }
}

class DashedPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double spaceLength;
  final double? indent;
  final double? endIndent;

  DashedPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.spaceLength,
    this.indent,
    this.endIndent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double minPoint = indent ?? 0.0;
    final double maxPoint = size.width - (endIndent ?? 0.0);
    for (double x = minPoint; x < maxPoint; x += dashLength + spaceLength) {
      var endX = x + dashLength;
      if (endX > maxPoint) {
        endX = maxPoint;
      }
      canvas.drawLine(Offset(x, 0), Offset(endX, 0), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
