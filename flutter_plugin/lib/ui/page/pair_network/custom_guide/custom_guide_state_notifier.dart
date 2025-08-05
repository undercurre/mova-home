import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/ui/page/pair_network/custom_guide/custome_guide_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/nearby_connect/nearby_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_code/pair_qr_code_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_tips/pair_qr_tips_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'custom_guide_uistate.dart';

part 'custom_guide_state_notifier.g.dart';

@riverpod
class CustomGuideStateNotifier extends _$CustomGuideStateNotifier {
  List<PairGuideModel>? _guideList;

  @override
  CustomGuideUiState build(String? guideId) {
    return const CustomGuideUiState();
  }

  void toggleEnableBtn() {
    state = state.copyWith(enableBtn: !state.enableBtn);
  }

  void parseAppRouterExtra(Pair<int, List<PairGuideModel>>? extra) {
    _guideList = extra?.second;
    int sortIndex = extra?.first ?? -1;
    bool isShowOver =
        sortIndex == extra?.second.last.guideSortIndex && sortIndex != -1;
    PairGuideModel? guideModel = extra?.second
        .where((element) => element.guideSortIndex == sortIndex)
        .first;
    state = state.copyWith(
        guideModel: guideModel,
        guideSortIndex: sortIndex,
        totalSteps: IotPairNetworkInfo().totalStep,
        currentStep: IotPairNetworkInfo().currentStep,
        isShowOver: isShowOver);
  }

  Future<bool> _toNextGuidePage() async {
    if (_guideList == null) {
      return false;
    }
    int currentIdx = _guideList!.indexWhere(
        (element) => element.guideSortIndex == state.guideSortIndex);
    if (currentIdx != -1 && currentIdx < (_guideList!.length - 1)) {
      int targetIndex = _guideList![currentIdx + 1].guideSortIndex;
      await AppRoutes().push(CustomGuidePage.routePath,
          extra: Pair(targetIndex, _guideList!));
      return true;
    }
    return false;
  }

  Future<void> gotoNextPage() async {
    if (state.isShowOver) {
      if (IotPairNetworkInfo().pairEntrance == IotPairEntrance.qr &&
          IotPairNetworkInfo().deviceSsid?.isNotEmpty == true) {
        ///一机一码
        await AppRoutes().push(PairQrTipsPage.routePath);
      } else if (IotPairNetworkInfo()
              .product
              ?.extendScType
              .contains(IotDeviceExtendScType.QR_CODE_V2.extendSctype) ==
          true) {
        /// 配网码配网
        await AppRoutes().push(PairQrCodePage.routePath);
      } else if (IotPairNetworkInfo().product?.scType ==
              IotScanType.BLE.scanType ||
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
      await _toNextGuidePage();
    }
  }
}
