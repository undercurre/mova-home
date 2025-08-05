import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_phone_ui_state.freezed.dart';

@freezed
class ChangePhoneUiState with _$ChangePhoneUiState {
  factory ChangePhoneUiState({
    String? phoneNumber, //手机号
    String? phoneCode, //验证码
    UserInfoModel? userInfo, //用户信息
    SmsTrCodeRes? smsRes, //验证码接口返回数据模型
    String? phoneAreaCode, //手机区号码
    RegionItem? selectRegion, //选择后的国家区域
    required RegionItem currentRegion, //默认的国家区域

    @Default(false) bool enableBindButton, //绑定按钮
    @Default(false) bool timerRunning, //按钮倒计时中

    @Default(false) bool enableValidCodeButton, //验证码按钮

    @Default('') String sendMailCodeStr, //邮箱验证码文案
    @Default(true) bool enableSend, //是否可以发送验证码
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _ChangePhoneUiState;
}
