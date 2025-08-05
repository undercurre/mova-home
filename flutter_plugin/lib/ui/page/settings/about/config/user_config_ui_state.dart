import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_config_ui_state.freezed.dart';

@freezed
class UserConfigPageUiState with _$UserConfigPageUiState {
  factory UserConfigPageUiState(
      {@Default('') String privacyUrl,
      @Default(false) bool isOn,
      @Default(false) bool loading,
      CommonUIEvent? uiEvent}) = _UserConfigPageUiState;
}
