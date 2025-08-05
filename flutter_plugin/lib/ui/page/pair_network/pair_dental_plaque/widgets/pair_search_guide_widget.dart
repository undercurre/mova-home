import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/pair_network/nearby_connect/nearby_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/nearby_connect/nearby_connect_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/search/pair_search_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';

///牙菌斑配网-唤醒牙刷提示页面
class PairSearchGuideWidget extends ConsumerStatefulWidget {
  const PairSearchGuideWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PairSearchGuideWidgetState();
}

class _PairSearchGuideWidgetState extends ConsumerState<PairSearchGuideWidget> {

  Widget buildItem(BuildContext context, StyleModel style,
      ResourceModel resource, String title, String imgUrl) {
    return Container(
      width: double.infinity,
      height: 246,
      padding: const EdgeInsets.only(top: 13, bottom: 13, left: 16, right: 16),
      decoration: BoxDecoration(
          color: style.bgWhite, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: style.textSecond, fontSize: style.largeText),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: style.bgWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image(
                image: AssetImage(resource.getResource(imgUrl)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: style.bgGray,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                height: 221,
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    resource.getResource('ic_pair_search_guide'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'hint_long_press_enter_network'.tr(),
                style:
                    TextStyle(color: const Color(0xFF333333), fontSize: style.secondary),
              ),
              const SizedBox(height: 10),
              Text(
                'hint_indicator_light_flashes_blue'.tr(),
                style:
                    TextStyle(color: style.textSecond, fontSize: style.largeText),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Image.asset(resource.getResource(ref.watch(
                              pairSearchStateNotifierProvider
                                  .select((value) => value.enableBtn))
                          ? 'ic_agreement_selected'
                          : 'ic_agreement_unselect')),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        'hint_check_toothbrush_is_already'.tr(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: style.textMain),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ).onClick(() {
                  ref
                      .read(pairSearchStateNotifierProvider.notifier)
                      .toggleEnableBtn();
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: DMCommonClickButton(
                  backgroundGradient: style.confirmBtnGradient,
                  disableBackgroundGradient: style.disableBtnGradient,
                  borderRadius: style.buttonBorder,
                  enable: ref.watch(pairSearchStateNotifierProvider
                      .select((value) => value.enableBtn)),
                  text: 'text_powered_on'.tr(),
                  onClickCallback: () {
                    if(Platform.isIOS){
                      // 如果是IOS设备则跳过搜索模块
                     ref
                         .watch(nearbyConnectStateNotifierProvider.notifier)
                         .gotoNextPage(isManualConnect: true);
                    }else{
                      //进入搜索设备热点界面
                      AppRoutes().push(NearbyConnectPage.routePath);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: PairNetIndicatorWidget(
                    ref.watch(pairSearchStateNotifierProvider
                        .select((value) => value.currentStep)),
                    ref.watch(pairSearchStateNotifierProvider
                        .select((value) => value.totalStep)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
