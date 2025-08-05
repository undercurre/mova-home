import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_helper.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/widgets/pincode/pair_net_pincode_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:flutter_plugin/ui/widget/dm_pincode_text_field.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PairNetPinCodeWidget extends ConsumerStatefulWidget {
  PairNetPinCodeWidget(/*this.onConfirm, */ {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PairNetPinCodeWidgetState();
  }
}

class PairNetPinCodeWidgetState extends ConsumerState<PairNetPinCodeWidget>
    with CommonDialog {
  final GlobalKey<DmPincodeTextFieldState> _globalKey =
      GlobalKey(debugLabel: 'pincode');

  void listenpairConnectStateNotifierProvider() {
    ref.listen(
        pairConnectStateNotifierProvider.select((value) => value.showPinCode),
        (previous, next) async {
      ///
    });
    ref.listen(
        pairConnectStateNotifierProvider
            .select((value) => Pair(value.pinCodeStatus, value.remain)),
        (previous, next) async {
      if (next.first == WHAT_PINCODE_ERROR) {
        // show aleart
        final remain = ref.read(
            pairConnectStateNotifierProvider.select((value) => value.remain));
        showInputErrorAlert(remain);
      } else if (next.first == WHAT_PINCODE_LOCK) {
        final remain = ref.read(
            pairConnectStateNotifierProvider.select((value) => value.remain));

        ref
            .read(pairNetPinCodeStateNotifierProvider.notifier)
            .updateRemainingTime(remain);
        showInputLockAlert(remain);
      }
    });
    ref.listen(pairNetPinCodeStateNotifierProvider, (previous, next) async {});
  }

  void showInputErrorAlert(int remain) {
    showConfirmDialog(
        content: 'text_pincode_invalid_and_retry'.tr(),
        confirmContent: 'know'.tr(),
        confirmCallback: () {
          // 什么都不做
          _globalKey.currentState?.pinController.text = '';
          ref
              .read(pairNetPinCodeStateNotifierProvider.notifier)
              .updatePinCode('');
        });
  }

  void showInputLockAlert(int remain) {
    var showTime = '';
    if (remain > 60) {
      showTime = '${remain ~/ 60}min';
    } else {
      showTime = '${remain}s';
    }
    final content = 'text_max_attempts_try_later'.tr(args: [showTime]);
    showConfirmDialog(
        content: content,
        confirmContent: 'know'.tr(),
        confirmCallback: () {
          // 什么都不做
          _globalKey.currentState?.pinController.text = '';
          ref
              .read(pairNetPinCodeStateNotifierProvider.notifier)
              .updatePinCode('');
        });
  }

  @override
  Widget build(BuildContext context) {
    listenpairConnectStateNotifierProvider();
    final remainingTime = ref.watch(pairNetPinCodeStateNotifierProvider
        .select((value) => value.remainingTime));
    final showTime = ref.watch(
        pairNetPinCodeStateNotifierProvider.select((value) => value.showTime));
    return ThemeWidget(builder: (context, style, resource) {
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
                            fontSize: style.middleText,
                            color: style.textSecond),
                        content:
                            'text_max_attempts_try_later'.tr(args: [showTime]),
                        indexs: [showTime],
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
                  key: _globalKey,
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
                        .read(pairNetPinCodeStateNotifierProvider.notifier)
                        .updatePinCode(number);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: DMCommonClickButton(
                backgroundGradient: style.confirmBtnGradient,
                disableBackgroundGradient: style.disableBtnGradient,
                disableTextColor: style.disableBtnTextColor,
                textColor: style.confirmBtnTextColor,
                borderRadius: style.buttonBorder,
                enable: ref.watch(pairNetPinCodeStateNotifierProvider
                    .select((value) => value.enableBtn)),
                text: 'confirm'.tr(),
                onClickCallback: () async {
                  // 点击输入
                  final pinCode = ref.watch(pairNetPinCodeStateNotifierProvider
                      .select((value) => value.pincode));
                  // widget.onConfirm(ref.watch(pairNetPinCodeStateNotifierProvider
                  //     .select((value) => value.pincode)));
                  LogUtils.i('-----BLE------ click confirm pincode: $pinCode');
                  showLoading();
                  SmartStepHelper().handleMessage(SmartStepEvent(
                      StepName.STEP_PIN_CODE,
                      what: WHAT_PINCODE_INPUT,
                      obj: pinCode));
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
