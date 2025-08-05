// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class DmSettingItem extends StatelessWidget {
  String? leadingIcon;
  String? leadingTitle;
  double leadingTitleWidth;
  Widget? trailing;
  String? trailingText;
  TextStyle? leadingTextStyle;

  /// 文字最大宽度
  double trailingWidth;
  Widget? endWidget;
  bool showRedDot;
  bool showEndIcon;
  bool showDivider;
  double paddingStart;
  double paddingEnd;
  double paddingTop;
  double paddingBottom;
  double dividerTopOffset;
  Function(BuildContext)? onTap;

  DmSettingItem(
      {super.key,
      this.leadingIcon,
      this.leadingTitle,
      this.leadingTitleWidth = 100,
      this.trailing,
      this.trailingText,
      this.trailingWidth = double.infinity,
      this.endWidget,
      this.leadingTextStyle,
      this.showRedDot = false,
      this.showEndIcon = true,
      this.showDivider = false,
      this.paddingStart = 20,
      this.paddingEnd = 12,
      this.paddingTop = 19,
      this.paddingBottom = 19,
      this.dividerTopOffset = 0,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => {onTap?.call(context)},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                          paddingStart, paddingTop, paddingEnd, paddingBottom)
                      .withRTL(context),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (trailing != null || trailingText == null)
                            ? Expanded(
                                child: _buildLeading(
                                    context, style, resource, true),
                              )
                            : _buildLeading(context, style, resource, false),
                        (trailing == null && trailingText != null)
                            ? Expanded(
                                child: _buildtrailing(
                                    context, style, resource, true),
                              )
                            : _buildtrailing(context, style, resource, false),
                      ]),
                ),
                Visibility(
                  visible: showDivider,
                  child: Container(
                    height: 0.8,
                    margin: EdgeInsets.only(left: 16, top: dividerTopOffset)
                        .withRTL(context),
                    decoration: BoxDecoration(color: style.lightBlack1),
                  ),
                )
              ],
            ));
      },
    );
  }

  Widget _buildLeading(BuildContext context, StyleModel style,
      ResourceModel resource, bool shoudExpand) {
    Widget leadingWidget = Text(
      leadingTitle ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: leadingTextStyle ??
          TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: style.largeText,
              fontWeight: FontWeight.w500,
              color: style.normal),
    );

    return Row(
      children: [
        Visibility(
            visible: leadingIcon != null,
            child: leadingIcon != null
                ? Image.asset(
                    leadingIcon!,
                    width: 24,
                    height: 24,
                  )
                : const SizedBox.shrink()),
        shoudExpand
            ? Expanded(
                child: leadingWidget,
              )
            : leadingWidget
      ],
    );
  }

  Widget _buildtrailing(BuildContext context, StyleModel style,
      ResourceModel resource, bool shoudExpand) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Visibility(
        //   visible: showRedDot,
        //   child: Container(
        //     width: 6,
        //     height: 6,
        //     alignment: Alignment.center,
        //     decoration: BoxDecoration(
        //         color: style.red1, borderRadius: BorderRadius.circular(100.0)),
        //   ),
        // ),
        Visibility(
          visible: trailing != null,
          child: trailing ?? const SizedBox.shrink(),
        ),
        shoudExpand
            ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: style.middleText,
                          color: style.textSecond,
                          overflow: TextOverflow.ellipsis,
                        ),
                        children: [
                          WidgetSpan(
                            baseline: TextBaseline.alphabetic,
                            alignment: PlaceholderAlignment.baseline,
                            child: Visibility(
                              visible: showRedDot,
                              child: Container(
                                width: 6,
                                height: 6,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: style.red1,
                                    borderRadius: BorderRadius.circular(100.0)),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: trailingText ?? '',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : SizedBox(
                // constraints:
                //     BoxConstraints(maxWidth: trailingWidth),
                height: style.largeText + 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: style.middleText,
                          color: style.textDisable,
                          overflow: TextOverflow.ellipsis,
                        ),
                        children: [
                          WidgetSpan(
                            baseline: TextBaseline.alphabetic,
                            alignment: PlaceholderAlignment.baseline,
                            child: Visibility(
                              visible: showRedDot,
                              child: Container(
                                width: 6,
                                height: 6,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: style.red1,
                                    borderRadius: BorderRadius.circular(100.0)),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: trailingText ?? '',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
        const SizedBox(
          width: 12,
        ),
        Visibility(
          visible: showEndIcon,
          child: showEndIcon
              ? (endWidget != null
                      ? endWidget!
                      : Image.asset(
                          resource.getResource('icon_arrow_right2'),
                          width: 7,
                          height: 13,
                        ))
                  .flipWithRTL(context)
              : const SizedBox.shrink(),
        )
      ],
    );
  }
}
