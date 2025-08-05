

import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_change_password_ui_state.freezed.dart';


@freezed
class UserChangePasswordUiState with _$UserChangePasswordUiState{
  factory UserChangePasswordUiState({
    @Default(false) bool enableCommitButton,
    @Default(true)  bool oldPasswordFocus,
    @Default(false) bool newPassword1Focus,
    @Default(false) bool newPassword2Focus,


    String? oldPassword,
    String? newPassword1,
    String? newPassword2,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _UserChangePasswordUiState;
}