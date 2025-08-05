import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class BLEOperateHelper {
  late BluetoothCharacteristic bleCharacteristic;

  BLEOperateHelper deviceWithUUID(
      BluetoothDevice device, Guid serviceUUID, Guid characteristicUUID) {
    if (device.isConnected) {
      int index = device.servicesList
          .indexWhere((element) => element.uuid == serviceUUID);
      if (index != -1) {
        var service = device.servicesList[index];
        int cIndex = service.characteristics.indexWhere(
            (element) => element.characteristicUuid == characteristicUUID);
        if (cIndex != -1) {
          bleCharacteristic = service.characteristics[cIndex];
        }
      }
    }

    return this;
  }

  // BLEOperateHelper withUUID(
  //     remoteId, Guid serviceUUID, Guid characteristicUUID) {
  //   bleCharacteristic = BluetoothCharacteristic(
  //       remoteId: remoteId,
  //       serviceUuid: serviceUUID,
  //       characteristicUuid: characteristicUUID);
  //   return this;
  // }

  // BLEOperateHelper withUUIDString(
  //     remoteId, String serviceUUID, String characteristicUUID) {
  //   bleCharacteristic = BluetoothCharacteristic(
  //     remoteId: remoteId,
  //     serviceUuid: Guid(serviceUUID),
  //     characteristicUuid: Guid(characteristicUUID),
  //   );
  //   return this;
  // }

  Future<List<int>> readData() async {
    if (!bleCharacteristic.properties.read) {
      LogUtils.i('-----BLE------ Characteristic does not support read');
      return [];
    }
    try {
      final result = await bleCharacteristic.read();
      return result;
    } catch (e) {
      if (e is FlutterBluePlusException) {
        LogUtils.e('-----BLE------ read error $e');
      } else {
        LogUtils.e('-----BLE------ read error $e');
      }
      return [];
    }
  }

  Future<bool> writeData(BluetoothDevice device, List<int> data) async {
    try {
      int mtu = device.mtuNow;
      LogUtils.i('-----BLE------ mtu now $mtu');
      if (Platform.isIOS) {
        if (mtu > 185) {
          await bleCharacteristic.splitWrite(data);
        } else {
          await bleCharacteristic.splitWrite(data, mtu: mtu);
        }
      } else {
        await bleCharacteristic.splitWrite(data, mtu: mtu);
      }
      return true;
    } catch (e) {
      LogUtils.i('-----BLE----- device conntection ${device.isConnected}');
      if (e is FlutterBluePlusException) {
        LogUtils.i(
            '-----BLE------ failed to write characteristic ${e.code} - ${e.description}');
      } else {
        LogUtils.i('-----BLE------ write with an unexpectied error. $e');
      }
      return false;
    }
  }

  Future<bool> setNotify({bool notify = false}) async {
    try {
      if (bleCharacteristic.properties.notify) {
        await bleCharacteristic.setNotifyValue(notify);
        return true;
      } else {
        LogUtils.i(
            '-----BLE------ Characteristic does not support notify, please check the properties $bleCharacteristic');
        return false;
      }
    } catch (e) {
      if (e is FlutterBluePlusException) {
        LogUtils.i(
            '-----BLE------ failed to set notify ${e.code} - ${e.description}');
      } else {
        LogUtils.i('-----BLE------ set notify with an unexpectied error. $e');
      }
      return false;
    }
  }
}

extension SplitWrite on BluetoothCharacteristic {
  Future<void> splitWrite(List<int> value,
      {int mtu = 185, int timeout = 15}) async {
    int chunk = mtu - 3;
    if (value.length <= chunk) {
      await write(value, timeout: timeout);
    } else {
      for (int i = 0; i < value.length; i += chunk) {
        List<int> subvalue = value.sublist(i, min(i + chunk, value.length));
        await write(subvalue, timeout: timeout);
      }
    }
  }
}
