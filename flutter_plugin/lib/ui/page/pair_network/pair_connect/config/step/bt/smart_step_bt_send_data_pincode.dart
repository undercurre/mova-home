import 'dart:async';

import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/base_send_data.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';

import '../../smart_step_event.dart';
import 'smart_step_bt_send_data.dart';

/// 支持 pincode feature 需要在UI上输入PINCODE 然后按按钮，才会发送第一包数据，
/// 在第一包的回复数据中，处理pincode 错误和锁定的情况
class SmartStepBtSenDataPinCode extends SmartStepBtSenData {
  SmartStepBtSenDataPinCode({required super.bleDevice});

  @override
  Future<void> stepCreate() async {
    await registerSubscription();
    postEvent(
        SmartStepEvent(StepName.STEP_TRANSFORM, what: WHAT_PINCODE_INPUT));
  }

  @override
  Future<void> handleMessage(msg) async {
    if (msg.what == WHAT_PINCODE_INPUT) {
      final pinCode = msg.obj as String?;
      if (pinCode != null) {
        LogUtils.i(
            '-----BLE------SmartStepBtSenDataPinCode handleMessage $pinCode');
        await sendBleData(arguments: {'pcode': pinCode});
      }
    }
  }

  @override
  Future<void> parseAskDataSuccess(ParseData parseData) async {
    postEvent(
        SmartStepEvent(StepName.STEP_TRANSFORM, what: WHAT_PINCODE_HIDE));
    await super.parseAskDataSuccess(parseData);
  }

  ///  code -1 pcode 错误 -2 被锁定 remain 剩余次数或时间
  ///  code：-2 时,remain 剩余锁定时间
  //   code：-1 时,remain 剩余输入次数
  @override
  Future<void> parseAskDataFail(ParseData parseData) async {
    if (parseData.content.containsKey('remain')) {
      var remain = parseData.content['remain'];
      if (parseData.code == -1) {
        /// 发送pincode 错误
        postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
            what: WHAT_PINCODE_ERROR, obj: remain, args: parseData.content));
      } else if (parseData.code == -2) {
        /// 发送pincode 被锁，remain 表示被锁时间
        postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
            what: WHAT_PINCODE_LOCK, obj: remain, args: parseData.content));
      }
    } else {
      /// 发送错误
      await connectFail();
    }
  }
}
