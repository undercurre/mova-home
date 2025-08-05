import 'dart:convert';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/utils/logutils.dart';

/// 语言、国家
class LocalModule {
  LocalModule._internal();

  factory LocalModule() => _instance;
  static final LocalModule _instance = LocalModule._internal();
  final _plugin = const MethodChannel('com.dreame.flutter/module_local');

  /// 获取当前语言tag  带国家码
  /// Pair[语言tag,国家码]
  Future<Pair> getLangTagCode() async {
    final map = await _plugin.invokeMethod('getLangTagCode');
    return Pair(map['languageCode'], map['countryCode']);
  }

  /// 获取当前语言tag
  /// @return zh/zh-TW/HK
  Future<String> getLangTag({String defaultV = 'zh'}) async {
    return await _plugin.invokeMethod('getLangTag') ?? Future.value(defaultV);
  }

  /// 设置当前语言
  /// @return zh/zh-TW/HK
  Future<void> setLanguage(LanguageModel language) async {
    try {
      return await _plugin.invokeMethod('setLangTag', language.toJson());
    } on MissingPluginException {
      LogUtils.e(
          'No implementation found for method setLanguage on channel ${_plugin.name}');
      return Future.value();
    }
  }

  /// 更新当前国家
  Future<bool?> setCurrentCountry(RegionItem country) {
    return _plugin.invokeMethod('setCurrentCountry', country.toJson());
  }

  /// 获取当前国家
  Future<RegionItem> getCurrentCountry() async {
    String accountJson = await _plugin.invokeMethod('getCurrentCountry');
    return RegionItem.fromMap(json.decode(accountJson));
  }

  /// 获取当前CountryCode
  Future<String> getCountryCode() async {
    final country = await getCurrentCountry();
    return country.countryCode;
  }

  /// 获取当前serverSite
  Future<String> serverSite() async {
    final country = await getCurrentCountry();
    var domain = country.domain;
    var fixdomain = domain.substring(0, domain.indexOf('.'));
    if (fixdomain.contains('-')) {
      return fixdomain.substring(0, fixdomain.indexOf('-'));
    }
    return fixdomain;
  }

  /// 获取当前时区
  Future<String?> getTimeZone() {
    return _plugin.invokeMethod('getTimeZone');
  }

  /// 更新当前主题
  Future<bool?> setCurrentTheme(String type) {
    return _plugin.invokeMethod('setAppTheme', type);
  }

}
