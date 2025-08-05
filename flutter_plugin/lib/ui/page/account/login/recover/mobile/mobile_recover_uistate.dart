import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'mobile_recover_uistate.freezed.dart';

@freezed
class MobileRecoverUiState with _$MobileRecoverUiState {
  factory MobileRecoverUiState({
    @Default(false) bool enableSend,
    RegionItem? phoneCodeRegion,
    String? phone,
    String? initPhone,
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(false) bool prepared,
  }) = _MobileRecoverUiState;
}
