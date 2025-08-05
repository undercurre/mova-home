import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_solution/pair_solution_ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
part 'pair_solution_state_notifier.g.dart';

@riverpod
class PairSolutionStateNotifier extends _$PairSolutionStateNotifier {
  @override
  PairSolutionUiState build() {
    return PairSolutionUiState();
  }

  void initData() {
    var scType = IotPairNetworkInfo().product?.scType;
    List<PairSolutionModel> solutions = [];
    var bleSolution = PairSolutionModel();
    bleSolution.title = IotScanType.BLE.scanType == scType
        ? 'look_up_desc'.tr()
        : 'text_ble_pair_solution_tip'.tr();
    bleSolution.solution = [
      'text_keep_net_stable'.tr(),
      'text_keep_permission_authed'.tr(),
      'text_keep_device_on_power'.tr(),
      'text_keep_distance_appropriate'.tr(),
      'text_keep_device_reset_net'.tr()
    ];
    solutions.add(bleSolution);
    if (scType != IotScanType.BLE.scanType) {
      var apSolution = PairSolutionModel();
      apSolution.title = 'text_ap_pair_solution_tip'.tr();
      apSolution.solution = [
        'network_config_error_wifi'.tr(),
        'network_config_error_wifipwd'.tr(),
        'network_config_error_character'.tr(),
        'network_config_error_mac'.tr(),
        'network_config_error_vpn'.tr(),
        'network_config_error_auth'.tr(),
        'network_config_error_wifiname'.tr(),
        'network_config_error_network_unreachable'.tr(),
        'text_poor_wifi'.tr()
      ];
      solutions.add(apSolution);
    }
    state = state.copyWith(solutions: solutions);
  }
}
