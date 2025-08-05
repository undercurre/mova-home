import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart'; //数据源
import 'package:flutter_plugin/ui/page/settings/userphone/user_phone_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/region_utils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_phone_state_notifier.g.dart';

@riverpod
class UserPhoneStateNotifier extends _$UserPhoneStateNotifier {
  Timer? _currentTimer;
  int _countTime = 0;

  @override
  UserPhoneUiState build() {
    RegionItem item = RegionStore().currentRegion;
    return UserPhoneUiState(
        sendMailCodeStr: 'send_sms_code'.tr(),
        unbindButtonText: 'unbind'.tr(),
        currentRegion: item);
  }

  Future<void> getUserInfo() async {
    try {
      UserInfoModel? userInfo =
          await ref.read(accountSettingRepositoryProvider).getUserInfo();
      if (userInfo.phone != null && userInfo.phone!.isNotEmpty) {
        state = state.copyWith(
            userInfo: userInfo,
            phoneAreaCode: userInfo.phoneCode,
            bindPhoneType: BindPhoneType.containPhoneType);
      } else {
        state = state.copyWith(
            userInfo: userInfo,
            phoneAreaCode: userInfo.phoneCode,
            bindPhoneType: BindPhoneType.nonePhoneType);
      }
      await AccountModule().saveUserInfo(userInfo);
    } catch (error) {
      LogUtils.e('UserPhoneStateNotifier getUserInfo error:$error');
    }
  }

