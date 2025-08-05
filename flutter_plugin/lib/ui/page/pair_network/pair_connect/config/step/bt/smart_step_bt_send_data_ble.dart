import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/base_send_data.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/special_send_data_param.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/protocol/bt_send_data_protocol.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/smart_step_check_pair.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import '../../smart_step_event.dart';
import 'smart_step_bt_send_data_basic.dart';

class SmartStepBtSendDataBLE extends SmartStepBtSenDataBasic {
  late BtSendDataProtocol btSendDataProtocol = BtSendDataProtocol();
  late MowerSendDataParam sendDataParam = MowerSendDataParam();

  SmartStepBtSendDataBLE(
      {required super.bleDevice, this.isPinCodeEnable = false});

  @override
  StepId get stepId => StepId.STEP_BLE_SEND_DATA;
  final int kRetryReadCountMax = 3;
  final int kRetryWriteCountMax = 2;

  /// 如果支持pincode,则等输入后发送数据
  /// 如果不支持pincode,则直接发送数据
  bool isPinCodeEnable = false;
  String? propertyValue;

  @override
  Future<void> stepCreate() async {
    await registerSubscription();
    if (!isPinCodeEnable) {
      LogUtils.i('getAuthBean---for----SmartStepBtSendDataBLE.stepCreate');
      final authBean = await AccountModule().getAuthBean();
      await sendBleData(arguments: {'uid': authBean.uid});
    } else {
      postEvent(
          SmartStepEvent(StepName.STEP_TRANSFORM, what: WHAT_PINCODE_INPUT));
    }
  }

  @override
  Future<void> handleMessage(msg) async {
    if (msg.what == WHAT_PINCODE_INPUT) {
      final pinCode = msg.obj as String?;
      if (pinCode != null) {
        LogUtils.i('getAuthBean---for----SmartStepBtSendDataBLE.handleMessage');
        final authBean = await AccountModule().getAuthBean();
        await sendBleData(arguments: {'pcode': pinCode, 'uid': authBean.uid});
      }
    }
  }

  @override
  Future<void> onReadSuccess(Uint8List recvData) async {
    switch (sendStep) {
      case BleSendDataStep.idle:
      case BleSendDataStep.query:

      /// recv response_connection.
        final parseData = await parseAskDataFrame(recvData);
        LogUtils.i(
            '-----BLE------ onReadSuccess parseAskDataFrame: $parseData');
        if (parseData.code == 40045) {
          // 机器人已被其他用户绑定 text_robot_is_bound
          postEvent(
              SmartStepEvent(StepName.STEP_TRANSFORM, what: WHAT_BIND_HAS_OWN));
        } else if (parseData.code == 0) {
          sendStep = BleSendDataStep.setting;
          postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
              what: WHAT_PINCODE_HIDE, obj: 0));

          /// 绑定接口
          var map = sendDataParam.decodeECDHContent(
              deviceId: deviceId ?? '',
              pubKey: iotPublicKey ?? '',
              encryptContent: parseData.content['value']);

          /// 绑定失败
          if (map.isEmpty) {
            sendStep = BleSendDataStep.query;

            /// 发送错误
            await connectFail();
            return;
          }
          // 绑定
          final result = await repository.postDevicePair4Ble(map);
          var configRouterParam = {
            'method': 'request_binding',
            'code': result,
          };
          await sendBleData(arguments: configRouterParam);
        } else {
          /// 重试
          sendStep = BleSendDataStep.query;

          /// 发送错误
          await connectFail();
        }
        break;
      case BleSendDataStep.setting:
      // recv response_router.
        final result = await parseSettingDataFrame(recvData);
        if (result.code == 0) {
          sendStep = BleSendDataStep.finish;
          postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
              status: SmartStepStatus.success));
          nextStep(SmartStepCheckPair(deviceId!, needCheckPair: false));
        } else if (result.code == 40045) {
          postEvent(
              SmartStepEvent(StepName.STEP_TRANSFORM, what: WHAT_BIND_HAS_OWN));
        } else {
          sendStep = BleSendDataStep.setting;
          postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
              status: SmartStepStatus.failed));
          await connectFail();
        }
        break;
      case BleSendDataStep.finish:
        break;
    }
  }

  Future<void> sendBleData({Map<String, dynamic>? arguments}) async {
    LogUtils.i('-----BLE------ sendBLEData $sendStep');
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
            '-----BLE------ sendBleData BleSendDataStep.query $sendStep ,hexString $hexString');
        break;
      case BleSendDataStep.setting:
      // send config_router.
        if (deviceId != null) {
          sendData = await packageSettingDataFrame(arguments: arguments);
          String hexString = hex.encode(sendData);
          LogUtils.i(
              '-----BLE------sendBleData BleSendDataStep.setting $sendStep hexString $hexString');
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

  @override
  Future<void> connectFail() async {
    if (bleDevice.isConnected == true) {
      LogUtils.i('-----BLE------BLE ONLY connectFail disconnect------$this');
      forceDisConnectDeviceBt(bleDevice);
    }
    postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
        status: SmartStepStatus.failed));
  }

  /// 常用的两步发数据
  Future<Uint8List> packageAskDataFrame(
      {Map<String, dynamic>? arguments}) async {
    var requestConnectionParam =
    sendDataParam.requestConnectionParam(arguments: arguments);
    LogUtils.i(
        '-----BLE------SmartStepBtSendDataBLE  packageAskDataFrame arguments $requestConnectionParam');
    return btSendDataProtocol.packageQueryString(requestConnectionParam);
  }

  Future<ParseData> parseAskDataFrame(Uint8List data) async {
    final pair = btSendDataProtocol.parseQueryAckData(data);
    if (pair.first == 0) {
      final ret = sendDataParam.parseParamStr(pair.second);
      LogUtils.i(
          '-----BLE------SmartStepBtSendDataBLE packageAskDataFrame ${ret}');
      deviceId = ret['did'];
      int code = int.parse(ret['code'] ?? '0');
      iotPublicKey = ret['pubCer'];
      propertyValue = ret['value'];
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
    var configRouterParam = json.encoder.convert(arguments ?? {});
    LogUtils.i(
        '-----BLE------SmartStepBtSendDataBLE packageSettingDataFrame $configRouterParam');
    return btSendDataProtocol.packageSettingString(configRouterParam);
  }

  Future<ParseData> parseSettingDataFrame(Uint8List data) async {
    final pair =
    btSendDataProtocol.parseSettingAckData(data, skipAckCheck: true);
    if (pair.first == 0) {
      final ret = sendDataParam.parseParamStr(pair.second);
      LogUtils.i(
          '-----BLE------SmartStepBtSendDataBLE packageSettingDataFrame $ret');
      return ParseData(int.parse(ret['code'] ?? '-1'), ret);
    } else {
      return ParseData(pair.first, const {});
    }
  }
}
