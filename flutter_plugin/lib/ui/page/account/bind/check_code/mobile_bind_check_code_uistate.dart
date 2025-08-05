import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'mobile_bind_check_code_uistate.freezed.dart';

@freezed
class MobileBindCheckCodeUiState with _$MobileBindCheckCodeUiState {
  factory MobileBindCheckCodeUiState({
    String? sourceText,
    String? sourceWayText,
    @Default(false) bool enableSend,
    @Default(false) bool enableNext,
    @Default('') String sendButtonText,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _MobileBindCheckCodeUiState;
}
