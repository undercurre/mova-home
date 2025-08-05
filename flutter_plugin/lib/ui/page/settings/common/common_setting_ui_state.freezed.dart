// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common_setting_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommonSettingPageUiState {
  String get cacheSize => throw _privateConstructorUsedError;
  String get reginDisplay => throw _privateConstructorUsedError;
  String get displayLang => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CommonSettingPageUiStateCopyWith<CommonSettingPageUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommonSettingPageUiStateCopyWith<$Res> {
  factory $CommonSettingPageUiStateCopyWith(CommonSettingPageUiState value,
          $Res Function(CommonSettingPageUiState) then) =
      _$CommonSettingPageUiStateCopyWithImpl<$Res, CommonSettingPageUiState>;
  @useResult
  $Res call({String cacheSize, String reginDisplay, String displayLang});
}

/// @nodoc
class _$CommonSettingPageUiStateCopyWithImpl<$Res,
        $Val extends CommonSettingPageUiState>
    implements $CommonSettingPageUiStateCopyWith<$Res> {
  _$CommonSettingPageUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cacheSize = null,
    Object? reginDisplay = null,
    Object? displayLang = null,
  }) {
    return _then(_value.copyWith(
      cacheSize: null == cacheSize
          ? _value.cacheSize
          : cacheSize // ignore: cast_nullable_to_non_nullable
              as String,
      reginDisplay: null == reginDisplay
          ? _value.reginDisplay
          : reginDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      displayLang: null == displayLang
          ? _value.displayLang
          : displayLang // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommonSettingPageUiStateImplCopyWith<$Res>
    implements $CommonSettingPageUiStateCopyWith<$Res> {
  factory _$$CommonSettingPageUiStateImplCopyWith(
          _$CommonSettingPageUiStateImpl value,
          $Res Function(_$CommonSettingPageUiStateImpl) then) =
      __$$CommonSettingPageUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String cacheSize, String reginDisplay, String displayLang});
}

/// @nodoc
class __$$CommonSettingPageUiStateImplCopyWithImpl<$Res>
    extends _$CommonSettingPageUiStateCopyWithImpl<$Res,
        _$CommonSettingPageUiStateImpl>
    implements _$$CommonSettingPageUiStateImplCopyWith<$Res> {
  __$$CommonSettingPageUiStateImplCopyWithImpl(
      _$CommonSettingPageUiStateImpl _value,
      $Res Function(_$CommonSettingPageUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cacheSize = null,
    Object? reginDisplay = null,
    Object? displayLang = null,
  }) {
    return _then(_$CommonSettingPageUiStateImpl(
      cacheSize: null == cacheSize
          ? _value.cacheSize
          : cacheSize // ignore: cast_nullable_to_non_nullable
              as String,
      reginDisplay: null == reginDisplay
          ? _value.reginDisplay
          : reginDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      displayLang: null == displayLang
          ? _value.displayLang
          : displayLang // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CommonSettingPageUiStateImpl implements _CommonSettingPageUiState {
  _$CommonSettingPageUiStateImpl(
      {this.cacheSize = '0B', this.reginDisplay = '', this.displayLang = ''});

  @override
  @JsonKey()
  final String cacheSize;
  @override
  @JsonKey()
  final String reginDisplay;
  @override
  @JsonKey()
  final String displayLang;

  @override
  String toString() {
    return 'CommonSettingPageUiState(cacheSize: $cacheSize, reginDisplay: $reginDisplay, displayLang: $displayLang)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonSettingPageUiStateImpl &&
            (identical(other.cacheSize, cacheSize) ||
                other.cacheSize == cacheSize) &&
            (identical(other.reginDisplay, reginDisplay) ||
                other.reginDisplay == reginDisplay) &&
            (identical(other.displayLang, displayLang) ||
                other.displayLang == displayLang));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, cacheSize, reginDisplay, displayLang);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommonSettingPageUiStateImplCopyWith<_$CommonSettingPageUiStateImpl>
      get copyWith => __$$CommonSettingPageUiStateImplCopyWithImpl<
          _$CommonSettingPageUiStateImpl>(this, _$identity);
}

abstract class _CommonSettingPageUiState implements CommonSettingPageUiState {
  factory _CommonSettingPageUiState(
      {final String cacheSize,
      final String reginDisplay,
      final String displayLang}) = _$CommonSettingPageUiStateImpl;

  @override
  String get cacheSize;
  @override
  String get reginDisplay;
  @override
  String get displayLang;
  @override
  @JsonKey(ignore: true)
  _$$CommonSettingPageUiStateImplCopyWith<_$CommonSettingPageUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
