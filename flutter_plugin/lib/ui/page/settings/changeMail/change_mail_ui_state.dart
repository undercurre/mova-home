import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_mail_ui_state.freezed.dart';

@freezed
class ChangeMailUiState with _$ChangeMailUiState {
  factory ChangeMailUiState({
    required RegionItem currentRegion,
    @Default(false) bool enableBindButton, //绑定
    @Default(false) bool timerRunning, //按钮倒计时中

    @Default(false) bool enableMailCodeButton, //验证码
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(false) bool agreed, //协议；
    @Default('') String sendMailCodeStr, //邮箱验证码文案

    String? emailAddress,
    String? emailAddressCode,
    UserInfoModel? userInfo, //用户信息
    RecaptchaModel? recaptchaModel, //验证码模型
    @Default(true) bool enableSend, //是否可以发送验证码
    SmsTrCodeRes? smsResponse,
  }) = _ChangeMailUiState;
}
