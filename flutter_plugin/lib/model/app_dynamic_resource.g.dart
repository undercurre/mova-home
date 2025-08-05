// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_dynamic_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppDynamicResourceImpl _$$AppDynamicResourceImplFromJson(
        Map<String, dynamic> json) =>
    _$AppDynamicResourceImpl(
      startDate: (json['startDate'] as num?)?.toInt() ?? 0,
      endDate: (json['endDate'] as num?)?.toInt() ?? 0,
      appLaunch: json['appLaunch'] as String? ?? '',
      addDeviceBg: json['addDeviceBg'] as String? ?? '',
      appLaunchType: json['appLaunchType'] as String? ?? '',
      addDeviceBgType: json['addDeviceBgType'] as String? ?? '',
      addDeviceBgCover: json['addDeviceBgCover'] as String? ?? '',
      isExpired: json['isExpired'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppDynamicResourceImplToJson(
        _$AppDynamicResourceImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'appLaunch': instance.appLaunch,
      'addDeviceBg': instance.addDeviceBg,
      'appLaunchType': instance.appLaunchType,
      'addDeviceBgType': instance.addDeviceBgType,
      'addDeviceBgCover': instance.addDeviceBgCover,
      'isExpired': instance.isExpired,
    };
