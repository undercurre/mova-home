import 'dart:typed_data';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/bt/bt_protocol_attributes.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wifi_scan/wifi_scan.dart';

part 'iot_device.g.dart';

/// 扫描到的Wi-Fi和蓝牙设备的基类
@JsonSerializable()
class IotDevice {
  @JsonKey(includeFromJson: false, includeToJson: false)
  ScanResult? scanResult;
  @JsonKey(includeFromJson: false, includeToJson: false)
  WiFiAccessPoint? wiFiAccessPoint;
  @JsonKey(includeFromJson: false, includeToJson: false)
  BluetoothDevice? bleDevice;

  //蓝牙设备的广播数据
  String? btScanResult;
  String? wifiSsid;
  Product? product;
  bool isUpdated = false;
  int timestamp = -1;
  int btTimestamp = -1;

  String? _btScanPid;
  String? _btScanMac;
  String? _wifiScanModel;

  factory IotDevice.fromJson(Map<String, dynamic> json) =>
      _$IotDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$IotDeviceToJson(this);

  IotDevice();

  IotDevice.from(
      ScanResult? scanResult, WiFiAccessPoint? wiFiAccessPoint, this.product) {
    _parse(scanResult, wiFiAccessPoint?.ssid);
  }

  IotDevice.from2(ScanResult? scanResult, String? ssid, this.product) {
    _parse(scanResult, ssid);
  }

  IotDevice.fromQR(String ap, this.product) {
    wifiSsid = ap;
    timestamp = DateTime.now().millisecondsSinceEpoch;
  }

  bool isNearbyDevice() {
    return bleDevice != null && wifiSsid != null;
  }

  String btName() {
    if (bleDevice != null && scanResult != null) {
      var advName = scanResult?.advertisementData.advName ??
          scanResult?.device.remoteId.str ??
          '';
      return advName;
    }
    return scanResult?.device.remoteId.str ?? '';
  }

  void _parse(ScanResult? scanResult, String? realSSID) {
    if (scanResult != null) {
      var ret = scanResult
          .advertisementData.serviceData[BtProtocolAttributes.bleServiceUuid];
      var byteArray = Uint8List.fromList(ret ?? []);
      var btInfo = String.fromCharCodes(byteArray);
      var index1 = btInfo.indexOf('-');
      var index2 = btInfo.lastIndexOf('-');
      var isHasPidAndMac = index1 != -1 && index2 != -1 && index1 != index2;
      if ((btInfo.startsWith('dreame') ||
              btInfo.startsWith('mova') ||
              btInfo.startsWith('trouver')) &&
          isHasPidAndMac) {
        var productId = btInfo.substring(index1 + 1, index2);
        var mac = btInfo.substring(index2 + 1);
        _btScanPid = productId;
        _btScanMac = mac.replaceAll(':', '').toUpperCase();
        btScanResult = btInfo;
        this.scanResult = scanResult;
        timestamp = DateTime.now().millisecondsSinceEpoch;
        btTimestamp = DateTime.now().millisecondsSinceEpoch;
        LogUtils.i('-----BLE----- IoTDevice-$btInfo $mac');
        bleDevice = scanResult.device;
      }
    }
    if (realSSID != null) {
      var ssid = realSSID ?? '';
      var index = ssid.indexOf('_miap');
      if ((ssid.startsWith('trouver-') ||
              ssid.startsWith('mova-') ||
              ssid.startsWith('dreame-')) &&
          index != -1) {
        _wifiScanModel = ssid.substring(0, index).replaceAll('-', '.');
        wifiSsid = ssid;
        timestamp = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is IotDevice) {
      // 蓝牙设备比较
      if (other.btScanResult != null && btScanResult != null) {
        return other.btScanResult == btScanResult;
      }
      // SSID比较
      if (other.wifiSsid != null && wifiSsid != null) {
        return other.wifiSsid == wifiSsid;
      }

      // 蓝牙设备比较
      if (other._btScanPid != null &&
          _btScanPid != null &&
          other._btScanMac != null &&
          _btScanMac != null) {
        return other._btScanMac == _btScanMac && other._btScanPid == _btScanPid;
      }
      // 蓝牙设备 和 Wi-Fi设备比较
      if (other._btScanPid != null &&
          other._btScanMac != null &&
          product != null &&
          wifiSsid != null) {
        var pattern = "_miap";
        int ssidMacIndex = wifiSsid?.indexOf(pattern) ?? -1;
        var ssidMac = '';
        if (ssidMacIndex >= 0) {
          ssidMac = wifiSsid?.substring(ssidMacIndex + pattern.length) ?? '';
        } else {
          ssidMac = '';
        }
        // 已查询的设备中比较
        if (product?.productId == other.btScanPid) {
          return ssidMac == other._btScanMac;
        }
        if (product?.quickConnects.keys.contains(other._btScanPid) == true) {
          return ssidMac == other._btScanMac;
        }
      }
    }
    return super == other;
  }

  @override
  int get hashCode {
    if (btScanResult != null) {
      return btScanResult.hashCode;
    }
    if (wifiSsid != null) {
      return wifiSsid.hashCode;
    }
    return super.hashCode;
  }

  void updateIotDeviceInfo(IotDevice element) {
    if (element.btScanResult != null) {
      timestamp = element.timestamp;
      btTimestamp = element.btTimestamp;
      btScanResult = element.btScanResult;
      _parse(element.scanResult, null);
    }
    if (element.wifiSsid != null) {
      timestamp = element.timestamp;
    }
  }

  void updateIotDeviceProductInfo(Product product) {
    this.product = product;
    if (isBtIotDevice()) {
      if (product.productId == btScanPid) {
        wifiSsid =
            '${product.model.replaceAll('.', '-')}_miap${_btScanMac ?? ''}';
        _wifiScanModel = product.model;
      }
    }
  }

  /// 此扫描到的产品是否已经查询过信息
  bool isHasProductInfo(IotDevice iotDevice) {
    var pid = iotDevice.btScanPid;
    var model = iotDevice.wifiScanModel;
    if (pid == null && model == null) return false;
    if (product == null) return false;

    /// 当前产品匹配到pid或者model
    if (product!.productId == pid || product!.model == model) return true;

    /// 产品分类时，匹配到pid或者model
    return product!.quickConnects.entries
        .where((element) => element.key == pid || element.value == model)
        .isNotEmpty;
  }

  String? get btScanPid {
    return _btScanPid;
  }

  String? get wifiScanModel {
    return _wifiScanModel;
  }

  bool isIotDevice() {
    return btScanResult != null || wifiSsid != null;
  }

  bool isBtIotDevice() =>
      btScanResult != null && btScanResult?.isNotEmpty == true;
}
