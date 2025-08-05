import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_resource_config_model.freezed.dart';
part 'product_resource_config_model.g.dart';

@freezed
class ProductResourceConfigModel with _$ProductResourceConfigModel {
  const factory ProductResourceConfigModel({
    String? productId,
    String? dictKey,
    String? dictValue,
    String? fileName,
    String? filePath,
  }) = _ProductResourceConfigModel;

  factory ProductResourceConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ProductResourceConfigModelFromJson(json);
}
