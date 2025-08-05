import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/email_collection_respository.dart';
import 'package:flutter_plugin/ui/page/email_collection/userinfo_change_event.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart'; //数据源
import 'package:flutter_plugin/ui/page/settings/changeMail/change_mail_ui_state.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_mail_state_notifier.g.dart';

@riverpod
class ChangeMailStateNotifier extends _$ChangeMailStateNotifier {
  @override
  ChangeMailUiState build() {
    RegionItem item = RegionStore().currentRegion;
    return ChangeMailUiState(
      sendMailCodeStr: 'send_sms_code'.tr(),
      currentRegion: item,
    );
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

  /// 获取邮箱验证码
  Future<SmsTrCodeRes?> getEmailCodeAction(
      RecaptchaModel recaptchaModel) async {
    LogUtils.i('changemailPage getEmailCodeAction start');
    String emailAddress = state.emailAddress ?? '';
    String lange = await LocalModule().getLangTag();
    if (!_validGerMailCodeParams(emailAddress)) {
      LogUtils.i('changemailPage mail not avalid');
      return Future.value(null);
    }

    state = state.copyWith(
      recaptchaModel: recaptchaModel,
    );
    LogUtils.i('changemailPage start request');
    try {
      SmartDialog.showLoading();
      state = state.copyWith(enableSend: false);
      var data = await ref
          .watch(accountSettingRepositoryProvider)
          .getEmailVerificationCode(recaptchaModel, emailAddress, lange);
      startTime();
      state = state.copyWith(smsResponse: data);
      SmartDialog.dismiss(status: SmartStatus.loading);
      ref
          .read(changeMailUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'send_success'.tr()));
      return Future.value(data);
    } on DreameException catch (e) {
      LogUtils.i('changemailPage  request on catch error');
      state = state.copyWith(enableSend: true);
      SmartDialog.dismiss(status: SmartStatus.loading);
      var code = e.code;
      switch (code) {
        case 10007:
          ref
              .read(changeMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'mail_error'.tr()));
          break;
        case 11003:
          ref
              .read(changeMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'send_sms_too_frequent'.tr()));
          break;
        case 11004:
          ref
              .read(changeMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'text_error_toomuch'.tr()));
          break;
        case 30911:
          showAlertforceBindTips();
          break;
        case 30913:
          ref.read(changeMailUiEventProvider.notifier).sendEvent(
              ToastEvent(text: 'can_not_change_original_email'.tr()));
          break;
        default:
          ref
              .read(changeMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'operate_failed'.tr()));
          break;
      }
    } catch (error) {
      LogUtils.i('changemailPage  request catch error');
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.e(error);
      return Future.error(error);
    }
  }

  Future<bool> bindEmailAction(bool force) async {
    String emailAddress = state.emailAddress ?? '';
    String emailAddressCode = state.emailAddressCode ?? '';
    String codeKey = state.smsResponse?.codeKey ?? '';
    if (_validBindCommitParams(emailAddress, emailAddressCode, codeKey)) {
      try {
        SmartDialog.showLoading();
        if (force == false) {
          bool checkSuccess = await ref
              .watch(accountSettingRepositoryProvider)
              .checkEmailVerificationCode(
                  emailAddress, codeKey, emailAddressCode);
          if (!checkSuccess) return Future.value(false);
        }
        await ref
            .watch(accountSettingRepositoryProvider)
            .bindEmail(emailAddress, codeKey, force: force);
        EventBusUtil.getInstance().fire(UserInfoChangeEvent());
        if (state.agreed) {
          await emailSubsribue();
        }
        SmartDialog.dismiss(status: SmartStatus.loading);
        return Future.value(true);
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
                .read(changeMailUiEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
            break;
          case 11015:
            ref
                .read(changeMailUiEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'email_code_invalid'.tr()));

            break;
          case 30911:
            showAlertforceBindTips();
            break;
          default:
            ref
                .read(changeMailUiEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'bind_failure'.tr()));
            break;
        }
      } catch (error) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        LogUtils.e(error);
        return Future.value(false);
      }
    }
    return Future.value(false);
  }

  void agreementChange() {
    state = state.copyWith(agreed: !state.agreed);
  }

  Future<bool> emailSubsribue() async {
    bool isSuccess =
        await ref.read(emailCollectionRespositoryProvider.notifier).subscribe();
    ;
    if (isSuccess == true) {
      return Future.value(true);
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
    bool timerRunning = state.timerRunning;

    if (_countTime >= 0) {
      sendButtonText = '${_countTime.toString()}s';
      sendEnable = false;
      timerRunning = true;
    } else {
      sendButtonText = 'send_sms_code'.tr();
      sendEnable = true;
      timerRunning = false;

      _currentTimer?.cancel();
    }

    state = state.copyWith(
      sendMailCodeStr: sendButtonText,
    );
    if (sendEnable != state.enableSend) {
      state = state.copyWith(enableSend: sendEnable);
    }
    if (timerRunning != state.timerRunning) {
      state = state.copyWith(timerRunning: timerRunning);
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

  void changeEmailAddressCode(String content) {
    state = state.copyWith(emailAddressCode: content);
    _validCanClickCommitButton();
  }

  /// 验证邮箱格式
  bool verifyMailFormat() {
    String emailAddress = state.emailAddress ?? '';
    if (emailAddress.length > 45) {
      ref
          .read(changeMailUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'email_too_long'.tr()));
      return false;
    }
    if (!isVaildEmail(emailAddress)) {
      ref
          .read(changeMailUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'mail_error'.tr()));
      return false;
    }
    return true;
  }

  // 提交网络请求前的本地验证
  bool _validBindCommitParams(
      String emailAddress, String emailAddressCode, String codekey) {
    if (!isVaildEmail(emailAddress)) {
      ref
          .read(changeMailUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'mail_error'.tr()));
      return false;
    } else if (codekey.isEmpty) {
      ref
          .read(changeMailUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'get_sms_code'.tr()));
      return false;
    } else if (emailAddressCode.isEmpty || emailAddressCode.length < 6) {
      ref
          .read(changeMailUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'sms_code_invalid'.tr()));
      return false;
    }
    return true;
  }

  bool _validGerMailCodeParams(String emailAddress) {
    if (emailAddress.length > 45) {
      SmartDialog.showToast('email_too_long'.tr());
      return false;
    }
    return true;
  }

  // 验证按钮是否可点击
  void _validCanClickCommitButton() {
    String email = state.emailAddress ?? '';
    String emailCode = state.emailAddressCode ?? '';
    if (email.isNotEmpty && emailCode.isNotEmpty) {
      state = state.copyWith(enableBindButton: true);
    } else {
      state = state.copyWith(enableBindButton: false);
    }
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

  // 强制弹窗提示
  void showAlertforceBindTips() {
    showAlert(
      text: 'text_mine_phone_email_cover'.tr(),
      cancelString: 'cancel'.tr(),
      confirmString: 'confirm'.tr(),
      confirmCallBack: () async {
        bool success = await bindEmailAction(true);
        if (success) {
          ref
              .watch(changeMailUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'bind_success'.tr()));
          ref.watch(changeMailUiEventProvider.notifier).sendEvent(PushEvent(
              popUntilPath: AccountSettingPage.routePath,
              func: RouterFunc.pop));
        }
      },
    );
  }

  void showAlert({
    required String text,
    String? cancelString,
    String? confirmString,
    Function()? confirmCallBack,
    Function()? cancelCallback,
  }) {
    AlertEvent alert = AlertEvent(
      content: text,
      cancelContent: cancelString ?? 'cancel'.tr(),
      confirmContent: confirmString ?? 'confirm'.tr(),
      confirmCallback: confirmCallBack,
      cancelCallback: cancelCallback,
    );
    state = state.copyWith(event: alert);
  }
}

@riverpod
class ChangeMailUiEvent extends _$ChangeMailUiEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent value) {
    state = value;
  }
}
