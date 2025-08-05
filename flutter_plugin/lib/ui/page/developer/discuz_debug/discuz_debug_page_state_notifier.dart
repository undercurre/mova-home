import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/mall_debug_model.dart';
import 'package:flutter_plugin/ui/page/developer/discuz_debug/discuz_debug_page_ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discuz_debug_page_state_notifier.g.dart';

@riverpod
class DiscuzDebugPageStateNotifier extends _$DiscuzDebugPageStateNotifier {
  late MallDebugModel _mallDebugModel;
  @override
  DiscuzDebugPageUIState build() {
    return DiscuzDebugPageUIState();
  }

  void initData() {
    updateStatus();
  }

  Future<void> updateStatus() async {
    _mallDebugModel =
        await MallDebugModel.getMallDebugInfo('discuz_debug_info');
    state = state.copyWith(
      host: _mallDebugModel.host,
      enable: _mallDebugModel.enable,
    );

    debugPrint('objecsssst--_mallDebugModel--${_mallDebugModel.toJson()}');
  }

  Future<void> updateEnable() async {
    _mallDebugModel.enable = !_mallDebugModel.enable;
    state = state.copyWith(enable: !state.enable);
    await _mallDebugModel.refreshDebugInfo('discuz_debug_info');
  }

  Future<void> updateHost(String host) async {
    _mallDebugModel.host = host;

    state = state.copyWith(host: host);
    await _mallDebugModel.refreshDebugInfo('discuz_debug_info');
  }
}
