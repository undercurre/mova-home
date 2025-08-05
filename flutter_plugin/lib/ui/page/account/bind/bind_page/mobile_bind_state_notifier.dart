import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/common/providers/send_message_provider.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';

import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/model/send_message_action.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind/bind_page/mobile_bind_uistate.dart';
import 'package:flutter_plugin/ui/page/account/bind/check_code/mobile_bind_check_code_page.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mobile_bind_state_notifier.g.dart';

@riverpod
class MobileBindStateNotifier extends _$MobileBindStateNotifier {
  RegionItem region = RegionStore().currentRegion;
  String _phone = '';
  @override
  MobileBindUiState build() {
    return MobileBindUiState(code: region.code);
  }

  void onLoad() {}

  void updateRegion(RegionItem item) {
    region = item;
    state = state.copyWith(code: region.code);
  }

  void phoneNumberChange(String phone) {
    _phone = phone;
    bool canSend = phone.isNotEmpty;
    state = state.copyWith(enableSend: canSend);
  }

  Future<SmscodeTrans> sendMessage(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    var isValidPhone = isValidPhonenumber(_phone, region.code);
    if (!isValidPhone) {
      showToast('text_error_phone_format'.tr());
      return Future.error('');
    }
    SmartDialog.showLoading();
    try {
      SmsCodeReq req = SmsCodeReq(
          phone: _phone,
          phoneCode: region.code,
          lang: await LocalModule().getLangTag(),
          skipPhoneBoundVerify: false,
          token: '',
          sessionId: '',
          sig: '');

      SendMessageAction<SmsCodeReq> action = SendMessageAction(
          smsCodeReq: req,
          request: ref
              .read(accountRepositoryProvider)
              .getSecureByPhoneVerificationCode,
          contex: context);
      ref.read(sendMessageProviderProvider.notifier).updateAction(action);
      var request = await ref
          .read(sendMessageProviderProvider.notifier)
          .sendCode<SmsCodeReq>();
      SmartDialog.dismiss(status: SmartStatus.loading);
      showToast('send_success'.tr());
      pushToRecoverCodePage(request);
      return Future.value(request);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11004:
          showToast('text_error_toomuch'.tr());
          break;
        case 11003:
          showToast('send_sms_too_frequent'.tr());
          break;
        case 30910:
          showToast('phone_has_register'.tr());
          break;
        default:
          showToast('send_sms_code_error'.tr());
          break;
      }

      return Future.error(e);
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      if (e != 300101) {
        showToast('send_sms_code_error'.tr());
      }
      return Future.error(e);
    }
  }

  void showToast(String text) {
    state = state.copyWith(event: ToastEvent(text: text));
  }

  void pushToRecoverCodePage(SmscodeTrans smsTrans) {
    // GoRouter.of(context)
    //     .push(AppRoutes.RECOVER_CODE_PAGE, extra: {'trans': smsTrans});
    state = state.copyWith(
      event: PushEvent(
        path: MobileBindCheckCodePage.routePath,
        extra: {
          'trans': smsTrans,
        },
        func: RouterFunc.push,
      ),
    );
  }
}
