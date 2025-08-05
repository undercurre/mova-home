import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/signup.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/password/mobile_signup_password_page.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'mobile_signup_uistate.dart';

part 'mobile_signup_state_notifier.g.dart';

enum SignUpType {
  phoneNumber,
  email,
}

@riverpod
class MobileSignUpStateNotifier extends _$MobileSignUpStateNotifier {
  final bool _isChinese = LanguageStore().getCurrentLanguage().isChinese();
  final bool _isChina =
      RegionStore().currentRegion.countryCode.toLowerCase() == 'cn';

  /// 当前类型，此类在邮箱注册和手机注册中都有使用
  // late final String _type;
  // late SignUpType _entranceType;

  @override
  MobileSignUpUiState build() {
    return initData();
  }

  MobileSignUpUiState initData() {
//判断是否有切换的入口 中国地区只有手机号注册（没有入口） 海外游手机号和邮箱注册两个入口
//地区中国只有手机号注册
//海外有两种注册方式邮箱和手机号
//中国地区进入时，默认手机号注册，没有切换入口
//海外地区进入时，默认邮箱注册注册，有切换入口，且为跳转到手机号注册
//中国地区切换为海外地区时，依旧为手机号注册模式，有切换入口，且跳转为邮箱注册
//海外地区切换为中国地区时，切换为手机号注册模式，没有切换入口

    int showChangeType = _isChina ? -1 : 0;
    SignUpType type =
        _isChina == true ? SignUpType.phoneNumber : SignUpType.email;
    RegionItem item = RegionStore().currentRegion;
    MobileSignUpUiState st = MobileSignUpUiState(
      currentRegion: item,
      currentPhone: item,
      currentName: _isChinese ? item.name : item.en,
      showChangeType: showChangeType,
      singupType: type,
    );
    return st;
  }

  void sendInput(text) {
    LogUtils.d('---------sendInput--------- $text');
    state = state.copyWith(account: text);
    _isButtonEnable();
  }

  void sendInput2(text) {
    state = state.copyWith(dynamicCode: text);
    _isButtonEnable();
  }

  void onSelectChange(bool value) {
    if (value == true) {
      LogModule().eventReport(2, 11, int1: 1);
    }
    state = state.copyWith(isPrivacyChecked: value);
    _isButtonEnable();
  }

  void onPersonalizedAdSelectChange(bool value) {
    state = state.copyWith(isPersonalizedAdChecked: value);
  }

  void _isButtonEnable() {
    var isPhone = (state.account ?? '').isNotEmpty;
    var isDynamicCode = (state.dynamicCode ?? '').isNotEmpty;
    var isEnable = isPhone && isDynamicCode && state.isPrivacyChecked;
    state = state.copyWith(isButtonEnable: isEnable, enableGetDynamic: isPhone);
  }

  void changePhoneCode(RegionItem value) {
    state = state.copyWith(currentPhone: value);
  }

  void changeRegion(RegionItem value) {
    SignUpType oldType = state.singupType;

    //如果切换的是中国地区，且为手机号注册
    if (value.countryCode.toLowerCase() == 'cn') {
      state = state.copyWith(
        currentRegion: value,
        currentPhone: value,
        currentName: _isChinese ? value.name : value.en,
        showChangeType: -1,
        singupType: SignUpType.phoneNumber,
      );
    } else {
      state = state.copyWith(
        currentRegion: value,
        currentPhone: value,
        currentName: _isChinese ? value.name : value.en,
        showChangeType: state.singupType == SignUpType.email ? 0 : 1,
      );
    }
    if (oldType != state.singupType) {
      sendInput(null);
      sendInput2(null);
    }
  }

  void changeSignType() {
    //如果当前是邮箱登录 则切换为手机号
    //如果当前是手机号登录 则切换为邮箱

    state = state.copyWith(
      showChangeType: state.showChangeType == 0 ? 1 : 0,
      singupType: state.singupType == SignUpType.phoneNumber
          ? SignUpType.email
          : SignUpType.phoneNumber,
    );
    sendInput(null);
    sendInput2(null);
  }

