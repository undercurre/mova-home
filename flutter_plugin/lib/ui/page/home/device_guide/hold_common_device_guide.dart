import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/page/home/device_guide/hold_device_guide.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';

class HoldCommonDeviceGuide extends HoldDeviceGuide {
  CommonBtnProtolModel? btnProtool;

  HoldCommonDeviceGuide(
      {required super.rtl,
      required super.holdActionType,
      required super.nextCallback,
      super.skipCallback,
      this.btnProtool});

  @override
  String provideHeaderControlBtnImgRes(GuideStep step) {
    if (btnProtool != null) {
      String? headerControlBtnImgRes;
      if (step == GuideStep.step2) {
        headerControlBtnImgRes = 'ic_home_btn_self_clean';
        if (btnProtool?.leftWorkMode == 0) {
          headerControlBtnImgRes = 'ic_home_btn_dry';
        } else if (btnProtool?.leftWorkMode == 1 ||
            btnProtool?.leftWorkMode == 2) {
          headerControlBtnImgRes = 'ic_home_btn_self_clean';
        } else if (btnProtool?.leftWorkMode == 3) {
          headerControlBtnImgRes = 'ic_home_btn_self_clean_deep';
        } else if (btnProtool?.leftWorkMode == 4 ||
            btnProtool?.leftWorkMode == 5 ||
            btnProtool?.leftWorkMode == 6) {
          headerControlBtnImgRes = 'ic_home_btn_hold_mode_4_5';
        }
      } else if (step == GuideStep.step3) {
        headerControlBtnImgRes = 'ic_home_btn_dry';
        if (btnProtool?.rightWorkMode == 0) {
          headerControlBtnImgRes = 'ic_home_btn_dry';
        } else if (btnProtool?.rightWorkMode == 1 ||
            btnProtool?.rightWorkMode == 2) {
          headerControlBtnImgRes = 'ic_home_btn_self_clean';
        } else if (btnProtool?.rightWorkMode == 3) {
          headerControlBtnImgRes = 'ic_home_btn_self_clean_deep';
        } else if (btnProtool?.rightWorkMode == 4 ||
            btnProtool?.rightWorkMode == 5 ||
            btnProtool?.rightWorkMode == 6) {
          headerControlBtnImgRes = 'ic_home_btn_hold_mode_4_5';
        }
      }
      return headerControlBtnImgRes!;
    } else {
      return super.provideHeaderControlBtnImgRes(step);
    }
  }

  @override
  Triple<String, String, String> provideTitleDescOrders(GuideStep step) {
    if (btnProtool != null) {
      Triple<String, String, String>? strRes;
      final third = rtl!
          ? '($stepCount/${step.index + 1})'
          : '(${step.index + 1}/$stepCount)';
      if (step == GuideStep.step2) {
        if (btnProtool?.leftWorkMode == 0) {
          strRes = Triple(titleHold[2], descHold[2], third);
        } else if (btnProtool?.leftWorkMode == 1) {
          strRes = Triple(titleHold[1], descHold[1], third);
        } else if (btnProtool?.leftWorkMode == 2) {
          strRes = Triple(titleHoldHot[1], descHoldHot[1], third);
        } else if (btnProtool?.leftWorkMode == 3) {
          strRes = Triple(titleHoldHot[2], descHoldHot[2], third);
        } else if (btnProtool?.leftWorkMode == 4 ||
            btnProtool?.leftWorkMode == 5) {
          strRes = Triple(titleHold[1], descHold[1], third);
        }
      } else if (step == GuideStep.step3) {
        if (btnProtool?.rightWorkMode == 0) {
          strRes = Triple(titleHold[2], descHold[2], third);
        } else if (btnProtool?.rightWorkMode == 1) {
          strRes = Triple(titleHold[1], descHold[1], third);
        } else if (btnProtool?.rightWorkMode == 2) {
          strRes = Triple(titleHoldHot[1], descHoldHot[1], third);
        } else if (btnProtool?.rightWorkMode == 3) {
          strRes = Triple(titleHoldHot[2], descHoldHot[2], third);
        } else if (btnProtool?.rightWorkMode == 4 ||
            btnProtool?.rightWorkMode == 5) {
          strRes = Triple(titleHold[1], descHold[1], third);
        }
      }
      return strRes!;
    } else {
      return super.provideTitleDescOrders(step);
    }
  }
}
