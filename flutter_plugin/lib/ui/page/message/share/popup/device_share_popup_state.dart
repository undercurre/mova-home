import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_share_popup_state.freezed.dart';

@freezed
class DeviceSharePopupState with _$DeviceSharePopupState {
  factory DeviceSharePopupState(CommonUIEvent? uiEvent) = _DeviceSharePopupState;
}
