import 'dart:collection';
import 'dart:convert';

import 'package:flutter_plugin/common/bridge/local_storage.dart';

class MallDebugModel {
  String host = '';
  bool enable = false;
  MallDebugModel({this.host = '', this.enable = false});

  factory MallDebugModel.fromJson(Map<String, dynamic> json) {
    return MallDebugModel(
      host: json['host'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = HashMap();
    map['host'] = host;
    map['enable'] = enable;
    return map;
  }

  static Future<MallDebugModel> getMallDebugInfo(String key) async {
    String? info = await LocalStorage().getString(key);
    if (info == null) {
      return MallDebugModel();
    }
    Map<String, dynamic> map = jsonDecode(info);
    return MallDebugModel.fromJson(map);
  }

  Future<void> refreshDebugInfo(String key) async {
    Map<String, dynamic> map = toJson();
    String jsonString = jsonEncode(map);
    await LocalStorage().putString(key, jsonString);
  }
}
