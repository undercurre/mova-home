/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-26 15:48:06
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-09-02 11:40:21
 * @FilePath: /flutter_plugin/lib/ui/page/language/language_item.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

class LanguageItem {
  LanguageItem(
      {required this.displayLang,
      required this.langTag,
      required this.country});
  String displayLang;
  String langTag;
  String country;

  String toDreamelanTag() {
    // if (langTag == 'zh' && (country == 'TW' || country == 'HK')) {
    //   return '$langTag-$country';
    // }
    return langTag;
  }

  bool isChinese() {
    return toDreamelanTag() == 'zh';
  }

  Locale toLanguageLocal() {
    if (langTag == 'zh') {
      return Locale(langTag, country);
    } else if (langTag == 'zh-HK') {
      return Locale('zh', 'HK');
    } else if (langTag == 'zh-TW') {
      return Locale('zh', 'TW');
    }
    return Locale(langTag, null);
  }

  LanguageItem copyWith({required LanguageItem language}) {
    return LanguageItem(
      country: language.country,
      langTag: language.langTag,
      displayLang: language.displayLang,
    );
  }

  static LanguageItem fromJson(Map<String, dynamic> map) {
    String displayLang = map['displayLang'];
    String langTag = map['langTag'];
    String country = map['country'];
    return LanguageItem(
        displayLang: displayLang, langTag: langTag, country: country);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['displayLang'] = displayLang;
    map['langTag'] = langTag;
    map['country'] = country;
    return map;
  }

  static List<LanguageItem> getItems(List<Map<String, dynamic>> maps) {
    List<LanguageItem> items = [];
    for (var map in maps) {
      LanguageItem item = LanguageItem.fromJson(map);
      items.add(item);
    }
    return items;
  }

  static Future<List<LanguageItem>> getAllLanguageList() async {
    String jsonString = await loadAsset();
    List<dynamic> json = jsonDecode(
      jsonString,
    );
    List<LanguageItem> items =
        LanguageItem.getItems(List<Map<String, dynamic>>.from(json));
    return items;
  }

  static Future<String> loadAsset() async {
    // RegionItem.j
    return await rootBundle.loadString('assets/resource/language.json');
  }

  // static Future<LanguageItem> getLanguageFromDreameLangTag(
  //     String dreametag) async {
  //   List<LanguageItem> items = await getAllLanguageList();
  //   late LanguageItem defalueItem;
  //   for (var element in items) {
  //     if (element.toDreamelanTag() == dreametag) {
  //       return element;
  //     }
  //     if (element.langTag == 'en') {
  //       defalueItem = element;
  //     }
  //   }
  //   return defalueItem;
  // }

  static Future<List<Locale>> supportLanguage() async {
    List<LanguageItem> languages = await getAllLanguageList();
    return languages.map((e) => e.toLanguageLocal()).toList();
  }
}
