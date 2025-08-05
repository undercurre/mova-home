import 'package:flutter_plugin/model/rn_debug_packages.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'developer_mode_page_ui_state.freezed.dart';

@unfreezed
class DeveloperModePageUIState with _$DeveloperModePageUIState {
  factory DeveloperModePageUIState({RNDebugPackages? rnDebugPackages}) =
      _DeveloperModePageUIState;
}
