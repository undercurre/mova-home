// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheme_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SchemeState {
  String get schemeType => throw _privateConstructorUsedError;
  String get ext => throw _privateConstructorUsedError;
  bool get fromColdBoot => throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SchemeStateCopyWith<SchemeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemeStateCopyWith<$Res> {
  factory $SchemeStateCopyWith(
          SchemeState value, $Res Function(SchemeState) then) =
      _$SchemeStateCopyWithImpl<$Res, SchemeState>;
  @useResult
  $Res call(
      {String schemeType,
      String ext,
      bool fromColdBoot,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class _$SchemeStateCopyWithImpl<$Res, $Val extends SchemeState>
    implements $SchemeStateCopyWith<$Res> {
  _$SchemeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schemeType = null,
    Object? ext = null,
    Object? fromColdBoot = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_value.copyWith(
      schemeType: null == schemeType
          ? _value.schemeType
          : schemeType // ignore: cast_nullable_to_non_nullable
              as String,
      ext: null == ext
          ? _value.ext
          : ext // ignore: cast_nullable_to_non_nullable
              as String,
      fromColdBoot: null == fromColdBoot
          ? _value.fromColdBoot
          : fromColdBoot // ignore: cast_nullable_to_non_nullable
              as bool,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SchemeStateCopyWith<$Res>
    implements $SchemeStateCopyWith<$Res> {
  factory _$$_SchemeStateCopyWith(
          _$_SchemeState value, $Res Function(_$_SchemeState) then) =
      __$$_SchemeStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String schemeType,
      String ext,
      bool fromColdBoot,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$_SchemeStateCopyWithImpl<$Res>
    extends _$SchemeStateCopyWithImpl<$Res, _$_SchemeState>
    implements _$$_SchemeStateCopyWith<$Res> {
  __$$_SchemeStateCopyWithImpl(
      _$_SchemeState _value, $Res Function(_$_SchemeState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schemeType = null,
    Object? ext = null,
    Object? fromColdBoot = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_$_SchemeState(
      schemeType: null == schemeType
          ? _value.schemeType
          : schemeType // ignore: cast_nullable_to_non_nullable
              as String,
      ext: null == ext
          ? _value.ext
          : ext // ignore: cast_nullable_to_non_nullable
              as String,
      fromColdBoot: null == fromColdBoot
          ? _value.fromColdBoot
          : fromColdBoot // ignore: cast_nullable_to_non_nullable
              as bool,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$_SchemeState implements _SchemeState {
  _$_SchemeState(
      {this.schemeType = '',
      this.ext = '',
      this.fromColdBoot = false,
      this.uiEvent});

  @override
  @JsonKey()
  final String schemeType;
  @override
  @JsonKey()
  final String ext;
  @override
  @JsonKey()
  final bool fromColdBoot;
  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'SchemeState(schemeType: $schemeType, ext: $ext, fromColdBoot: $fromColdBoot, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SchemeState &&
            (identical(other.schemeType, schemeType) ||
                other.schemeType == schemeType) &&
            (identical(other.ext, ext) || other.ext == ext) &&
            (identical(other.fromColdBoot, fromColdBoot) ||
                other.fromColdBoot == fromColdBoot) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, schemeType, ext, fromColdBoot, uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SchemeStateCopyWith<_$_SchemeState> get copyWith =>
      __$$_SchemeStateCopyWithImpl<_$_SchemeState>(this, _$identity);
}

abstract class _SchemeState implements SchemeState {
  factory _SchemeState(
      {final String schemeType,
      final String ext,
      final bool fromColdBoot,
      final CommonUIEvent? uiEvent}) = _$_SchemeState;

  @override
  String get schemeType;
  @override
  String get ext;
  @override
  bool get fromColdBoot;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$_SchemeStateCopyWith<_$_SchemeState> get copyWith =>
      throw _privateConstructorUsedError;
}
