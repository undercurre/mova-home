import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';

class SmartStepEvent<T> {
  final StepName stepName;
  SmartStepStatus? status;
  T? obj;
  int what;
  bool canManualConnect;
  Map<String, dynamic> args = {};

  SmartStepEvent(this.stepName,
      {this.status,
      this.obj,
      this.what = -1,
      this.canManualConnect = false,
      this.args = const {}});
}

enum SmartStepStatus {
  start,
  success,
  failed,
  stop,
}

enum StepName {
  STEP_CONNECT(1),
  STEP_TRANSFORM(2),
  STEP_CHECK_PAIR(3),
  STEP_QR_NET_PAIR(4),
  STEP_MAUNAL(5),

// 割草机新增
  STEP_PIN_CHECK(7),
  STEP_PIN_CODE(8),
  STEP_PIN_BIND(9),
  STEP_ROUTE_CONFIG_NET(10),
  STEP_ROUTE_CONNECT_NET(11),
  ;

  final step;

  const StepName(this.step);
}

/// 被别人绑定了
final WHAT_BIND_HAS_OWN = 18000;

/// pincode 输入
final WHAT_PINCODE_HIDE = 19000;
final WHAT_PINCODE_INPUT = 19001;
final WHAT_PINCODE_ERROR = 19002;
final WHAT_PINCODE_LOCK = 19003;
