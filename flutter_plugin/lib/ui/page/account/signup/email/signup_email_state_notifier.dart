import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/page/account/signup/email/signup_email_uistate.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/password/mobile_signup_password_page.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_email_state_notifier.g.dart';

@riverpod
class SignUpEmailStateNotifier extends _$SignUpEmailStateNotifier {
  final bool _isChinese = LanguageStore().getCurrentLanguage().isChinese();

  /// 当前类型，此类在邮箱注册和手机注册中都有使用
  late final String _type;

  @override
  SignUpEmailUiState build({String type = 'mobile'}) {
    this._type = type;
    return initData();
  }

  SignUpEmailUiState initData() {
    RegionItem item = RegionStore().currentRegion;
    SignUpEmailUiState st = SignUpEmailUiState(
      currentRegion: item,
      currentPhone: item,
      currentName: _isChinese ? item.name : item.en,
    );
    return st;
  }

  void sendInput(text) {
    LogUtils.d('---------sendInput--------- $text');
    state = state.copyWith(email: text);
    _isButtonEnable();
  }

  void sendInput2(text) {
    state = state.copyWith(dynamicCode: text);
    _isButtonEnable();
  }

  void sendInput3(text) {
    state = state.copyWith(password: text);
    _isButtonEnable();
  }

  void onSelectChange(bool value) {
    if (value == true) {
      LogModule().eventReport(2, 11, int1: 1);
    }
    state = state.copyWith(isPrivacyChecked: value);
    _isButtonEnable();
  }

  void _isButtonEnable() {
    var isPhone = (state.email ?? '').isNotEmpty;
    var isDynamicCode = (state.dynamicCode ?? '').isNotEmpty;
    var isEnable = isPhone && isDynamicCode && state.isPrivacyChecked;
    state = state.copyWith(isButtonEnable: isEnable, enableGetDynamic: isPhone);
  }

  void changePhoneCode(RegionItem value) {
    state = state.copyWith(currentPhone: value);
  }

  void changeRegion(RegionItem value) {
    state = state.copyWith(
      currentRegion: value,
      currentPhone: value,
      currentName: _isChinese ? value.name : value.en,
    );
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

  /// 发送验证码
  Future<bool> sendDynamicCode(RecaptchaModel value) async {
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
        email: state.email ?? '',
        lang: lang,
      );
      var ret =
          await ref.read(accountRepositoryProvider).sendRegisterEmailCode(req);
      SmartDialog.dismiss(status: SmartStatus.loading);
      state = state.copyWith(codeKey: ret.codeKey);
      ref
          .read(signUpEmailUiEventProvider.call(type: _type).notifier)
          .showUiEvent(ToastEvent(text: 'send_success'.tr()));
      // 成功跳转
      return Future.value(true);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11002:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
          break;
        case 11003:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(ToastEvent(text: 'send_sms_too_frequent'.tr()));
          break;
        case 11004:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(ToastEvent(text: 'text_error_toomuch'.tr()));
          break;
        case 30901:

          /// 账号已注册
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(ActionEvent(action: ShowSignUpDialog()));
          break;
        case BadResultCode.NET_ERROR:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(
                  ToastEvent(text: e.message ?? 'toast_net_error'.tr()));
          break;
        case BadResultCode.CANCEL:
          break;
        case -1:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(
                  ToastEvent(text: e.message ?? 'send_sms_code_error'.tr()));
          break;

        default:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
          break;
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('----------sendDynamicCode-----------$e');
    }
    return Future.value(false);
  }

  /// 立即注册校验验证码
  Future<bool> mobileSignUpVerifyCode() async {
    if (!state.isPrivacyChecked) {
      ref
          .read(signUpEmailUiEventProvider.call(type: _type).notifier)
          .showUiEvent(ToastEvent(text: 'terms_uncheck'.tr()));
      return false;
    }
    if (state.codeKey?.isNotEmpty != true) {
      ref
          .read(signUpEmailUiEventProvider.call(type: _type).notifier)
          .showUiEvent(ToastEvent(text: 'get_sms_code'.tr()));
      return Future.value(false);
    }

    if (state.dynamicCode?.length != 6) {
      ref
          .read(signUpEmailUiEventProvider.call(type: _type).notifier)
          .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
      return Future.value(false);
    }

    try {
      SmartDialog.showLoading();
      var lang = await LocalModule().getLangTag();
      var req = EmailCheckCodeReq(
        email: state.email ?? '',
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
      await AppRoutes().push(MobileSignUpPasswordPage.routePath, extra: state);
      return Future.value(true);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11000:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case 11001:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case BadResultCode.NET_ERROR:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(
                  ToastEvent(text: e.message ?? 'toast_net_error'.tr()));
          break;
        case BadResultCode.CANCEL:
          break;
        case -1:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
              .showUiEvent(
                  ToastEvent(text: e.message ?? 'operate_failed'.tr()));
          break;

        default:
          ref
              .read(signUpEmailUiEventProvider.call(type: _type).notifier)
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

  ///
}

@riverpod
class SignUpEmailUiEvent extends _$SignUpEmailUiEvent {
  @override
  CommonUIEvent build({String type = 'mobile'}) {
    return const EmptyEvent();
  }

  void showUiEvent(CommonUIEvent value) {
    state = value;
  }
}
