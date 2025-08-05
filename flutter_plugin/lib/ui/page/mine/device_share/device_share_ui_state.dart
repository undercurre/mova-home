import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_share_ui_state.freezed.dart';

@freezed
class DeviceShareUiState with _$DeviceShareUiState {
  factory DeviceShareUiState({
    @Default(false) bool showSharingListPage,
    @Default(false) bool showAcceptedLisePage,
    CommonUIEvent? uiEvent,
  }) = _DeviceShareUiState;
}
