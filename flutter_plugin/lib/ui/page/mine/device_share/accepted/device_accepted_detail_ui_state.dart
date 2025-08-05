import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/mine_share_permission_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_accepted_detail_ui_state.freezed.dart';

@freezed
class DeviceAcceptedDetailUiState with _$DeviceAcceptedDetailUiState {
  factory DeviceAcceptedDetailUiState({
    @Default(null) DeviceModel? deviceModel,
    @Default('') String deviceId,
    @Default(false) bool isEditable,
    @Default([]) List<String> queryResult,
    @Default([]) List<MineSharePermissionModel> permissionList,
    @Default(null) SharedDeviceThumbEntity? sharedEntity,
    CommonUIEvent? uiEvent,
  }) = _DeviceAcceptedDetailUiState;
}
