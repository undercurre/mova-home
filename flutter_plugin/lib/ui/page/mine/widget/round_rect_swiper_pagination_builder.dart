import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/mine/mine_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 圆角矩形indicate
class RoundRectSwiperPaginationBuilder extends SwiperPlugin {
  const RoundRectSwiperPaginationBuilder({
    this.activeColor = const Color(0xFFFFFFFF),
    this.color = const Color(0x4DFFFFFF),
    this.key,
    this.width = 60,
    this.size = const Size(20.0, 2.0),
    this.radius = 2,
    this.activeSize = const Size(20.0, 2.0),
    this.space = 0,
  });

  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  ///Size of the rect when activate
  final Size activeSize;

  ///Size of the rect
  final Size size;

  final double width;

  /// Space between rects
  final double space;

  final double radius;

  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    final list = <Widget>[];

    const double totalWidth = 60;

    final itemWith =
        (totalWidth) / (totalWidth <= 0 ? 1 : (config.itemCount + 1));

    final itemCount = config.itemCount;
    final activeIndex = config.activeIndex;
    for (var i = 0; i < itemCount; ++i) {
      final active = i == activeIndex;
      final size = active ? activeSize : this.size;
      list.add(SizedBox(
        width: itemWith,
        height: size.height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(this.radius),
            color: active ? activeColor : color,
          ),
          key: Key('pagination_$i'),
        ),
      ));
      list.add(SizedBox(
        width: space,
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}
