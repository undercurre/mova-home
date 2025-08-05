import 'dart:ui';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/page/home/home_guide_manager.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'action/device_guide_action.dart';

class MowerDeviceGuide extends DeviceGuideAction {
  final List<String> _titleMower = [
    'text_guide_step_1_title'.tr(),
    'text_mower_start'.tr(),
    'text_back_station'.tr()
  ];
  final List<String> _descMower = [
    'text_guide_step_1_desc_v2'.tr(),
    'text_guide_step_2_desc_mower'.tr(),
    'text_guide_step_3_desc_mower'.tr()
  ];
  final List<String> _imageResMower = [
    'ic_home_step_1',
    'ic_home_step_2',
    'ic_home_step_3_mower'
  ];
  final List<String> _headerControlBtnImgResMower = [
    'ic_home_btn_clean',
    'ic_home_btn_mower_charge',
  ];

  MowerDeviceGuide(
      {required super.rtl, super.skipCallback, required super.nextCallback}) {
    super.stepCount = _titleMower.length;
    super.deviceType = DeviceType.mower;
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
    return Triple(_titleMower[step.index], _descMower[step.index], third);
  }

  @override
  String provideImageRes(GuideStep step) {
    return _imageResMower[step.index];
  }

  @override
  bool provideLastStep(GuideStep step) {
    return step.index == stepCount! - 1;
  }

  @override
  String provideHeaderControlBtnImgRes(GuideStep step) {
    return _headerControlBtnImgResMower[step.index - 1];
  }
}
