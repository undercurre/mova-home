import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'mine_email_bind_uistate.freezed.dart';

@freezed
class MineEmailBindUiState with _$MineEmailBindUiState {
  factory MineEmailBindUiState({
    @Default(false) bool enableSend,
    @Default(false) bool agreed,
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(false) bool isbindEmail,
    @Default(false) bool canSendMessage,
  }) = _MineEmailBindUiState;
}
