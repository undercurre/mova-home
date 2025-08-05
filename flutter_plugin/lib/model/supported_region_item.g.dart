// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_region_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupportedRegionItemImpl _$$SupportedRegionItemImplFromJson(
        Map<String, dynamic> json) =>
    _$SupportedRegionItemImpl(
      id: (json['id'] as num?)?.toInt(),
      countryCode: json['country_code'] as String?,
      isEnabled: (json['is_enabled'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SupportedRegionItemImplToJson(
        _$SupportedRegionItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country_code': instance.countryCode,
      'is_enabled': instance.isEnabled,
    };
