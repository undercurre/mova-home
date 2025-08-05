// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IotDevice _$IotDeviceFromJson(Map<String, dynamic> json) => IotDevice()
  ..btScanResult = json['btScanResult'] as String?
  ..wifiSsid = json['wifiSsid'] as String?
  ..product = json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>)
  ..isUpdated = json['isUpdated'] as bool
  ..timestamp = (json['timestamp'] as num).toInt()
  ..btTimestamp = (json['btTimestamp'] as num).toInt();

Map<String, dynamic> _$IotDeviceToJson(IotDevice instance) => <String, dynamic>{
      'btScanResult': instance.btScanResult,
      'wifiSsid': instance.wifiSsid,
      'product': instance.product,
      'isUpdated': instance.isUpdated,
      'timestamp': instance.timestamp,
      'btTimestamp': instance.btTimestamp,
    };
