// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';

class DmTabItem extends StatelessWidget {
  String? tabTitle;
  double dotRadius;
  bool? showDot;
  Color? dotColor;

  DmTabItem(
      {super.key,
      this.tabTitle,
      this.dotRadius = 3,
      this.showDot,
      this.dotColor});

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return Tab(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SizedBox(width: dotRadius * 2, height: dotRadius * 2),
            Text(tabTitle ?? ''),
            Opacity(
                opacity: showDot == true ? 1 : 0,
                child: Container(
                  width: dotRadius * 2,
                  height: dotRadius * 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(dotRadius),
                      color: dotColor ?? style.red1),
                )),
          ]));
    });
  }
}
