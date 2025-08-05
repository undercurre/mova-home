import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'unbind_phone_ui_state.freezed.dart';

@freezed
class UnbindPhoneUiState with _$UnbindPhoneUiState {
  factory UnbindPhoneUiState({
    String? phoneNumber, //手机号
    String? phoneCode, //验证码
    UserInfoModel? userInfo, //用户信息
    SmsTrCodeRes? smsRes, //验证码接口返回数据模型
    String? phoneAreaCode, //手机区号码
    @Default('') String sendPhoneCodeStr, //邮箱验证码文案
    @Default(true) bool enableSend, //是否可以发送验证码

    @Default(false) bool showChangeEmail, //更换邮箱
    @Default(EmptyEvent()) CommonUIEvent event,

    // 解除绑定
    @Default(false) bool enableUnbindButton, //解除绑定按钮可点击状态
  }) = _UnbindPhoneUiState;
}
