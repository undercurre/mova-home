
import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_setting_ui_state.freezed.dart';

@freezed
class CommonSettingPageUiState with _$CommonSettingPageUiState{
  factory CommonSettingPageUiState({
    @Default('0B') String cacheSize,
    @Default('') String reginDisplay,
    @Default('') String displayLang,
  }) = _CommonSettingPageUiState;
}