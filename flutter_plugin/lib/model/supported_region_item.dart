import 'package:freezed_annotation/freezed_annotation.dart';

part 'supported_region_item.freezed.dart';
part 'supported_region_item.g.dart';

@freezed
class SupportedRegionItem with _$SupportedRegionItem {
  factory SupportedRegionItem({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'is_enabled') int? isEnabled,
  }) = _SupportedRegionItem;

  factory SupportedRegionItem.fromJson(Map<String, dynamic> json) =>
      _$SupportedRegionItemFromJson(json);
}
