import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/signup.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/region_utils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'email_signup_uistate.dart';

part 'email_signup_state_notifier.g.dart';

@riverpod
class EmailSignUpStateNotifier extends _$EmailSignUpStateNotifier {
  final bool _isChinese = LanguageStore().getCurrentLanguage().isChinese();

  @override
  EmailSignUpUiState build() {
    return init();
  }

  EmailSignUpUiState init() {
    RegionItem item = RegionStore().currentRegion;
    EmailSignUpUiState st = EmailSignUpUiState(
        currentRegion: item, regionName: _isChinese ? item.name : item.en);

    return st;
  }

  void sendInput(text) {
    state = state.copyWith(account: text);
    _isButtonEnable();
  }

  void sendInput3(text) {
    state = state.copyWith(password: text);
    _isButtonEnable();
  }

  void onSelectChange(bool value) {
    if (value) {
      LogModule().eventReport(2, 11, int2: 1);
    }
    state = state.copyWith(isPrivacyChecked: value);
    _isButtonEnable();
  }

  void _isButtonEnable() {
    var isPhone = (state.account ?? '').isNotEmpty;
    var isPassword = (state.password ?? '').isNotEmpty;
    var isEnable = isPhone && isPassword && state.isPrivacyChecked;
    state = state.copyWith(isButtonEnable: isEnable);
  }

  void changeRegion(RegionItem value) {
    state = state.copyWith(
      currentRegion: value,
      regionName: _isChinese ? value.name : value.en,
      isCn: RegionUtils.isCn(value.countryCode),
      isEmail: !RegionUtils.isCn(value.countryCode),
    );
  }

  /// 立即注册
  Future<bool> emailSignUp() async {
    if (!isVaildEmail(state.account ?? '')) {
      ref
          .read(emailSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'mail_error'.tr()));
      return Future.value(false);
    }
    if (state.account!.length > 45) {
      ref
          .read(emailSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'email_too_long'.tr()));
      return Future.value(false);
    }
    if (!isVaildPassword(state.password ?? '')) {
      ref
          .read(emailSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'pwd_error'.tr()));
      return Future.value(false);
    }
    if (!state.isPrivacyChecked) {
      ref
          .read(emailSignUpUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'terms_uncheck'.tr()));
      return Future.value(false);
    }
    try {
      SmartDialog.showLoading();
      var lang = await LocalModule().getLangTag();
      var req = EmailRegisterReq(
        email: state.account ?? '',
        password: state.password ?? '',
        confirmedPassword: state.password ?? '',
        country: state.currentRegion.countryCode,
        lang: lang,
      );

      /// 默认同意隐私
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();
      // 注册
      var ret = await ref.read(accountRepositoryProvider).registerByEmail(req);
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogModule().eventReport(2, 24, int2: 1);
      // if (!state.isCn) {
      //   ref
      //       .read(emailSignUpUiEventProvider.notifier)
      //       .showUiEvent(ActionEvent(action: ShowEmailCollectionSubscribe()));
      // } else {
      await LifeCycleManager().logingSuccess();
      await LifeCycleManager().gotoMainPage();
      SmartDialog.showToast('register_success'.tr());
      // }
      return Future.value(ret);
    } on DreameException catch (e) {
      LogModule().eventReport(2, 24, int2: 2);
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 10007:
          ref
              .read(emailSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'mail_error'.tr()));
          break;
        case 10009:
          ref
              .read(emailSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'pwd_error'.tr()));
          break;
        case 30901:

          /// 账号已注册
          ref
              .read(emailSignUpUiEventProvider.notifier)
              .showUiEvent(ActionEvent(action: ShowSignUpDialog()));
          break;
        case BadResultCode.NET_ERROR:
          ref.read(emailSignUpUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'toast_net_error'.tr()));
          break;
        case BadResultCode.CANCEL:
          break;
        case -1:
          ref.read(emailSignUpUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'register_failed'.tr()));
          break;

        default:
          ref
              .read(emailSignUpUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'register_failed'.tr()));
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

  void changeRegisterType({required bool isEmail}) {
    state = state.copyWith(
        account: '',
        password: '',
        isPrivacyChecked: false,
        isButtonEnable: false);
    state = state.copyWith(isEmail: isEmail);
  }
}

@riverpod
class EmailSignUpUiEvent extends _$EmailSignUpUiEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void showUiEvent(CommonUIEvent value) {
    state = value;
  }
}
