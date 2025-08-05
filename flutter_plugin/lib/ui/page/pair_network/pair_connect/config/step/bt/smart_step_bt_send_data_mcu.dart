import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/bt/ble_operate_helper.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/base_send_data.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/base_send_data_bt.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/mcu_send_data_bt.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/mcu_send_data_param.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/special_send_data_bt.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/vacuum_send_data_bt.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/bt/bt_protocol_attributes.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_ble_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_config.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/ap/smart_step_ap_connect.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/smart_step_check_pair.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import '../../smart_step_event.dart';
import 'smart_step_bt_send_data.dart';
import 'smart_step_bt_send_data_basic.dart';

class SmartStepBtSendDataMCU extends SmartStepBtSenData {
  late final McuSendDataParam _sendDataParam = McuSendDataParam();

  @override
  StepId get stepId => StepId.STEP_BLE_SEND_DATA;
  final int kRetryReadCountMax = 3;
  final int kRetryWriteCountMax = 2;
  bool success = false;

  SmartStepBtSendDataMCU({required super.bleDevice});

  @override
  Future<void> stepCreate() async {
    await registerSubscription();
    await sendBleData();
  }

  @override
  Future<void> handleMessage(msg) async {}

  @override
  Future<void> parseAskDataSuccess(ParseData parseData) async {
    /// 准备下一包数据
    await sendBleData();
  }

  @override
  Future<void> parseAskDataFail(ParseData parseData) async {
    /// 发送错误
    await connectFail();
  }

  @override
  Future<void> connectFail() async {
    if (bleDevice.isConnected == true) {
      LogUtils.i('-----BLE------mcu connectFail disconnect------$this');
      await forceDisConnectDeviceBt(bleDevice);
    }
    postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
        status: SmartStepStatus.failed));
  }

  @override
  Future<void> parseSettingDataFrameSuccess(ParseData parseData) async {
    postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
        status: SmartStepStatus.success));
    nextStep(SmartStepCheckPair(deviceId!, needCheckPair: false));
  }

  @override
  Future<void> parseSettingDataFrameFail(ParseData parseData) async {
    await connectFail();
  }

  @override
  Future<void> onReadSuccess(Uint8List recvData) async {
    switch (sendStep) {
      case BleSendDataStep.idle:
      case BleSendDataStep.query:

        /// recv response_connection.
        final parseData = await parseAskDataFrame(recvData);
        LogUtils.i(
            '-----BLE------SmartStepBtSendDataMCU onReadSuccess parseAskDataFrame: $parseData');
        if (parseData.code == 40045) {
          // 机器人已被其他用户绑定 text_robot_is_bound
          postEvent(
              SmartStepEvent(StepName.STEP_TRANSFORM, what: WHAT_BIND_HAS_OWN));
        } else if (parseData.code == 0) {
          sendStep = BleSendDataStep.setting;
          await parseAskDataSuccess(parseData);
        } else {
          sendStep = BleSendDataStep.query;
          await parseAskDataFail(parseData);
        }
        break;
      case BleSendDataStep.setting:
        // recv response_router.
        final parseData = await parseSettingDataFrame(recvData);
        if (parseData.code == 0) {
          sendStep = BleSendDataStep.finish;
          await parseSettingDataFrameSuccess(parseData);
        } else {
          sendStep = BleSendDataStep.setting;
          await parseSettingDataFrameFail(parseData);
        }
        break;
      case BleSendDataStep.finish:
        break;
    }
  }

  Future<void> sendBleData({Map<String, dynamic>? arguments}) async {
    LogUtils.i('-----BLE------SmartStepBtSendDataMCU sendBLEData $sendStep');
    if (bleDevice.isDisconnected == true) {
      await connectFail();
      return;
    }
    Uint8List? sendData;
    switch (sendStep) {
      case BleSendDataStep.idle:
      case BleSendDataStep.query:
        // send request_connection.
        sendData = await packageAskDataFrame(arguments: arguments);
        String hexString = hex.encode(sendData);
        LogUtils.i(
            '-----BLE------SmartStepBtSendDataMCU sendBleData BleSendDataStep.query $sendStep, data:$arguments, hexString $hexString');
        break;
      case BleSendDataStep.setting:
        // send config_router.
        if (deviceId != null) {
          sendData = await packageSettingDataFrame(arguments: arguments);
          String hexString = hex.encode(sendData);
          LogUtils.i(
              '-----BLE------SmartStepBtSendDataMCU sendBleData BleSendDataStep.setting $sendStep, data:$arguments, hexString $hexString');
        } else {
          await connectFail();
        }
        break;
      default:
        break;
    }
    if (sendData == null) {
      await connectFail();
    } else {
      var isSuccess = await writeBleData(sendData);
      if (!isSuccess) {
        await connectFail();
      }
    }
  }

  /// 常用的两步发数据
  @override
  Future<Uint8List> packageAskDataFrame(
      {Map<String, dynamic>? arguments}) async {
    return await _sendDataParam.packageRandomCode();
  }

  @override
  Future<ParseData> parseAskDataFrame(Uint8List data) async {
    final ret = _sendDataParam.parseRandomCode(data);
    ret['nonce'] = _sendDataParam.randomString();
    ret['mac'] = bleDevice?.remoteId.str ?? '';
    if (ret['code'] == '0') {
      deviceId = ret['did'];
      iotPublicKey = ret['value'];

      /// 检查是否支持换绑
      if (IotPairNetworkInfo()
              .selectIotDevice
              ?.product
              ?.bindType
              .contains(IotDeviceBindType.STRONG.bindType) ==
          true) {
        final ret = await repository.checkDeviceBindOther(deviceId!);
        if (ret == true) {
          return ParseData(40045, {'msg': '已有绑定其他用户，不支持换绑'});
        }
      }

      /// 绑定设备
      success = await repository.postDevicePairByNonce(ret);
      LogUtils.i(
          'SmartStepBtSendDataMCU postDevicePairByNonce ret:$ret ,success: $success');
      return ParseData(success ? 0 : -1, ret);
    } else {
      return ParseData(int.parse(ret['code'] ?? '-1'), ret ?? {});
    }
  }

  @override
  Future<Uint8List> packageSettingDataFrame(
      {Map<String, dynamic>? arguments}) async {
    return _sendDataParam.packageConfigNet(success);
  }

  @override
  Future<ParseData> parseSettingDataFrame(Uint8List data) async {
    final ret = _sendDataParam.parseConfigNet(data);
    return ParseData(int.parse(ret['code'] ?? '-1'), ret);
  }
}
