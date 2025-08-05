import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'router_password_uistate.freezed.dart';

@freezed
class RouterPasswordUiState with _$RouterPasswordUiState {
  const factory RouterPasswordUiState({
    String? routerWifiName,
    @Default('') String routerWifipwd,
    String? domain,
    String? pairQRKey,
    @Default(0) int frequency,
    @Default(false) bool enableBtn,
    @Default(false) bool isAfterSale,
    @Default(false) bool isClearLog,
    @Default(true) bool isWifiOpen,
    IotPairNetworkInfo? iotPairNetworkInfo,
    List<PairGuideModel>? pairGuides,
    @Default(1) int currentStep,
    @Default(1) int totalStep,
    @Default(false) bool autoFocus,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _RouterPasswordUiState;
}
