import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

enum GuideStep { step1, step2, step3, step4 }

///所有成员变量非必须
abstract class BaseDeviceGuideDialog {
  Triple<String, String, String>? provideTitleDescOrders;
  String? provideImageRes;
  bool? lastStep;

  //引导页布局方向需要外部传入，根据外部布局方向定义
  bool? rtl;
  VoidCallback? nextStepCallback;
  VoidCallback? skipCallback;
  VoidCallback? finishCallback;

  BaseDeviceGuideDialog(
      {this.nextStepCallback,
      this.skipCallback,
      this.finishCallback,
      this.provideTitleDescOrders,
      this.provideImageRes,
      this.rtl,
      this.lastStep});

  void show() {
    SmartDialog.show(
        keepSingle: true,
        backDismiss: false,
        clickMaskDismiss: false,
        animationType: SmartAnimationType.fade,
        builder: (context) {
          return buildBody();
        });
  }

  void dismiss() {
    SmartDialog.dismiss();
  }

  ThemeWidget buildBody();

  Widget buildContent(BuildContext context,
      {required StyleModel style,
      required ResourceModel resource,
      double? maxWidth}) {
    maxWidth = maxWidth ?? 270;
    String title = provideTitleDescOrders!.first;
    String desc = provideTitleDescOrders!.second;
    String order = provideTitleDescOrders!.third;
    return ThemeWidget(
      builder: (_, style, resource) {
        return Container(
          margin: const EdgeInsets.only(top: 8).withRTL(_),
          constraints: BoxConstraints(maxWidth: maxWidth!),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: style.bgWhite),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  resource.getResource(provideImageRes!),
                  width: 100,
                  height: 146,
                ).withDynamic(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12).withRTL(_),
                child: RichText(
                    text: TextSpan(
                        text: title,
                        style: TextStyle(
                            color: style.textMain,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        children: [
                      WidgetSpan(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 5).withRTL(_),
                            child: Text(
                              order,
                              style: TextStyle(
                                  fontSize: 12, color: style.textMain),
                            )),
                      )
                    ])),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 30).withRTL(_),
                  child: Text(
                    desc,
                    style: TextStyle(
                        height: 1.3,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: style.textSecond),
                  )),
              Visibility(
                  visible: lastStep == true,
                  child: DMButton(
                    onClickCallback: (_) {
                      dismiss();
                      finishCallback?.call();
                    },
                    text: 'text_i_know'.tr(),
                    backgroundGradient: style.confirmBtnGradient,
                    borderRadius: 80,
                    textColor: style.btnText,
                    fontsize: 14,
                    width: double.infinity,
                    fontWidget: FontWeight.w500,
                    height: 40,
                  )),
              Visibility(
                visible: lastStep == false,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: DMButton(
                          onClickCallback: (_) {
                            dismiss();
                            skipCallback?.call();
                          },
                          text: 'Text_3rdPartyBundle_BundlePage_Skip'.tr(),
                          borderRadius: 80,
                          fontsize: 14,
                          textColor: style.cancelBtnTextColor,
                          backgroundGradient: style.cancelBtnGradient,
                          width: double.infinity,
                          fontWidget: FontWeight.w500,
                          height: 40,
                        )),
                    // const Spacer(),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: DMButton(
                          onClickCallback: (_) => nextStepCallback?.call(),
                          text: 'next'.tr(),
                          backgroundGradient: style.confirmBtnGradient,
                          borderRadius: 80,
                          textColor: style.btnText,
                          fontsize: 14,
                          width: double.infinity,
                          fontWidget: FontWeight.w500,
                          height: 40,
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
