// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';

class DmCustomeCell extends StatelessWidget {
  Widget? leadingWidge;
  String? leadingTitle;
  Widget? trailing;
  String? trailingText;
  Widget? endWidget;
  bool showRedDot;
  bool showEndIcon;
  bool showDivider;
  EdgeInsetsGeometry padding;

  Function(BuildContext)? onTap;

  DmCustomeCell(
      {super.key,
      this.leadingWidge,
      this.leadingTitle,
      this.trailing,
      this.trailingText,
      this.endWidget,
      this.showRedDot = false,
      this.showEndIcon = true,
      this.showDivider = false,
      this.padding = const EdgeInsets.fromLTRB(16, 19, 16, 19),
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => {onTap?.call(context)},
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    padding: padding,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                              visible: leadingWidge != null,
                              child: leadingWidge != null
                                  ? leadingWidge!
                                  : const SizedBox.shrink()),
                          Expanded(
                              flex: 1,
                              child: Text(
                                leadingTitle ?? '',
                                style: TextStyle(
                                    height: 1.0,
                                    fontSize: style.largeText,
                                    fontWeight: FontWeight.bold,
                                    color: style.textMain),
                              )),
                          Visibility(
                              visible: showRedDot,
                              child: Container(
                                width: 6,
                                height: 6,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: style.red1,
                                    borderRadius: BorderRadius.circular(100.0)),
                              )),
                          Visibility(
                              visible: trailing != null,
                              child: trailing ?? const SizedBox.shrink()),
                          Visibility(
                              visible: true,
                              child: Text(
                                trailingText ?? '',
                                style: TextStyle(
                                    height: 1.0,
                                    fontSize: style.middleText,
                                    color: style.textSecond),
                              )),
                          const SizedBox(
                            width: 12,
                          ),
                          Visibility(
                              visible: endWidget != null,
                              child: endWidget != null
                                  ? (endWidget!)
                                  : const SizedBox.shrink()),
                          Visibility(
                              visible: showEndIcon,
                              child: showEndIcon
                                  ? (Image.asset(
                                      resource.getResource('icon_arrow_right2'),
                                      width: 6,
                                      height: 10,
                                    ))
                                  : (const SizedBox.shrink()))
                        ]),
                  ),
                  Visibility(
                    visible: showDivider,
                    child: Container(
                      height: 0.8,
                      margin: const EdgeInsets.only(left: 16).withRTL(context),
                      decoration: BoxDecoration(color: style.lightBlack1),
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
