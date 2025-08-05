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
import 'package:flutter_plugin/ui/page/settings/unbindMail/unbind_mail_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/unbindMail/unbind_mail_ui_state.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UnbindMailSettingPage extends BasePage {
  static const String routePath = '/unbind_mail_seting';

  const UnbindMailSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UnbindMailSettingPageState();
  }
}

class UnbindMailSettingPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'unbind'.tr();

  @override
  void initPageState() {}

  @override
  void initData() {
    super.initData();
    var extras = GoRouterState.of(context).extra;
    if (extras is Map<String, dynamic>) {
      String? emailAddress = extras['emailAddress'];
      if (emailAddress != null && emailAddress.isNotEmpty) {
        ref
            .watch(unbindMailStateNotifierProvider.notifier)
            .changeEmailAddress(emailAddress);
      }
    }

    ref.watch(unbindMailStateNotifierProvider.notifier).getUserInfo();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(unbindMailUiEventProvider, (previous, next) {
      responseFor(next);
    });
  }

  Widget _tipsCell2(BuildContext context, StyleModel style,
      ResourceModel resource, UnbindMailUiState uiState) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 18, 4, 18),
      width: double.infinity,
      child: Text(
        'current_email'.tr(args: [uiState.emailAddress ?? '']),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: style.textMain,
          fontSize: style.largeText,
        ),
      ),
    );
  }

  Widget _passwordCell2(BuildContext context, StyleModel style,
      ResourceModel resource, UnbindMailUiState uiState) {
    return DMTextFieldItem(
        inputStyle: style.fourthStyle(),
        padding: EdgeInsets.zero,
        width: double.infinity,
        obscureText: true,
        height: 52,
        text: ref.watch(unbindMailStateNotifierProvider).password,
        showClear: true,
        showPrivate: true,
        placeText: 'enter_pwd'.tr(),
        onChanged: (value) {
          ref
              .read(unbindMailStateNotifierProvider.notifier)
              .changePassword(value);
        });
  }

  Widget _unbindCell2(BuildContext context, StyleModel style,
      ResourceModel resource, UnbindMailUiState uiState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56),
      child: SizedBox(
        width: double.infinity,
        child: DMCommonClickButton(
          enable: ref.watch(unbindMailStateNotifierProvider
              .select((value) => value.enableUnbindButton)),
          width: double.infinity,
          height: 52,
          borderRadius: style.buttonBorder,
          disableBackgroundGradient: style.disableBtnGradient,
          disableTextColor: style.disableBtnTextColor,
          textColor: style.enableBtnTextColor,
          backgroundGradient: style.confirmBtnGradient,
          pressedColor: style.lightBlack1,
          disablePressedColor: style.bgGray,
          text: 'unbind'.tr(),
          onClickCallback: () {
            _tapUnbindButtonClick();
          },
        ),
      ),
    );
  }

  // 解除绑定邮箱逻辑
  Widget buildContenteBody(BuildContext context, StyleModel style,
      ResourceModel resource, UnbindMailUiState uiState) {
    List<Widget> widgetList = [];
    widgetList.add(_tipsCell2(context, style, resource, uiState));
    widgetList.add(_passwordCell2(context, style, resource, uiState));
    widgetList.add(_unbindCell2(context, style, resource, uiState));

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
    UnbindMailUiState uiState = ref.watch(unbindMailStateNotifierProvider);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: style.bgGray,
      child: buildContenteBody(context, style, resource, uiState),
    );
  }
}

extension UnbindMailSettingPageAction on UnbindMailSettingPageState {
  Future<void> tapGetVaildCodeNumber() async {
    await RecaptchaController(context, (recaptchaModel) {
      ref
          .watch(unbindMailStateNotifierProvider.notifier)
          .getEmailCodeAction(recaptchaModel);
    }).check();
  }

  void _tapUnbindButtonClick() {
    showCommonDialog(
        content: 'dialog_delete_current_email'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmContent: 'confirm_unbind'.tr(),
        confirmCallback: () async {
          bool isSuccess = await ref
              .read(unbindMailStateNotifierProvider.notifier)
              .unbindEmailAction();
          if (isSuccess) {
            ref
                .read(unbindMailUiEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'unbind_success'.tr()));
            await Future.delayed(const Duration(milliseconds: 200));
            ref.read(unbindMailUiEventProvider.notifier).sendEvent(PushEvent(
                path: AccountSettingPage.routePath, func: RouterFunc.pop));
          }
        });
  }
}
