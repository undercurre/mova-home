import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/model/account/sendcode/send_code_model.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/code/social_signin_bind_code_uistate.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'social_signin_bind_code_state_notifier.g.dart';

@riverpod
class SocialSignInBindCodeStateNotifier
    extends _$SocialSignInBindCodeStateNotifier {
  @override
  SocialSignInBindCodeUiState build() {
    RegionItem item = RegionStore().currentRegion;
    return SocialSignInBindCodeUiState(currentPhone: item, currentRegion: item);
  }

  void init(SocialCodeModel data) {
    state = state.copyWith(
      account: data.phone,
      interval: data.interval,
      codeKey: data.codeKey,
      socialUUid: data.uuid,
      source: data.oauthSource,
      currentPhone: data.currentPhone,
      currentRegion: data.currentRegion,
    );
  }

  void sendInput(String code) {
    bool isInputValid = code.length == 6;
    state = state.copyWith(code: code, isInputInvalid: isInputValid);
  }

  Future<bool> sendCodeAgain(RecaptchaModel recaptchaModel) async {
    if (recaptchaModel.result == -100) {
      // 取消
      return Future.value(false);
    }
    if (recaptchaModel.result != 0) {
      ref
          .watch(socialSignInBindCodeEventProvider.notifier)
          .sendEvent(ToastShow(msg: 'send_sms_code_error'.tr()));
      return Future.value(false);
    }
    SmartDialog.showLoading();
    var lang = await LocalModule().getLangTag();
    var req = SmsCodeSocialReq(
      phone: state.account ?? '',
      phoneCode: state.currentPhone.code,
      lang: lang,
      token: recaptchaModel.token ?? '',
      sessionId: recaptchaModel.csessionid ?? '',
      sig: recaptchaModel.sig ?? '',
      socialUUid: state.socialUUid ?? '',
      source: state.source ?? '',
    );
    try {
      var data =
          await ref.watch(accountRepositoryProvider).autoRegisterBindSms(req);
      // 验证码发送成功
      state =
          state.copyWith(interval: data.interval ?? 60, codeKey: data.codeKey);
      SmartDialog.dismiss(status: SmartStatus.loading);
      ref
          .watch(socialSignInBindCodeEventProvider.notifier)
          .sendEvent(ToastShow(msg: 'send_success'.tr()));
      return Future.value(true);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11002:
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'send_sms_code_error'.tr()));
          break;
        case 11003:
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'send_sms_too_frequent'.tr()));
          break;
        case 11004:
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'text_error_toomuch'.tr()));
          break;
        case 10016:
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'phone_has_register'.tr()));
          break;
        default:
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'send_sms_code_error'.tr()));
          break;
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('------sendVerifyCode --------$e');
      ref
          .watch(socialSignInBindCodeEventProvider.notifier)
          .sendEvent(ToastShow(msg: 'send_sms_code_error'.tr()));
    }
    return Future.value(false);
  }

  Future<bool> socialSignInMobileBind(bool cover) async {
    try {
      LogUtils.d('----- socialSignInMobileBind  ------------- ');
      SmartDialog.showLoading();
      var lang = await LocalModule().getLangTag();

      var req = SocialSignInBindReq.createBindMobile(
          phone: state.account ?? '',
          phone_code: state.currentPhone.code,
          source: state.source ?? '',
          socialUUid: state.socialUUid ?? '',
          country: state.currentRegion.countryCode,
          lang: lang,
          cover: cover);
      var data = await ref
          .read(accountRepositoryProvider)
          .loginWithPhone(state.codeKey ?? '', state.code ?? '', req.toJson());
      LogUtils.d('----- socialSignInMobileBind ------++++++ $data');
      SmartDialog.dismiss(status: SmartStatus.loading);
      await LifeCycleManager().gotoMainPage();
      SmartDialog.showToast('login_success'.tr());
      return Future.value(true);
    } on DreameAuthException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d(
          '----- socialSignInMobileBind DreameException ------------- $e');
      var code = e.code;
      switch (code) {
        case 11000:
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'sms_code_invalid_expired'.tr()));
          break;
        case 11001:
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'sms_code_invalid_expired'.tr()));
          break;
        case 10015:
          ref.watch(socialSignInBindCodeEventProvider.notifier).sendEvent(
              ToastShow(
                  msg: 'Toast_3rdPartyBundle_BundleProcess_TimeOut_Tip'.tr()));
          break;
        case 10016:
          // bindCoverDialog
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'phone_has_register'.tr()));
          break;

        case 20101:
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'user_password_not_match'.tr()));
          //
          if ("0" == e.remains) {
            // ShowAccountLocked
            ref
                .read(socialSignInBindCodeEventProvider.notifier)
                .sendEvent(ShowAccountLocked());
          }
          break;
        case 20102:
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'login_request_too_much'.tr()));
          break;
        case -1:
          // bindCoverDialog
          ref
              .watch(socialSignInBindCodeEventProvider.notifier)
              .sendEvent(ToastShow(msg: e.message ?? ''));
          break;

        default:
          ref.watch(socialSignInBindCodeEventProvider.notifier).sendEvent(
              ToastShow(msg: 'Toast_3rdPartyBundle_ResultFailed'.tr()));
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('----- mobileSignIn ------------- $e');
      ref
          .watch(socialSignInBindCodeEventProvider.notifier)
          .sendEvent(ToastShow(msg: 'login_failed'.tr()));
    }
    return Future.value(false);
  }
}

@riverpod
class SocialSignInBindCodeEvent extends _$SocialSignInBindCodeEvent {
  @override
  SocialSignInBindCodeUiEvent build() {
    return SocialSignInBindCodeUiEvent();
  }

  void sendEvent(SocialSignInBindCodeUiEvent event) {
    state = event;
  }
}
