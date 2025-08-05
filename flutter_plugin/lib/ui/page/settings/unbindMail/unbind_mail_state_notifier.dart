import 'dart:async';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart'; //数据源
import 'package:flutter_plugin/ui/page/settings/unbindMail/unbind_mail_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unbind_mail_state_notifier.g.dart';

@riverpod
class UnbindMailStateNotifier extends _$UnbindMailStateNotifier {
  @override
  UnbindMailUiState build() {
    return UnbindMailUiState(sendMailCodeStr: 'send_sms_code'.tr());
  }

  Timer? _currentTimer;
  int _countTime = 0;

  Future<UserInfoModel> getUserInfo() async {
    try {
      UserInfoModel userInfo =
          await ref.watch(accountSettingRepositoryProvider).getUserInfo();
      state = state.copyWith(
        userInfo: userInfo,
      );

      return Future.value(userInfo);
    } catch (error) {
      LogUtils.e(error);
      return Future.error(error);
    }
  }

  Future<SmsTrCodeRes?> getEmailCodeAction(
      RecaptchaModel recaptchaModel) async {
    String emailAddress = state.emailAddress ?? '';
    String lange = await LocalModule().getLangTag();
    if (!_validGerMailCodeParams(emailAddress)) {
      return Future.value(null);
    }

    try {
      SmartDialog.showLoading();
      var data = await ref
          .watch(accountSettingRepositoryProvider)
          .getEmailVerificationCode(recaptchaModel, emailAddress, lange);
      startTime();
      state = state.copyWith(smsResponse: data);
      SmartDialog.dismiss(status: SmartStatus.loading);
      ref
          .read(unbindMailUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'send_success'.tr()));
      return Future.value(data);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      var code = e.code;
      switch (code) {
        case 10007:
          ref
              .read(unbindMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'mail_error'.tr()));
        case 11003:
          ref
              .read(unbindMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'send_sms_too_frequent'.tr()));
        case 11004:
          ref
              .read(unbindMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'text_error_toomuch'.tr()));
        case 30911:

          ///xxxxx
          ref
              .read(unbindMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'change_email_has_registered'.tr()));

        case 30913:
          ref.read(unbindMailUiEventProvider.notifier).sendEvent(
              ToastEvent(text: 'can_not_change_original_email'.tr()));

        default:
          ref
              .read(unbindMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'operate_failed'.tr()));
      }
    } catch (error) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.e(error);
      return Future.error(error);
    }
  }

  Future<bool> unbindEmailAction() async {
    String phone = state.userInfo?.phone ?? '';
    if (phone.isEmpty) {
      ref
          .read(unbindMailUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'not_allow_unbind_phone'.tr()));
      return Future.value(false);
    } else if (state.userInfo?.hasPass == false) {
      ref.read(unbindMailUiEventProvider.notifier).sendEvent(
          ToastEvent(text: 'Popup_Me_Account_AddEmail_Unbundle'.tr()));
      return Future.value(false);
    }

    String password = state.password ?? '';
    try {
      SmartDialog.showLoading();
      bool isSuccess = await ref
          .watch(accountSettingRepositoryProvider)
          .unbindEmail(password);
      SmartDialog.dismiss(status: SmartStatus.loading);
      return Future.value(isSuccess);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      var code = e.code;
      switch (code) {
        case 10009:
        case 30914:
          ref
              .read(unbindMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'unbind_email_password_error'.tr()));
        case 30915:
          ref
              .read(unbindMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'not_allow_unbind_email'.tr()));
        default:
          ref
              .read(unbindMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'unbind_failed'.tr()));
      }
    } catch (error) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.e(error);
      return Future.value(false);
    }
    return Future.value(false);
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
      sendMailCodeStr: sendButtonText,
    );
    if (sendEnable != state.enableSend) {
      state = state.copyWith(enableSend: sendEnable);
    }
  }

  void dispose() {
    _currentTimer?.cancel();
    _currentTimer = null;
  }

  void changeEmailAddress(String content) {
    state = state.copyWith(emailAddress: content);
    _validCanClickMailCodeButton();
  }

  void changePassword(String content) {
    state = state.copyWith(password: content);
    _validCanClickUnbindButton();
  }

  // 提交网络请求前的本地验证
  bool _validGerMailCodeParams(String emailAddress) {
    if (emailAddress.length > 45) {
      SmartDialog.showToast('email_too_long'.tr());
      return false;
    }
    return true;
  }

  // 验证按钮是否可点击
  void _validCanClickMailCodeButton() {
    String emailAddress = state.emailAddress ?? '';
    if (emailAddress.isNotEmpty && isVaildEmail(emailAddress)) {
      state = state.copyWith(enableMailCodeButton: true);
    } else {
      state = state.copyWith(enableMailCodeButton: false);
    }
  }

  // 验证是否可以点击 解除绑定按钮
  void _validCanClickUnbindButton() {
    String password = state.password ?? '';
    if (password.isNotEmpty) {
      state = state.copyWith(enableUnbindButton: true);
    } else {
      state = state.copyWith(enableUnbindButton: false);
    }
  }
}

@riverpod
class UnbindMailUiEvent extends _$UnbindMailUiEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent value) {
    state = value;
  }
}
