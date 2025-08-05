import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/settings/username/user_name_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/username/user_name_ui_state.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_textField_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserNameSettingPage extends BasePage {
  static const String routePath = '/user_name_seting';
  const UserNameSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserNameSettingPageState();
  }
}

class UserNameSettingPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'set_nick'.tr();

  @override
  void initPageState() {}

  @override
  Future<void> initData() async {
    await ref.watch(userNameSetNotifierProvider.notifier).getUserInfo();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(userNameEventProvider, (previous, next) {
      responseFor(next);
    });
  }

  Widget _topCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserNameUiState uistate) {
    return SizedBox(
        width: double.infinity,
        child: DMTextFieldItem(
          width: double.infinity,
          placeText: 'please_enter_nick_name'.tr(),
          text: ref.watch(userNameSetNotifierProvider).userName,
          height: 52,
          borderRadius: style.buttonBorder,
          showClear: true,
          inputStyle: TextStyle(
            color: style.textMainBlack,
            fontSize: 16,
          ),
          onChanged: (value) {
            ref
                .read(userNameSetNotifierProvider.notifier)
                .changeNickName(value);
          },
        ));
  }

  Widget _middleCell(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return const Expanded(
      flex: 1,
      child: SizedBox(
        width: double.infinity,
        child: SizedBox.shrink(),
      ),
    );
  }

  Widget _bottomeCell(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: DMCommonClickButton(
        enable: ref.watch(userNameSetNotifierProvider
            .select((value) => value.enableSaveButton)),
        text: 'save'.tr(),
        disableBackgroundGradient: style.disableBtnGradient,
        disableTextColor: style.disableBtnTextColorGold,
        textColor: style.enableBtnTextColorGold,
        backgroundGradient: style.brandColorGradient,
        height: 48,
        borderRadius: style.buttonBorder,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        onClickCallback: () async {
          bool isSuccess = await ref
              .watch(userNameSetNotifierProvider.notifier)
              .putUserInfo();
          if (isSuccess) {
            GoRouter.of(context).pop();
          }
        },
      ),
    );
  }

  Widget buildContenteBody(BuildContext context, StyleModel style,
      ResourceModel resource, UserNameUiState uistate) {
    List<Widget> widgetList = [];
    if (ref.watch(
        userNameSetNotifierProvider.select((value) => value.dataPrepared))) {
      widgetList.add(_topCell(context, style, resource, uistate));
      widgetList.add(_middleCell(context, style, resource));
      widgetList.add(_bottomeCell(context, style, resource));
    }

    return Container(
        color: style.bgGray,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widgetList),
        ));
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    UserNameUiState uiState = ref.watch(userNameSetNotifierProvider);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: style.bgGray,
      child: buildContenteBody(context, style, resource, uiState),
    );
  }
}

extension UserNameSettingPageAction on UserNameSettingPageState {}
