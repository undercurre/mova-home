import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/mall_debug_model.dart';
import 'package:flutter_plugin/ui/page/developer/mall_debug/mall_debug_page_ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mall_debug_page_state_notifier.g.dart';

@riverpod
class MallDebugPageStateNotifier extends _$MallDebugPageStateNotifier {
  late MallDebugModel _mallDebugModel;
  @override
  MallDebugPageUIState build() {
    return MallDebugPageUIState();
  }

  void initData() {
    updateStatus();
  }

  Future<void> updateStatus() async {
    _mallDebugModel = await MallDebugModel.getMallDebugInfo('mall_debug_info');
    state = state.copyWith(
      host: _mallDebugModel.host,
      enable: _mallDebugModel.enable,
    );

    debugPrint('objecsssst--_mallDebugModel--${_mallDebugModel.toJson()}');
  }

  Future<void> updateEnable() async {
    _mallDebugModel.enable = !_mallDebugModel.enable;
    state = state.copyWith(enable: !state.enable);
    await _mallDebugModel.refreshDebugInfo('mall_debug_info');
  }

  Future<void> updateHost(String host) async {
    _mallDebugModel.host = host;

    state = state.copyWith(host: host);
    await _mallDebugModel.refreshDebugInfo('mall_debug_info');
  }
}
