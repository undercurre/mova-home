import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';

import 'common_step_chain.dart';

///
class BasicPermissionStep extends CommonStep with CommonDialog {
  /// 描述本步骤是否是必须的
  final bool isMustBe;

  /// 描述本步骤是否需要再次执行
  final bool isOnceAgain;

  BasicPermissionStep(
      {required super.stepId,
      this.isMustBe = true,
      this.isOnceAgain = false,
      super.dependenceStepIds = const []});

  void showRequestAndGotoSettingDialog(
      CommonStepChain chain, StepEvent event) {}
}
