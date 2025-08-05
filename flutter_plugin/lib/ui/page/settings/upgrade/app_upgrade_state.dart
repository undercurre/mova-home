import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_upgrade_state.freezed.dart';

@freezed
class AppUpgradeState with _$AppUpgradeState {
  factory AppUpgradeState(
      {@Default(false) bool isForce,
      @Default(false) bool downFirst,
      @Default('') String versionName,
      @Default('') String versionDesc,
      @Default('') String downloadUrl,
      @Default(0) int progress,
      @Default(false) bool downloading,
      @Default(false) bool installApk,
      @Default(false) bool hasNewVersion,
      CommonUIEvent? uiEvent}) = _AppUpgradeState;
}
