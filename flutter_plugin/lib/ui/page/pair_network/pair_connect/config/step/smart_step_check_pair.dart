import 'dart:async';

import 'package:async/async.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_config.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/mixin/pair_net_wifi_info_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_network_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class SmartStepCheckPair extends SmartStepConfig with PairNetWifiInfoMixin {
  @override
  StepId get stepId => StepId.STEP_CHECK_PAIR_STATE;
  var repository = PairNetworkRepository(ApiClient());
 
  final String deviceId;
  final bool needCheckPair;

  SmartStepCheckPair(this.deviceId, {this.needCheckPair = true});

  String _errorMsg = '';
  int _errorCode = -1;

  CancelableOperation? _cancelableOperation;

  @override
  void handleMessage(SmartStepEvent<dynamic> msg) {}

  @override
  void stepCreate() async {
    postEvent(SmartStepEvent(StepName.STEP_CHECK_PAIR,
        status: SmartStepStatus.start));

    if (needCheckPair) {
      try {
        _cancelableOperation = await CancelableOperation.fromFuture(
            checkDevicePairResult(deviceId!),
            onCancel: () {});
      } catch (e) {
        postEvent(SmartStepEvent(StepName.STEP_CHECK_PAIR,
            status: SmartStepStatus.failed));
      }
    } else {
      postEvent(SmartStepEvent(StepName.STEP_CHECK_PAIR,
          status: SmartStepStatus.success));
    }
  }

  Future<bool> checkDevicePairResult(String did) async {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    var curTime = DateTime.now().millisecondsSinceEpoch;
    // 请求 pair 接口结果
    await Future.delayed(const Duration(seconds: 3));
    while (curTime - startTime <= 10 * 10 * 1000) {
      if (_cancelableOperation == null ||
          _cancelableOperation?.isCanceled == true ||
          _cancelableOperation?.isCompleted == true) {
        return false;
      }
      final devicePair = await getDevicePair(did);
      if (devicePair) {
        /// 成功
        /// 保存Wi-Fi名密码
        await saveWifiInfo();
        postEvent(SmartStepEvent(StepName.STEP_CHECK_PAIR,
            status: SmartStepStatus.success));
        return true;
      }
      await Future.delayed(const Duration(seconds: 1));
      curTime = DateTime.now().millisecondsSinceEpoch;
    }
    postEvent(SmartStepEvent(StepName.STEP_CHECK_PAIR,
        status: SmartStepStatus.failed));
    return false;
  }

  Future<bool> getDevicePair(String did) async {
    try {
      var result = await repository.getDevicePair(did);
      LogUtils.i('-----PAIR 接口----- check pair did: $did ,result: $result');

      if (result) {
        _errorCode = -1;
        _errorMsg = '';
      }
      return result;
    } on DreameException catch (e) {
      LogUtils.e(
          '-----PAIR 接口----- check pair exception ${e.code} ${e.message}');
      _errorCode = 5;
      _errorMsg = e.message ?? '';
    } catch (e) {
      _errorCode = 6;
      _errorMsg = e.toString();
    }
    return false;
  }

  @override
  Future<void> stepDestroy() async {
    await _cancelableOperation?.cancel();
    _cancelableOperation = null;
  }
}
