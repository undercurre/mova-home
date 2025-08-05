import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'about_page_ui_state.freezed.dart';

@freezed
class AboutPageUiState with _$AboutPageUiState {
  factory AboutPageUiState(
      {@Default('') String appVersion,
      @Default('') String privacyUrl,
      @Default('') String agreementUrl,
      @Default('') String shareListUrl,
      @Default('') String permissionUrl,
      @Default(false) bool hasNewVersion,
      @Default(false) bool uiNewVersion,
      @Default('') String newVersionName,
      CommonUIEvent? uiEvent}) = _AboutPageUiState;
}
