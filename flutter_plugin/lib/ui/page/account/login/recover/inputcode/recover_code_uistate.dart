import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'recover_code_uistate.freezed.dart';

@freezed
class RecoverCodeUiState with _$RecoverCodeUiState {
  factory RecoverCodeUiState({
    @Default(false) bool enableSend,
    // RegionItem? phoneCodeRegion,
    String? sourceText,
    String? sourceWayText,
    @Default(false) bool enableNext,
    @Default('') String sendButtonText,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _RecoverCodeUiState;
}
