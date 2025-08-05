import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_status.dart';

import 'step_event.dart';

/// 设计的想法是：每一个步骤配一个ID，一个依赖List,如果依赖List执行成功，则执行它，
/// 失败则跳过
class CommonStep {
  ///当前stepId
  final StepId stepId;
  StepResultStatus resultStatus = StepResultStatus.none;
  StepRunningStatus runningStatus = StepRunningStatus.none;

  /// 依赖的StepId列表
  final List<StepId> dependenceStepIds;

  /// 记录step next走进来的次数
  var enterCount = 0;

  CommonStep({
    required this.stepId,
    this.dependenceStepIds = const [],
  });

  Future<StepResult> next(CommonStepChain chain, StepEvent event) async {
    return chain.proceed(event, next: true);
  }

  void onStepStart(CommonStepChain chain, StepEvent event) {
    runningStatus = StepRunningStatus.start;
  }

  void onStepStop(CommonStepChain chain) {
    runningStatus = StepRunningStatus.stop;
  }

  void dispose(CommonStepChain chain) {
    runningStatus = StepRunningStatus.complete;
  }
}
