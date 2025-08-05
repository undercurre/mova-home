import 'package:flutter/material.dart';

class HorizontalProgressBar extends StatefulWidget {
  final double progress;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;

  const HorizontalProgressBar({
    super.key,
    required this.progress,
    this.width = 200,
    this.height = 9,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.black,
  });

  @override
  HorizontalProgressBarState createState() => HorizontalProgressBarState();
}

class HorizontalProgressBarState extends State<HorizontalProgressBar> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: ProgressBarPainter(
        progress: widget.progress,
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.foregroundColor,
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color foregroundColor;

  ProgressBarPainter({
    required this.progress,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.fill;

    final progressWidth = size.width * progress;
    final borderRadius = size.height / 2;

    // 绘制背景
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ),
      backgroundPaint,
    );

    // 绘制前景
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, progressWidth, size.height),
        Radius.circular(borderRadius),
      ),
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
