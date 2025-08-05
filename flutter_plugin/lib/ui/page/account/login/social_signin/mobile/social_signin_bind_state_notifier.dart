import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/sendcode/send_code_model.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/usecase/social_signin_bind_usecase.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/region_utils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'social_signin_bind_uistate.dart';

part 'social_signin_bind_state_notifier.g.dart';

@riverpod
class SocialSigninBindStateNotifier extends _$SocialSigninBindStateNotifier {
  late SocialSignInBindUseCase _socialSignInBindUseCase;

  @override
  SocialSignInBindUiState build() {
    _socialSignInBindUseCase =
        SocialSignInBindUseCase(ref.watch(accountRepositoryProvider));

    RegionItem item = RegionStore().currentRegion;
    return SocialSignInBindUiState(currentPhone: item, currentRegion: item);
  }

  void init(SocialCodeModel model) {
    LogUtils.d('---------SocialSigninBindStateNotifier init-------- $model');
    state = state.copyWith(
      isMobileOnly: model.currentRegion.countryCode == 'CN',
      isInputPhoneNumber: model.currentRegion.countryCode == 'CN',
      socialUUid: model.uuid,
      source: model.oauthSource,
      currentPhone: model.currentPhone,
      currentRegion: model.currentRegion,
    );
    updateSkip();
    LogUtils.d('---------SocialSigninBindStateNotifier init-------- $state');
  }

  Future<void> updateSkip() async {
    try {
      bool isForce = await _socialSignInBindUseCase.getBindSwitch();
      state = state.copyWith(showSkip: !isForce);
    } catch (e) {
      state = state.copyWith(showSkip: false);
    }
  }

  void passwordHidenChange(bool hide) {
    state = state.copyWith(hidePassword: hide);
  }

  void sendInput(String account) {
    var isCnPhoneCode = RegionUtils.isCn(state.currentPhone.countryCode);
    var isCnRegion = RegionUtils.isCn(state.currentRegion.countryCode);
    var isValidPhone = isCnRegion || isValidPhoneFor(account, false);
    LogUtils.d(
        '----- sendInput ------ account: $account ,isCnRegion: $isCnRegion ,isCnPhoneCode: $isCnPhoneCode ,isValidPhone: $isValidPhone');
    state = state.copyWith(
        account: account,
        isInputPhoneNumber: state.isMobileOnly || isValidPhone);
    _isButtonEnable();
  }

  void sendInput2(String password) {
    LogUtils.d('----- sendInput2 ------ $password');
    state = state.copyWith(password: password);
    _isButtonEnable();
  }

  void changePhoneCode(RegionItem item) {
    LogUtils.d(
        '----- changePhoneCode ------ ${item.countryCode} ${item.code} ${item.name}');
    state = state.copyWith(currentPhone: item);
  }

  void changeRegion(RegionItem item, {bool isOnlyRegion = false}) {
    LogUtils.d(
        '----- changeRegion ------ ${item.countryCode} ${item.code} ${item.name}');
    if (isOnlyRegion) {
      state = state.copyWith(currentRegion: item);
    } else {
      state = state.copyWith(currentRegion: item, currentPhone: item);
    }
  }

