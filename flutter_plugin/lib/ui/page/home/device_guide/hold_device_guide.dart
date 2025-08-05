import 'dart:ui';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'action/device_guide_action.dart';

class HoldDeviceGuide extends DeviceGuideAction {
  final List<String> titleHold = [
    'text_guide_step_1_title'.tr(),
    'text_self_cleaning_start'.tr(),
    'text_drying_start'.tr()
  ];
  final List<String> descHold = [
    'text_guide_step_1_desc_v2'.tr(),
    'text_guide_step_2_desc_hold'.tr(),
    'text_guide_step_3_desc_hold'.tr(),
  ];
  final List<String> _imageResHold = [
    'ic_home_step_1',
    'ic_home_step_2_hold',
    'ic_home_step_3_hold',
  ];

  final List<String> _headerControlBtnImgResHold = [
    'ic_home_btn_self_clean',
    'ic_home_btn_dry',
  ];

  final List<String> titleHoldHot = [
    'text_guide_step_1_title'.tr(),
    'text_guide_step_2_title_hold_hot'.tr(),
    'text_guide_step_3_title_hold_hot'.tr()
  ];
  final List<String> descHoldHot = [
    'text_guide_step_1_desc_v2'.tr(),
    'text_guide_step_2_desc_hold_hot'.tr(),
    'text_guide_step_3_desc_hold_hot'.tr(),
  ];
  final List<String> _imageResHoldHot = [
    'ic_home_step_1',
    'ic_home_step_2_hold',
    'ic_home_step_3_hold_hot',
  ];
  final List<String> _headerControlBtnImgResHoldHot = [
    'ic_home_btn_self_clean',
    'ic_home_btn_self_clean_deep',
  ];

  HoldDeviceGuide(
      {required super.rtl,
      required super.holdActionType,
      super.skipCallback,
      required super.nextCallback}) {
    super.stepCount = titleHold.length;
    super.deviceType = DeviceType.hold;
  }

  @override
  void showStep(
      {GuideStep? guideStep = GuideStep.step1, Offset? offset, Size? size}) {
    baseShowStep(guideStep: guideStep, offset: offset, size: size);
  }

  @override
  Triple<String, String, String> provideTitleDescOrders(GuideStep step) {
    final third = rtl!
        ? '($stepCount/${step.index + 1})'
        : '(${step.index + 1}/$stepCount)';

    switch (holdActionType!) {
      case HoldActionType.cleanDry:
        return Triple(titleHold[step.index], descHold[step.index], third);
      case HoldActionType.cleanDeepClean:
        return Triple(titleHoldHot[step.index], descHoldHot[step.index], third);
    }
  }

  @override
  String provideImageRes(GuideStep step) {
    switch (holdActionType!) {
      case HoldActionType.cleanDry:
        return _imageResHold[step.index];
      case HoldActionType.cleanDeepClean:
        return _imageResHoldHot[step.index];
    }
  }

  @override
  bool provideLastStep(GuideStep step) {
    return step.index == stepCount! - 1;
  }

  @override
  String provideHeaderControlBtnImgRes(GuideStep step) {
    switch (holdActionType!) {
      case HoldActionType.cleanDry:
        return _headerControlBtnImgResHold[step.index - 1];
      case HoldActionType.cleanDeepClean:
        return _headerControlBtnImgResHoldHot[step.index - 1];
    }
  }
}
