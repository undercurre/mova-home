import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/unbindPhone/unbind_phone_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/unbindPhone/unbind_phone_ui_state.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnbindPhoneSettingPage extends BasePage {
  static const String routePath = '/unbind_phone_seting';
  const UnbindPhoneSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UnbindPhoneSettingPageState();
  }
}

class UnbindPhoneSettingPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'mine_phone_number'.tr();

  @override
  void initPageState() {}

  @override
  void initData() {
    ref.watch(unbindPhoneStateNotifierProvider.notifier).getUserInfo();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(unbindPhoneEventProvider, (previous, next) {
      responseFor(next);
    });
  }

  Widget _fixPhoneTipsCell(BuildContext context, StyleModel style,
      ResourceModel resource, UnbindPhoneUiState uiState) {
    String phone = uiState.userInfo?.phone ?? '';
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Text('current_phone'.tr(args: [phone]),
              style:
                  TextStyle(fontSize: style.largeText, color: style.textMain)),
        ));
  }

  Widget _fixPhoneCodeCell(BuildContext context, StyleModel style,
      ResourceModel resource, UnbindPhoneUiState uiState) {
    Widget clickButton = DMButton(
      borderRadius: 0,
      textColor: style.click,
      borderColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      text: uiState.sendPhoneCodeStr,
      onClickCallback: (_) async {
        if (uiState.enableSend) {
          await clickUnBindGetPhoneCodeAction();
        }
      },
    );

    return DMTextFieldItem(
      width: double.infinity,
      height: 52,
      keyboardType: TextInputType.number,
      placeText: 'input_verify_code'.tr(),
      text: ref.watch(unbindPhoneStateNotifierProvider).phoneCode,
      inputStyle: style.thirdStyle(),
      rightWidget: clickButton,
      maxLength: 6,
      onChanged: (value) {
        ref
            .read(unbindPhoneStateNotifierProvider.notifier)
            .changeUnbindPhoneCodeNumber(value);
      },
      onEditingComplete: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _fixPhoneConfirmUnbindCell(BuildContext context, StyleModel style,
      ResourceModel resource, UnbindPhoneUiState uiState) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 56),
      child: SizedBox(
        width: double.infinity,
        child: DMCommonClickButton(
          height: 52,
          borderRadius: style.buttonBorder,
          disableTextColor: style.disableBtnTextColor,
          disableBackgroundGradient: style.disableBtnGradient,
          textColor: style.enableBtnTextColor,
          backgroundGradient: style.confirmBtnGradient,
          enable: ref.watch(unbindPhoneStateNotifierProvider
              .select((value) => value.enableUnbindButton)),
          text: 'confirm_unbind'.tr(),
          margin: const EdgeInsets.only(top: 51).withRTL(context),
          onClickCallback: () async {
            await tapComfirmUnbindButton(uiState);
          },
        ),
      ),
    );
  }

  // 解绑手机号
  Widget buildContenteBody(BuildContext context, StyleModel style,
      ResourceModel resource, UnbindPhoneUiState uiState) {
    List<Widget> widgetList = [];
    widgetList.add(_fixPhoneTipsCell(context, style, resource, uiState));
    widgetList.add(_fixPhoneCodeCell(context, style, resource, uiState));
    widgetList
        .add(_fixPhoneConfirmUnbindCell(context, style, resource, uiState));

    return Container(
      color: style.bgGray,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgetList),
      ),
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    UnbindPhoneUiState uiState = ref.watch(unbindPhoneStateNotifierProvider);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
      width: double.infinity,
      height: double.infinity,
      color: style.bgGray,
      child: buildContenteBody(context, style, resource, uiState),
      ),
    );
  }
}

extension UnbindPhoneSettingPageAction on UnbindPhoneSettingPageState {
  Future<void> clickUnBindGetPhoneCodeAction() async {
    if (ref
        .read(unbindPhoneStateNotifierProvider.notifier)
        .checkPhoneNumber()) {
      await RecaptchaController(context, (recaptchaModel) {
        _getUnbindVerifyCode2(recaptchaModel);
      }).check();
    }
  }

  Future<void> _getUnbindVerifyCode2(RecaptchaModel recaptchaModel) async {
    var ret = await ref
        .read(unbindPhoneStateNotifierProvider.notifier)
        .unbindGetPhoneCodeAction(recaptchaModel)
        .then((value) => value.second);
    if (ret != null) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'send_success'.tr()));
    }
  }

  // 提交参数校验
  bool _vertifiCommitParams(
      String phone, String regnCode, String codeKey, String codeValue) {
    if (phone.isEmpty) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'mobile_invalid'.tr()));
      return false;
    } else if (regnCode.isEmpty || codeKey.isEmpty) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'get_sms_code'.tr()));
      return false;
    } else if (codeValue.isEmpty || codeValue.length < 6) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'email_code_invalid'.tr()));
      return false;
    }
    return true;
  }

  Future<void> tapComfirmUnbindButton(UnbindPhoneUiState uiState) async {
    String phoneNumber = uiState.userInfo?.phone ?? '';
    String regnCode = uiState.userInfo?.phoneCode ?? '';
    String codeKey = uiState.smsRes?.codeKey ?? '';
    String codeValue = uiState.phoneCode ?? '';

    if (_vertifiCommitParams(phoneNumber, regnCode, codeKey, codeValue)) {
      showCommonDialog(
          content: 'dialog_delete_current_phone'.tr(),
          cancelContent: 'cancel'.tr(),
          confirmContent: 'confirm_unbind'.tr(),
          cancelCallback: () {},
          confirmCallback: () async {
            await realCommitFunc();
          });
    }
  }

  Future<void> realCommitFunc() async {
    // 点解确认解除绑定按钮
    bool success = await ref
        .read(unbindPhoneStateNotifierProvider.notifier)
        .unbindPhoneAction();
    if (success) {
      ref
          .read(unbindPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'unbind_success'.tr()));
      await Future.delayed(const Duration(milliseconds: 200));
      ref.read(unbindPhoneEventProvider.notifier).sendEvent(
          PushEvent(path: AccountSettingPage.routePath, func: RouterFunc.pop));
    }
  }
}
