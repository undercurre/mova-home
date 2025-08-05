import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/inputcode/recover_code_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mail/mail_recover_state_notifier.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mobile/mobile_recover_page.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/recover_bottom_button.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:go_router/go_router.dart';

class MailRecoverPage extends BasePage {
  static const String routePath = '/mail_recover_page';

  const MailRecoverPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MailRecoverPage createState() {
    return _MailRecoverPage();
  }
}

class _MailRecoverPage extends BasePageState
    with recoverCodePageEnbale, CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'text_retrieve_password'.tr();

  late MailRecoverStateNotifier notifier =
      ref.read(mailRecoverStateNotifierProvider.notifier);

  Future<SmscodeTrans> reset(BuildContext ncontext) {
    return notifier.sendMessage();
  }

  @override
  void addObserver() {
    super.addObserver();
    addUIEventListen();
  }

  void addUIEventListen() {
    ref.listen(mailRecoverStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 16).withRTL(context),
      child: Column(
        children: [
          RegionSelectMeun(canTap: false),
          AnimatedInputText(
            onTextChanged: (value) {
              notifier.emailChange(value);
            },
            textHint: 'please_input_email'.tr(),
            underLineColor: style.lightBlack1,
            animateColor: style.click,
            showCountryCode: false,
            showGetDynamicCode: false,
            textInputType: TextInputType.emailAddress,
            changeCountryCode: () {},
            onTap: () {
              LogModule().eventReport(4, 5, int1: 1);
            },
          ),
          DMCommonClickButton(
            borderRadius: style.buttonBorder,
            disableBackgroundGradient: style.disableBtnGradient,
            disableTextColor: style.disableBtnTextColorGold,
            textColor: style.enableBtnTextColorGold,
            backgroundGradient: style.brandColorGradient,
            enable: ref.watch(mailRecoverStateNotifierProvider
                .select((value) => value.enableSend)),
            text: 'send_sms_code'.tr(),
            margin: const EdgeInsets.only(top: 55).withRTL(context),
            onClickCallback: () async {
              LogModule().eventReport(4, 6, int2: 1);
              SmscodeTransByMail? trans =
                  await notifier.sendMessage() as SmscodeTransByMail?;
              if (trans != null) {
                pushToRecoverCodePage(trans);
              }
            },
          ),
          const Spacer(),
          Container(
              padding: const EdgeInsets.only(bottom: 40).withRTL(context),
              child: Center(
                child: RecoverBottomButton(
                  icon: Image.asset(
                    resource.getResource('use_phone_reset_mail'),
                    width: 32,
                    height: 32,
                  ),
                  text: 'use_phone_reset_password'.tr(),
                  onPress: () {
                    LogModule().eventReport(4, 8, int1: 1);

                    try {
                      Page<dynamic> _ = Navigator.of(context)
                          .widget
                          .pages
                          .firstWhere((element) => ('${element.name}' ==
                              MobileRecoverPage.routePath));
                      GoRouter.of(context).pop();
                    } catch (_) {
                      GoRouter.of(context).push(MobileRecoverPage.routePath);
                    }
                  },
                ),
              )),
        ],
      ),
    );
  }
}
