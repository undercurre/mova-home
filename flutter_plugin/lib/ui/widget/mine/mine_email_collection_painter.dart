import 'package:flutter/material.dart';

class MineEmailCollectionPainter extends CustomPainter {
  late final TextPainter _painter = TextPainter(
      maxLines: 100,
      ellipsis: '...   ..',
      text: const TextSpan(
          text:
              'dhasjdhsajdhjsahdjshdjashdjahsdjahsjdhajshdjksahdjsahdjhsajdhjashdkjahsdjahsdjhakjsdhkjashdjsahdjhasjdhajshdhasjdhjasdhjsa',
          style: TextStyle(fontSize: 12.0, color: Colors.black)),
      textDirection: TextDirection.ltr)
    ..layout(maxWidth: 100, minWidth: 0);
  @override
  void paint(Canvas canvas, Size size) {
    _painter.paint(canvas, const Offset(0, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
