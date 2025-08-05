import 'package:flutter/cupertino.dart';

extension AlignmentExtension on Alignment {
  Alignment withRTL(BuildContext context) {
    bool rtl = (Directionality.of(context) == TextDirection.rtl);
    // return EdgeInsets.fromLTRB(
    // !rtl ? left : right, top, !rtl ? right : left, bottom);

    return Alignment(!rtl ? x : (1 - x), y);

    // Alignment finalMent = this;
    // if (rtl)
    // {
    //   switch (this) {
    //     case Alignment.centerLeft:
    //         finalMent = Alignment.centerRight;
    //         break;
    //     case Alignment.centerRight:
    //         finalMent = Alignment.centerLeft;
    //         break;
    //     case Alignment.topLeft:
    //         finalMent = Alignment.topRight;
    //         break;
    //     case Alignment.topRight:
    //         finalMent = Alignment.topLeft;
    //         break;
    //     case Alignment.bottomLeft:
    //         finalMent = Alignment.bottomRight;
    //         break;
    //     case Alignment.bottomRight:
    //         finalMent = Alignment.bottomLeft;
    //         break;
    //     default:
    //   }
    // }

    // return finalMent;
  }
}
