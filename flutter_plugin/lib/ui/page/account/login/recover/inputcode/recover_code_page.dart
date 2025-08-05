import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/change/recover_change_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/inputcode/recover_code_state_notigier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_pincode_text_field.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:go_router/go_router.dart';

class RecoverCodePage extends BasePage {
  static const String routePath = '/recover_code_page';

  const RecoverCodePage({super.key});

  @override
  RecoverCodeState createState() {
    return RecoverCodeState();
  }
}

class RecoverCodeState extends BasePageState
    with recoverChangePageEnbale, CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'input_verify_code'.tr();

  late RecoverCodeStateNotifier notifier =
      ref.read(recoverCodeStateNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var extras = GoRouterState.of(context).extra as Map<String, dynamic>;
      var trans = extras['trans'];
      ref.read(recoverCodeStateNotifierProvider.notifier).updateData(trans);
    });
  }

  @override
  void addObserver() {
    super.addObserver();
    addUIEventListen();
  }

  void addUIEventListen() {
    ref.listen(recoverCodeStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    notifier.dispose();
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 16).withRTL(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: ref.watch(
                        recoverCodeStateNotifierProvider
                            .select((value) => value.sourceWayText ?? ''),
                      ),
                    ),
                    TextSpan(
                      text: ref.watch(recoverCodeStateNotifierProvider
                          .select((value) => value.sourceText ?? '')),
                      style: TextStyle(
                        color: style.click,
                      ),
                    ),
                  ],
                  style: style.secondStyle(),
                ),
              ),
            ],
          ),
          Padding(
              padding:
                  const EdgeInsets.only(top: 50, bottom: 26).withRTL(context),
              child: DmPincodeTextField(
                  length: 6,
                  width: 48,
                  height: 54,
                  fontSize: style.input_number,
                  fontWeight: FontWeight.w600,
                  onChanged: (number) {
                    notifier.changeCode(number);
                  })),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 36).withRTL(context),
            child: GestureDetector(
              onTap: () {
                bool enable = ref.watch(recoverCodeStateNotifierProvider
                    .select((value) => value.enableSend));
                if (enable) {
                  notifier.resetCode(context);
                }
              },
              child: Text(
                ref.watch(recoverCodeStateNotifierProvider
                    .select((value) => value.sendButtonText)),
                style: ref.watch(recoverCodeStateNotifierProvider
                        .select((value) => value.enableSend))
                    ? style.clickStyle()
                    : style.secondStyle(),
              ),
            ),
          ),
          DMCommonClickButton(
            borderRadius: style.buttonBorder,
            disableBackgroundGradient: style.disableBtnGradient,
            disableTextColor: style.disableBtnTextColor,
            textColor: style.enableBtnTextColor,
            backgroundGradient: style.confirmBtnGradient,
            enable: ref.watch(
              recoverCodeStateNotifierProvider
                  .select((value) => value.enableNext),
            ),
            text: 'next'.tr(),
            onClickCallback: () async {
              // pushToRecoverChangePage(notifier.trans);
              SmscodeTrans trans = await notifier.checkCode();
              pushToRecoverChangePage(trans);
            },
          ),
        ],
      ),
    );
  }
}

mixin recoverCodePageEnbale on BasePageState {
  void pushToRecoverCodePage(SmscodeTrans smsTrans) {
    GoRouter.of(context)
        .push(RecoverCodePage.routePath, extra: {'trans': smsTrans});
  }
}