  /// 检查手机号是否正确
  bool checkPhoneNumber() {
    var ret =
        isValidPhonenumber(state.account ?? '', state.currentPhone.countryCode);
    LogUtils.d('------------ checkPhoneNumber --------- $ret');
    if (!ret) {
      ref
          .read(mobileSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'text_error_phone_format'.tr()));
      return false;
    }
    return ret;
  }

  Future callBackRegion(Future<RegionItem?> futureItem, bool forRegion) async {
    RegionItem? item = await futureItem;
    if (item != null) {
      if (forRegion) {
        changeRegion(item);
      } else {
        changePhoneCode(item);
      }
    }
  }

  void passwordHidenChange(bool hide) {
    state = state.copyWith(hidePassword: hide);
  }

  ///
}

@riverpod
class MobileSignUpUiEvent extends _$MobileSignUpUiEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void showUiEvent(CommonUIEvent value) {
    state = value;
  }
}

extension MobileSignUpStateNotifierExt on MobileSignUpStateNotifier {
  Future<bool> sendDynamicCode(RecaptchaModel value) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (state.singupType == SignUpType.phoneNumber) {
      return _sendDynamicCodeForPhone(value);
    } else {
      return _sendDynamicCodeForEmail(value);
    }
  }

  Future<bool> mobileSignUpVerifyCode() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (state.singupType == SignUpType.phoneNumber) {
      return _mobileSignUpVerifyCodeForPhone();
    } else {
      return _mobileSignUpVerifyCodeForEmail();
    }
  }

  /// 立即注册校验验证码
  Future<bool> _mobileSignUpVerifyCodeForPhone() async {
    if (!state.isPrivacyChecked) {
      ref
          .read(mobileSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'terms_uncheck'.tr()));
      return false;
    }
    if (state.codeKey?.isNotEmpty != true) {
      ref
          .read(mobileSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'get_sms_code'.tr()));
      return Future.value(false);
    }

    if (!isValidPhonenumber(state.account ?? '', state.currentPhone.code)) {
      ref
          .read(mobileSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'text_error_phone_format'.tr()));
      return Future.value(false);
    }

    if (state.dynamicCode?.length != 6) {
      ref
          .read(mobileSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
      return Future.value(false);
    }

    try {
      SmartDialog.showLoading();
      var req = MobileCheckCodeReq(
        phone: state.account ?? '',
        phoneCode: state.currentPhone.code,
        codeKey: state.codeKey ?? '',
        codeValue: state.dynamicCode ?? '',
      );

      /// 默认同意隐私
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();
      // 注册前校验验证码
      var ret =
          await ref.read(accountRepositoryProvider).verifyRegisterSmsCode(req);
      SmartDialog.dismiss(status: SmartStatus.loading);
      var lang = await LocalModule().getLangTag();
      RegisterByPhoneReq _req = RegisterByPhoneReq(
          phone: state.account ?? '',
          phoneCode: state.currentPhone.code,
          codeKey: state.codeKey ?? '',
          country: state.currentRegion.countryCode,
          lang: lang,
          password: '',
          confirmedPassword: '');

      await AppRoutes().push(MobileSignUpPasswordPage.routePath, extra: _req);
      return Future.value(true);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11000:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case 11001:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case BadResultCode.NET_ERROR:
          ref.read(mobileSignUpUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'toast_net_error'.tr()));
          break;
        case BadResultCode.CANCEL:
          break;
        case -1:
          ref.read(mobileSignUpUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'operate_failed'.tr()));
          break;

        default:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'operate_failed'.tr()));
          break;
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('----------mobileSignUp----------- $e');
    }
    return Future.value(false);
  }

  /// 立即注册校验验证码
  Future<bool> _mobileSignUpVerifyCodeForEmail() async {
    if (!state.isPrivacyChecked) {
      ref
          .read(mobileSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'terms_uncheck'.tr()));
      return false;
    }
    if (state.codeKey?.isNotEmpty != true) {
      ref
          .read(mobileSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'get_sms_code'.tr()));
      return Future.value(false);
    }

    if (state.dynamicCode?.length != 6) {
      ref
          .read(mobileSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
      return Future.value(false);
    }

    try {
      SmartDialog.showLoading();
      var lang = await LocalModule().getLangTag();
      var req = EmailCheckCodeReq(
        email: state.account ?? '',
        codeKey: state.codeKey ?? '',
        codeValue: state.dynamicCode ?? '',
        lang: lang,
      );

      /// 默认同意隐私
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();
      // 注册前校验验证码
      var ret = await ref
          .read(accountRepositoryProvider)
          .verifyRegisterEmailCode(req);
      SmartDialog.dismiss(status: SmartStatus.loading);

      RegisterByEmailReq _req = RegisterByEmailReq(
        email: state.account ?? '',
        password: '',
        confirmedPassword: '',
        country: state.currentRegion.countryCode,
        lang: lang,
        codeKey: state.codeKey ?? '',
      );
      await AppRoutes().push(MobileSignUpPasswordPage.routePath, extra: _req);
      return Future.value(true);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11000:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case 11001:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case BadResultCode.NET_ERROR:
          ref.read(mobileSignUpUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'toast_net_error'.tr()));
          break;
        case BadResultCode.CANCEL:
          break;
        case -1:
          ref.read(mobileSignUpUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'operate_failed'.tr()));
          break;

        default:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'operate_failed'.tr()));
          break;
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('----------mobileSignUp----------- $e');
    }
    return Future.value(false);
  }

  void passwordHidenChange(bool hide) {
    state = state.copyWith(hidePassword: hide);
  }

  Future<bool> _sendDynamicCodeForPhone(RecaptchaModel value) async {
    LogUtils.d('----------sendDynamicCode-----------  ');
    state = state.copyWith(isGetDynamic: true);
    _isButtonEnable();

    if (value.result != 0) {
      LogUtils.d('----------sendDynamicCode-----------2  ');
      return Future.value(false);
    }
    try {
      SmartDialog.showLoading();
      var lang = await LocalModule().getLangTag();

      /// 发送验证码
      var req = SmsCodeReq(
          phone: state.account ?? '',
          phoneCode: state.currentPhone.code,
          lang: lang,
          token: value.token ?? '',
          sessionId: value.csessionid ?? '',
          sig: value.sig ?? '');
      var ret =
          await ref.read(accountRepositoryProvider).sendRegisterSmsCode(req);
      SmartDialog.dismiss(status: SmartStatus.loading);
      state = state.copyWith(codeKey: ret.codeKey);
      ref
          .read(mobileSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'send_success'.tr()));
      // 成功跳转
      return Future.value(true);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11002:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
          break;
        case 11003:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'send_sms_too_frequent'.tr()));
          break;
        case 11004:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'text_error_toomuch'.tr()));
          break;
        case 30900:

          /// 账号已注册
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ActionEvent(action: ShowSignUpDialog()));
          break;
        case BadResultCode.NET_ERROR:
          ref.read(mobileSignUpUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'toast_net_error'.tr()));
          break;
        case BadResultCode.CANCEL:
          break;
        case -1:
          ref.read(mobileSignUpUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'send_sms_code_error'.tr()));
          break;

        default:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
          break;
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('----------sendDynamicCode-----------$e');
    }
    return Future.value(false);
  }

  /// 发送验证码
  Future<bool> _sendDynamicCodeForEmail(RecaptchaModel value) async {
    LogUtils.d('----------sendDynamicCode-----------  ');
    state = state.copyWith(isGetDynamic: true);
    _isButtonEnable();

    if (value.result != 0) {
      LogUtils.d('----------sendDynamicCode-----------2  ');
      return Future.value(false);
    }
    try {
      SmartDialog.showLoading();
      var lang = await LocalModule().getLangTag();

      /// 发送验证码
      var req = EmailCodeReq(
        email: state.account ?? '',
        lang: lang,
      );
      var ret =
          await ref.read(accountRepositoryProvider).sendRegisterEmailCode(req);
      SmartDialog.dismiss(status: SmartStatus.loading);
      state = state.copyWith(codeKey: ret.codeKey);
      ref
          .read(mobileSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'send_success'.tr()));
      // 成功跳转
      return Future.value(true);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11002:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
          break;
        case 11003:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'send_sms_too_frequent'.tr()));
          break;
        case 11004:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'text_error_toomuch'.tr()));
          break;
        case 10007:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'mail_error'.tr()));
          break;
        case 30901:

          /// 账号已注册
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ActionEvent(action: ShowSignUpDialog()));
          break;
        case BadResultCode.NET_ERROR:
          ref.read(mobileSignUpUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'toast_net_error'.tr()));
          break;
        case BadResultCode.CANCEL:
          break;
        case -1:
          ref.read(mobileSignUpUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'send_sms_code_error'.tr()));
          break;

        default:
          ref
              .read(mobileSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
          break;
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('----------sendDynamicCode-----------$e');
    }
    return Future.value(false);
  }
}
