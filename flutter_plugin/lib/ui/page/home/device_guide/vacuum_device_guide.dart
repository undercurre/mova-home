import 'dart:ui';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/page/home/home_guide_manager.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'action/device_guide_action.dart';

class VacuumDeviceGuide extends DeviceGuideAction {
  final List<String> _titleVacuum = [
    'text_more_operate'.tr(),
    'home_device_clean_start_new'.tr(),
    'home_device_charge_start'.tr(),
    'text_home_fast_command'.tr()
  ];
  final List<String> _descVacuum = [
    'text_guide_step_1_desc_v2'.tr(),
    'text_guide_step_2_desc_v2'.tr(),
    'text_guide_step_3_desc'.tr(),
    'text_guide_step_4_desc'.tr()
  ];
  final List<String> _imageResVacuum = [
    'ic_home_step_1',
    'ic_home_step_2',
    'ic_home_step_3',
    'ic_home_step_4'
  ];
  final List<String> _headerControlBtnImgResVacuum = [
    'ic_home_btn_clean',
    'ic_home_btn_charge',
  ];
  bool supportFastCommand;

  VacuumDeviceGuide(
      {required super.rtl,
      required this.supportFastCommand,
      super.skipCallback,
      required super.nextCallback}) {
    super.stepCount = supportFastCommand ? _titleVacuum.length : 3;
    super.deviceType = DeviceType.vacuum;
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
    return Triple(_titleVacuum[step.index], _descVacuum[step.index], third);
  }

  @override
  String provideImageRes(GuideStep step) {
    return _imageResVacuum[step.index];
  }

  @override
  bool provideLastStep(GuideStep step) {
    return step.index == stepCount! - 1;
  }

  @override
  String provideHeaderControlBtnImgRes(GuideStep step) {
    return _headerControlBtnImgResVacuum[step.index - 1];
  }
}
