import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/settings/settingpassword/user_setting_password_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserSettingPasswordPage extends BasePage {
  static const String routePath = '/user_setting_password';

  const UserSettingPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserSettingPasswordPageState();
  }
}

class UserSettingPasswordPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'set_password'.tr();

  @override
  void initPageState() {}

  @override
  void initData() {}

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(userSettingPasswordUiEventProvider, (previous, next) {
      responseFor(next);
    });
  }

  Widget _tipsCell(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 10),
      width: double.infinity,
      height: 34,
      child: Text(
        'text_new_password_tips'.tr(),
        maxLines: 2,
        style: TextStyle(
          color: style.textSecond,
          fontSize: style.smallText,
        ),
      ),
    );
  }

  Widget _passwordCell1(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return DMTextFieldItem(
      width: double.infinity,
      height: 52,
      padding: EdgeInsets.zero,
      obscureText: true,
      showClear: true,
      showPrivate: true,
      placeText: 'reset_input_new_password'.tr(),
      text: ref.watch(userSettingPasswordStateNotifierProvider).password1,
      inputStyle: style.thirdStyle(),
      onChanged: (value) {
        ref
            .read(userSettingPasswordStateNotifierProvider.notifier)
            .changePassword1(value);
      },
    );
  }

  Widget _passwordCell2(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return DMTextFieldItem(
      width: double.infinity,
      height: 52,
      obscureText: true,
      padding: EdgeInsets.zero,
      showClear: true,
      showPrivate: true,
      placeText: 'reset_input_new_password'.tr(),
      inputStyle: style.thirdStyle(),
      text: ref.watch(userSettingPasswordStateNotifierProvider).password2,
      onChanged: (value) {
        ref
            .read(userSettingPasswordStateNotifierProvider.notifier)
            .changePassword2(value);
      },
    );
  }

  Widget _bottomeCell(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56),
      child: SizedBox(
        width: double.infinity,
        child: DMCommonClickButton.gradient(
          borderRadius: style.buttonBorder,
          height: 52,
          disableBackgroundGradient: style.disableBtnGradient,
          disableTextColor: style.disableBtnTextColor,
          textColor: style.enableBtnTextColor,
          backgroundGradient: style.confirmBtnGradient,
          enable: ref.watch(userSettingPasswordStateNotifierProvider
              .select((value) => value.enableCommitButton)),
          text: 'confirm'.tr(),
          onClickCallback: () {
            clickCommitButton();
          },
        ),
      ),
    );
  }

  Widget buildContenteBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    List<Widget> widgetList = [];
    widgetList.add(_tipsCell(context, style, resource));
    widgetList.add(_passwordCell1(context, style, resource));
    widgetList.add(_passwordCell2(context, style, resource));
    widgetList.add(_bottomeCell(context, style, resource));

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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: style.bgGray,
      child: buildContenteBody(context, style, resource),
    );
  }

  Future<void> clickCommitButton() async {
    bool isSuccess = await ref
        .watch(userSettingPasswordStateNotifierProvider.notifier)
        .settingPasswordAction();
    if (isSuccess) {
      ref
          .read(userSettingPasswordUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'setting_success'.tr()));
      await Future.delayed(const Duration(milliseconds: 200));
      GoRouter.of(context).pop();
    }
  }
}
