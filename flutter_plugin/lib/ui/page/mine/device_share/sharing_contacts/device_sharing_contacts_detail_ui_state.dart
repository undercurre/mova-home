import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/mine_share_permission_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_sharing_contacts_detail_ui_state.freezed.dart';

@freezed
class DeviceSharingContactsDetailUiState
    with _$DeviceSharingContactsDetailUiState {
  factory DeviceSharingContactsDetailUiState({
    @Default(MineRecentUser()) MineRecentUser user,
    @Default([]) List<MineSharePermissionModel> permissionList,
    @Default('') String deviceName,
    @Default('') String deviceId,
    @Default({}) Map<String, bool> orgPermissionMap,
    @Default(false) bool originalValue,
    @Default(false) bool isEditable,
    @Default(null) SharedDeviceThumbEntity? sharedEntity,
    @Default([]) List<String> queryResult,
    CommonUIEvent? uiEvent,
  }) = _DeviceSharingContactsDetailUiState;
}
