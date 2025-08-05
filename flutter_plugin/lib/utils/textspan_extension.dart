import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

extension TextSpanDetectorExtension on TextSpan {
  TextSpan onclick({onClickCallback, int ms = 800}) {
    bool clickable = true;
    return TextSpan(
        text: text,
        children: children,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (clickable) {
              clickable = false;
              onClickCallback();
              Future.delayed(Duration(milliseconds: ms), () {
                clickable = true;
              });
            }
          },
        style: style);
  }
}