  Future<bool> checkContainEMail() async {
    if (state.userInfo == null) {
      UserInfoModel? userInfo = await AccountModule().getUserInfo();
      state = state.copyWith(userInfo: userInfo);
    }
    if (state.userInfo != null &&
        state.userInfo!.email != null &&
        state.userInfo!.email!.isNotEmpty) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  //绑定
  Future<bool> bindPhoneAction() async {
    try {
      String phone = state.phoneNumber ?? '';
      String regnCode = state.currentRegion.code;
      String codeKey = state.smsRes?.codeKey ?? '';
      String codeValue = state.phoneCode ?? '';

      if (_vertifiCommitParams(phone, regnCode, codeKey, codeValue)) {
        SmartDialog.showLoading();
        await ref
            .read(accountSettingRepositoryProvider)
            .bindPhoneNumber(phone, regnCode, codeKey, codeValue);
        SmartDialog.dismiss(status: SmartStatus.loading);
        return Future.value(true);
      }
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
              .read(userPhoneEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'sms_code_invalid_expired'.tr()));
          break;
        case 11015:
          ref.read(userPhoneEventProvider.notifier).sendEvent(ToastEvent(
              text: 'Toast_3rdPartyBundle_BundleProcess_TimeOut_Tip'.tr()));
          break;
        case 20102:
          ref
              .read(userPhoneEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'login_request_too_much'.tr()));
          break;
        default:
          ref
              .read(userPhoneEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'bind_failure'.tr()));
          break;
      }
    } catch (error) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      ref
          .read(userPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'bind_failure'.tr()));
      LogUtils.e(error);
    }
    return Future.value(false);
  }

  /// 检查手机号是否有效
  bool checkPhoneNumber() {
    var phoneNumber = state.phoneNumber ?? '';
    var ret = isValidPhonenumber(phoneNumber, state.currentRegion.code);
    if (!ret) {
      ref
          .read(userPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'text_error_phone_format'.tr()));
    }
    return ret;
  }

  //绑定手机号（获取验证码）
  Future<Pair<bool, SmsTrCodeRes?>> getPhoneCodeAction(
      RecaptchaModel recaptchaModel) async {
    // 验证滑块验证码是否错误
    if (recaptchaModel.result == -100) {
      // 取消
      return Future.value(Pair(false, null));
    }
    if (recaptchaModel.result != 0) {
      ref
          .read(userPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
      return Future.value(Pair(false, null));
    } else {
      var langString = await LocalModule().getLangTag();
      try {
        String phone = state.phoneNumber!;
        String reginCode = state.currentRegion.code;
        String lang = langString;
        if (_vertifiPhoneParams(phone)) {
          SmartDialog.showLoading();
          state = state.copyWith(enableSend: false);
          SmsTrCodeRes smsResponse = await ref
              .read(accountSettingRepositoryProvider)
              .getPhoneVerificationCode(recaptchaModel, phone, reginCode, lang);
          state = state.copyWith(smsRes: smsResponse);
          startTime();
          SmartDialog.dismiss(status: SmartStatus.loading);
          return Future.value(Pair(true, smsResponse));
        }
      } on DreameException catch (e) {
        state = state.copyWith(enableSend: true);
        SmartDialog.dismiss(status: SmartStatus.loading);
        var code = e.code;
        switch (code) {
          case 11002:
            ref
                .read(userPhoneEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
            break;
          case 11003:
            ref
                .read(userPhoneEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'send_sms_too_frequent'.tr()));
            break;
          case 11004:
            ref
                .read(userPhoneEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'text_error_toomuch'.tr()));
            break;
          case 30910:
            ref
                .read(userPhoneEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'phone_has_register'.tr()));
            break;
          case 30912:
            ref.read(userPhoneEventProvider.notifier).sendEvent(
                ToastEvent(text: 'can_not_change_original_phone'.tr()));
            break;
          case 30410:
            ref.read(userPhoneEventProvider.notifier).sendEvent(
                ToastEvent(text: 'can_not_change_original_phone'.tr()));
            break;
          default:
            ref
                .read(userPhoneEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'send_sms_code_error'.tr()));
        }
      } catch (error) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        LogUtils.e(error);
      }
    }
    return Future.value(Pair(false, null));
  }

  void _verifyPhoneTextField(String content) {
    state = state.copyWith(enableValidCodeButton: content.isNotEmpty);
  }

  void _verifyBindCombinTextField(String phone, String phoneCode) {
    if (phone.isNotEmpty && phoneCode.isNotEmpty) {
      state = state.copyWith(enableBindButton: true);
    } else {
      state = state.copyWith(enableBindButton: false);
    }
  }

  void changePhoneNumber(String content) {
    _verifyPhoneTextField(content);
    state = state.copyWith(phoneNumber: content);
  }

  // 更改选择国家区号
  Future<void> changeRegion(Future<RegionItem?> sourceItem) async {
    RegionItem? item = await sourceItem;
    if (item != null) {
      state = state.copyWith(currentRegion: item);
    }
  }

  // 提交参数校验
  bool _vertifiCommitParams(
      String phone, String regnCode, String codeKey, String codeValue) {
    var isCnRegion = RegionUtils.isCn(state.currentRegion.countryCode);
    var isValidPhone = isValidPhoneFor(phone, isCnRegion);
    if (phone.isEmpty || !isValidPhone) {
      ref
          .read(userPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'mobile_invalid'.tr()));
      return false;
    } else if (regnCode.isEmpty || codeKey.isEmpty) {
      ref
          .read(userPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'get_sms_code'.tr()));
      return false;
    } else if (codeValue.isEmpty || codeValue.length < 6) {
      ref
          .read(userPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'sms_code_invalid'.tr()));
      return false;
    }
    return true;
  }

  /// 校验手机号
  bool _vertifiPhoneParams(String phone) {
    var isCnRegion = RegionUtils.isCn(state.currentRegion.countryCode);
    var isValidPhone = isValidPhoneFor(phone, isCnRegion);
    if (phone.isEmpty || !isValidPhone) {
      ref
          .read(userPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'mobile_invalid'.tr()));
      return false;
    }
    return true;
  }

  void changeBindPhoneCodeNumber(String content) {
    _verifyBindCombinTextField(state.phoneNumber ?? '', content);
    state = state.copyWith(phoneCode: content);
  }

  void changePageType(BindPhoneType type) {
    state = state.copyWith(bindPhoneType: type);
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
      state = state.copyWith(
        enableSend: sendEnable,
      );
    }
    if (timerRunning != state.timerRunning) {
      state = state.copyWith(timerRunning: timerRunning);
    }
  }

  void dispose() {
    _currentTimer?.cancel();
    _currentTimer = null;
  }
}

@riverpod
class UserPhoneEvent extends _$UserPhoneEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent event) {
    state = event;
  }
}
