import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/bridge/pair_net_module.dart';

import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/mixin/pair_net_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_network_repository.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/qr_scan_ui_state.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'qr_scan_bussiness_ui_state.dart';

part 'qr_scan_bussiness_state_notifier.g.dart';

@riverpod
class QrScanBussinessStateNotifier extends _$QrScanBussinessStateNotifier {
  late IotPairNetworkInfo pairEntry;

  @override
  QrScanBussinessUiState build() {
    return QrScanBussinessUiState();
  }

  void initData() async {}


  void updateEvent(CommonUIEvent event) {
    if (event is LoadingEvent) {
      state = state.copyWith(loading: event.isLoading);
    } else {
      state = state.copyWith(event: event);
    }
  }

  void reportPopToPage() {}

  void reportPushToPage() {}

}
