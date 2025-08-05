import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/account/smscode.dart';

import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart'; //数据源
import 'package:flutter_plugin/ui/page/settings/unbindPhone/unbind_phone_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unbind_phone_state_notifier.g.dart';

@riverpod
class UnbindPhoneStateNotifier extends _$UnbindPhoneStateNotifier {
  @override
  UnbindPhoneUiState build() {
    return UnbindPhoneUiState(
      sendPhoneCodeStr: 'send_sms_code'.tr(),
    );
  }

  Timer? _currentTimer;
  int _countTime = 0;

  Future<void> getUserInfo() async {
    try {
      UserInfoModel? userInfo =
          await ref.watch(accountSettingRepositoryProvider).getUserInfo();
      if (userInfo.phone != null && userInfo.phone!.isNotEmpty) {
        state = state.copyWith(userInfo: userInfo, phoneNumber: userInfo.phone);
      }
      await AccountModule().saveUserInfo(userInfo);
    } catch (error) {
      LogUtils.e(error);
    }
  }

  /// 检查手机号是否有效
  bool checkPhoneNumber() {
    var phoneNumber = state.phoneNumber ?? '';
    String reginCode = state.userInfo?.phoneCode ?? '';
    var ret = isValidPhonenumber(phoneNumber, reginCode);
    if (!ret) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'text_error_phone_format'.tr()));
    }
    return ret;
  }

  //解除绑定
  Future<bool> unbindPhoneAction() async {
    try {
      String phoneNumber = state.userInfo?.phone ?? '';
      String regnCode = state.userInfo?.phoneCode ?? '';
      String codeKey = state.smsRes?.codeKey ?? '';
      String codeValue = state.phoneCode ?? '';
      if (_vertifiCommitParams(phoneNumber, regnCode, codeKey, codeValue)) {
        SmartDialog.showLoading();
        await ref
            .watch(accountSettingRepositoryProvider)
            .unbindPhoneNumber(phoneNumber, codeValue, codeKey, codeValue);
        SmartDialog.dismiss(status: SmartStatus.loading);
        return Future.value(true);
      }
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      var code = e.code;
      switch (code) {
        case 11000:
        case 11001:
        case 11005:
        case 11006:
        case 10121:
          ref
              .read(unbindPhoneEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case 30410:
          ref
              .read(unbindPhoneEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'user_not_exist'.tr()));
          break;
        case 30915:
          ref
              .read(unbindPhoneEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'not_allow_unbind_phone'.tr()));
          break;
        default:
          ref
              .read(unbindPhoneEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'unbind_failed'.tr()));
      }
    } catch (error) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.e(error);
    }
    return Future.value(false);
  }

  //解绑手机号（获取验证码）
  Future<Pair<bool, SmsTrCodeRes?>> unbindGetPhoneCodeAction(
      RecaptchaModel recaptchaModel) async {
    // 验证滑块验证码是否错误
    if (recaptchaModel.result == -100) {
      // 取消
      return Future.value(Pair(false, null));
    }
    if (recaptchaModel.result != 0) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
      return Future.value(Pair(false, null));
    } else {
      try {
        var langString = await LocalModule().getLangTag();
        String phone = state.userInfo?.phone ?? '';
        String reginCode = state.userInfo?.phoneCode ?? '';
        String lang = langString;
        if (_vertifiGetPhoneCodeParams(phone, reginCode, lang)) {
          SmartDialog.showLoading();
          state = state.copyWith(enableSend: false);
          SmsTrCodeRes smsResponse = await ref
              .watch(accountSettingRepositoryProvider)
              .unbindGetPhoneVertificationCode(
                  recaptchaModel, phone, reginCode, lang);
          state = state.copyWith(smsRes: smsResponse);
          startTime();
          SmartDialog.dismiss(status: SmartStatus.loading);

          return Future.value(Pair(true, smsResponse));
        }
      } on DreameException catch (e) {
        state = state.copyWith(enableSend: true);
        SmartDialog.dismiss(status: SmartStatus.loading);
        var code = e.code;
        switch (code) {
          case 11003:
            ref
                .read(unbindPhoneEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'send_sms_too_frequent'.tr()));
            break;
          case 11004:
            ref
                .read(unbindPhoneEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'text_error_toomuch'.tr()));
            break;
          case 30410:
            ref
                .read(unbindPhoneEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'user_not_exist'.tr()));
            break;
          case 30915:
            ref
                .read(unbindPhoneEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'not_allow_unbind_phone'.tr()));
            break;
          default:
            ref
                .read(unbindPhoneEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
            break;
        }
      } catch (error) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        ref
            .read(unbindPhoneEventProvider.notifier)
            .sendEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
        LogUtils.e(error);
      }
    }
    return Future.value(Pair(false, null));
  }

  void _verifyUnbindCombinTextField(String phone, String phoneCode) {
    if (phone.isNotEmpty && phoneCode.isNotEmpty) {
      state = state.copyWith(enableUnbindButton: true);
    } else {
      state = state.copyWith(enableUnbindButton: false);
    }
  }

  // 提交参数校验
  bool _vertifiCommitParams(
      String phone, String regnCode, String codeKey, String codeValue) {
    if (phone.isEmpty) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'mobile_invalid'.tr()));
      return false;
    } else if (regnCode.isEmpty || codeKey.isEmpty) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'get_sms_code'.tr()));
      return false;
    } else if (codeValue.isEmpty || codeValue.length < 6) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'email_code_invalid'.tr()));
      return false;
    }
    return true;
  }

  bool _vertifiGetPhoneCodeParams(String phone, String regnCode, String lang) {
    if (phone.isEmpty) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'mobile_invalid'.tr()));
      return false;
    } else if (regnCode.isEmpty || lang.isEmpty) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'get_sms_code'.tr()));
      return false;
    }
    return true;
  }

  void changeUnbindPhoneCodeNumber(String content) {
    _verifyUnbindCombinTextField(state.phoneNumber ?? '', content);
    state = state.copyWith(phoneCode: content);
  }

  void startTime() {
    _countTime = 59;
    const period = Duration(seconds: 1);
    _currentTimer?.cancel();
    _currentTimer = Timer.periodic(period, (timer) {
      _countTime--;
      _checkTimeInterval();
    });
    _checkTimeInterval();
  }

  void _checkTimeInterval() {
    String sendButtonText = '';
    bool sendEnable = false;
    if (_countTime >= 0) {
      sendButtonText = '${_countTime.toString()}s';
      sendEnable = false;
    } else {
      sendButtonText = 'send_sms_code'.tr();
      sendEnable = true;
      _currentTimer?.cancel();
    }

    state = state.copyWith(
      sendPhoneCodeStr: sendButtonText,
    );
    if (sendEnable != state.enableSend) {
      state = state.copyWith(enableSend: sendEnable);
    }
  }

  void dispose() {
    _currentTimer?.cancel();
    _currentTimer = null;
  }
}

@riverpod
class UnbindPhoneEvent extends _$UnbindPhoneEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent event) {
    state = event;
  }
}
