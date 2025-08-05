import 'package:freezed_annotation/freezed_annotation.dart';
part 'after_sale_config.freezed.dart';
part 'after_sale_config.g.dart';

@freezed
class AfterSaleConfig with _$AfterSaleConfig {
  factory AfterSaleConfig(
      {String? contactNumber,
      String? website,
      String? email,
      String? country,
      String? ext,
      @Default(0) int onlineService}) = _AfterSaleConfig;

  factory AfterSaleConfig.fromJson(Map<String, dynamic> json) =>
      _$AfterSaleConfigFromJson(json);
}
