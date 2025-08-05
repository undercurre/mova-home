import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'step_status.dart';

/// StepEvent，记录步骤事件
class StepEvent<T> {
  StepId stepId = StepId.STEP_NONE;
  T? data;
  Map<StepId, StepRunningStatus> runningStatus = {};
  Map<StepId, StepResultStatus> resultStatus = {};

  StepEvent(this.stepId, {T? data});

  bool isSuccess() {
    return resultStatus[stepId] == StepResultStatus.success;
  }

  static StepEvent from() {
    return StepEvent(StepId.STEP_NONE);
  }

  StepEvent success(StepId stepId, {T? data}) {
    this.data = data;
    this.stepId = stepId;
    resultStatus[stepId] = StepResultStatus.success;
    runningStatus[stepId] = StepRunningStatus.complete;
    return this;
  }

  StepEvent fail(StepId stepId, {T? data}) {
    this.data = data;
    this.stepId = stepId;
    resultStatus[stepId] = StepResultStatus.failed;
    runningStatus[stepId] = StepRunningStatus.complete;
    return this;
  }

  StepEvent running(StepId stepId, {T? data}) {
    this.data = data;
    this.stepId = stepId;
    resultStatus[stepId] = StepResultStatus.none;
    runningStatus[stepId] = StepRunningStatus.running;
    return this;
  }

  tosString() {
    return 'StepEvent{stepId: $stepId, data: $data, runningStatus: $runningStatus, resultStatus: $resultStatus}';
  }
}

class BLEStepEvent extends StepEvent {
  BluetoothDevice bleDevice;

  BLEStepEvent(super.stepId, this.bleDevice);
}

class PairStateStepEvent extends StepEvent {
  String did;

  PairStateStepEvent(super.stepId, this.did);
}

class StepResult {
  final StepId stepId;
  final bool success;
  final bool isFinish;
  final StepEvent event;
  StepRunningStatus runningStatus = StepRunningStatus.none;
  StepResultStatus resultStatus = StepResultStatus.none;

  StepResult(
      {required this.stepId,
      required this.success,
      required this.isFinish,
      required this.event,
      this.runningStatus = StepRunningStatus.none,
      this.resultStatus = StepResultStatus.none});

  tosString() {
    return 'StepResult{stepId: $stepId, success: $success, isFinish: $isFinish, event:$event, runningStatus: $runningStatus, resultStatus: $resultStatus}';
  }
}

class StepResultWaiting extends StepResult {
  StepResultWaiting(StepId stepId)
      : super(
          stepId: stepId,
          success: false,
          isFinish: false,
          event: StepEvent.from(),
        );
}

enum StepId {
  ///*************** 权限*********************///
  STEP_NONE,
  STEP_BT_OPEN_REQUEST_DIALOG,
  STEP_BT_PERMISSION_REQUEST_DIALOG,
  STEP_CAMERA_PERMISSION_REQUEST_DIALOG,
  STEP_WIFI_OPEN_REQUEST_DIALOG,
  STEP_WIFI_PERMISSION_REQUEST_DIALOG,
  STEP_WIFI_LOCATION_SERVICE_REQUEST_DIALOG,

  ///***************** 配网发数据*******************///
  STEP_WIFI_SCAN,
  STEP_AP_AUTO_CONNECTION,
  STEP_AP_MAUNAL_CONNECTION,
  STEP_AP_SEND_DATA,
  // 蓝牙连接
  STEP_BLE_SCAN,
  STEP_BLE_CONNECTION,
  // 蓝牙数据交互
  STEP_BLE_SEND_DATA,
  // 查询机器配网状态
  STEP_CHECK_PAIR_STATE,
  STEP_CHECK_PAIR_QR_STATE,
}