  Future<Pair<bool, SocialCodeModel?>> autoRegisterBindSms(
      RecaptchaModel recaptchaModel) async {
    LogUtils.d('----------- autoRegisterBindSms  ---------$recaptchaModel');
    try {
      SmartDialog.showLoading();
      var ret = await _socialSignInBindUseCase.sendAutoRegisterBindSms(
          recaptchaModel, state);
      SmartDialog.dismiss(status: SmartStatus.loading);
      if (ret.first) {
        var data = ret.third!;
        var sendCodeModel = SocialCodeModel(
            oauthSource: state.source ?? '',
            uuid: state.socialUUid ?? '',
            interval: data.interval,
            phone: state.account ?? '',
            currentPhone: state.currentPhone,
            currentRegion: state.currentRegion,
            codeKey: data.codeKey);
        ref
            .watch(socialSignInBindEventProvider.notifier)
            .sendEvent(ToastShow(msg: 'send_success'.tr()));
        return Future.value(Pair(true, sendCodeModel));
      } else if (ret.second != null) {
        ref
            .watch(socialSignInBindEventProvider.notifier)
            .sendEvent(ToastShow(msg: ret.second ?? ''));
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('------sendVerifyCode --------$e');
    }
    return Future.value(Pair(false, null));
  }

  void _isButtonEnable() {
    String account = state.account ?? '';
    if (state.isInputPhoneNumber) {
      state = state.copyWith(isButtonEnable: account.isNotEmpty);
    } else {
      state = state.copyWith(
          isButtonEnable:
              account.isNotEmpty && state.password?.isNotEmpty == true);
    }
    LogUtils.d('------_isButtonEnable --------${state.isButtonEnable}');
  }

  Future<bool> socialbBindSkip() async {
    LogUtils.d('----------- socialbBindSkip  --------');
    try {
      SmartDialog.showLoading();
      var ret = await _socialSignInBindUseCase.socialbBindSkip(state);
      SmartDialog.dismiss(status: SmartStatus.loading);
      if (ret.first) {
        // success
        await LifeCycleManager().gotoMainPage();
        SmartDialog.showToast('login_success'.tr());
        return Future.value(true);
      } else {
        ref
            .watch(socialSignInBindEventProvider.notifier)
            .sendEvent(ToastShow(msg: ret.second ?? ''));
        return Future.value(false);
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('------sendVerifyCode --------$e');
    }
    return Future.value(false);
  }

  Future<bool> socialbBind(bool cover) async {
    LogUtils.d('----------- socialbBind  -------- $cover');
    try {
      if (state.isInputPhoneNumber) {
        var ret =
            isValidPhonenumber(state.account ?? '', state.currentPhone.code);
        if (!ret) {
          ref
              .watch(socialSignInBindEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'text_error_phone_format'.tr()));
          return false;
        }
      } else {
        if (!isVaildEmail(state.account ?? '')) {
          ref
              .watch(socialSignInBindEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'mail_error'.tr()));
          return false;
        }
        if (state.account!.length > 45) {
          ref
              .watch(socialSignInBindEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'email_too_long'.tr()));
          return false;
        }
        if (!isVaildPassword(state.password ?? '')) {
          ref
              .watch(socialSignInBindEventProvider.notifier)
              .sendEvent(ToastShow(msg: 'pwd_error'.tr()));
          return false;
        }
      }

      SmartDialog.showLoading();
      var event = await _socialSignInBindUseCase.socialbBind(state, cover);
      SmartDialog.dismiss(status: SmartStatus.loading);
      ref.read(socialSignInBindEventProvider.notifier).sendEvent(event);
      if (event is Success) {
        await LifeCycleManager().gotoMainPage();
        SmartDialog.showToast('login_success'.tr());
        return Future.value(true);
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('------sendVerifyCode --------$e');
    }
    return Future.value(false);
  }

  Future<void> callBackRegion(
      Future<RegionItem?> futureItem, bool forRegion) async {
    RegionItem? item = await futureItem;
    if (item != null) {
      if (forRegion) {
        changeRegion(item);
      } else {
        changePhoneCode(item);
      }
    }
  }

  bool checkPhoneNumber() {
    var ret = isValidPhonenumber(state.account ?? '', state.currentPhone.code);
    if (!ret) {
      ref
          .watch(socialSignInBindEventProvider.notifier)
          .sendEvent(ToastShow(msg: 'text_error_phone_format'.tr()));
    }
    return ret;
  }
}

@riverpod
class SocialSignInBindEvent extends _$SocialSignInBindEvent {
  @override
  SocialSignInBindUiEvent build() {
    return DefaultEvent();
  }

  void sendEvent(SocialSignInBindUiEvent event) {
    state = event;
  }
}
