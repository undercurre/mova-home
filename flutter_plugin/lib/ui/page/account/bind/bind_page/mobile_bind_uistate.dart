import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'mobile_bind_uistate.freezed.dart';

@freezed
class MobileBindUiState with _$MobileBindUiState {
  factory MobileBindUiState({
    @Default(false) bool enableSend,
    // RegionItem? phoneCodeRegion,
    @Default('86') String code,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _MobileBindUiState;
}
