import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

import '../../widget/dialog/device_guide/base_device_guide_dialog.dart';

class HomeGuideManager {
  HomeGuideManager._internal();
  factory HomeGuideManager() => _instance;
  static final HomeGuideManager _instance = HomeGuideManager._internal();

  final titleVacuum = [
    'text_more_operate'.tr(),
    'home_device_clean_start_new'.tr(),
    'home_device_charge_start'.tr(),
    'text_home_fast_command'.tr()
  ];
  final titleHold = [
    'text_guide_step_1_title'.tr(),
    'text_self_cleaning_start'.tr(),
    'text_drying_start'.tr()
  ];
  final titleHoldHot = [
    'text_guide_step_1_title'.tr(),
    'text_guide_step_2_title_hold_hot'.tr(),
    'text_guide_step_3_title_hold_hot'.tr()
  ];
  final titleMower = [
    'text_guide_step_1_title'.tr(),
    'text_mower_start'.tr(),
    'text_back_station'.tr()
  ];
  final descVacuum = [
    'text_guide_step_1_desc_v2'.tr(),
    'text_guide_step_2_desc_v2'.tr(),
    'text_guide_step_3_desc'.tr(),
    'text_guide_step_4_desc'.tr()
  ];

  final descHold = [
    'text_guide_step_1_desc_v2'.tr(),
    'text_guide_step_2_desc_hold'.tr(),
    'text_guide_step_3_desc_hold'.tr(),
  ];
  final descHoldHot = [
    'text_guide_step_1_desc_v2'.tr(),
    'text_guide_step_2_desc_hold_hot'.tr(),
    'text_guide_step_3_desc_hold_hot'.tr(),
  ];
  final descMower = [
    'text_guide_step_1_desc_v2'.tr(),
    'text_guide_step_2_desc_mower'.tr(),
    'text_guide_step_3_desc_mower'.tr()
  ];

  int _stepCount = 0;
  bool _rtl = false;
  DeviceType _deviceType = DeviceType.vacuum;
  HoldActionType _holdActionType = HoldActionType.cleanDry;

