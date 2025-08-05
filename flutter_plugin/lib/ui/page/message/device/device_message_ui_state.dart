import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_message_ui_state.freezed.dart';

@unfreezed
class DeviceMessageUIState with _$DeviceMessageUIState {
  DeviceMessageUIState._();
  factory DeviceMessageUIState(
      {String? did,
      BaseDeviceModel? currentDevice,
      Map<String, List<Content>>? messageList,
      @Default(false) bool isEdit,
      @Default(false) bool isSelectAll,
      @Default(true) bool loading,
      @Default(0) int unreadTotal,
      @Default(0) int offset,
      CommonUIEvent? uiEvent}) = _DeviceMessageUIState;
}
