import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'iot_step_mixin.dart';
import 'smart_step_event.dart';

abstract class SmartStepConfigCallback {
  void nextStep(SmartStepConfig nextStep);

  void finish(bool success);

  void postEvent<T>(SmartStepEvent<T> event, {int delayMs = 0});

  SmartStepConfig? currentStep();
}

abstract class SmartStepConfig with IotStepMixin {
  SmartStepConfigCallback? stepConfigCallback;
  var stepRunning = true;

  void handleMessage(SmartStepEvent msg);

  late StepId stepId;

  void stepCreate();

  void stepResume() {}

  void stepPause() {}

  void stepDestroy();

  // @visibleForTesting
  void onStepDestroy() {
    stepRunning = false;
    stepDestroy();
  }

  void nextStep(SmartStepConfig nextStep) {
    if (stepRunning) {
      onStepDestroy();
      stepConfigCallback?.nextStep(nextStep);
    }
  }

  void finish(bool success) {
    if (stepRunning) {
      onStepDestroy();
      stepConfigCallback?.finish(success);
    }
  }

  bool isStepRunning() {
    return stepRunning;
  }

  void postEvent(SmartStepEvent event, {int delay = 0}) {
    stepConfigCallback?.postEvent(event, delayMs: delay);
  }

  bool isBtOnly() {
    return IotPairNetworkInfo().selectIotDevice?.product?.scType ==
        IotScanType.BLE.scanType;
  }

  Future<bool>? onBackClick() {
    return null;
  }

  SmartStepConfig? currentStep() => stepConfigCallback?.currentStep();
}
