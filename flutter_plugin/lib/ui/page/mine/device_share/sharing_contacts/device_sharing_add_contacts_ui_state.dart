import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_sharing_add_contacts_ui_state.freezed.dart';

@freezed
class DeviceSharingAddContactsUiState with _$DeviceSharingAddContactsUiState {
  factory DeviceSharingAddContactsUiState({
    @Default(1) int page,
    @Default(20) int size,
    @Default([]) List<MineRecentUser> userList,
    @Default(null) SharedDeviceThumbEntity? sharedEntity,
    CommonUIEvent? uiEvent,
  }) = _DeviceSharingAddContactsUiState;
}
