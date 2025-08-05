import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_theme_model.freezed.dart';

typedef ClickCallback = void Function();

@unfreezed
class AppThemeModel with _$AppThemeModel {
  factory AppThemeModel({
    @Default('') String title,
    @Default('') String normalIcon,
    @Default('') String selectedIcon,
    @Default(true) bool selected,
    ClickCallback? onTouchUp,
  }) = _AppThemeModel;
}
