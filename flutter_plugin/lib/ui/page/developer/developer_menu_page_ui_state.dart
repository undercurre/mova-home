import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'developer_menu_page_ui_state.freezed.dart';

@unfreezed
class DeveloperMenuPageUIState with _$DeveloperMenuPageUIState {
  factory DeveloperMenuPageUIState({
    @Default(false) bool afterSaleEnable,
    @Default(false) bool commonPairNetEnable,
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(false) bool sdkTestPluginEnable,
    @Default(false) bool concurrentTestEnable,
    @Default(false) bool enableConventionCenter,
  }) = _DeveloperMenuPageUIState;
}
