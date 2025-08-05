import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info_step_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/search/pair_search_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/widgets/pair_mobile_hotspot_guidance_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';

/// 牙菌斑配网-配网手机热点引导页面
class PairMobileHotspotGuidancePage extends BasePage {
  static const routePath = '/pair_hotspot_guidance';

  const PairMobileHotspotGuidancePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PairMobileHotspotGuidancePageState();
  }
}

class _PairMobileHotspotGuidancePageState extends BasePageState
    with IotPairNetInfoStepMixin {
  @override
  void initData() {
    super.initData();
    ref.read(pairSearchStateNotifierProvider.notifier).initData();
  }

  @override
  PreferredSizeWidget buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: 'text_usage_guide'.tr(),
      bgColor: style.bgGray,
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          onTitleLeftClick();
        }
      },
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return const PairMobileHotspotGuidanceWidget();
  }
}
