import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/inputcode/recover_code_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mail/mail_recover_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mobile/mobile_recover_state_notifier.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_page.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/recover_bottom_button.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:go_router/go_router.dart';

class MobileRecoverPage extends BasePage {
  static const String routePath = '/mobile_recover_page';

  const MobileRecoverPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MobileRecoverState createState() {
    return _MobileRecoverState();
  }
}

class _MobileRecoverState extends BasePageState
    with
        regionPickerEnbale,
        recoverCodePageEnbale,
        CommonDialog,
        ResponseForeUiEvent {
  late MoblieRecoverStateNotifier notifier =
      ref.read(moblieRecoverStateNotifierProvider.notifier);

  @override
  String get centerTitle => 'text_retrieve_password'.tr();

  Future<SmscodeTrans> reset(BuildContext ncontext) {
    return notifier.sendMessage(ncontext);
  }

  @override
  void initData() {
    super.initData();
    var extra = GoRouterState.of(context).extra;
    String? phone = (extra is String) ? extra : null;
    notifier.preparedData(phone);
  }

  @override
  void addObserver() {
    super.addObserver();
    addUIEventListen();
  }

  void addUIEventListen() {
    ref.listen(
        moblieRecoverStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    if (ref.watch(
        moblieRecoverStateNotifierProvider.select((value) => value.prepared))) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(32, 40, 32, 16).withRTL(context),
        child: Column(
          children: [
            const RegionSelectMeun(canTap: false),
            AnimatedInputText(
              onTextChanged: (value) {
                ref
                    .read(moblieRecoverStateNotifierProvider.notifier)
                    .phoneNumberChange(value);
              },
              textHint: 'please_input_mobile'.tr(),
              underLineColor: style.lightBlack1,
              animateColor: style.click,
              initialValue:
                  ref.read(moblieRecoverStateNotifierProvider).initPhone,
              showCountryCode: false,
              showGetDynamicCode: false,
              textInputType: TextInputType.number,
              changeCountryCode: () async {
                LogModule().eventReport(4, 3, int1: 1);
                RegionItem? item0 = ref.read(moblieRecoverStateNotifierProvider
                    .select((value) => value.phoneCodeRegion));
                if (item0 == null) return;
                RegionItem? item = await pushToPicker(item0);
                if (item != null) {
                  ref
                      .read(moblieRecoverStateNotifierProvider.notifier)
                      .phoneCodeChange(item);
                }
              },
              onTap: () {
                LogModule().eventReport(4, 4, int1: 1);
              },
            ),
            DMCommonClickButton(
              borderRadius: style.buttonBorder,
              disableBackgroundGradient: style.disableBtnGradient,
              disableTextColor: style.disableBtnTextColorGold,
              textColor: style.enableBtnTextColorGold,
              backgroundGradient: style.brandColorGradient,
              enable: ref.watch(moblieRecoverStateNotifierProvider
                  .select((value) => value.enableSend)),
              text: 'send_sms_code'.tr(),
              margin: const EdgeInsets.only(top: 55).withRTL(context),
              onClickCallback: () async {
                LogModule().eventReport(4, 6, int2: 1);
                SmscodeTransByPhone? trans =
                    await notifier.sendMessage(context) as SmscodeTransByPhone?;
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
                    resource.getResource('recover_by_mail'),
                    width: 32,
                    height: 32,
                  ),
                  text: 'use_email_reset_password'.tr(),
                  onPress: () {
                    LogModule().eventReport(4, 7, int1: 1);
                    // GoRouter.of(context).go(MailRecoverPage.routePath);
                    try {
                      Page<dynamic> _ = Navigator.of(context)
                          .widget
                          .pages
                          .firstWhere((element) =>
                              ('${element.name}' == MailRecoverPage.routePath));
                      GoRouter.of(context).pop();
                    } catch (_) {
                      GoRouter.of(context).push(MailRecoverPage.routePath);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
