import 'dart:convert';

import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/model/debug/gps_debug_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/developer/gps_debug/gps_debug_ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gps_debug_state_notifier.g.dart';

@riverpod
class GPSDebugStateNotifier extends _$GPSDebugStateNotifier {
  static String GPS_DEBUG_MODEL = 'kGPSDebugModel';

  @override
  GPSDebugUiState build() {
    return GPSDebugUiState();
  }

  Future<void> initData() async {
    GPSDebugModel debugModel = await getLocation();
    state = state.copyWith(debugModel: debugModel);
  }

  Future<GPSDebugModel> getLocation() async {
    String debugModel = await LocalStorage().getString(GPS_DEBUG_MODEL) ?? '';
    if (debugModel.isEmpty) {
      return GPSDebugModel();
    }
    GPSDebugModel gpsDebugModel =
        GPSDebugModel.fromJson(json.decode(debugModel));
    return gpsDebugModel;
  }

  Future<void> updateLocation(
      {String? longitude, String? latitude, bool? isDebug}) async {
    var debugModel = state.debugModel ?? await getLocation();
    if (longitude != null) {
      debugModel.longitude = longitude;
    }
    if (latitude != null) {
      debugModel.latitude = latitude;
    }
    if (isDebug != null) {
      debugModel.isDebug = isDebug;
    }
    state = state.copyWith(debugModel: debugModel);
  }

  Future<void> saveLocation() async {
    await LocalStorage()
        .putString(GPS_DEBUG_MODEL, json.encode(state.debugModel?.toJson()));
    state = state.copyWith(event: const ToastEvent(text: '已保存'));
  }

  Future<void> clearLocationData() async {
    await LocalStorage().remove(GPS_DEBUG_MODEL);
    state = state.copyWith(
        debugModel: null, event: const ToastEvent(text: 'GPS 数据已清理'));
  }
}
