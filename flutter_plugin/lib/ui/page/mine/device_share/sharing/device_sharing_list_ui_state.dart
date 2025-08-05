import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_sharing_list_ui_state.freezed.dart';

@freezed
class DeviceSharingListUiState with _$DeviceSharingListUiState {
  factory DeviceSharingListUiState({
    @Default(1) int page,
    @Default(20) int size,
    @Default([]) List<DeviceModel> deviceList,
    @Default(null) SharedDeviceThumbEntity? sharedEntity,
    CommonUIEvent? uiEvent,
  }) = _DeviceSharingListUiState;
}
