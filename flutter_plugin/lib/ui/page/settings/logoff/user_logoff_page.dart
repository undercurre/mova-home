import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/settings/changepassword/user_change_password_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/changepassword/user_change_password_ui_state.dart';
import 'package:flutter_plugin/ui/page/settings/logoff/user_logoff_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserLogoffPage extends BasePage {
  static const String routePath = '/user_delete_account';
  const UserLogoffPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserLogoffPageState();
  }
}

class _UserLogoffPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'logoff_account'.tr();

  @override
  void initData() {
    ref.watch(userLogoffStateNotifierProvider.notifier).prepared();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(deleteAccountUiEventProvider, (previous, next) {
      responseFor(next);
    });
  }

  Future<void> _clickCommitButton() async {
    showCommonDialog(
        content: 'logoff_warning'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmContent: 'logoff_confirm'.tr(),
        confirmCallback: () async {
          await LifeCycleManager().logOut(
              logoutFuture: ref
                  .read(userLogoffStateNotifierProvider.notifier)
                  .logoOffAction);
        });
  }

  Widget _tipsCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserChangePasswordUiState uiState) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      child: Text(
        'logoff_account_title'.tr(),
        maxLines: 2,
        style: TextStyle(
          color: style.textNormal,
          fontSize: style.largeText,
        ),
      ),
    );
  }

  Widget _contentTextCell1(BuildContext context, StyleModel style,
      ResourceModel resource, UserChangePasswordUiState uiState) {
    String content = ref
        .watch(userLogoffStateNotifierProvider.select((value) => value.tipStr));
    return Expanded(
        flex: 1,
        child: Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content,
                  maxLines: 10,
                  style: TextStyle(
                    color: style.textNormal,
                    fontSize: style.largeText,
                  )),
            ],
          ),
        ));
  }

  Widget _bottomeCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserChangePasswordUiState uiState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 56),
      child: SizedBox(
        width: double.infinity,
        child: DMButton(
          backgroundGradient: style.cancelBtnGradient,
          width: double.infinity,
          height: 48,
          borderRadius: style.buttonBorder,
          text: 'logoff'.tr(),
          textColor: style.lightDartBlack,
          onClickCallback: (context) {
            _clickCommitButton();
          },
        ),
      ),
    );
  }

  Widget buildContenteBody(BuildContext context, StyleModel style,
      ResourceModel resource, UserChangePasswordUiState uiState) {
    List<Widget> widgetList = [];
    widgetList.add(_tipsCell(context, style, resource, uiState));
    widgetList.add(_contentTextCell1(context, style, resource, uiState));
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
    return ProviderScope(
      overrides: [
        userChangePasswordUiEventProvider
            .overrideWith(() => UserChangePasswordUiEvent()),
        userChangePasswordStateNotifierProvider
            .overrideWith(() => UserChangePasswordStateNotifier())
      ],
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: style.bgBlack,
        child: buildContenteBody(context, style, resource,
            ref.watch(userChangePasswordStateNotifierProvider)),
      ),
    );
  }
}
