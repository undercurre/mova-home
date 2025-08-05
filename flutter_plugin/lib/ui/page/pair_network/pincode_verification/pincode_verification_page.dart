import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pincode_verification/pincode_verification_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:flutter_plugin/ui/widget/dm_pincode_text_field.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PincodeVerificationPage extends ConsumerStatefulWidget {
  static const String routePath = '/pincode_verification';

  const PincodeVerificationPage({super.key});

  @override
  PincodeVerificationPageState createState() {
    return PincodeVerificationPageState();
  }
}

class PincodeVerificationPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        pincodeVerificationStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  @override
  void initData() {
    super.initData();
    ref.read(pincodeVerificationStateNotifierProvider.notifier).initData();
  }

  @override
  String get centerTitle => 'text_verify_pincode'.tr();

  @override
  Widget get rightItemWidget => SizedBox(
        width: 60,
        height: 52,
        child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            ref.read(resourceModelProvider).getResource('ic_verify_pincode_tip'),
            width: 24,
            height: 24,
          ),
        ),
      ).onClick(() {});

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resourceModel) {
    final remainingTime = ref.watch(pincodeVerificationStateNotifierProvider
        .select((value) => value.remainingTime));
    return Container(
      color: style.bgWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: remainingTime > 0
                  ? DMFormatRichText(
                      normalTextStyle: TextStyle(
                          fontSize: style.middleText, color: style.textSecond),
                      content: 'text_max_attempts_try_later'
                          .tr(args: ['$remainingTime(s)']),
                      indexs: ['$remainingTime(s)'],
                      richCallback: (index, key, content) {})
                  : Text(
                      'text_input_your_pincode'.tr(),
                      style: TextStyle(
                        color: style.textSecond,
                        fontSize: style.middleText,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 50, bottom: 85).withRTL(context),
            child: DmPincodeTextField(
                length: 4,
                width: 48,
                height: 54,
                fontSize: style.input_number,
                fontWeight: FontWeight.w600,
                defaultTextColor: style.textNormal,
                defaultBorderColor: style.lightBlack1,
                focusedTextColor: style.textNormal,
                focusedBorderColor: style.normal,
                cursorColor: style.textSecond,
                onChanged: (number) {
                  ref
                      .read(pincodeVerificationStateNotifierProvider.notifier)
                      .updatePinCode(number);
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: DMCommonClickButton(
              disableBackgroundGradient: style.disableBtnGradient,
              disableTextColor: style.disableBtnTextColor,
              textColor: style.enableBtnTextColor,
              backgroundGradient: style.confirmBtnGradient,
              borderRadius: style.buttonBorder,
              enable: ref.watch(pincodeVerificationStateNotifierProvider
                  .select((value) => value.enableBtn)),
              text: 'confirm'.tr(),
              onClickCallback: () async {
                await ref
                    .read(pincodeVerificationStateNotifierProvider.notifier)
                    .verifyPinCode();
              },
            ),
          ),
        ],
      ),
    );
  }
}
