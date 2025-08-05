import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_setting_password_ui_state.freezed.dart';

@freezed
class UserSettingPasswordUiState with _$UserSettingPasswordUiState {
  factory UserSettingPasswordUiState({
    @Default(false) bool enableCommitButton,
    String? password1,
    String? password2,
  }) = _UserSettingPasswordUiState;
}
