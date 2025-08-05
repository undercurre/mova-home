import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_mail_ui_state.freezed.dart';

// ignore: camel_case_types
enum BindMailEnum {
  notBindMailType, //未绑定邮箱
  containMailType, //更换邮箱
}

@freezed
class UserMailUiState with _$UserMailUiState {
  factory UserMailUiState({
    required RegionItem currentRegion,
    @Default(BindMailEnum.notBindMailType) BindMailEnum pageType,
    @Default(false) bool enableBindButton, //绑定
    @Default(false) bool timerRunning, //按钮倒计时中

    @Default(false) bool enableMailCodeButton, //验证码
    @Default(false) bool phoneFocus,
    @Default(false) bool phoneCodeFocus,
    @Default(false) bool agreed, //协议；

    @Default(EmptyEvent()) CommonUIEvent event,
    @Default('') String sendMailCodeStr, //邮箱验证码文案
    @Default(true) bool enableSend, //是否可以发送验证码

    String? emailAddress,
    String? emailAddressCode,
    String? password,
    UserInfoModel? userInfo, //用户信息
    SmsTrCodeRes? smsResponse,
  }) = _UserMailUiState;
}
