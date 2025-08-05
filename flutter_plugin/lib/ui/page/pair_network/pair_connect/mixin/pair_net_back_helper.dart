import 'dart:io';

import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/pair_net_module.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/custom_guide/custome_guide_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/product_list/product_list_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/qr_scan_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/router_password/router_password_page.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin PairNetBackHelper<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void gotoHomePage({bool isSuccess = true}) {
    UIModule().exitPairNetEngine(isPairDone: true);
  }

  ///返回到启始页
  void gotoPairNetBackToFirst() {
    /// 是否是非绑定Wi-Fi设备
    bool isNonForceWifi = IotPairNetworkInfo()
            .product
            ?.extendScType
            .contains(IotDeviceExtendScType.NON_FORCE_WIFI.extendSctype) ??
        false;

    var isHasGuidesSteps = IotPairNetworkInfo().guideSteps.isNotEmpty;

    if (!isNonForceWifi) {
      // 跳转到输入Wi-Fi密码页
      // IotPairNetworkInfo().currentStep = 1;
      AppRoutes().popUntil(path: RouterPasswordPage.routePath);
    } else {
      if (isHasGuidesSteps) {
        // IotPairNetworkInfo().currentStep = 1;
        AppRoutes().popAbove(CustomGuidePage.routePath,
            topPath: ProductListPage.routePath, topPath2: QrScanPage.routePath);
      } else {
        AppRoutes().popUntil(
            path: ProductListPage.routePath, path2: QrScanPage.routePath);
      }
    }
  }

  void gotoTriggerApPage() {
    // 判断如果输入Wi-Fi名密码，则跳转进入输入Wi-Fi名密码页面，否则进入引导页面
    gotoPairNetBackToFirst();
  }
}
