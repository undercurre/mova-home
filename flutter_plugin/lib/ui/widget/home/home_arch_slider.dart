import 'dart:math';

import 'package:flutter/material.dart';

const Color defaultStokeColor = Color(0x80000000);

class ArchSlider extends StatefulWidget {
  final int currentIndex;
  final int total;
  final double width;
  final double height;
  final double lineWidth;
  final Color colorBg;
  final Color colorline;
  const ArchSlider(
      {super.key,
      required this.currentIndex,
      required this.total,
      this.width = 100,
      this.height = 40,
      this.lineWidth = 2.5,
      this.colorBg = const Color(0x30B2B2B2),
      this.colorline = const Color(0xffE9D0A5)});

  @override
  State<StatefulWidget> createState() {
    return ArchSliderState();
  }
}

class ArchSliderState extends State<ArchSlider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
            size: Size(widget.width, widget.height),
            painter: ArchPainter(
                rtl: Directionality.of(context) == TextDirection.rtl,
                currentIndex: widget.currentIndex,
                total: widget.total,
                lineWidth: widget.lineWidth,
                colorBg: widget.colorBg,
                colorline: widget.colorline))
      ],
    );
  }
}

class ArchPainter extends CustomPainter {
  int currentIndex = 0;
  int total = 1;
  late Paint mPaint;
  double mStrokeWidth = 1.0;
  double mPaintStrokeWidth = 1.5;
  Color colorBg;
  Color colorline;
  double lineWidth = 2.5;
  double startAngle = 150;
  double sweepAngle = -120;
  final bool rtl;
  ArchPainter(
      {Key? key,
      required this.currentIndex,
      required this.total,
      this.lineWidth = 2.5,
      this.rtl = true,
      this.colorBg = const Color(0x30B2B2B2),
      this.colorline = const Color(0xffE9D0A5)}) {
    mPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // // //画背景
    // mPaint.color = Colors.red;
    // canvas.drawLine(Offset(0, size.height / 2),
    //     Offset(size.width, size.height / 2), mPaint);
    //画背景
    mPaint.color = colorBg;
    canvas.drawArc(Rect.fromLTRB(0.0, 0.0, size.width, size.height),
        startAngle * (pi / 180), sweepAngle * (pi / 180), false, mPaint);

    //画弧形进度
    mPaint.color = colorline;
    if (!rtl) {
      canvas.drawArc(
          Rect.fromLTRB(0.0, 0.0, size.width, size.height),
          (startAngle + sweepAngle / total * currentIndex) * (pi / 180),
          sweepAngle / total * (pi / 180),
          false,
          mPaint);
    } else {
      canvas.drawArc(
          Rect.fromLTRB(0.0, 0.0, size.width, size.height),
          (startAngle + sweepAngle / total * (total - currentIndex)) *
              (pi / 180),
          -sweepAngle / total * (pi / 180),
          false,
          mPaint);
    }
  }

  @override
  bool shouldRepaint(ArchPainter oldDelegate) {
    return true;
  }
}
