import 'dart:async';
import 'package:dreame_flutter_base_event_tracker/default/model/default_event.dart';
import 'package:dreame_flutter_base_event_tracker/event_tracker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LogModule {
  LogModule._internal();
  factory LogModule() => _instance;
  static final LogModule _instance = LogModule._internal();
  final _plugin = const MethodChannel('com.dreame.flutter/module_log');

  Future<void> log(String message,
      {String level = 'debug', String stackTrace = ''}) {
    try {
      return _plugin.invokeMethod('log',
          {'level': level, 'message': message, 'stackTrace': stackTrace});
    } catch (e) {
      debugPrint('LogModule error: $e');
    }
    return Future.value();
  }

  Future<void> close() {
    try {
      return _plugin.invokeMethod('close');
    } catch (e) {
      debugPrint('LogModule uploadLog error: $e');
    }
    return Future.value();
  }

  Future<void> uploadLog(String id) {
    try {
      return _plugin.invokeMethod('uploadLog', {'msgId': id});
    } catch (e) {
      debugPrint('LogModule uploadLog error: $e');
    }
    return Future.value();
  }

  void eventReport(int modelCode, int eventCode,
      {int int1 = 0,
      int int2 = 0,
      int int3 = 0,
      int int4 = 0,
      int int5 = 0,
      int pluginVer = 0,
      String str1 = '',
      String str2 = '',
      String str3 = '',
      String rawStr = '',
      String did = '',
      String model = '',
      int? stayTime}) {
    try {
      var currentSecond = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      var event = DefaultEvent(
          modelCode: modelCode,
          eventCode: eventCode,
          pluginVer: pluginVer,
          int1: int1 < 0 ? 0 : int1,
          int2: int2 < 0 ? 0 : int2,
          int3: int3 < 0 ? 0 : int3,
          int4: int4 < 0 ? 0 : int4,
          int5: int5 < 0 ? 0 : int5,
          str1: str1,
          str2: str2,
          str3: str3,
          rawStr: rawStr,
          did: did,
          model: model,
          currentSecond: currentSecond,
          remainSecond: stayTime);
      EventTracker().trackEvent(event);
    } catch (e) {
      debugPrint('eventReport error: $e');
    }
  }
}
