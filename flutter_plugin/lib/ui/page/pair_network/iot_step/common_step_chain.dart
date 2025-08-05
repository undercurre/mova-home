import 'dart:async';
import 'dart:collection';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_status.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import 'common_step.dart';

typedef OnStepChange = void Function(CommonStep? prev, CommonStep? next);

class CommonStepChain {
  /// The list of steps
  final List<CommonStep> _steps = [];
  int _index = 0;

  StepId get firstStepId => _steps.firstOrNull?.stepId ?? StepId.STEP_NONE;

  StepId get currentStepId =>
      _steps.elementAtOrNull(_index)?.stepId ?? StepId.STEP_NONE;

  OnStepChange? onStepChange;

  /// 配置step列表
  CommonStepChain configureStepChain(List<CommonStep> steps) {
    _steps.clear();
    _steps.addAll(steps);
    return this;
  }

  /// chain 串行执行，强依赖关系，前一步失败，则整体失败，
  /// [event] 用于步骤间的数据传递
  /// 依赖关系是通过[dependenceStepIds]来定义的
  /// [next] 是否继续下一步，如果为true，则会执行下一步，否则只是执行当前步骤
  /// [success] 当前步骤是否成功
  /// [isDependence] 是否结束，默认结束，如果为false，则表示当前步骤失败，但是还可以继续判断下一步的依赖步骤如果完成，可以继续下一步
  /// 返回[StepResult]，表示当前步骤的执行结果
  Future<StepResult> proceed(StepEvent event,
      {bool next = false,
      bool success = true,
      bool isDependence = false}) async {
    //后续没有步骤了
    if (_steps.isEmpty) {
      return StepResult(
          stepId: StepId.STEP_NONE,
          success: true,
          isFinish: true,
          event: event,
          runningStatus: StepRunningStatus.none,
          resultStatus: StepResultStatus.none);
    }

    if (next) {
      _index++;
    }

    final preStep = _preStep(minus: next)?..onStepStop(this);
    final nextStep = _steps.elementAtOrNull(_index);
    preStep?.resultStatus =
        success == true ? StepResultStatus.success : StepResultStatus.failed;
    if (nextStep == null) {
      // 后续没有步骤了，结束了
      clearSteps();
      return StepResult(
          stepId: preStep?.stepId ?? StepId.STEP_NONE,
          success: success,
          isFinish: true,
          event: event,
          runningStatus: preStep?.runningStatus ?? StepRunningStatus.complete,
          resultStatus: preStep?.resultStatus ?? StepResultStatus.success);
    }
    LogUtils.i(
        '--> proceed: ${this}   ${event} ${preStep}  ${nextStep}  ${_index} ${_steps.length}');

    /// 需要判断依赖，如果依赖的步骤没有完成，则不能继续下一步
    final canGoToNextStep = success ||
        isDependence &&
            (nextStep.dependenceStepIds.isEmpty ||
                nextStep.dependenceStepIds.where((element) {
                  return event.resultStatus[element] !=
                      StepResultStatus.success;
                }).isEmpty);

    if (!canGoToNextStep) {
      clearSteps();
      return StepResult(
          stepId: preStep?.stepId ?? StepId.STEP_NONE,
          success: false,
          isFinish: true,
          event: event,
          runningStatus: preStep?.runningStatus ?? StepRunningStatus.complete,
          resultStatus: preStep?.resultStatus ?? StepResultStatus.success);
    }

    nextStep.onStepStart(this, event);
    if (preStep != null || nextStep != null) {
      onStepChange?.call(preStep, nextStep);
    }
    nextStep.runningStatus = StepRunningStatus.running;
    return nextStep.next(this, event);
  }

//减号
  CommonStep? _preStep({bool minus = true}) {
    var index = minus ? _index - 1 : _index;
    if (index >= 0) {
      var preStep = _steps.elementAtOrNull(index);
      return preStep;
    }
    return null;
  }

  void clearSteps() {
    _index = 0;
    for (var element in _steps) {
      element.dispose(this);
    }
    _steps.clear();
  }
}
