// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warranty_debug_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarrantyDebugModelImpl _$$WarrantyDebugModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WarrantyDebugModelImpl(
      countryCode: json['countryCode'] as String? ?? '',
      useCNShopifyLink: json['useCNShopifyLink'] as bool? ?? false,
      showOverseaMall: json['showOverseaMall'] as bool? ?? false,
      isDebug: json['isDebug'] as bool? ?? false,
    );

Map<String, dynamic> _$$WarrantyDebugModelImplToJson(
        _$WarrantyDebugModelImpl instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'useCNShopifyLink': instance.useCNShopifyLink,
      'showOverseaMall': instance.showOverseaMall,
      'isDebug': instance.isDebug,
    };
