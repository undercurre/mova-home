// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageGetModelImpl _$$MessageGetModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageGetModelImpl(
      serviceMsgSwitch: json['serviceMsgSwitch'] as bool?,
      systemMsgSwitch: json['systemMsgSwitch'] as bool?,
    );

Map<String, dynamic> _$$MessageGetModelImplToJson(
        _$MessageGetModelImpl instance) =>
    <String, dynamic>{
      'serviceMsgSwitch': instance.serviceMsgSwitch,
      'systemMsgSwitch': instance.systemMsgSwitch,
    };

_$MessageSetModelImpl _$$MessageSetModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageSetModelImpl(
      msgSwitch: json['msgSwitch'] as bool,
      msgType: json['msgType'] as String,
    );

Map<String, dynamic> _$$MessageSetModelImplToJson(
        _$MessageSetModelImpl instance) =>
    <String, dynamic>{
      'msgSwitch': instance.msgSwitch,
      'msgType': instance.msgType,
    };

_$MessageSettingModelImpl _$$MessageSettingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageSettingModelImpl(
      devNotify: json['devNotify'] as bool?,
      devShare: json['devShare'] as bool?,
      devices: (json['devices'] as List<dynamic>?)
          ?.map((e) => DeviceItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      homeShare: json['homeShare'] as bool?,
      noDisturb: json['noDisturb'] as bool?,
      noDisturbFrom: (json['noDisturbFrom'] as num?)?.toInt(),
      noDisturbTo: (json['noDisturbTo'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MessageSettingModelImplToJson(
        _$MessageSettingModelImpl instance) =>
    <String, dynamic>{
      'devNotify': instance.devNotify,
      'devShare': instance.devShare,
      'devices': instance.devices,
      'homeShare': instance.homeShare,
      'noDisturb': instance.noDisturb,
      'noDisturbFrom': instance.noDisturbFrom,
      'noDisturbTo': instance.noDisturbTo,
    };

_$DeviceModelImpl _$$DeviceModelImplFromJson(Map<String, dynamic> json) =>
    _$DeviceModelImpl(
      deviceId: (json['deviceId'] as num?)?.toInt(),
      deviceName: json['deviceName'] as String?,
      icon: json['icon'] as String?,
      model: json['model'] as String?,
      notify: json['notify'] as bool?,
      region: json['region'] as String?,
      share: (json['share'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$DeviceModelImplToJson(_$DeviceModelImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'icon': instance.icon,
      'model': instance.model,
      'notify': instance.notify,
      'region': instance.region,
      'share': instance.share,
    };
