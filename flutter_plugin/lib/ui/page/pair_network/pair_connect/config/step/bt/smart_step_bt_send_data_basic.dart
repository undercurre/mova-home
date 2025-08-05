import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/bt/ble_operate_helper.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/repository/pair_net_repository.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/bt/bt_protocol_attributes.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_config.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/ap/smart_step_ap_connect.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import '../../smart_step_event.dart';

enum BleSendDataStep {
  idle,
  query,
  setting,
  finish,
}

class SmartStepBtSenDataBasic extends SmartStepConfig {
  @override
  StepId get stepId => StepId.STEP_BLE_SEND_DATA;

  SmartStepBtSenDataBasic({required this.bleDevice});

  // 蓝牙设备对象
  final BluetoothDevice bleDevice;

  // 通信取到的机器 did
  String? deviceId;

  // 通信取到的机器的公钥
  String? iotPublicKey;

  // 标记步骤状态
  BleSendDataStep sendStep = BleSendDataStep.idle;

  // 蓝牙连接状态监听
  StreamSubscription? _btConnectStateStreamSubscription;

  // 接口请求
  late PairNetRepository repository = PairNetRepository();

  @override
  Future<void> handleMessage(msg) async {}

  /// UI状态先改成[start]状态，然后订阅机器连接状态，监听蓝牙数据变化
  /// 开启[notify](兼容擦窗机器人)
  @override
  Future<void> stepCreate() async {
    await registerSubscription();
  }

  Future<void> registerSubscription() async {
    postEvent(
        SmartStepEvent(StepName.STEP_TRANSFORM, status: SmartStepStatus.start));
    _btConnectStateStreamSubscription =
        bleDevice.connectionState.listen((event) {
      if (event == BluetoothConnectionState.disconnected) {
        /// 失败
        LogUtils.e(
            'SmartStepBtSenDataBasic registerSubscription connectionState: $event $this');
        connectFail();
      }
    });
    _listenOnValueReceived();
    await _notifyCharacteristic();
  }

  Future<void> onReadSuccess(Uint8List recvData) async {
    throw UnimplementedError('UnimplementedError onReadSuccess');
  }

  /// 由于部分机器某些原因不能支持用[read]可以用[notify]，导致此处改为使用[onValueReceived]监听
  /// (notify/read数据都会回调)，所以不在此处处理了read的结果了；
  Future<bool> readCharacteristic() async {
    var bleOperateHelper = BLEOperateHelper().deviceWithUUID(
        bleDevice,
        BtProtocolAttributes.bleServiceUuid,
        BtProtocolAttributes.bleReadCharUuid);
    List<int> ret = await bleOperateHelper.readData();
    if (ret.isNotEmpty) {
      String hexString = hex.encode(ret);
      LogUtils.i('-----BLE------ readCharacteristic hexString $hexString');
    }
    return ret.isNotEmpty;
  }

  /// 开启[notify]，当部分机器不支持一写一读的操作时，就让机器主动推送数据
  Future<void> _notifyCharacteristic() async {
    var bleOperateHelper = BLEOperateHelper().deviceWithUUID(
        bleDevice,
        BtProtocolAttributes.bleServiceUuid,
        BtProtocolAttributes.bleReadCharUuid);
    await bleOperateHelper.setNotify(notify: true);
  }

  /// 监听数据变化，[notify]和[read]都会走到这里
  void _listenOnValueReceived() {
    var bleOperateHelper = BLEOperateHelper().deviceWithUUID(
        bleDevice,
        BtProtocolAttributes.bleServiceUuid,
        BtProtocolAttributes.bleReadCharUuid);
    List<int> bytes = [];
    final streamSubscription = bleOperateHelper
        .bleCharacteristic.onValueReceived
        .listen((event) async {
      final hexString = hex.encode(event);
      LogUtils.i('------- listenOnValueReceived ------- $hexString');
      if ((hexString.startsWith('C0') && hexString.endsWith('C0')) ||
          (hexString.startsWith('c0') && hexString.endsWith('c0'))) {
        // 数据包完整,直接解析
        await onReadSuccess(Uint8List.fromList(event));
      } else if (hexString.startsWith('C0') || hexString.startsWith('c0')) {
        // 分片接收开始
        bytes.clear();
        bytes.addAll(event);
      } else if (hexString.endsWith('C0') || hexString.endsWith('c0')) {
        // 分片接收结束
        bytes.addAll(event);
        await onReadSuccess(Uint8List.fromList(bytes));
      } else {
        // 分片接收中
        bytes.addAll(event);
      }
    });
    bleDevice.cancelWhenDisconnected(streamSubscription);
  }

  /// [write]写数据操作
  Future<bool> writeBleData(List<int> data) async {
    if (bleDevice.isDisconnected == true) {
      return false;
    }
    var bleOperateHelper = BLEOperateHelper().deviceWithUUID(
        bleDevice,
        BtProtocolAttributes.bleServiceUuid,
        BtProtocolAttributes.bleWriteCharUuid);
    String hexString = hex.encode(data);
    LogUtils.i('-----BLE------ _writeBleData hexString $hexString');
    var ret = await bleOperateHelper.writeData(bleDevice, data);
    if (ret) {
      await readCharacteristic();
    }
    return ret;
  }

  /// 连接失败，断开蓝牙连接，发送失败事件，
  /// 如果支持Wi-Fi，则跳转到Wi-Fi连接
  Future<void> connectFail() async {
    if (bleDevice.isConnected == true) {
      LogUtils.i('-----BLE------basic connectFail disconnect------$this');
      await forceDisConnectDeviceBt(bleDevice);
    }
    if (!isBtOnly()) {
      nextStep(SmartStepApConnect());
    } else {
      postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
          status: SmartStepStatus.failed));
    }
  }

  @override
  Future<void> stepDestroy() async {
    await unRegisterSubscription();
    await forceDisConnectDeviceBt(bleDevice);
  }

  Future<void> unRegisterSubscription() async {
    await _btConnectStateStreamSubscription?.cancel();
    _btConnectStateStreamSubscription = null;
  }
}
