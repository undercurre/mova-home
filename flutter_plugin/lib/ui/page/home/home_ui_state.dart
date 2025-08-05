import 'package:dreame_flutter_base_mqtt/dreame_flutter_base_mqtt.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_ui_state.freezed.dart';

@freezed
class HomeUiState with _$HomeUiState {
  const factory HomeUiState({
    @Default(false) bool loading,
    @Default(false) bool refreshing,
    @Default([]) List<BaseDeviceModel> deviceList,
    BaseDeviceModel? currentDevice,
    @Default(0) int currentIndex,
    @Default(-1) int targetTab,
     /// 是否是第一次加载
    @Default(true) bool firstLoad,
    @Default(false) bool loadError,
    @Default(false) bool showMsgTips,
    @Default(false) bool showCustomerS,
    @Default('') String unReadCount,
    CommonUIEvent? uiEvent,
  }) = _HomeUiState;
}
