// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_config_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserConfigPageUiState {
  bool get loading => throw _privateConstructorUsedError;
  String get privacyUrl => throw _privateConstructorUsedError;
  bool get isOn => throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserConfigPageUiStateCopyWith<UserConfigPageUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserConfigPageUiStateCopyWith<$Res> {
  factory $UserConfigPageUiStateCopyWith(UserConfigPageUiState value,
          $Res Function(UserConfigPageUiState) then) =
      _$UserConfigPageUiStateCopyWithImpl<$Res, UserConfigPageUiState>;
  @useResult
  $Res call({bool loading,String privacyUrl, bool isOn, CommonUIEvent? uiEvent});
}

/// @nodoc
class _$UserConfigPageUiStateCopyWithImpl<$Res,
        $Val extends UserConfigPageUiState>
    implements $UserConfigPageUiStateCopyWith<$Res> {
  _$UserConfigPageUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = false,
    Object? privacyUrl = null,
    Object? isOn = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
      as bool,
      privacyUrl: null == privacyUrl
          ? _value.privacyUrl
          : privacyUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isOn: null == isOn
          ? _value.isOn
          : isOn // ignore: cast_nullable_to_non_nullable
              as bool,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserConfigPageUiStateImplCopyWith<$Res>
    implements $UserConfigPageUiStateCopyWith<$Res> {
  factory _$$UserConfigPageUiStateImplCopyWith(
          _$UserConfigPageUiStateImpl value,
          $Res Function(_$UserConfigPageUiStateImpl) then) =
      __$$UserConfigPageUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool loading,String privacyUrl, bool isOn, CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$UserConfigPageUiStateImplCopyWithImpl<$Res>
    extends _$UserConfigPageUiStateCopyWithImpl<$Res,
        _$UserConfigPageUiStateImpl>
    implements _$$UserConfigPageUiStateImplCopyWith<$Res> {
  __$$UserConfigPageUiStateImplCopyWithImpl(_$UserConfigPageUiStateImpl _value,
      $Res Function(_$UserConfigPageUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? privacyUrl = null,
    Object? isOn = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_$UserConfigPageUiStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      privacyUrl: null == privacyUrl
          ? _value.privacyUrl
          : privacyUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isOn: null == isOn
          ? _value.isOn
          : isOn // ignore: cast_nullable_to_non_nullable
              as bool,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$UserConfigPageUiStateImpl implements _UserConfigPageUiState {
  _$UserConfigPageUiStateImpl(
      {this.loading = false, this.privacyUrl = '', this.isOn = false, this.uiEvent});

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final String privacyUrl;
  @override
  @JsonKey()
  final bool isOn;
  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'UserConfigPageUiState(loading: $loading, privacyUrl: $privacyUrl, isOn: $isOn, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserConfigPageUiStateImpl &&
            (identical(other.privacyUrl, privacyUrl) ||
                other.privacyUrl == privacyUrl) &&
            (identical(other.isOn, isOn) || other.isOn == isOn) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, privacyUrl, loading, isOn, uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserConfigPageUiStateImplCopyWith<_$UserConfigPageUiStateImpl>
      get copyWith => __$$UserConfigPageUiStateImplCopyWithImpl<
          _$UserConfigPageUiStateImpl>(this, _$identity);
}

abstract class _UserConfigPageUiState implements UserConfigPageUiState {
  factory _UserConfigPageUiState(
      {final bool loading,
      final String privacyUrl,
      final bool isOn,
      final CommonUIEvent? uiEvent}) = _$UserConfigPageUiStateImpl;

  @override
  bool get loading;
  @override
  String get privacyUrl;
  @override
  bool get isOn;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$UserConfigPageUiStateImplCopyWith<_$UserConfigPageUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
