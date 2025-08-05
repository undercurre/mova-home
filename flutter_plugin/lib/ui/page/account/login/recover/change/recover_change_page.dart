import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/change/recover_change_state_notifier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';

// ignore: implementation_imports
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:go_router/go_router.dart';

class RecoverChangePage extends BasePage {
  static const String routePath = '/recover_change_page';

  const RecoverChangePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return RecoverChangeState();
  }
}

class RecoverChangeState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'text_retrieve_password'.tr();

  late RecoverChangeStateNotifier notifier =
      ref.read(recoverChangeStateNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var trans = GoRouterState.of(context).extra as SmscodeTrans;
      notifier.updateTrans(trans);
    });
  }

  @override
  void addObserver() {
    super.addObserver();
    addUIEventListen();
  }

  void addUIEventListen() {
    ref.listen(
        recoverChangeStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(32, 20, 32, 16).withRTL(context),
        child: Column(
          children: [
            AnimatedInputText(
              fontSize: 16,
              textHint: 'enter_new_pwd'.tr(),
              inputType: AnimatedInputText.INPUT_TYPE_PWD,
              hidePassword: ref.read(recoverChangeStateNotifierProvider
                  .select((value) => value.hidePassword)),
              showCountryCode: false,
              showEye: true,
              showGetDynamicCode: false,
              onTextChanged: (text) {
                notifier.passwordChange(text);
              },
              onPassWordHideChanged: (value) {
                notifier.changehidePassword(value);
              },
              onTap: () {
                notifier.inputBegin(10);
              },
            ),
            AnimatedInputText(
              fontSize: 16,
              textHint: 'confirm_new_pwd'.tr(),
              inputType: AnimatedInputText.INPUT_TYPE_PWD,
              hidePassword: ref.read(recoverChangeStateNotifierProvider
                  .select((value) => value.configPassword)),
              showCountryCode: false,
              showEye: true,
              showGetDynamicCode: false,
              onTextChanged: (text) {
                notifier.confimWordChange(text);
              },
              onPassWordHideChanged: (value) {
                notifier.changeConfigPassword(value);
              },
              onTap: () {
                notifier.inputBegin(11);
              },
            ),
            Container(
              margin:
                  const EdgeInsets.only(top: 32, bottom: 32).withRTL(context),
              child: Text(
                'text_new_password_tips'.tr(),
                style: style.secondStyle(fontSize: 12),
              ),
            ),
            DMCommonClickButton(
              borderRadius: style.buttonBorder,
              disableBackgroundGradient: style.disableBtnGradient,
              disableTextColor: style.disableBtnTextColor,
              textColor: style.enableBtnTextColor,
              backgroundGradient: style.confirmBtnGradient,
              enable: ref.watch(
                recoverChangeStateNotifierProvider
                    .select((value) => value.enableNext),
              ),
              text: 'confirm'.tr(),
              onClickCallback: () async {
                notifier.changePassword();
              },
            ),
          ],
        ));
  }
}

mixin recoverChangePageEnbale on BasePageState {
  void pushToRecoverChangePage(SmscodeTrans smsTrans) {
    GoRouter.of(context).push(RecoverChangePage.routePath, extra: smsTrans);
  }
}
