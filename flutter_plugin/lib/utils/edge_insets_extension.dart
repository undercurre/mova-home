import 'package:flutter/cupertino.dart';

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets withRTL(BuildContext context) {
    bool rtl = (Directionality.of(context) == TextDirection.rtl);
    return EdgeInsets.fromLTRB(
        !rtl ? left : right, top, !rtl ? right : left, bottom);
  }
}
