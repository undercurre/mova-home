import 'dart:convert';

import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/model/debug/warranty_debug_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/developer/warranty_debug/warranty_debug_ui_state.dart';
import 'package:flutter_plugin/ui/page/mine/warranty_cards/warranty_handler_utils.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'warranty_debug_state_notifier.g.dart';

@riverpod
class WarrantyDebugStateNotifier extends _$WarrantyDebugStateNotifier {
  @override
  WarrantyDebugUiState build() {
    return WarrantyDebugUiState();
  }

  Future<void> initData() async {
    WarrantyDebugModel debugModel = await getWarrantyContry();
    state = state.copyWith(debugModel: debugModel);
  }

  Future<WarrantyDebugModel> getWarrantyContry() async {
    String debugModel = await LocalStorage()
            .getString(WarrantyHandlerUtils.kWarrantyDebugModel) ??
        '';
    if (debugModel.isEmpty) {
      return WarrantyDebugModel();
    }
    WarrantyDebugModel warrantyDebugModel =
        WarrantyDebugModel.fromJson(json.decode(debugModel));
    return warrantyDebugModel;
  }

  Future<void> updateWarrantyContry({
    String? countryCode,
    bool? isDebug,
    bool? useCNShopifyLink,
    bool? showOverseaMall,
  }) async {
    var debugModel = state.debugModel ?? await getWarrantyContry();
    if (countryCode != null) {
      debugModel.countryCode = countryCode;
    }
    if (isDebug != null) {
      debugModel.isDebug = isDebug;
    }
    if (useCNShopifyLink != null) {
      debugModel.useCNShopifyLink = useCNShopifyLink;
    }
    if (showOverseaMall != null) {
      debugModel.showOverseaMall = showOverseaMall;
    }
    state = state.copyWith(debugModel: debugModel);
  }

  Future<void> saveCountry() async {
    await LocalStorage().putString(WarrantyHandlerUtils.kWarrantyDebugModel,
        json.encode(state.debugModel?.toJson()));
    LogUtils.d('warranty debug saveCountry: ${state.debugModel?.toJson()}');
    state = state.copyWith(event: const ToastEvent(text: '已保存'));
  }

  Future<void> clearMockedData() async {
    await LocalStorage().remove(WarrantyHandlerUtils.kWarrantyDebugModel);
    state = state.copyWith(event: const ToastEvent(text: '保修卡模拟数据已清理'));
  }
}
