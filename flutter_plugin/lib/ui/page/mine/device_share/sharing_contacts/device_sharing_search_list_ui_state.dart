import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_sharing_search_list_ui_state.freezed.dart';

@freezed
class DeviceSharingSearchListUiState with _$DeviceSharingSearchListUiState {
  factory DeviceSharingSearchListUiState({
    @Default([]) List<MineRecentUser> userList,
    @Default([]) List<MineRecentUser> searchedList,
    @Default(false) bool nextStepEnable,
    @Default('') String searchedKeyword,
    @Default(null) SharedDeviceThumbEntity? sharedEntity,
    @Default(EmptyEvent()) CommonUIEvent uiEvent,
  }) = _DeviceSharingDetailUiState;
}
