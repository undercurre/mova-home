import 'dart:convert';
import 'dart:ui';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';

class LanguageStore {
  static final LanguageStore _singleton = LanguageStore._internal();
  late List<LanguageModel> _languages;
  LanguageModel? _currentLanguage;
  factory LanguageStore() {
    return _singleton;
  }
  LanguageStore._internal();
  Future<void> register() async {
    List<LanguageModel> languages = await getAllLanguageList();
    _languages = languages;
    String? currentLanguage = await LocalModule().getLangTag();
    // if (currentLanguage == 'zh-CN') {
    //   currentLanguage = 'zh';
    // }
    LanguageModel language = await getLanguageFromLangTag(currentLanguage);
    _currentLanguage = language;
  }

  /// 从assets中读取语言列表
  Future<List<LanguageModel>> getAllLanguageList() async {
    String jsonString =
    await rootBundle.loadString('assets/resource/language.json');
    Iterable elements = json.decode(jsonString);
    List<LanguageModel> list = List<LanguageModel>.from(
        elements.map((e) => LanguageModel.fromJson(e)));
    return list;
  }

  Future<LanguageModel> getLanguageFromDreameLangTag(String dreametag) async {
    List<LanguageModel> items = _languages;
    late LanguageModel defalueItem;
    for (var element in items) {
      if (element.toDreamelanTag() == dreametag) {
        return element;
      }
      if (element.langTag == 'en') {
        defalueItem = element;
      }
    }
    return defalueItem;
  }

  Future<LanguageModel> getLanguageFromLangTag(String langtag) async {
    List<LanguageModel> items = _languages;
    late LanguageModel defalueItem;
    for (var element in items) {
      if (element.langTag == langtag) {
        return element;
      }
      if (element.langTag == 'en') {
        defalueItem = element;
      }
    }
    return defalueItem;
  }

  List<LanguageModel> getLanguages() {
    return _languages;
  }

  LanguageModel getCurrentLanguage() {
    return _currentLanguage!;
  }

  List<Locale> supportLocales() {
    return _languages.map((e) => e.toLanguageLocal()).toList();
  }

  Future<void> updateLanguageFrom({required LanguageModel language}) async {
    _currentLanguage = language;
    await updatePrefer(language.toDreamelanTag());
  }

  Future<void> updatePrefer(String dreameLanTag) async {
    LanguageModel language = await getLanguageFromDreameLangTag(dreameLanTag);
    await LocalModule().setLanguage(language);
  }

  // void registerCurrentLanguage({required Locale locale}) {
  //   if (_currentLanguage != null) return;
  //   String dreameLangTag = '';
  //   if (locale.languageCode == 'zh') {
  //     if (locale.scriptCode == 'Hans') {
  //       dreameLangTag = 'zh';
  //     } else if (locale.countryCode == 'TW') {
  //       dreameLangTag = 'zh-TW';
  //     } else if (locale.countryCode == 'HK') {
  //       dreameLangTag = 'zh-HK';
  //     } else {
  //       dreameLangTag = 'zh';
  //     }
  //   } else {
  //     dreameLangTag = locale.languageCode;
  //   }
  //   late LanguageModel defalueItem;
  //   for (var element in _languages) {
  //     if (element.toDreamelanTag() == dreameLangTag) {
  //       defalueItem = element;
  //       break;
  //     }
  //     if (element.langTag == 'en') {
  //       defalueItem = element;
  //     }
  //   }
  //   _currentLanguage = defalueItem;
  //   // updatePrefer(defalueItem.toDreamelanTag());
  // }

  bool isChinese() {
    return getCurrentLanguage().isChinese();
  }
}
