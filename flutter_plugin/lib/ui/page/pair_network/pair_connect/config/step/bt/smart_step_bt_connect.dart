import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/bt/bt_protocol_attributes.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_config.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/ap/smart_step_ap_connect.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/bt/smart_step_bt_send_data.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/bt/smart_step_bt_send_data_ble.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import 'smart_step_bt_send_data_basic.dart';
import 'smart_step_bt_send_data_mcu.dart';
import 'smart_step_bt_send_data_pincode.dart';
import 'package:async/async.dart';

class SmartStepBtConnect extends SmartStepConfig {
  @override
  StepId get stepId => StepId.STEP_BLE_CONNECTION;

  late BluetoothDevice bleDevice;

  Map<Guid, BluetoothCharacteristic> discoveredCharList = {};

  StreamSubscription? _subscription;

  CancelableOperation? _connectOperation;

  final int _kRetryConnectCountMax = 1;
  int _kRetryConnectCount = 0;

  @override
  Future<void> handleMessage(msg) async{}

  @override
  Future<void> stepCreate() async {
    bleDevice = IotPairNetworkInfo().selectIotDevice!.bleDevice!;
    postEvent(
        SmartStepEvent(StepName.STEP_CONNECT, status: SmartStepStatus.start));
    await _onConnectStateChange();
    await _connect();
  }

  @override
  Future<void> stepDestroy() async {
    await _subscription?.cancel();
    _subscription = null;
    // 如果已经跳转到下一步，则不取消
    if (currentStep() is! SmartStepBtSenDataBasic) {
      await _connectOperation?.cancel();
      _subscription = null;
    }
  }

  Future<void> _connect({int? timeout}) async {
    try {
      _connectOperation = await CancelableOperation.fromFuture(
          _internalConnect(timeout: timeout), onCancel: () async {
        /// 取消操作
        if (bleDevice.isConnected) {
          LogUtils.i('-----BLE------ _connect disconnect------$this');
          await forceDisConnectDeviceBt(bleDevice);
        }
      });
    } catch (e) {
      postEvent(SmartStepEvent(StepName.STEP_CHECK_PAIR,
          status: SmartStepStatus.failed));
    }
  }

  Future<void> _internalConnect({int? timeout}) async {
    // 连接设备蓝牙
    LogUtils.i('-----BLE------ connect ------');
    try {
      await bleDevice.connect(timeout: Duration(seconds: timeout ?? 35));
      if (_connectOperation?.isCompleted == true ||
          _connectOperation?.isCanceled == true) {
        return;
      }
      await _discoverCharacteristic();
    } catch (e) {
      LogUtils.i('-----BLE------ connect fail ----------- :$e');
      if (_kRetryConnectCount < _kRetryConnectCountMax) {
        _kRetryConnectCount++;
        /// 重试一次
        await Future.delayed(const Duration(microseconds: 200), () async {
          await _internalConnect();
        });
        return;
      }
      if (!isBtOnly()) {
        nextStep(SmartStepApConnect());
      } else {
        postEvent(SmartStepEvent(StepName.STEP_CONNECT,
            status: SmartStepStatus.failed));
      }
    }
  }

  Future<void> _onConnectStateChange() async {
    _subscription = bleDevice.connectionState.listen((state) async {
      LogUtils.i('-----BLE------ connect state $state------');
    });
    // clean up.
    bleDevice.cancelWhenDisconnected(_subscription!, delayed: true, next: true);
  }

  Future<void> _discoverCharacteristic() async {
    try {
      // 已连接, 发现服务及特征
      List<BluetoothService> services = await bleDevice.discoverServices();
      var index = services.indexWhere((element) =>
          element.serviceUuid == BtProtocolAttributes.bleServiceUuid);
      if (index != -1) {
        var characteristics = services[index].characteristics;
        // 发现特征
        for (BluetoothCharacteristic c in characteristics) {
          if (c.characteristicUuid == BtProtocolAttributes.bleReadCharUuid ||
              c.characteristicUuid == BtProtocolAttributes.bleWriteCharUuid) {
            discoveredCharList[c.characteristicUuid] = c;
          }
        }
        if (discoveredCharList.values.length == 2) {
          // 发现服务及特征成功
          LogUtils.i('-----BLE------ discoverServices success -----------');
          postEvent(SmartStepEvent(StepName.STEP_CONNECT,
              status: SmartStepStatus.success));

          /// 判断逻辑
          await gotoSendDataBt();
        } else {
          LogUtils.i('-----BLE------ discoverServices failed -----------');
          postEvent(SmartStepEvent(StepName.STEP_CONNECT,
              status: SmartStepStatus.failed));
          if (!isBtOnly()) {
            nextStep(SmartStepApConnect());
          }
        }
      } else {
        LogUtils.i('-----BLE------ discoverServices failed -----------');
        postEvent(SmartStepEvent(StepName.STEP_CONNECT,
            status: SmartStepStatus.failed));
        if (!isBtOnly()) {
          nextStep(SmartStepApConnect());
        }
      }
    } catch (e) {
      LogUtils.i('-----BLE------ discoverServices error: ----------- :$e');
      postEvent(
          SmartStepEvent(StepName.STEP_CONNECT, status: SmartStepStatus.stop));

      ///
      if (!isBtOnly()) {
        nextStep(SmartStepApConnect());
      }
    }
  }

  /// 跳转到发送数据步骤
  Future<void> gotoSendDataBt() async {
    /// 如果是BLOB，则走MCU send data, 目前是牙刷
    if (IotPairNetworkInfo()
            .selectIotDevice
            ?.product
            ?.extendScType
            .contains(IotDeviceExtendScType.BLOB.extendSctype) ==
        true) {
      nextStep(SmartStepBtSendDataMCU(bleDevice: bleDevice));
      return;
    }

    /// 机器不能自己上线，例如：没有Wi-Fi模块的擦窗和割草机
    if (IotPairNetworkInfo()
            .selectIotDevice
            ?.product
            ?.extendScType
            .contains(IotDeviceExtendScType.NON_FORCE_WIFI.extendSctype) ==
        true) {
      final isPinCodeEnable = IotPairNetworkInfo()
              .selectIotDevice
              ?.product
              ?.extendScType
              .contains(IotDeviceExtendScType.PINCODE.extendSctype) ==
          true;
      nextStep(SmartStepBtSendDataBLE(
          bleDevice: bleDevice, isPinCodeEnable: isPinCodeEnable));
      return;
    }

    if (IotPairNetworkInfo()
            .selectIotDevice
            ?.product
            ?.extendScType
            .contains(IotDeviceExtendScType.PINCODE.extendSctype) ==
        true) {
      nextStep(SmartStepBtSenDataPinCode(bleDevice: bleDevice));
      return;
    }
    nextStep(SmartStepBtSenData(bleDevice: bleDevice));
  }
}
