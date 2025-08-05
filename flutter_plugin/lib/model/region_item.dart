import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';

class RegionItem {
  // ignore: non_constant_identifier_names
  String? _domain_abbreviation;
  String? _domainAliFy;
  String? _iosDomain;
  String? _androidDomain;
  String en;

  // ignore: non_constant_identifier_names
  String name;
  String pinyin;
  String countryCode;
  String code;
  bool isSelect = false;

  String get domainForAliFy {
    return (_domain_abbreviation ?? _domainAliFy) ?? '';
  }

  String get domain {
    return (_androidDomain ?? _iosDomain) ?? '';
  }

  bool get isChinaServer {
    return countryCode.toLowerCase() == 'cn';
  }

  RegionItem(
      {required this.en,
      required this.name,
      required this.pinyin,
      required this.countryCode,
      required this.code});

  static RegionItem regionItemCreate(
      {required String countryCode, required String code}) {
    return RegionItem(
        en: '', name: '', pinyin: '', countryCode: countryCode, code: code);
  }

  static RegionItem fromMap(Map<String, dynamic> map) {
    RegionItem item = RegionItem.regionItemCreate(countryCode: '', code: '');
    item._domain_abbreviation = map['domain_abbreviation'];
    item._domainAliFy = map['domainAliFy'];
    item._iosDomain = map['currentDomain'];
    item._androidDomain = map['domain'];
    item.en = map['en'];
    item.name = map['name'];
    item.pinyin = map['pinyin'];
    item.countryCode = map['short'];
    item.code = map['tel'];
    return item;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = HashMap();
    map['domain_abbreviation'] = domainForAliFy;
    map['domainAliFy'] = domainForAliFy;
    map['currentDomain'] = domain;
    map['domain'] = domain;
    map['en'] = en;
    map['name'] = name;
    map['pinyin'] = pinyin;
    map['short'] = countryCode;
    map['countryCode'] = countryCode;
    map['tel'] = code;
    map['code'] = code;
    return map;
  }

  static List<RegionItem> listFromMaps(List<dynamic> maps) {
    List<RegionItem> items = [];
    for (var map in maps) {
      RegionItem item = RegionItem.fromMap(map);
      items.add(item);
    }
    return items;
  }

  static Future<List<RegionItem>> getRegions() async {
    String jsonString =
        await rootBundle.loadString('assets/resource/country.json');
    var json = jsonDecode(jsonString);
    List<RegionItem> items = RegionItem.listFromMaps(json);
    return items;
  }

  static Future<RegionItem?> getRegionFromCountryCode(
      String countryCode) async {
    List<RegionItem> regionItems = await getRegions();
    return regionItems
        .firstWhere((element) => element.countryCode == countryCode);
  }

  static Future<RegionItem?> getRegionFromPhoneCode(String phoneCode) async {
    List<RegionItem> regionItems = await getRegions();
    return regionItems.firstWhere((element) => element.code == phoneCode);
  }
}
