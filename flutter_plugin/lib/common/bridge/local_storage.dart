import 'package:flutter/services.dart';

/// 本地持久化数据
class LocalStorage {
  LocalStorage._internal();
  factory LocalStorage() => _instance;
  static final LocalStorage _instance = LocalStorage._internal();
  final _plugin =
      const MethodChannel('com.dreame.flutter/module_local_storage');

  /// 删除缓存
  Future<bool> remove(String key, {String fileName = ''}) async {
    return await _plugin
        .invokeMethod('remove', {'key': key, 'fileName': fileName});
  }

  Future<bool> clear({String fileName = ''}) async {
    return await _plugin.invokeMethod('clear', {'fileName': fileName});
  }

  Future<bool> containsKey(String key, {String fileName = ''}) async {
    return await _plugin
        .invokeMethod('containsKey', {'key': key, 'fileName': fileName});
  }

  Future<List<String>> getKeys({String fileName = ''}) async {
    final result =
        await _plugin.invokeListMethod('getKeys', {'fileName': fileName});
    if (result != null) {
      return result.map((e) => e as String).toList();
    } else {
      return [];
    }
  }

  /// put String
  Future<bool> putString(String key, String value,
      {String fileName = ''}) async {
    return await _plugin.invokeMethod(
        'putString', {'key': key, 'value': value, 'fileName': fileName});
  }

  /// get String
  Future<String?> getString(String key, {String fileName = ''}) {
    return _plugin
        .invokeMethod('getString', {'key': key, 'fileName': fileName});
  }

  /// put int
  Future<bool> putInt(String key, int value, {String fileName = ''}) async {
    return await _plugin.invokeMethod(
        'putInt', {'key': key, 'value': value, 'fileName': fileName});
  }

  /// get int
  Future<int?> getInt(String key, {String fileName = ''}) {
    return _plugin.invokeMethod('getInt', {'key': key, 'fileName': fileName});
  }

  /// put int
  Future<bool> putLong(String key, int value, {String fileName = ''}) async {
    return await _plugin.invokeMethod(
        'putLong', {'key': key, 'value': value, 'fileName': fileName});
  }

  /// get int
  Future<int?> getLong(String key, {String fileName = ''}) {
    return _plugin.invokeMethod('getLong', {'key': key, 'fileName': fileName});
  }

  /// putBool
  Future<bool> putBool(String key, bool value, {String fileName = ''}) async {
    return await _plugin.invokeMethod(
        'putBool', {'key': key, 'value': value, 'fileName': fileName});
  }

  /// getBool
  Future<bool?> getBool(String key, {String fileName = ''}) {
    return _plugin.invokeMethod('getBool', {'key': key, 'fileName': fileName});
  }

  /// putStringList
  Future<bool> putStringList(String key, List<String> value,
      {String fileName = ''}) async {
    return await _plugin.invokeMethod(
        'putStringList', {'key': key, 'value': value, 'fileName': fileName});
  }

  /// getStringList
  Future<List<String>?> getStringList(String key,
      {String fileName = ''}) async {
    return await _plugin
        .invokeListMethod('getStringList', {'key': key, 'fileName': fileName});
  }
}
