// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_debug_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GPSDebugModelImpl _$$GPSDebugModelImplFromJson(Map<String, dynamic> json) =>
    _$GPSDebugModelImpl(
      longitude: json['longitude'] as String? ?? '',
      latitude: json['latitude'] as String? ?? '',
      isDebug: json['isDebug'] as bool? ?? false,
    );

Map<String, dynamic> _$$GPSDebugModelImplToJson(_$GPSDebugModelImpl instance) =>
    <String, dynamic>{
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'isDebug': instance.isDebug,
    };
