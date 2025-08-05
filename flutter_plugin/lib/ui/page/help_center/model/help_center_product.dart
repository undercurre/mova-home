import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'help_center_product.freezed.dart';
part 'help_center_product.g.dart';

/// 产品品类，包含产品列表
@freezed
class HelpCenterKindOfProduct with _$HelpCenterKindOfProduct {
  factory HelpCenterKindOfProduct(
      {@Default('') String categoryId,
      @Default(-1) int categoryOrder,
      @Default('') String name,
      @Default([]) List<HelpCenterProduct> childrenList,

      // 调试字段
      @Default(false) bool isSelected}) = _HelpCenterKindOfProduct;

  factory HelpCenterKindOfProduct.fromJson(Map<String, dynamic> json) =>
      _$HelpCenterKindOfProductFromJson(json);
}

@unfreezed
class HelpCenterProduct with _$HelpCenterProduct {
  factory HelpCenterProduct({
    String? displayName,
    String? model,
    String? productId,
    HelpCenterProductImage? mainImage,
    @Default({}) Map<String, String> quickConnects,
    @Default(0) int tag,
  }) = _HelpCenterProduct;

  factory HelpCenterProduct.fromJson(Map<String, dynamic> json) =>
      _$HelpCenterProductFromJson(json);

  static HelpCenterProduct fromJsonString(String json) {
    debugPrint('json-------: $json');
    Map<String, dynamic> map = jsonDecode(json);
    debugPrint('json-------map--: $json');
    return HelpCenterProduct.fromJson(map);
  }

  static HelpCenterProduct fromProduct(Product product) {
    return HelpCenterProduct(
      displayName: product.displayName,
      model: product.model,
      productId: product.productId,
      quickConnects: product.quickConnects,
      mainImage: HelpCenterProductImage(
        imageUrl: product.mainImage?.imageUrl,
        smallImageUrl: product.mainImage?.smallImageUrl,
      ),
    );
  }
}

@freezed
class HelpCenterProductImage with _$HelpCenterProductImage {
  factory HelpCenterProductImage({
    String? as,
    String? caption,
    @Default(0) int height,
    @Default(0) int width,
    String? imageUrl,
    String? smallImageUrl,
  }) = _HelpCenterProductImage;

  factory HelpCenterProductImage.fromJson(Map<String, dynamic> json) =>
      _$HelpCenterProductImageFromJson(json);
}
