import 'package:flutter/material.dart';

bool isRTL(BuildContext context) {
  bool rtl = (Directionality.of(context) == TextDirection.rtl);
  return rtl;
}
