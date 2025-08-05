// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_center_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HelpCenterKindOfProductImpl _$$HelpCenterKindOfProductImplFromJson(
        Map<String, dynamic> json) =>
    _$HelpCenterKindOfProductImpl(
      categoryId: json['categoryId'] as String? ?? '',
      categoryOrder: (json['categoryOrder'] as num?)?.toInt() ?? -1,
      name: json['name'] as String? ?? '',
      childrenList: (json['childrenList'] as List<dynamic>?)
              ?.map(
                  (e) => HelpCenterProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$$HelpCenterKindOfProductImplToJson(
        _$HelpCenterKindOfProductImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryOrder': instance.categoryOrder,
      'name': instance.name,
      'childrenList': instance.childrenList,
      'isSelected': instance.isSelected,
    };

_$HelpCenterProductImpl _$$HelpCenterProductImplFromJson(
        Map<String, dynamic> json) =>
    _$HelpCenterProductImpl(
      displayName: json['displayName'] as String?,
      model: json['model'] as String?,
      productId: json['productId'] as String?,
      mainImage: json['mainImage'] == null
          ? null
          : HelpCenterProductImage.fromJson(
              json['mainImage'] as Map<String, dynamic>),
      quickConnects: (json['quickConnects'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      tag: (json['tag'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HelpCenterProductImplToJson(
        _$HelpCenterProductImpl instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'model': instance.model,
      'productId': instance.productId,
      'mainImage': instance.mainImage,
      'quickConnects': instance.quickConnects,
      'tag': instance.tag,
    };

_$HelpCenterProductImageImpl _$$HelpCenterProductImageImplFromJson(
        Map<String, dynamic> json) =>
    _$HelpCenterProductImageImpl(
      as: json['as'] as String?,
      caption: json['caption'] as String?,
      height: (json['height'] as num?)?.toInt() ?? 0,
      width: (json['width'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] as String?,
      smallImageUrl: json['smallImageUrl'] as String?,
    );

Map<String, dynamic> _$$HelpCenterProductImageImplToJson(
        _$HelpCenterProductImageImpl instance) =>
    <String, dynamic>{
      'as': instance.as,
      'caption': instance.caption,
      'height': instance.height,
      'width': instance.width,
      'imageUrl': instance.imageUrl,
      'smallImageUrl': instance.smallImageUrl,
    };
