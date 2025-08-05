import 'dart:async';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/base_send_data.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/vacuum_send_data_param.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/protocol/bt_send_data_protocol.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/smart_step_check_pair.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import '../../smart_step_event.dart';
import 'smart_step_bt_send_data_basic.dart';

class SmartStepBtSenData extends SmartStepBtSenDataBasic {
  late final VacuumSendDataParam _sendDataParam = VacuumSendDataParam();
  late final BtSendDataProtocol _btSendDataProtocol = BtSendDataProtocol();

  @override
  StepId get stepId => StepId.STEP_BLE_SEND_DATA;
  final int kRetryReadCountMax = 3;
  final int kRetryWriteCountMax = 2;

  SmartStepBtSenData({required super.bleDevice});

  @override
  Future<void> stepCreate() async {
    LogUtils.i('-----BLE------SmartStepBtSenData stepCreate');
    await registerSubscription();
    await sendBleData();
  }

  @override
  Future<void> handleMessage(msg) async {}

  Future<void> parseAskDataSuccess(ParseData parseData) async {
    LogUtils.i(
        '-----BLE------SmartStepBtSenData parseAskDataSuccess $parseData');
    /// 准备下一包数据
    await sendBleData();
  }

  Future<void> parseAskDataFail(ParseData parseData) async {
    /// 发送错误
    await connectFail();
  }

  Future<void> parseSettingDataFrameSuccess(ParseData parseData) async {
    postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
        status: SmartStepStatus.success));
    nextStep(SmartStepCheckPair(deviceId!, needCheckPair: true));
  }

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
            '-----BLE------SmartStepBtSenData onReadSuccess parseAskDataFrame: $parseData');
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
          final code = parseData.content['code'];
          if (code == null || code == '0') {
            await parseSettingDataFrameSuccess(parseData);
          } else {
            postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
                status: SmartStepStatus.success));
            postEvent(SmartStepEvent(StepName.STEP_CHECK_PAIR,
                status: SmartStepStatus.failed));
          }
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
    LogUtils.i('-----BLE------SmartStepBtSenData sendBLEData $sendStep');
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
            '-----BLE------SmartStepBtSenData sendBleData BleSendDataStep.query $sendStep ,hexString $hexString');
        break;
      case BleSendDataStep.setting:
      // send config_router.
        if (deviceId != null) {
          sendData = await packageSettingDataFrame(arguments: arguments);
          String hexString = hex.encode(sendData);
          LogUtils.i(
              '-----BLE------SmartStepBtSenData sendBleData BleSendDataStep.setting $sendStep hexString $hexString');
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
  Future<Uint8List> packageAskDataFrame(
      {Map<String, dynamic>? arguments}) async {
    var requestConnectionParam =
        _sendDataParam.requestConnectionParam(arguments: arguments);
    LogUtils.i(
        '-----BLE------SmartStepBtSenData  packageAskDataFrame  $requestConnectionParam');
    return _btSendDataProtocol.packageQueryString(requestConnectionParam);
  }

  Future<ParseData> parseAskDataFrame(Uint8List data) async {
    final pair = _btSendDataProtocol.parseQueryAckData(data);
    if (pair.first == 0) {
      final ret = _sendDataParam.parseParamStr(pair.second);
      LogUtils.i('-----BLE------SmartStepBtSenData  parseAskDataFrame  $ret');
      deviceId = ret['did'];
      int code = int.parse(ret['code'] ?? '0');
      iotPublicKey = ret['value'];
      if (code != 0) {
        return ParseData(code, ret);
      }

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
      return ParseData(code, ret);
    } else {
      return ParseData(pair.first, const {});
    }
  }

  Future<Uint8List> packageSettingDataFrame(
      {Map<String, dynamic>? arguments}) async {
    var configRouterParam =
    await _sendDataParam.configRouterParam(deviceId!, value: iotPublicKey);
    LogUtils.i(
        '-----BLE------SmartStepBtSenData  packageSettingDataFrame  $configRouterParam');
    return _btSendDataProtocol.packageSettingString(configRouterParam);
  }

  Future<ParseData> parseSettingDataFrame(Uint8List data) async {
    final pair = _btSendDataProtocol.parseSettingAckData(data);
    if (pair.first == 0) {
      final ret = _sendDataParam.parseParamStr(pair.second);
      LogUtils.i(
          '-----BLE------SmartStepBtSenData  parseSettingDataFrame  $ret');
      return ParseData(0, ret);
    } else {
      return ParseData(pair.first, const {});
    }
  }
}
