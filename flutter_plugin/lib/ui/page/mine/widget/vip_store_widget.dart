import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_handle_notifier.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_type.dart';
import 'package:flutter_plugin/ui/page/mine/mine_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'round_rect_swiper_pagination_builder.dart';

class VipStoreWidget extends ConsumerStatefulWidget {
  final StyleModel style;
  final ResourceModel resource;

  const VipStoreWidget(
      {super.key, required this.style, required this.resource});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => VipStoreWidgetState();
}

class VipStoreWidgetState extends ConsumerState<VipStoreWidget> {
  void pushToAccountSetting() {
    GoRouter.of(context).push(AccountSettingPage.routePath).then(
        (value) => ref.read(mineStateNotifierProvider.notifier).getUserInfo());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildVipInfoWidget(context, widget.style, widget.resource),
        buildBannerWidget(widget.style, widget.resource)
      ],
    );
  }

  /// 会员信息
  Widget buildVipInfoWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      height: 136,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.only(left: 20, right: 12, bottom: 12)
                .withRTL(context),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(resource.getResource('ic_mine_vip_bg')))),
            child: Center(
              child: Semantics(
                explicitChildNodes: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      label: 'text_my_marketing_member_center'.tr(),
                      child: Image.asset(resource.getResource('ic_mine_vip_center'),
                          width: 64, height: 14),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Semantics(
                      explicitChildNodes: false,
                      label: 'text_my_marketing_points'.tr() + ref.watch(mineStateNotifierProvider
                          .select((value) => value.vipPoint)),
                      child: ExcludeSemantics(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('text_my_marketing_points'.tr(),
                                style: TextStyle(
                                    fontSize: style.middleText,
                                    fontWeight: FontWeight.w600,
                                    color: style.lightBeige)),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                                ref.watch(mineStateNotifierProvider
                                    .select((value) => value.vipPoint)),
                                style: TextStyle(
                                    fontSize: style.middleText,
                                    fontWeight: FontWeight.w600,
                                    color: style.lightBeige)),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    InkWell(
                      onTap: () {
                        ref
                            .read(mineStateNotifierProvider.notifier)
                            .pushToGrowthCenter();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: style.brandColorGradient,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: Image.asset(
                                    resource.getResource('ic_mine_vip_level'),
                                    width: 12,
                                    height: 12,
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  ref.watch(mineStateNotifierProvider
                                      .select((value) => value.vipLevel)),
                                  style: TextStyle(
                                      fontSize: style.smallText,
                                      fontWeight: FontWeight.w600,
                                      color: style.lightDartBlack),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                                  resource.getResource('ic_mine_vip_arrow_right'),
                                  width: 24,
                                  height: 24)
                              .flipWithRTL(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              width: MediaQuery.of(context).size.width - 40,
              height: 88,
              decoration: BoxDecoration(
                color: style.bgWhite,
                borderRadius:
                    BorderRadius.all(Radius.circular(style.circular8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...ref
                      .read(mineStateNotifierProvider.notifier)
                      .getMallServiceItems()
                      .map((item) {
                    return InkWell(
                      onTap: () {
                        item.onTouchUp?.call();
                      },
                      child: Container(
                          // color: Colors.red,
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            resource.getResource(item.icon),
                            width: 30,
                            height: 30,
                            color: style.textMainBlack,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            item.leftText,
                            style: TextStyle(
                                color: style.textMainBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                    );
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final swiperController = SwiperController();

  Widget buildBannerWidget(style, resource) {
    final vipBanners = ref
        .watch(mineStateNotifierProvider.select((value) => value.vipBanners));
    if (vipBanners.isEmpty) {
      return Container();
    }
    return LayoutBuilder(builder: (context, constraints) {
      var width = constraints.maxWidth - 40;
      var height = width * 88 / 350;
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(style.circular8)),
              color: Colors.transparent),
          margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8), // 设置圆角半径
            child: Swiper(
              itemCount: vipBanners.length,
              pagination: const SwiperPagination(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 8),
                builder: RoundRectSwiperPaginationBuilder(),
              ),
              controller: swiperController,
              autoplay: true,
              scrollDirection: Axis.horizontal,
              onTap: (index) {
                final banner = vipBanners[index];
                final jump_type = banner.jump_type;
                final jump_url = banner.jump_url;
                final appid = banner.appid;
                if (jump_type == null || jump_url == null) {
                  return;
                }
                final extMap = <String, dynamic>{};
                if (banner.appid != null && banner.appid?.isNotEmpty == true) {
                  extMap['id'] = appid;
                  extMap['path'] = jump_url;
                  ref
                      .read(schemeHandleNotifierProvider.notifier)
                      .handleSchemeJump(SchemeType(jump_type), extMap);
                } else {
                  extMap['url'] = jump_url;
                  ref
                      .read(schemeHandleNotifierProvider.notifier)
                      .handleSchemeJump(SchemeType(jump_type), extMap);
                }
              },
              itemBuilder: (context, index) {
                var imageUrl = vipBanners[index].image;
                return imageUrl == null || imageUrl.isEmpty
                    ? SizedBox(
                        width: width,
                        height: height,
                      )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(style.circular8)),
                            color: Colors.transparent),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: width,
                          height: height,
                          errorWidget: (context, string, _) {
                            return Container(
                              width: width,
                              height: height,
                            );
                          },
                        ));
              },
            ),
          ));
    });
  }
}
