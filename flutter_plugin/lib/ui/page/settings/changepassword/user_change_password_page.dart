import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/settings/changepassword/user_change_password_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/changepassword/user_change_password_ui_state.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserChangePasswordPage extends BasePage {
  static const String routePath = '/user_change_password';

  const UserChangePasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserChangePasswordPageState();
  }
}

class _UserChangePasswordPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'reset_password'.tr();

  @override
  void initData() {}

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(userChangePasswordUiEventProvider, (previous, next) {
      responseFor(next);
    });
    ref.listen(
        userChangePasswordStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  Future<void> _clickCommitButton() async {
    bool success = await ref
        .watch(userChangePasswordStateNotifierProvider.notifier)
        .changePasswordAction();
    if (success) {
      ref
          .read(userChangePasswordUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'reset_success'.tr()));
      await LifeCycleManager().logOut();
    }
  }

  Widget _tipsCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserChangePasswordUiState uiState) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: double.infinity,
      child: Text(
        'text_new_password_tips'.tr(),
        style: TextStyle(
          color: style.textSecond,
          fontSize: style.smallText,
        ),
      ),
    );
  }

  Widget _passwordCell1(BuildContext context, StyleModel style,
      ResourceModel resource, UserChangePasswordUiState uiState) {
    return DMTextFieldItem(
      inputStyle: TextStyle(
        color: style.textMainBlack,
        fontSize: 16,
      ),
      width: double.infinity,
      height: 52,
      padding: EdgeInsets.zero,
      borderRadius: style.cellBorder,
      autofocus: uiState.oldPasswordFocus,
      showClear: true,
      showPrivate: true,
      obscureText: true,
      placeText: 'reset_input_original_password'.tr(),
      text: ref.watch(userChangePasswordStateNotifierProvider).oldPassword,
      onEditingComplete: (value) {
        ref
            .read(userChangePasswordStateNotifierProvider.notifier)
            .focusNewPassword1();
      },
      onChanged: (value) {
        ref
            .read(userChangePasswordStateNotifierProvider.notifier)
            .changeOldPasswrd(value);
      },
    );
  }

  Widget _passwordCell2(BuildContext context, StyleModel style,
      ResourceModel resource, UserChangePasswordUiState uiState) {
    return DMTextFieldItem(
        inputStyle: TextStyle(
          color: style.textMainBlack,
          fontSize: 16,
        ),
        width: double.infinity,
        height: 52,
        padding: EdgeInsets.zero,
        borderRadius: style.cellBorder,
        autofocus: uiState.newPassword1Focus,
        showClear: true,
        showPrivate: true,
        obscureText: true,
        placeText: 'reset_confirm_new_password'.tr(),
        text: ref.watch(userChangePasswordStateNotifierProvider).newPassword1,
        onEditingComplete: (value) {
          ref
              .read(userChangePasswordStateNotifierProvider.notifier)
              .focusNewPassword2();
        },
        onChanged: (value) {
          ref
              .read(userChangePasswordStateNotifierProvider.notifier)
              .changeNewPasswrd1(value);
        });
  }

  Widget _passwordCell3(BuildContext context, StyleModel style,
      ResourceModel resource, UserChangePasswordUiState uiState) {
    return DMTextFieldItem(
        inputStyle: TextStyle(
          color: style.textMainBlack,
          fontSize: 16,
        ),
        width: double.infinity,
        height: 52,
        borderRadius: style.cellBorder,
        showClear: true,
        showPrivate: true,
        obscureText: true,
        padding: EdgeInsets.zero,
        autofocus: uiState.newPassword2Focus,
        placeText: 'confirm_new_pwd'.tr(),
        text: ref.read(userChangePasswordStateNotifierProvider).newPassword2,
        onEditingComplete: (value) {
          ref
              .watch(userChangePasswordStateNotifierProvider.notifier)
              .unfocusAlltextField();
        },
        onChanged: (value) {
          ref
              .read(userChangePasswordStateNotifierProvider.notifier)
              .changeNewPasswrd2(value);
        });
  }

  Widget _bottomeCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserChangePasswordUiState uiState) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 56),
        child: SizedBox(
            width: double.infinity,
            child: DMCommonClickButton(
              enable: uiState.enableCommitButton == true,
              width: double.infinity,
              height: 52,
              borderRadius: style.buttonBorder,
              text: 'confirm'.tr(),
              disableBackgroundGradient: style.disableBtnGradient,
              disableTextColor: style.disableBtnTextColor,
              textColor: style.enableBtnTextColor,
              backgroundGradient: style.confirmBtnGradient,
              onClickCallback: () async {
                await _clickCommitButton();
              },
            )));
  }

  Widget buildContenteBody(BuildContext context, StyleModel style,
      ResourceModel resource, UserChangePasswordUiState uiState) {
    List<Widget> widgetList = [];
    widgetList.add(_tipsCell(context, style, resource, uiState));
    widgetList.add(_passwordCell1(context, style, resource, uiState));
    widgetList.add(_passwordCell2(context, style, resource, uiState));
    widgetList.add(_passwordCell3(context, style, resource, uiState));
    widgetList.add(_bottomeCell(context, style, resource, uiState));

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
    UserChangePasswordUiState uiState =
        ref.watch(userChangePasswordStateNotifierProvider);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: style.bgBlack,
      child: buildContenteBody(context, style, resource, uiState),
    );
  }
}
