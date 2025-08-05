import 'package:freezed_annotation/freezed_annotation.dart';

part 'warranty_debug_model.freezed.dart';
part 'warranty_debug_model.g.dart';

@unfreezed
class WarrantyDebugModel with _$WarrantyDebugModel {
  factory WarrantyDebugModel({
    @Default('') String countryCode,
    @Default(false) bool useCNShopifyLink,
    @Default(false) bool showOverseaMall,
    @Default(false) bool isDebug,
  }) = _WarrantyDebugModel;

  factory WarrantyDebugModel.fromJson(Map<String, dynamic> json) =>
      _$WarrantyDebugModelFromJson(json);
}
