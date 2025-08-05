// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_ui_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProdcutListUiStateImpl _$$ProdcutListUiStateImplFromJson(
        Map<String, dynamic> json) =>
    _$ProdcutListUiStateImpl(
      loading: json['loading'] as bool? ?? false,
      menuList: (json['menuList'] as List<dynamic>?)
              ?.map((e) => KindOfProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      productList: (json['productList'] as List<dynamic>?)
              ?.map((e) => SeriesOfProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      menuIndexPath: json['menuIndexPath'] as Map<String, dynamic>? ?? const {},
      scannedList: (json['scannedList'] as List<dynamic>?)
              ?.map((e) => IotDevice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedIdx: json['selectedIdx'] == null
          ? null
          : DMIndexPath.fromJson(json['selectedIdx'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProdcutListUiStateImplToJson(
        _$ProdcutListUiStateImpl instance) =>
    <String, dynamic>{
      'loading': instance.loading,
      'menuList': instance.menuList,
      'productList': instance.productList,
      'menuIndexPath': instance.menuIndexPath,
      'scannedList': instance.scannedList,
      'selectedIdx': instance.selectedIdx,
    };

_$DMIndexPathImpl _$$DMIndexPathImplFromJson(Map<String, dynamic> json) =>
    _$DMIndexPathImpl(
      section: (json['section'] as num?)?.toInt() ?? 0,
      row: (json['row'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DMIndexPathImplToJson(_$DMIndexPathImpl instance) =>
    <String, dynamic>{
      'section': instance.section,
      'row': instance.row,
    };
