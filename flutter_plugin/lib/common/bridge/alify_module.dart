import 'dart:convert';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/services.dart';

class AlifyModule {
  AlifyModule._internal();
  factory AlifyModule() => _instance;
  static final AlifyModule _instance = AlifyModule._internal();
  final _plugin = const MethodChannel('com.dreame.flutter/module_alify');

  Future<Map<String, dynamic>?> checkAliDevice(VacuumDeviceModel device) {
    return _plugin
        .invokeMapMethod('checkAliDevice', {'device': json.encode(device)});
  }
}
