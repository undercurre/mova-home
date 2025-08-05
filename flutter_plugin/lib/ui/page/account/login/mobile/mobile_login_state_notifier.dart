import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/sendcode/send_code_model.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/mobile_login_uistate.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/mobile_login_usecase.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/social_auth_usecase.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/send/social_sign_bind_email_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/mobile/social_signin_bind_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/usecase/social_signin_bind_usecase.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'onekey_auth_usecase.dart';

part 'mobile_login_state_notifier.g.dart';

@riverpod
class MobileLoginController extends _$MobileLoginController {
  late MobileLoginUsecase _usecase;
  late SocialAuthUsecase _socialAuthUsecase;
  late OneKeyAuthUsecase _oneKeyAuthUsecase;
  final bool isChinese = LanguageStore().getCurrentLanguage().isChinese();

  @override
  MobileLoginUiState build() {
    _usecase = MobileLoginUsecase(ref.watch(accountRepositoryProvider));
    _socialAuthUsecase =
        SocialAuthUsecase(ref.watch(accountRepositoryProvider));
    _oneKeyAuthUsecase =
        OneKeyAuthUsecase(ref.watch(accountRepositoryProvider));
    return init();
  }

  MobileLoginUiState init() {
    RegionItem item = RegionStore().currentRegion;
    MobileLoginUiState st = MobileLoginUiState(
      currentPhone: item,
      currentRegion: item,
      regionName: isChinese ? item.name : item.en,
    );
    return st;
  }

  Future<void> onLoad() async {
    String? phoneCode = await LocalStorage()
        .getString('mobile_login_phone_code', fileName: 'saveNotLogin');
    String? initAccount = await LocalStorage()
        .getString('mobile_login_phone_number', fileName: 'saveNotLogin');
    RegionItem? currentPhone;
    if (phoneCode != null) {
      currentPhone = await RegionItem.getRegionFromPhoneCode(phoneCode);
    }
    if (initAccount != null && currentPhone != null) {
      state = state.copyWith(
        regionName:
            isChinese ? state.currentRegion.name : state.currentRegion.en,
        currentPhone: currentPhone,
        initAccount: initAccount,
        phoneNumber: initAccount,
        prepared: true,
      );
    } else {
      state = state.copyWith(
        regionName:
            isChinese ? state.currentRegion.name : state.currentRegion.en,
        prepared: true,
      );
    }
  }

  void sendInput(String account) {
    state = state.copyWith(phoneNumber: account);
    _isButtonEnable();
  }

  Future<void> callBackRegion(
      Future<RegionItem?> futureItem, bool forRegion) async {
    RegionItem? item = await futureItem;

    LogUtils.d(
        '----- changeRegion1 ------ ${item?.countryCode} ${item?.code} ${item?.name}$forRegion');
    if (item != null) {
      if (forRegion) {
        changeRegion(item);
      } else {
        changePhoneCode(item);
      }
    }
    LogUtils.d(
        '----- changeRegion2 ------ ${item?.countryCode} ${item?.code} ${item?.name}$forRegion');
  }

  void changeRegion(RegionItem item, {bool isOnlyRegion = false}) {
    LogUtils.d(
        '----- changeRegion ------ ${item.countryCode} ${item.code} ${item.name}$isOnlyRegion');

    if (isOnlyRegion) {
      state = state.copyWith(
        currentRegion: item,
        regionName:
            isChinese ? state.currentRegion.name : state.currentRegion.en,
      );
    } else {
      state = state.copyWith(
        currentRegion: item,
        currentPhone: item,
        regionName:
            isChinese ? state.currentRegion.name : state.currentRegion.en,
      );
    }
  }

  void changePhoneCode(RegionItem item) {
    state = state.copyWith(currentPhone: item);
  }

