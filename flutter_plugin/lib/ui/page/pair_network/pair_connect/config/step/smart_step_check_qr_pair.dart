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

class SmartStepCheckQrPair extends SmartStepConfig with PairNetWifiInfoMixin {
  @override
  StepId get stepId => StepId.STEP_CHECK_PAIR_QR_STATE;
  var repository = PairNetworkRepository(ApiClient());

  final String pairQrKey;

  SmartStepCheckQrPair(this.pairQrKey);

  CancelableOperation? _cancelableOperation;

  @override
  void handleMessage(SmartStepEvent<dynamic> msg) {}

  @override
  void stepCreate() async {
    LogUtils.d('-----QRPair----- stepCreate $pairQrKey');
    postEvent(SmartStepEvent(StepName.STEP_QR_NET_PAIR,
        status: SmartStepStatus.start));
    try {
      _cancelableOperation = CancelableOperation.fromFuture(
          checkQrPairResult(pairQrKey),
          onCancel: () {});
    } catch (e) {
      postEvent(SmartStepEvent(StepName.STEP_CHECK_PAIR,
          status: SmartStepStatus.failed));
    }
  }

  Future<bool> checkQrPairResult(String pairQRKey) async {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    var curTime = DateTime.now().millisecondsSinceEpoch;
    // 请求 pair 接口结果
    await Future.delayed(const Duration(seconds: 3));
    while (curTime - startTime <= 10 * 10 * 1000) {
      LogUtils.d('-----QRPair----- check $pairQrKey');

      if (_cancelableOperation == null ||
          _cancelableOperation?.isCanceled == true ||
          _cancelableOperation?.isCompleted == true) {
        return false;
      }
      final devicePair = await getDeviceQRPair(pairQRKey);
      if (devicePair) {
        /// 成功
        /// 保存Wi-Fi名密码
        await saveWifiInfo();
        postEvent(SmartStepEvent(StepName.STEP_QR_NET_PAIR,
            status: SmartStepStatus.success));
        return true;
      }
      await Future.delayed(const Duration(seconds: 1));
      curTime = DateTime.now().millisecondsSinceEpoch;
    }
    postEvent(SmartStepEvent(StepName.STEP_QR_NET_PAIR,
        status: SmartStepStatus.failed));
    return false;
  }

  Future<bool> getDeviceQRPair(String pairQRKey) async {
    try {
      var result = await repository.getDeviceQRPair(pairQRKey);
      if (result.success) {
        LogUtils.d('-----QRPair----- check pair success $pairQRKey');
      }
      return result.success;
    } on DreameException catch (e) {
      LogUtils.d(
          '-----QRPair----- check pair exception ${e.code} ${e.message}');
    } catch (e) {
      LogUtils.d('-----QRPair----- check pair exception $e');
    }
    return false;
  }

  @override
  Future<void> stepDestroy() async {
    await _cancelableOperation?.cancel();
    _cancelableOperation = null;
  }
}
