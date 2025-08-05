
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_ui_state.freezed.dart';

@freezed
class SettingsPageUiState with _$SettingsPageUiState{
  factory SettingsPageUiState({
    @Default(false) bool hasNewAppVersion,
    @Default(false) bool devOption
  }) = _SettingsPageUiState;
}