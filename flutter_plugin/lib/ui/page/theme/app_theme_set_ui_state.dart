import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_theme_model.dart';

part 'app_theme_set_ui_state.freezed.dart';

typedef ClickCallback = void Function();

@unfreezed
class AppThemeSetUiState with _$AppThemeSetUiState {
  factory AppThemeSetUiState({
    @Default([]) List<AppThemeModel> dataList,
  }) = _AppThemeSetUiState;
}
