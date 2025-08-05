import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_page.dart';

import 'nearby_connect_uistate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nearby_connect_state_notifier.g.dart';

@riverpod
class NearbyConnectStateNotifier extends _$NearbyConnectStateNotifier {
  @override
  NearbyConnectUiState build() {
    return NearbyConnectUiState();
  }

  void initData(IotPairNetworkInfo? pairNetworkHelper) {
    state = state.copyWith(
        iotPairNetworkInfo: pairNetworkHelper,
        currentStep: IotPairNetworkInfo().totalStep - 1,
        totalStep: IotPairNetworkInfo().totalStep);
  }

  void updataScanDeviceList(List<IotDevice> scanList) {
    final deviceType = IotPairNetworkInfo().product?.deviceType;
    final vaildList =
        scanList.where((element) => element.product?.deviceType == deviceType);
    state = state.copyWith(scanList: [...vaildList]);
  }

  void updateProgress(double progress) {
    state = state.copyWith(progress: progress);
  }

  void updatescaningResult(ScanState newState, double progress) {
    state = state.copyWith(scanState: newState, progress: progress);
  }

  void selectedIotDevice(IotDevice? iotDevice) {
    IotPairNetworkInfo().selectIotDevice = iotDevice;
    state = state.copyWith(selectedDevice: iotDevice);
  }

  Future<void> gotoNextPage({bool isManualConnect = false}) async {
    if (isManualConnect) {
      IotPairNetworkInfo().selectIotDevice = null;
    }
    await AppRoutes()
        .push(PairConnectPage.routePath, extra: {'isManualConnect': isManualConnect});
  }
}
