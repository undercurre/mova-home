import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/theme/index.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef BarBtnCallback = void Function(BarButtonTag tag);

enum BarButtonTag { left, center, right }

enum ThemeStyle { light, dark }

class NavBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? leftBackResource;
  final Color? titleColor;

  static const double BAR_HEIGHT = 52;

  final String? title;
  final bool? backHidden;
  final bool? isHidden; // NavBar隐藏
  final bool? isHiddenTitle; // NavBar保留状态栏
  final bool? isShowSeparator; // NavBar显示分割线
  final String? rightImg;
  final String? rightTitle;
  final Color? bgColor;
  final Widget? leftWidget;
  final Widget? titleWidget;
  final Widget? rightWidget;
  final BarBtnCallback? itemAction;
  final ThemeStyle theme;
  final double barHeight;

  const NavBar({
    super.key,
    this.titleColor,
    this.leftBackResource,
    this.title,
    this.theme = ThemeStyle.dark,
    this.backHidden = false,
    this.isHidden = false,
    this.isHiddenTitle = false,
    this.isShowSeparator = false,
    this.rightImg = '',
    this.rightTitle = '',
    this.bgColor,
    this.leftWidget,
    this.titleWidget,
    this.rightWidget,
    this.itemAction,
    this.barHeight = BAR_HEIGHT,
  });

  final double itemW = 60;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ThemeWidget(builder: (context, style, resource) {
      return isHidden ?? false
          ? SizedBox(width: MediaQuery.of(context).size.width, height: 0)
          : isHiddenTitle ?? false
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).padding.top)
              : Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).padding.top + barHeight,
                      color: bgColor ?? style.bgColor,
                      child: Container(
                        margin: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top)
                            .withRTL(context),
                        child: Row(
                          children: <Widget>[
                            backHidden ?? false
                                ? leftWidget ??
                                    SizedBox(
                                      width: itemW,
                                      height: barHeight,
                                    )
                                : SizedBox(
                                    width: itemW,
                                    height: barHeight,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Semantics(
                                        label: 'go_back_previous_page'.tr(),
                                        child: Image.asset(
                                          leftBackResource ??
                                              resource.getResource('ic_nav_back'),
                                          width: 24,
                                          height: 24,
                                        ).flipWithRTL(context),
                                      ),
                                    ),
                                  ).onClick(
                                    () {
                                      if (itemAction != null) {
                                        itemAction!(BarButtonTag.left);
                                      }
                                    },
                                  ),
                            Expanded(
                              child: titleWidget ??
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      title ?? '',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            titleColor ?? style.textMainBlack,
                                      ),
                                    ),
                                  ),
                            ),
                            rightWidget ??
                                SizedBox(
                                  width: itemW,
                                  height: barHeight,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 16)
                                        .withRTL(context),
                                    child: rightTitle!.isNotEmpty
                                        ? Text(
                                            rightTitle!,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: style.textNormal),
                                          )
                                        : rightImg!.isNotEmpty
                                            ? Image.asset(
                                                resource.getResource(
                                                    rightImg ?? ''),
                                                width: 24,
                                                height: 24,
                                              )
                                            : Semantics(
                                              hidden: true,
                                              child: SizedBox(
                                                  width: itemW,
                                                  height: barHeight,
                                                ),
                                            ),
                                  ),
                                ).onClick(() {
                                  if (itemAction != null) {
                                    itemAction!(BarButtonTag.right);
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    isShowSeparator ?? false
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            color: style.lightBlack1,
                          )
                        : Container(color: bgColor, height: 1),
                  ],
                );
    });
  }

  @override
  Size get preferredSize => isHidden ?? false
      ? const Size.fromHeight(0)
      : Size.fromHeight(barHeight + 1);
}
