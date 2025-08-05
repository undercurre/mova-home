// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';

class RecoverBottomButton extends StatelessWidget {
  Image? icon;
  String? text;
  VoidCallback? onPress;

  RecoverBottomButton({super.key, this.icon, this.text, this.onPress});

  List<Widget> getContextList(TextStyle style) {
    List<Widget> lis = [];

    if (icon != null) {
      lis.add(icon!);
    }
    if (text != null) {
      Flexible t = Flexible(
        // flex: 0,
        fit: FlexFit.loose,
        child: Text(
          text!,
          textAlign: TextAlign.center,
          style: style,
          // softWrap: true,
          // textDirection: TextDirection.ltr,
        ),
      );
      lis.add(t);
    }
    return lis;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return GestureDetector(
          onTap: () {
            onPress?.call();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 40,
                    // maxWidth: 100,
                  ),
                  padding: const EdgeInsets.only(
                          left: 27, right: 27, top: 5, bottom: 5)
                      .withRTL(context),
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: style.lightBlack1,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getContextList(style.mainStyle()),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
