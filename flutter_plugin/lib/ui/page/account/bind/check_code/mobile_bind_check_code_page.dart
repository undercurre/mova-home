import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind/check_code/mobile_bind_check_code_state_notifier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_pincode_text_field.dart';
import 'package:flutter_plugin/utils/alignment_extension.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:go_router/go_router.dart';

class MobileBindCheckCodePage extends BasePage {
  static const String routePath = '/mobile_bind_check_code';

  const MobileBindCheckCodePage({super.key});

  @override
  MobileBindCheckCodePageState createState() {
    return MobileBindCheckCodePageState();
  }
}

class MobileBindCheckCodePageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  late MobileBindCheckCodeStateNotifier notifier =
      ref.read(mobileBindCheckCodeStateNotifierProvider.notifier);

  @override
  void addObserver() {
    super.addObserver();
    addUIEventListen();
  }

  void addUIEventListen() {
    ref.listen(
        mobileBindCheckCodeStateNotifierProvider.select((value) => value.event),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var extras = GoRouterState.of(context).extra as Map<String, dynamic>;
      var trans = extras['trans'];
      ref
          .read(mobileBindCheckCodeStateNotifierProvider.notifier)
          .updateData(trans);
    });
  }

  @override
  void dispose() {
    super.dispose();
    pinController.dispose();
  }

  @override
  String get centerTitle => 'mine_phone_number'.tr();

  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20).withRTL(context),
      child: Column(
        children: [
          // Text('bind_signin_phone_code'.tr()),
          Align(
            alignment: Alignment.centerLeft.withRTL(context),
            child: Wrap(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: ref.watch(
                          mobileBindCheckCodeStateNotifierProvider
                              .select((value) => value.sourceWayText ?? ''),
                        ),
                      ),
                      TextSpan(
                        text: ref.watch(mobileBindCheckCodeStateNotifierProvider
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
                bool enable = ref.watch(mobileBindCheckCodeStateNotifierProvider
                    .select((value) => value.enableSend));
                if (enable) {
                  notifier.resetCode(context);
                }
              },
              child: Text(
                ref.watch(mobileBindCheckCodeStateNotifierProvider
                    .select((value) => value.sendButtonText)),
                style: ref.watch(mobileBindCheckCodeStateNotifierProvider
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
            enable: ref.watch(mobileBindCheckCodeStateNotifierProvider
                .select((value) => value.enableNext)),
            text: 'bind'.tr(),
            onClickCallback: () async {
              await notifier.checkCode();
              // notifier.pushBack();
            },
          ),
        ],
      ),
    );
  }
}
