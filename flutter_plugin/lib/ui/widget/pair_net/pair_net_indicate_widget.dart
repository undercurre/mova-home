import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';

class PairNetIndicatorWidget extends StatelessWidget {
  final int index;
  final int totalIndex;

  const PairNetIndicatorWidget(this.index, this.totalIndex, {super.key});

  List<Widget> buildIndicator(BuildContext context, StyleModel style) {
    List<Widget> list = [];
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    for (int i = 1; i <= totalIndex; i++) {
      list.add(Container(
        width: 22,
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 0.7),
        decoration: BoxDecoration(
            color: (isRtl ? i <= totalIndex - index + 1 : i <= index)
                ? style.pairProcessActiveColor
                : style.pairProcessInActiveColor,
            borderRadius: i == 1
                ? const BorderRadius.only(
                    topLeft: Radius.circular(1), bottomLeft: Radius.circular(1))
                : i == totalIndex
                    ? const BorderRadius.only(
                        topRight: Radius.circular(1),
                        bottomRight: Radius.circular(1))
                    : null),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: (Directionality.of(context) == TextDirection.rtl)
                  ? <Widget>[
                      Text('$totalIndex\\',
                          style: TextStyle(
                              color: style.pairProcessInActiveColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      Text('$index',
                          style: TextStyle(
                              color: style.pairProcessActiveColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ]
                  : <Widget>[
                      Text('$index',
                          style: TextStyle(
                              color: style.pairProcessActiveColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      Text('/$totalIndex',
                          style: TextStyle(
                              color: style.pairProcessInActiveColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ]),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildIndicator(context, style),
          )
        ],
      );
    });
  }
}