  /// 检查手机号是否有效
  bool checkPhoneNumber() {
    var phoneNumber = state.phoneNumber ?? '';
    var ret = isValidPhonenumber(phoneNumber, state.currentPhone.code);
    if (!ret) {
      ref
          .read(mobileLoginEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'text_error_phone_format'.tr()));
      return ret;
    }
    ret = state.isPrivacyChecked;
    if (!ret) {
      ref
          .read(mobileLoginEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'terms_uncheck'.tr()));
      return false;
    }
    return ret;
  }

  Future<Pair<bool, SendCodeModel?>> sendVerifyCode(
      RecaptchaModel recaptchaModel) async {
    LogUtils.d('----------- sendVerifyCode  ---------$recaptchaModel');

    try {
      SmartDialog.showLoading();
      var resultEvent = await _usecase.sendVerifyCode(recaptchaModel, state);
      SmartDialog.dismiss(status: SmartStatus.loading);
      if (resultEvent is SuccessEvent) {
        var data = resultEvent.data as SmsCodeRes;
        var sendCodeModel = SendCodeModel(
            interval: data.interval ?? 60,
            phone: state.phoneNumber ?? '',
            codeKey: data.codeKey ?? '',
            currentPhone: state.currentPhone,
            currentRegion: state.currentRegion);
        ref
            .read(mobileLoginEventProvider.notifier)
            .sendEvent(ToastEvent(text: 'send_success'.tr()));
        return Future.value(Pair(true, sendCodeModel));
      } else {
        ref.read(mobileLoginEventProvider.notifier).sendEvent(resultEvent);
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('------sendVerifyCode --------$e');
    }
    return Future.value(Pair(false, null));
  }

  /// 同意隐私选中
  Future<void> toggleAgree(isAgree) async {
    state = state.copyWith(isPrivacyChecked: isAgree);
    _isButtonEnable();
  }

  void _isButtonEnable() {
    var isButtonEnable =
        state.phoneNumber?.isNotEmpty == true && state.isPrivacyChecked;
    state = state.copyWith(isButtonEnable: isButtonEnable);
  }

  Future<bool> onekeyLogin(String token) async {
    try {
      SmartDialog.showLoading();

      /// 默认同意隐私
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();
      var event = await _oneKeyAuthUsecase.oneKeySignIn(token, 'zh');
      SmartDialog.dismiss(status: SmartStatus.loading);
      if (event is SuccessEvent) {
        await LifeCycleManager().gotoMainPage();
        SmartDialog.showToast('login_success'.tr());
        return Future.value(true);
      } else {
        ref.read(mobileLoginEventProvider.notifier).sendEvent(event);
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('------onekeyLogin --------$e');
    }
    return Future.value(false);
  }

  /// 三方登录
  Future<bool> socialSignIn(String authType, dynamic token) async {
    if (authType == 'WECHAT_OPEN') {
      LogModule().eventReport(3, 20, int1: 1);
    } else if (authType == 'APPLE') {
      LogModule().eventReport(3, 19, int1: 1);
    }
    try {
      SmartDialog.showLoading();

      /// 默认同意隐私
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();
      var event = await _socialAuthUsecase.socialSignIn(
          authType: authType, token: token, emailCheck: 1);
      SmartDialog.dismiss(status: SmartStatus.loading);
      if (event is SuccessEvent) {
        ///
        LogUtils.d('------ActionEvent --------success');
        await LifeCycleManager().gotoMainPage();
        SmartDialog.showToast('login_success'.tr());
        return true;
      } else if (event is ToastEvent) {
        ref.read(mobileLoginEventProvider.notifier).sendEvent(event);
      } else if (event is ActionEvent) {
        LogUtils.d('------ActionEvent --------action');
        if (event.action is ActionSocialAccountBind) {
          LogUtils.d('------ActionEvent --------bind');
          RegionItem item = RegionStore().currentRegion;

          if (item.countryCode.toLowerCase() == 'cn') {
            var action = event.action as ActionSocialAccountBind;
            var model = SocialCodeModel(
                currentPhone: state.currentRegion,
                currentRegion: state.currentRegion,
                oauthSource: action.source ?? '',
                uuid: action.uuid ?? '');
            action.model = model;
            event.action = action;

            // if (action.source == 'APPLE') {
            //   bool res = await toRegisterApple(model);
            //   return res;
            // } else {
            ref.read(mobileLoginEventProvider.notifier).sendEvent(
                PushEvent(path: SocialSignInBindPage.routePath, extra: model));
            // }
          } else {
            ref.read(mobileLoginEventProvider.notifier).sendEvent(PushEvent(
                  path: SocialSignBindEmailPage.routePath,
                  extra: {
                    'authType': authType,
                    'token': token,
                  },
                ));
          }
        } else if (event.action is ActionSocialAccountBindT) {
          //跳转到新绑定页面
          ref.read(mobileLoginEventProvider.notifier).sendEvent(PushEvent(
                path: SocialSignBindEmailPage.routePath,
                extra: {
                  'authType': authType,
                  'token': token,
                  'socialNoEmail': true,
                },
              ));
        } else if (event.action is ActionSocialAccountBindRepeat) {
          //跳转到新绑定页面
          ref.read(mobileLoginEventProvider.notifier).sendEvent(
                PushEvent(
                  path: SocialSignBindEmailPage.routePath,
                  extra: {
                    'authType': authType,
                    'token': token,
                  },
                ),
              );
        } else {
          LogUtils.d('------ActionEvent --------unbind');
          ref.read(mobileLoginEventProvider.notifier).sendEvent(event);
        }
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('------socialSignIn --------$e');
    }
    return false;
  }

  Future<bool> toRegisterApple(SocialCodeModel model) async {
    try {
      SmartDialog.showLoading();
      // success
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();
      var ret =
          await SocialSignInBindUseCase(ref.watch(accountRepositoryProvider))
              .socialbBindSkipTwo(
                  source: model.oauthSource,
                  socialUUid: model.uuid,
                  countryCode: state.currentRegion.countryCode);
      SmartDialog.dismiss(status: SmartStatus.loading);
      if (ret.first) {
        await LifeCycleManager().gotoMainPage();
        SmartDialog.showToast('login_success'.tr());
        return Future.value(true);
      } else {
        ref
            .watch(mobileLoginEventProvider.notifier)
            .sendEvent(ToastEvent(text: ret.second ?? ''));
        return Future.value(false);
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      ref
          .watch(mobileLoginEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'login_failed'.tr()));
      LogUtils.d('------sendVerifyCode --------$e');
    }
    return Future.value(false);
  }
}

@riverpod
class MobileLoginEvent extends _$MobileLoginEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent event) {
    state = event;
  }
}
