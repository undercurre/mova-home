import 'dart:async';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/signup.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_state_notifier.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/settings_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'mobile_signup_password_uistate.dart';

part 'mobile_signup_password_state_notifier.g.dart';

@riverpod
class MobileSignUpPasswordStateNotifier
    extends _$MobileSignUpPasswordStateNotifier {
  late RegisterByPasswordReq _req;

  @override
  MobileSignUpPasswordUiState build() {
    return MobileSignUpPasswordUiState();
  }

  void initData(RegisterByPasswordReq req) {
    _req = req;
  }

  // void initData(MobileSignUpUiState uiState) {
  //   state = state.copyWith(
  //     currentRegion: uiState.currentRegion,
  //     currentPhone: uiState.currentPhone,
  //     phoneNumber: uiState.phoneNumber,
  //     dynamicCode: uiState.dynamicCode,
  //     password: uiState.password,
  //     codeKey: uiState.codeKey,
  //   );
  // }

  void sendInput(text) {
    LogUtils.d('---------sendInput--------- $text');
    state = state.copyWith(password: text);
    _isButtonEnable();
  }

  void _isButtonEnable() {
    var isPassword = (state.password ?? '').isNotEmpty;
    state = state.copyWith(isButtonEnable: isPassword);
  }

  /// 同意个性化广告，存储是否弹出过确认弹窗的状态值到本地
  Future<void> setPersonalizedAdState(bool authState) async {
    try {
      int onState = authState ? 1 : 0;
      try {
        await ref.read(settingsRepositoryProvider).setAduserswitch(onState);
      } catch (e) {
        LogUtils.e(e);
      }
      OAuthModel? account = await AccountModule().getAuthBean();
      String? countryCode = await LocalModule().getCountryCode();
      final String storageKey = '${account.uid}_${countryCode}';
      const String fileName = 'personalized_ad';
      // 0/null 未操作， 1：允许， 2：不允许
      await LocalStorage()
          .putInt(storageKey, authState ? 1 : 2, fileName: fileName);
    } catch (error) {
      LogUtils.e(error);
    }
  }

  /// 立即注册
  Future<bool> MobileSignUpPassword() async {
    if (!isVaildPassword(state.password ?? '')) {
      ref
          .read(mobileSignUpPasswordUiEventProvider.notifier)
          .showUiEvent(ToastEvent(text: 'pwd_error'.tr()));
      return Future.value(false);
    }

    try {
      SmartDialog.showLoading();
      var lang = await LocalModule().getLangTag();

      _req.updatePassword(state.password ?? '');

      /// 默认同意隐私
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();
      // 注册
      var ret =
          await ref.read(accountRepositoryProvider).registerByPassword(_req);
      SmartDialog.dismiss(status: SmartStatus.loading);

      final adState = ref.watch(mobileSignUpStateNotifierProvider
          .select((value) => value.isPersonalizedAdChecked));
      await setPersonalizedAdState(adState);

      // if (state.currentRegion?.countryCode.toLowerCase() != 'cn' &&
      //     _req is RegisterByEmailReq) {
      //   //弹出订阅弹窗
      //   ref
      //       .read(mobileSignUpPasswordUiEventProvider.notifier)
      //       .showUiEvent(ActionEvent(action: ShowEmailCollectionSubscribe()));
      //   return Future.value(false);
      // } else {
      await LifeCycleManager().gotoMainPage();
      SmartDialog.showToast('register_success'.tr());
      LogModule().eventReport(2, 24, int1: 1);
      return Future.value(ret);
      // }
    } on DreameException catch (e) {
      LogModule().eventReport(2, 24, int1: 2);
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11006:
          ref
              .read(mobileSignUpPasswordUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case 11000:
          ref
              .read(mobileSignUpPasswordUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case 11001:
          ref
              .read(mobileSignUpPasswordUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case 10009:
          ref
              .read(mobileSignUpPasswordUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'pwd_error'.tr()));
          break;
        case 30900:

          /// 账号已注册
          ref
              .read(mobileSignUpPasswordUiEventProvider.notifier)
              .showUiEvent(ActionEvent(action: ShowSignUpDialog()));
          break;
        case BadResultCode.NET_ERROR:
          ref.read(mobileSignUpPasswordUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'toast_net_error'.tr()));
          break;
        case BadResultCode.CANCEL:
          break;
        case -1:
          ref.read(mobileSignUpPasswordUiEventProvider.notifier).showUiEvent(
              ToastEvent(text: e.message ?? 'operate_failed'.tr()));
          break;

        default:
          ref
              .read(mobileSignUpPasswordUiEventProvider.notifier)
              .showUiEvent(ToastEvent(text: 'operate_failed'.tr()));
          break;
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('----------MobileSignUpPassword----------- $e');
    }
    return Future.value(false);
  }

  void passwordHidenChange(bool hide) {
    state = state.copyWith(hidePassword: hide);
  }
}

@riverpod
class MobileSignUpPasswordUiEvent extends _$MobileSignUpPasswordUiEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void showUiEvent(CommonUIEvent value) {
    state = value;
  }
}
