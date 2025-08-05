// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'after_sale_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AfterSaleConfigImpl _$$AfterSaleConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$AfterSaleConfigImpl(
      contactNumber: json['contactNumber'] as String?,
      website: json['website'] as String?,
      email: json['email'] as String?,
      country: json['country'] as String?,
      ext: json['ext'] as String?,
      onlineService: (json['onlineService'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AfterSaleConfigImplToJson(
        _$AfterSaleConfigImpl instance) =>
    <String, dynamic>{
      'contactNumber': instance.contactNumber,
      'website': instance.website,
      'email': instance.email,
      'country': instance.country,
      'ext': instance.ext,
      'onlineService': instance.onlineService,
    };
