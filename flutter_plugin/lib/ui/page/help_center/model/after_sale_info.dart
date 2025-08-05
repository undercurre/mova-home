import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'after_sale_info.freezed.dart';
part 'after_sale_info.g.dart';

class AfterSaleInfo {
  String? contactNumber;
  String? country;
  String? email;
  String? ext;
  String? remarks;
  String? website;
  List<AfterSaleItem> saleItems;
  bool onlineService = false;
  int? onlineServiceType = 0; // 0: 未知 1: zendesk 2: livechat 3: 智齿

  AfterSaleInfo({
    this.contactNumber,
    this.country,
    this.email,
    this.ext,
    this.remarks,
    this.website,
    required this.saleItems,
    this.onlineService = false,
    this.onlineServiceType,
  });

  factory AfterSaleInfo.fromJson(Map<String, dynamic> json) {
    String? contactNumber = json['contactNumber'];
    String? country = json['contactNumber'];
    String? email = json['email'];

    String? remarks = json['remarks'];
    String? website = json['website'];

    int? onlineServiceType = json['onlineServiceType'];

    String ext = json['ext'] ??
        '[{"key": "text_offical_website","valueList" : [{"channelContent" : "https://global.dreametech.com/","jumpContent" : "https://global.dreametech.com/","iosJumpLink" : "https://global.dreametech.com/",}]}]';
    List<dynamic> jsonDatas = jsonDecode(ext);
    List<AfterSaleItem> saleItems =
        jsonDatas.map((e) => AfterSaleItem.fromJson(e)).toList();

    bool onlineService = (json['onlineService'] ?? 0) == 1;
    AfterSaleInfo info = AfterSaleInfo(
      contactNumber: contactNumber,
      country: country,
      email: email,
      remarks: remarks,
      website: website,
      saleItems: saleItems,
      onlineService: onlineService,
      onlineServiceType: onlineServiceType,
    );
    return info;
  }
}

@freezed
class AfterSaleItem with _$AfterSaleItem {
  factory AfterSaleItem({
    String? key,
    @Default([]) List<AfterSaleItemValue> valueList,
  }) = _AfterSaleItem;
  factory AfterSaleItem.fromJson(Map<String, dynamic> json) =>
      _$AfterSaleItemFromJson(json);
}

@freezed
class AfterSaleItemValue with _$AfterSaleItemValue {
  factory AfterSaleItemValue({
    String? channelContent,
    String? jumpContent,
    String? androidJumpLink,
    String? iosJumpLink,
  }) = _AfterSaleItemValue;
  factory AfterSaleItemValue.fromJson(Map<String, dynamic> json) =>
      _$AfterSaleItemValueFromJson(json);
}
