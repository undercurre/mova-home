import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/model/account/sendcode/send_code_model.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'mobile_login_code_uistate.dart';

part 'mobile_login_code_state_notifier.g.dart';

@riverpod
class MobileLoginCodeStateNotifier extends _$MobileLoginCodeStateNotifier {
  @override
  MobileLoginCodeUiState build() {
    RegionItem item = RegionStore().currentRegion;
    return MobileLoginCodeUiState(currentPhone: item, currentRegion: item);
  }

  void init(SendCodeModel data) {
    state = state.copyWith(
        account: data.phone,
        interval: data.interval,
        codeKey: data.codeKey,
        currentPhone: data.currentPhone,
        currentRegion: data.currentRegion);
  }

  void sendInput(String code) {
    bool isInputValid = code.length == 6;
    state = state.copyWith(code: code, isInputInvalid: isInputValid);
  }

  Future<bool> sendCodeAgain(RecaptchaModel recaptchaModel) async {
    // 验证滑块验证码是否错误
    if (recaptchaModel.result == -100) {
      // 取消
      return Future.value(false);
    }
    if (recaptchaModel.result != 0) {
      ref
          .read(mobileLoginCodeEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
      return Future.value(false);
    }
    if (recaptchaModel.result == 0) {
      LogUtils.d('----- sendVerifyCode ------++++++ ');
      try {
        SmartDialog.showLoading();
        var lang = await LocalModule().getLangTag();
        var phoneCode = state.currentPhone.code;
        var smsCodeReq = SmsCodeReq(
          phone: state.account,
          phoneCode: phoneCode,
          lang: lang,
          token: recaptchaModel.token ?? '',
          sessionId: recaptchaModel.csessionid ?? '',
          sig: recaptchaModel.sig ?? '',
        );
        var data = await ref
            .read(accountRepositoryProvider)
            .getLoginVerificationCode(smsCodeReq);
        SmartDialog.dismiss(status: SmartStatus.loading);
        LogUtils.d('----- sendVerifyCode ------++++++ $data');
        // 验证码发送成功
        state = state.copyWith(
            interval: data.interval ?? 60, codeKey: data.codeKey);
        ref
            .read(mobileLoginCodeEventProvider.notifier)
            .sendEvent(ToastEvent(text: 'send_success'.tr()));
        return Future.value(true);
      } on DreameException catch (e) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        var code = e.code;
        switch (code) {
          case 11002:
            showToast('send_sms_code_error'.tr());
            break;
          case 11003:
            showToast('send_sms_too_frequent'.tr());
            break;
          case 11004:
            showToast('text_error_toomuch'.tr());
            break;
          case BadResultCode.NET_ERROR:
            showToast('toast_net_error'.tr());
            break;
          case BadResultCode.CANCEL:
            break;
          default:
            showToast('send_sms_code_error'.tr());
        }
      } catch (e) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        showToast('send_sms_code_error'.tr());
      }
    }
    return Future.value(false);
  }

  Future<bool> mobileSignIn() async {
    try {
      SmartDialog.showLoading();
      LogUtils.d('----- mobileSignIn  ------------- ');
      var lang = await LocalModule().getLangTag();
      var country = await LocalModule().getCountryCode();
      var req = MobileLoginReq(
          phone: state.account,
          phone_code: state.currentPhone.code,
          country: country,
          lang: lang,
          grant_type: 'sms',
          scope: 'all');

      /// 默认同意隐私
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();
      var data = await ref
          .read(accountRepositoryProvider)
          .loginWithPhone(state.codeKey ?? '', state.code ?? '', req.toJson());
      SmartDialog.dismiss(status: SmartStatus.loading);
      await LifeCycleManager().gotoMainPage();
      SmartDialog.showToast('login_success'.tr());
      unawaited(saveLoginInfo(state.account, state.currentPhone.code));
      LogUtils.d('----- mobileSignIn ------++++++ $data');
      // 验证码发送成功
      LogModule().eventReport(3, 24, int1: 1);
      return Future.value(true);
    } on DreameException catch (e) {
      LogModule().eventReport(3, 24, int1: 2);
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('----- mobileSignIn DreameException ------------- $e');
      var code = e.code;
      switch (code) {
        case 11000:
          showToast('sms_code_invalid_expired'.tr());
          break;
        case 11001:
          showToast('sms_code_invalid_expired'.tr());
          break;
        case BadResultCode.NET_ERROR:
          showToast('toast_net_error'.tr());
          break;
        case BadResultCode.CANCEL:
          break;
        default:
          showToast('login_failed'.tr());
          break;
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('----- mobileSignIn ------------- $e');
      showToast('login_failed'.tr());
    }
    return Future.value(false);
  }

  void showToast(String text) {
    ref
        .read(mobileLoginCodeEventProvider.notifier)
        .sendEvent(ToastEvent(text: text));
  }
}

Future<void> saveLoginInfo(String? phoneNumber, String? currentCode) async {
  if (phoneNumber != null && currentCode != null) {
    await LocalStorage().putString('mobile_login_phone_code', currentCode,
        fileName: 'saveNotLogin');
    await LocalStorage().putString('mobile_login_phone_number', phoneNumber,
        fileName: 'saveNotLogin');
  }
}

@riverpod
class MobileLoginCodeEvent extends _$MobileLoginCodeEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent event) {
    state = event;
  }
}
