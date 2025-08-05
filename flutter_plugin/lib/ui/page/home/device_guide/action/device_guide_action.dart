import 'dart:ui';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/device_guide_step_first_dialog.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/device_guide_step_four_dialog.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/device_guide_step_second_dialog.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/device_guide_step_third_dialog.dart';

typedef Callback = void Function(
    {required DeviceType deviceType, HoldActionType? holdActionType});

///用于后续第二三步传递弹窗元素的偏移量，避免页面初始化时获取的偏移量不准确
typedef NextStepSendArgument = Function(
    {required GuideStep step, Offset? offset, Size? size});
typedef NextCallback = Function(
    {required GuideStep step, NextStepSendArgument? nextStepSendArgument});

abstract class DeviceGuideAction {
  Offset? titleOffset;
  bool? rtl;
  DeviceType? deviceType;
  Callback? skipCallback;
  NextCallback? nextCallback;
  int? stepCount;
  HoldActionType? holdActionType;

  DeviceGuideAction(
      {this.titleOffset,
      this.rtl,
      this.deviceType,
      this.stepCount,
      this.holdActionType,
      this.skipCallback,
      this.nextCallback});

  void showStep({GuideStep? guideStep}) {}

  Triple<String, String, String>? provideTitleDescOrders(GuideStep step) {
    return null;
  }

  bool provideLastStep(GuideStep step) {
    return false;
  }

  String provideImageRes(GuideStep step) {
    return '';
  }

  String provideHeaderControlBtnImgRes(GuideStep step) {
    return '';
  }

  void baseShowStep({GuideStep? guideStep, Offset? offset, Size? size}) {
    switch (guideStep) {
      case GuideStep.step1:
        DeviceGuideStepFirstDialog(
            titleOffset: titleOffset!,
            provideTitleDescOrders: provideTitleDescOrders(GuideStep.step1),
            provideImageRes: provideImageRes(GuideStep.step1),
            lastStep: provideLastStep(GuideStep.step1),
            rtl: rtl!,
            skipCallback: () {
              skipCallback?.call(
                  deviceType: deviceType!, holdActionType: holdActionType);
            },
            nextStepCallback: () {
              nextCallback?.call(
                  step: GuideStep.step2, nextStepSendArgument: _nextStep);
            },
            finishCallback: () {
              skipCallback?.call(
                  deviceType: deviceType!, holdActionType: holdActionType);
            }).show();
        break;
      case GuideStep.step2:
        DeviceGuideStepSecondDialog(
            offset: offset!,
            size: size!,
            provideTitleDescOrders: provideTitleDescOrders(GuideStep.step2),
            provideImageRes: provideImageRes(GuideStep.step2),
            lastStep: provideLastStep(GuideStep.step2),
            rtl: rtl!,
            headerControlBtnImgRes:
                provideHeaderControlBtnImgRes(GuideStep.step2),
            skipCallback: () {
              skipCallback?.call(
                  deviceType: deviceType!, holdActionType: holdActionType);
            },
            nextStepCallback: () {
              nextCallback?.call(
                  step: GuideStep.step3, nextStepSendArgument: _nextStep);
            },
            finishCallback: () {
              skipCallback?.call(
                  deviceType: deviceType!, holdActionType: holdActionType);
            }).show();
        break;
      case GuideStep.step3:
        DeviceGuideStepThirdDialog(
            offset: offset!,
            size: size!,
            provideTitleDescOrders: provideTitleDescOrders(GuideStep.step3),
            provideImageRes: provideImageRes(GuideStep.step3),
            lastStep: provideLastStep(GuideStep.step3),
            rtl: rtl!,
            headerControlBtnImgRes:
                provideHeaderControlBtnImgRes(GuideStep.step3),
            skipCallback: () {
              skipCallback?.call(
                  deviceType: deviceType!, holdActionType: holdActionType);
            },
            nextStepCallback: () {
              nextCallback?.call(
                  step: GuideStep.step4, nextStepSendArgument: _nextStep);
            },
            finishCallback: () {
              skipCallback?.call(
                  deviceType: deviceType!, holdActionType: holdActionType);
            }).show();
        break;
      case GuideStep.step4:
        DeviceGuideStepFourDialog(
            offset: offset!,
            provideTitleDescOrders: provideTitleDescOrders(GuideStep.step4),
            provideImageRes: provideImageRes(GuideStep.step4),
            lastStep: provideLastStep(GuideStep.step4),
            rtl: rtl!,
            finishCallback: () {
              skipCallback?.call(
                  deviceType: deviceType!, holdActionType: holdActionType);
            }).show();
        break;
      default:
    }
  }

  ///执行弹窗下一步时由外部传递偏移量调用
  void _nextStep({required GuideStep step, Offset? offset, Size? size}) {
    baseShowStep(guideStep: step, offset: offset, size: size);
  }
}