  void showGuideStep1({
    required bool supportFastCommand,
    required Offset titleOffset,
    required DeviceType deviceType,
    required bool rtl,
    required HoldActionType holdActionType,
    VoidCallback? nextStepCallback,
    VoidCallback? skipCallback,
  }) {
    _rtl = rtl;
    _deviceType = deviceType;
    _holdActionType = holdActionType;
    var titleTop = titleOffset.dy + 25;
    if (deviceType == DeviceType.vacuum) {
      if (supportFastCommand) {
        _stepCount = titleVacuum.length;
      } else {
        _stepCount = 3;
      }
    } else if (deviceType == DeviceType.hold) {
      _stepCount = titleHold.length;
    } else if (deviceType == DeviceType.mower) {
      _stepCount = titleMower.length;
    }

    SmartDialog.show(
        keepSingle: true,
        backDismiss: false,
        clickMaskDismiss: false,
        animationType: SmartAnimationType.fade,
        builder: (ctx) {
          return ThemeWidget(builder: (context, style, resource) {
            return Stack(
              children: _rtl
                  ? [
                      Positioned(
                        top: titleOffset.dy - 8,
                        left: 12,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: style.bgWhite),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                resource.getResource('ic_home_more'),
                                width: 24,
                                height: 24,
                              ).withDynamic()
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 21,
                        top: titleTop + 20,
                        child: Image.asset(
                          resource.getResource('ic_home_step_arrow'),
                          width: 30,
                          height: 21,
                          color: style.bgWhite,
                        ).withDynamic(),
                      ),
                      Positioned(
                          left: 20,
                          top: titleTop + 21,
                          child: _buildContent(context, GuideStep.step1,
                              style: style,
                              resource: resource,
                              nextCallback: nextStepCallback,
                              skipCallback: skipCallback))
                    ]
                  : [
                      Positioned(
                        top: titleOffset.dy - 8,
                        right: 12,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: style.bgWhite),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                resource.getResource('ic_home_more'),
                                width: 24,
                                height: 24,
                              ).withDynamic()
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 21,
                        top: titleTop + 20,
                        child: Image.asset(
                          resource.getResource('ic_home_step_arrow'),
                          width: 30,
                          height: 21,
                          color: style.bgWhite,
                        ).withDynamic(),
                      ),
                      Positioned(
                          right: 20,
                          top: titleTop + 21,
                          child: _buildContent(context, GuideStep.step1,
                              style: style,
                              resource: resource,
                              nextCallback: nextStepCallback,
                              skipCallback: skipCallback))
                    ],
            );
          });
        });
  }

  void showGuide(Offset offset, Size size,
      {Posi posi = Posi.left,
      GuideStep step = GuideStep.step1,
      VoidCallback? nextStepCallback,
      VoidCallback? skipCallback,
      VoidCallback? finishCallback}) {
    double arrowLeft = size.width + offset.dx - 15;
    if (_rtl) {
      arrowLeft = offset.dx + size.width / 2 - 15;
    }
    if (step != GuideStep.step1) {
      arrowLeft = offset.dx + size.width / 2 - 15;
    }
    SmartDialog.show(
        keepSingle: true,
        backDismiss: false,
        clickMaskDismiss: false,
        animationType: SmartAnimationType.fade,
        builder: (ctx) {
          return ThemeWidget(builder: (context, style, resource) {
            return Stack(
              children: [
                Positioned(
                  left: offset.dx -
                      (step == GuideStep.step1 ? (_rtl ? 24 : 0) : 0),
                  top: offset.dy - size.height,
                  child: _buildHeader(step),
                ),
                Positioned(
                  left: arrowLeft,
                  top: offset.dy + 20,
                  child: Image.asset(
                    resource.getResource('ic_home_step_arrow'),
                    width: 30,
                    height: 21,
                    color: style.bgWhite,
                  ).withDynamic(),
                ),
                posi == Posi.left
                    ? Positioned(
                        left: 36,
                        top: offset.dy + 21,
                        child: _buildContent(context, step,
                            style: style,
                            resource: resource,
                            nextCallback: nextStepCallback,
                            skipCallback: skipCallback,
                            finishCallback: finishCallback),
                      )
                    : Positioned(
                        right: 24,
                        top: offset.dy + 21,
                        child: _buildContent(context, step,
                            style: style,
                            resource: resource,
                            nextCallback: nextStepCallback,
                            skipCallback: skipCallback,
                            finishCallback: finishCallback),
                      ),
              ],
            );
          });
        });
  }

  void showGuideStep4(Offset offset, {VoidCallback? finishCallback}) {
    SmartDialog.show(
        keepSingle: true,
        backDismiss: false,
        clickMaskDismiss: false,
        animationType: SmartAnimationType.fade,
        builder: (ctx) {
          return ThemeWidget(builder: (context, style, resource) {
            return Stack(
                children: _rtl
                    ? [
                        Positioned(
                            top: offset.dy - 44,
                            left: 0,
                            child: Container(
                              height: 44,
                              width: 64,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: _rtl
                                      ? const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12))
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12))),
                              child: Center(
                                child: Image.asset(
                                        width: 30,
                                        height: 24,
                                        resource
                                            .getResource('ic_home_fast_cmd'))
                                    .withDynamic(),
                              ),
                            )),
                        Positioned(
                          left: 64,
                          top: offset.dy - 30,
                          child: Image.asset(
                                  resource
                                      .getResource('ic_home_step_arrow_right'),
                                  width: 30,
                                  height: 21,
                                  color: style.bgWhite)
                              .withDynamic()
                              .flipWithRTL(context),
                        ),
                        Positioned(
                            left: 80,
                            top: offset.dy - 100,
                            child: _buildContent(context, GuideStep.step4,
                                style: style,
                                resource: resource,
                                finishCallback: finishCallback))
                      ]
                    : [
                        Positioned(
                            top: offset.dy - 44,
                            right: 0,
                            child: Container(
                              height: 44,
                              width: 64,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: _rtl
                                      ? const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12))
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12))),
                              child: Center(
                                child: Image.asset(
                                        width: 30,
                                        height: 24,
                                        resource
                                            .getResource('ic_home_fast_cmd'))
                                    .withDynamic(),
                              ),
                            )),
                        Positioned(
                          right: 64,
                          top: offset.dy - 30,
                          child: Image.asset(
                            resource.getResource('ic_home_step_arrow_right'),
                            width: 30,
                            height: 21,
                            color: style.bgWhite,
                          ).withDynamic(),
                        ),
                        Positioned(
                            right: 80,
                            top: offset.dy - 100,
                            child: _buildContent(context, GuideStep.step4,
                                style: style,
                                resource: resource,
                                finishCallback: finishCallback))
                      ]);
          });
        });
  }

  Widget _buildHeader(GuideStep step) {
    return ThemeWidget(builder: (context, style, resource) {
      if (step == GuideStep.step2) {
        String image = 'ic_home_btn_clean';
        if (_deviceType == DeviceType.vacuum) {
          image = 'ic_home_btn_clean';
        } else if (_deviceType == DeviceType.hold) {
          image = 'ic_home_btn_self_clean';
        } else if (_deviceType == DeviceType.mower) {
          image = 'ic_home_btn_clean';
        }
        return Image.asset(
          resource.getResource(image),
          width: 64,
          height: 64,
        ).withDynamic();
      } else {
        String image = 'ic_home_btn_charge';
        if (_deviceType == DeviceType.vacuum) {
          image = 'ic_home_btn_charge';
        } else if (_deviceType == DeviceType.hold) {
          if (_holdActionType == HoldActionType.cleanDry) {
            image = 'ic_home_btn_dry';
          } else if (_holdActionType == HoldActionType.cleanDeepClean) {
            image = 'ic_home_btn_self_clean_deep';
          }
        } else if (_deviceType == DeviceType.mower) {
          image = 'ic_home_btn_mower_charge';
        }
        return Image.asset(resource.getResource(image), width: 64, height: 64)
            .withDynamic();
      }
    });
  }

  Widget _buildContent(BuildContext context, GuideStep step,
      {required StyleModel style,
      required ResourceModel resource,
      VoidCallback? nextCallback,
      VoidCallback? skipCallback,
      VoidCallback? finishCallback}) {
    bool lastStep = step.index == _stepCount - 1;
    var stepImage = 'ic_home_step_1';
    if (step == GuideStep.step2) {
      if (_deviceType == DeviceType.vacuum) {
        stepImage = 'ic_home_step_2';
      } else if (_deviceType == DeviceType.hold) {
        stepImage = 'ic_home_step_2_hold';
      } else if (_deviceType == DeviceType.mower) {
        stepImage = 'ic_home_step_2';
      }
    } else if (step == GuideStep.step3) {
      if (_deviceType == DeviceType.vacuum) {
        stepImage = 'ic_home_step_3';
      } else if (_deviceType == DeviceType.hold) {
        if (_holdActionType == HoldActionType.cleanDry) {
          stepImage = 'ic_home_step_3_hold';
        } else if (_holdActionType == HoldActionType.cleanDeepClean) {
          stepImage = 'ic_home_step_3_hold_hot';
        }
      } else if (_deviceType == DeviceType.mower) {
        stepImage = 'ic_home_step_3_mower';
      }
    } else if (step == GuideStep.step4) {
      if (_deviceType == DeviceType.vacuum) {
        stepImage = 'ic_home_step_4';
      } else {
        return const SizedBox();
      }
    }
    String title = '';
    String desc = '';
    if (_deviceType == DeviceType.vacuum) {
      title = titleVacuum[step.index];
      desc = descVacuum[step.index];
    } else if (_deviceType == DeviceType.hold) {
      if (_holdActionType == HoldActionType.cleanDry) {
        title = titleHold[step.index];
        desc = descHold[step.index];
      } else if (_holdActionType == HoldActionType.cleanDeepClean) {
        title = titleHoldHot[step.index];
        desc = descHoldHot[step.index];
      }
    } else if (_deviceType == DeviceType.mower) {
      title = titleMower[step.index];
      desc = descMower[step.index];
    }
    double maxWidth = 270;
    if (step == GuideStep.step4) {
      maxWidth = MediaQuery.of(context).size.width - 100;
      if (maxWidth > 270) {
        maxWidth = 270;
      }
    }
    return ThemeWidget(
      builder: (_, style, resource) {
        return Container(
          margin: const EdgeInsets.only(top: 8).withRTL(_),
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(style.circular8),
              color: style.bgWhite),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  resource.getResource(stepImage),
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
                              _rtl
                                  ? '($_stepCount/${step.index + 1})'
                                  : '(${step.index + 1}/$_stepCount)',
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
                  visible: lastStep,
                  child: DMButton(
                    onClickCallback: (_) => finishCallback?.call(),
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
                visible: !lastStep,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: DMButton(
                          onClickCallback: (_) {
                            SmartDialog.dismiss();
                            skipCallback?.call();
                          },
                          text: 'Text_3rdPartyBundle_BundlePage_Skip'.tr(),
                          backgroundColor: style.bgWhite,
                          borderRadius: 80,
                          fontsize: 14,
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
                          onClickCallback: (_) => nextCallback?.call(),
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

enum Posi { left, right }