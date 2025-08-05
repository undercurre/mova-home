// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_theme_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppThemeModel {
  String get title => throw _privateConstructorUsedError;
  set title(String value) => throw _privateConstructorUsedError;
  String get normalIcon => throw _privateConstructorUsedError;
  set normalIcon(String value) => throw _privateConstructorUsedError;
  String get selectedIcon => throw _privateConstructorUsedError;
  set selectedIcon(String value) => throw _privateConstructorUsedError;
  bool get selected => throw _privateConstructorUsedError;
  set selected(bool value) => throw _privateConstructorUsedError;
  ClickCallback? get onTouchUp => throw _privateConstructorUsedError;
  set onTouchUp(ClickCallback? value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppThemeModelCopyWith<AppThemeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppThemeModelCopyWith<$Res> {
  factory $AppThemeModelCopyWith(
          AppThemeModel value, $Res Function(AppThemeModel) then) =
      _$AppThemeModelCopyWithImpl<$Res, AppThemeModel>;
  @useResult
  $Res call(
      {String title,
      String normalIcon,
      String selectedIcon,
      bool selected,
      ClickCallback? onTouchUp});
}

/// @nodoc
class _$AppThemeModelCopyWithImpl<$Res, $Val extends AppThemeModel>
    implements $AppThemeModelCopyWith<$Res> {
  _$AppThemeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? normalIcon = null,
    Object? selectedIcon = null,
    Object? selected = null,
    Object? onTouchUp = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      normalIcon: null == normalIcon
          ? _value.normalIcon
          : normalIcon // ignore: cast_nullable_to_non_nullable
              as String,
      selectedIcon: null == selectedIcon
          ? _value.selectedIcon
          : selectedIcon // ignore: cast_nullable_to_non_nullable
              as String,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
      onTouchUp: freezed == onTouchUp
          ? _value.onTouchUp
          : onTouchUp // ignore: cast_nullable_to_non_nullable
              as ClickCallback?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppThemeModelImplCopyWith<$Res>
    implements $AppThemeModelCopyWith<$Res> {
  factory _$$AppThemeModelImplCopyWith(
          _$AppThemeModelImpl value, $Res Function(_$AppThemeModelImpl) then) =
      __$$AppThemeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String normalIcon,
      String selectedIcon,
      bool selected,
      ClickCallback? onTouchUp});
}

/// @nodoc
class __$$AppThemeModelImplCopyWithImpl<$Res>
    extends _$AppThemeModelCopyWithImpl<$Res, _$AppThemeModelImpl>
    implements _$$AppThemeModelImplCopyWith<$Res> {
  __$$AppThemeModelImplCopyWithImpl(
      _$AppThemeModelImpl _value, $Res Function(_$AppThemeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? normalIcon = null,
    Object? selectedIcon = null,
    Object? selected = null,
    Object? onTouchUp = freezed,
  }) {
    return _then(_$AppThemeModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      normalIcon: null == normalIcon
          ? _value.normalIcon
          : normalIcon // ignore: cast_nullable_to_non_nullable
              as String,
      selectedIcon: null == selectedIcon
          ? _value.selectedIcon
          : selectedIcon // ignore: cast_nullable_to_non_nullable
              as String,
      selected: null == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool,
      onTouchUp: freezed == onTouchUp
          ? _value.onTouchUp
          : onTouchUp // ignore: cast_nullable_to_non_nullable
              as ClickCallback?,
    ));
  }
}

/// @nodoc

class _$AppThemeModelImpl implements _AppThemeModel {
  _$AppThemeModelImpl(
      {this.title = '',
      this.normalIcon = '',
      this.selectedIcon = '',
      this.selected = true,
      this.onTouchUp});

  @override
  @JsonKey()
  String title;
  @override
  @JsonKey()
  String normalIcon;
  @override
  @JsonKey()
  String selectedIcon;
  @override
  @JsonKey()
  bool selected;
  @override
  ClickCallback? onTouchUp;

  @override
  String toString() {
    return 'AppThemeModel(title: $title, normalIcon: $normalIcon, selectedIcon: $selectedIcon, selected: $selected, onTouchUp: $onTouchUp)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppThemeModelImplCopyWith<_$AppThemeModelImpl> get copyWith =>
      __$$AppThemeModelImplCopyWithImpl<_$AppThemeModelImpl>(this, _$identity);
}

abstract class _AppThemeModel implements AppThemeModel {
  factory _AppThemeModel(
      {String title,
      String normalIcon,
      String selectedIcon,
      bool selected,
      ClickCallback? onTouchUp}) = _$AppThemeModelImpl;

  @override
  String get title;
  set title(String value);
  @override
  String get normalIcon;
  set normalIcon(String value);
  @override
  String get selectedIcon;
  set selectedIcon(String value);
  @override
  bool get selected;
  set selected(bool value);
  @override
  ClickCallback? get onTouchUp;
  set onTouchUp(ClickCallback? value);
  @override
  @JsonKey(ignore: true)
  _$$AppThemeModelImplCopyWith<_$AppThemeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
