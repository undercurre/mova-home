import 'dart:io';
import 'dart:ui';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/pair_net_module.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/custom_guide/custome_guide_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/nearby_connect/nearby_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/pair_type_selection_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_network_repository.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_tips/pair_qr_tips_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/router_password/router_password_page.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin PairNetMixin<T> on AutoDisposeNotifier<T> {
  late IotPairNetworkInfo pairEntry = IotPairNetworkInfo()..enterPairNet();

  late VoidCallback? onStart;
  late VoidCallback? onComplete;

  /// 跳转到下一页，开始配网
  /// ap !=null,表示是一机一码
  Future<void> gotoPairNet(
      Product product, VoidCallback? onStart, VoidCallback? onComplete) async {
    this.onStart = onStart;
    this.onComplete = onComplete;
    onStart?.call();
    final getCommonPairNetEnable = await ref
        .read(developerMenuPageStateNotifierProvider.notifier)
        .getCommonPairNetEnable();
    if (getCommonPairNetEnable) {
      /// 跳转到Flutter配网
      await toPairGuidePage(product.productId, pairEntry);
      return;
    }

    /// 判断是跳转到原生还是跳转到Flutter
    if (product.model.contains('.vacuum.') ||
        product.model.contains('.hold.') ||
        product.model.contains('dreame.mower.p2255') ||
        product.model.contains('dreame.mower.g2422') ||
        product.model.contains('dreame.mower.g3422') ||
        product.model.contains('dreame.mower.p3255')) {
      /// 跳转原生
      this.onComplete?.call();
      await PairNetModule().startPairing(pairEntry);
    } else {
      /// 跳转到Flutter配网
      await toPairGuidePage(product.productId, pairEntry);
    }
  }

  /// 默认流程：
  /// scType包含了[IotScanType.WIFI]、[IotScanType.WIFI_BLE] 则先跳转[RouterPasswordPage]，然后跳转到引导页[CustomGuidePage]，
  /// 再跳转到附近设备扫描页[NearbyConnectPage]，最后配网[PairConnectPage];
  Future<void> toPairGuidePage(
      String productId, IotPairNetworkInfo pairNetworkInfo,
      {String? ap = null}) async {
    var guides = await getPairGuideList(productId);

    /// 总步骤计算：Wi-Fi + 配网引导 + 附近设备扫描 + 配网
    IotPairNetworkInfo().calculateTotalStep(guides);
    this.onComplete?.call();
    if (pairNetworkInfo.product?.extendScType
            .contains(IotDeviceExtendScType.NON_FORCE_WIFI.extendSctype) ==
        true) {
      /// 点击的附近设备，则跳过引导
      if (pairNetworkInfo.pairEntrance == IotPairEntrance.nearby) {
        await AppRoutes().push(PairConnectPage.routePath);
        return;
      }

      // 不需要配置Wi-Fi,跳转到引导页，没有引导直接跳过
      if (guides.isEmpty) {
        /// 1、一机一码
        if (IotPairNetworkInfo().pairEntrance == IotPairEntrance.qr &&
            IotPairNetworkInfo().deviceSsid?.isNotEmpty == true) {
          if (IotPairNetworkInfo().product?.scType ==
              IotScanType.BLE.scanType) {
            await AppRoutes().push(PairConnectPage.routePath);
          } else {
            await AppRoutes().push(PairQrTipsPage.routePath);
          }
        }

        /// 2、扫描到的附近设备
        else if (IotPairNetworkInfo().pairEntrance == IotPairEntrance.nearby) {
          await AppRoutes().push(PairConnectPage.routePath);
        }

        /// 3、点击item 设备， WIFI_BLE和BLE情况，直接跳转到扫描附近设备页面，只Wi-Fi情况，IOS直接手动，Android跳转附近扫描设备页
        if (IotPairNetworkInfo().product?.scType == IotScanType.BLE.scanType ||
            IotPairNetworkInfo().product?.scType ==
                IotScanType.WIFI_BLE.scanType) {
          await AppRoutes().push(NearbyConnectPage.routePath);
        } else if (IotPairNetworkInfo().product?.scType ==
            IotScanType.WIFI.scanType) {
          if (Platform.isIOS) {
            await AppRoutes().push(PairConnectPage.routePath);
          } else {
            await AppRoutes().push(NearbyConnectPage.routePath);
          }
        } else {
          /// 其他未知 不管
          await AppRoutes().push(PairConnectPage.routePath);
        }
      } else {
        // 如果是扫到的附近设备，直接跳转到配网页
        await AppRoutes().push(CustomGuidePage.routePath,
            extra: Pair(guides.first.guideSortIndex, guides));
      }
    } else {
      // 需要配置Wi-Fi
      await AppRoutes().push(RouterPasswordPage.routePath, extra: guides);
    }
  }

  Future<List<PairGuideModel>> getPairGuideList(String productId) async {
    try {
      var guideList = await ref
          .read(pairNetworkRepositoryProvider)
          .getPairGuideList(productId);
      return guideList;
    } on DreameException catch (e) {
      LogUtils.d('--== exception -- ${e.code} ${e.message}');
      return [];
    } catch (e) {
      LogUtils.d('--== exception -- $e');
      return [];
    }
  }
}
