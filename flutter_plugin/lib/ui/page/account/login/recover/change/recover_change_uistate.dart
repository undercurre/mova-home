import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'recover_change_uistate.freezed.dart';

@freezed
class RecoverChangeUiState with _$RecoverChangeUiState {
  factory RecoverChangeUiState({
    @Default(false) bool enableNext,
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(true) bool hidePassword,
    @Default(true) bool configPassword,
  }) = _RecoverChangeUiState;
}
