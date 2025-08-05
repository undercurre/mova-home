import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/hotspot/pair_set_hotspot_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/search/pair_search_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/router_password/router_password_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';

///牙菌斑配网-配网手机热点引导页面
class PairMobileHotspotGuidanceWidget extends ConsumerStatefulWidget {
  const PairMobileHotspotGuidanceWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PairMobileHotspotGuidanceWidgetState();
}

class _PairMobileHotspotGuidanceWidgetState
    extends ConsumerState<PairMobileHotspotGuidanceWidget> {
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'text_explanation_of_supported_network_standards'.tr(),
                        style: TextStyle(
                            color: const Color(0xFFFFB50A),
                            fontSize: style.largeText,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 20),
                      buildItem(
                          context,
                          style,
                          resource,
                          '1.${'text_turn_on_the_mobile_hotspot'.tr()}',
                          'ic_help_hotspot_guidance_1'),
                      const SizedBox(height: 10),
                      buildItem(
                          context,
                          style,
                          resource,
                          '2.${'text_turn_on_the_personal_hotspot'.tr()}',
                          'ic_help_hotspot_guidance_2'),
                      const SizedBox(height: 10),
                      buildItem(
                          context,
                          style,
                          resource,
                          '3.${'text_remember_the_hotspot_password'.tr()}',
                          'ic_help_hotspot_guidance_3'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DMCommonClickButton(
                text: 'text_check_immediately'.tr(),
                backgroundGradient: style.confirmBtnGradient,
                disableBackgroundColor: const Color(0xFFE2E2E2),
                borderRadius: style.buttonBorder,
                onClickCallback: () {
                  LogUtils.d(
                      '-------- PairMobileHotspotGuidanceWidget ---------${'text_check_immediately'.tr()}');
                  // 选择Wi-Fi
                  ref
                      .watch(routerPasswordStateNotifierProvider.notifier)
                      .gotoSettingSelectHotspot();
                },
              ),
              const SizedBox(height: 20),
              DMCommonClickButton(
                text: 'text_checked_next_step'.tr(),
                backgroundGradient: style.cancelBtnGradient,
                disableBackgroundColor: const Color(0xFFE2E2E2),
                borderRadius: style.buttonBorder,
                onClickCallback: () {
                  LogUtils.d(
                      '-------- PairMobileHotspotGuidanceWidget ---------${'text_checked_next_step'.tr()}');
                  AppRoutes().push(PairSetHotspotPage.routePath);
                },
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: false,
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
