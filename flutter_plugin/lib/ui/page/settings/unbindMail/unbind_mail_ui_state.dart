import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/account/smscode.dart';

import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'unbind_mail_ui_state.freezed.dart';

@freezed
class UnbindMailUiState with _$UnbindMailUiState {
  factory UnbindMailUiState({
    @Default(false) bool enableMailCodeButton, //验证码
    @Default(false) bool enableUnbindButton, //是否可以点击 解绑按钮
    @Default(false) bool phoneFocus,
    @Default(false) bool phoneCodeFocus,
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default('') String sendMailCodeStr, //邮箱验证码文案
    @Default(true) bool enableSend, //是否可以发送验证码

    String? emailAddress,
    String? emailAddressCode,
    String? password,
    UserInfoModel? userInfo, //用户信息

    SmsTrCodeRes? smsResponse,
  }) = _UnbindMailUiState;
}
