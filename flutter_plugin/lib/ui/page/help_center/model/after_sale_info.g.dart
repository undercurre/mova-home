// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'after_sale_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AfterSaleItemImpl _$$AfterSaleItemImplFromJson(Map<String, dynamic> json) =>
    _$AfterSaleItemImpl(
      key: json['key'] as String?,
      valueList: (json['valueList'] as List<dynamic>?)
              ?.map(
                  (e) => AfterSaleItemValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AfterSaleItemImplToJson(_$AfterSaleItemImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'valueList': instance.valueList,
    };

_$AfterSaleItemValueImpl _$$AfterSaleItemValueImplFromJson(
        Map<String, dynamic> json) =>
    _$AfterSaleItemValueImpl(
      channelContent: json['channelContent'] as String?,
      jumpContent: json['jumpContent'] as String?,
      androidJumpLink: json['androidJumpLink'] as String?,
      iosJumpLink: json['iosJumpLink'] as String?,
    );

Map<String, dynamic> _$$AfterSaleItemValueImplToJson(
        _$AfterSaleItemValueImpl instance) =>
    <String, dynamic>{
      'channelContent': instance.channelContent,
      'jumpContent': instance.jumpContent,
      'androidJumpLink': instance.androidJumpLink,
      'iosJumpLink': instance.iosJumpLink,
    };
