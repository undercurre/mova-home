// ignore_for_file: avoid_public_notifier_properties
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/common/providers/send_message_provider.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/model/send_message_action.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mobile/mobile_recover_uistate.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_page.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mobile_recover_state_notifier.g.dart';

@riverpod
class MoblieRecoverStateNotifier extends _$MoblieRecoverStateNotifier {
  // ignore: unused_field
  String _phone = '';
  @override
  MobileRecoverUiState build() {
    return init();
  }

  void preparedData(String? phone) {
    if (phone == null) {
      state = state.copyWith(prepared: true);
    } else {
      state = state.copyWith(
        prepared: true,
        initPhone: phone,
      );
      phoneNumberChange(phone);
    }
  }

  MobileRecoverUiState init() {
    MobileRecoverUiState st = MobileRecoverUiState();
    RegionItem? item = RegionStore().currentRegion;
    st = st.copyWith(phoneCodeRegion: item);
    return st;
  }

  void phoneNumberChange(String phone) {
    _phone = phone;
    bool canSend = phone.isNotEmpty;
    state = state.copyWith(enableSend: canSend);
  }

  void phoneCodeChange(RegionItem phoneCodeRegion) {
    state = state.copyWith(phoneCodeRegion: phoneCodeRegion);
  }

  Future<SmscodeTrans> sendMessage(BuildContext context) async {
    SmartDialog.showLoading();
    FocusManager.instance.primaryFocus?.unfocus();
    if (isValidPhonenumber(_phone, state.phoneCodeRegion?.code ?? '86') ==
        false) {
      SmartDialog.dismiss();
      showToast('text_error_phone_format'.tr());
      return Future.error(-1);
    }

    // loadingEvent(true);
    try {
      SmsCodeReq req = SmsCodeReq(
          phone: _phone,
          phoneCode: state.phoneCodeRegion?.code ?? '',
          lang: await LocalModule().getLangTag(),
          token: '',
          sessionId: '',
          sig: '');

      SendMessageAction<SmsCodeReq> action = SendMessageAction(
          smsCodeReq: req,
          request: ref
              .read(accountRepositoryProvider)
              .getRecoverByPhoneVerificationCode,
          contex: context);
      ref.read(sendMessageProviderProvider.notifier).updateAction(action);
      var request = await ref
          .read(sendMessageProviderProvider.notifier)
          .sendCode<SmsCodeReq>();
      SmartDialog.dismiss();
      showToast('send_success'.tr());
      return Future.value(request);
    } on DreameException catch (e) {
      SmartDialog.dismiss();
      switch (e.code) {
        case 11004:
          showToast('text_error_toomuch'.tr());
          break;
        case 11003:
          showToast('send_sms_too_frequent'.tr());
          break;
        case 30400:
          showAlert('text_account_unregister'.tr());
          break;
        case 300101:
          SmartDialog.dismiss();
        default:
          showToast('send_sms_code_error'.tr());
          break;
      }

      return Future.error(e);
    } catch (e) {
      SmartDialog.dismiss();
      if (e != 300101) {
        showToast('send_sms_code_error'.tr());
      }

      return Future.error(e);
    }
  }

  void showToast(String text) {
    state = state.copyWith(event: ToastEvent(text: text));
  }

  void showAlert(String text) {
    AlertEvent alert = AlertEvent(
      content: text,
      cancelContent: 'cancel'.tr(),
      confirmContent: 'confirm'.tr(),
      confirmCallback: _goToRegister,
    );
    state = state.copyWith(event: alert);
  }

  Future<void> _goToRegister() async {
    String registerPath = MobileSignUpPage.routePath;
    state = state.copyWith(
      event: PushEvent(
        path: registerPath,
        func: RouterFunc.push,
      ),
    );
  }
}
