import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mail_recover_uistate.freezed.dart';

@freezed
class MailRecoverUiState with _$MailRecoverUiState {
  factory MailRecoverUiState({
    @Default(false) bool enableSend,
    @Default(EmptyEvent()) CommonUIEvent event,
    // RegionItem? phoneCodeRegion,
    // String? phone,
  }) = _MailRecoverUiState;
}
