// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_bind_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MobileBindUiState {
  bool get enableSend =>
      throw _privateConstructorUsedError; // RegionItem? phoneCodeRegion,
  String get code => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MobileBindUiStateCopyWith<MobileBindUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileBindUiStateCopyWith<$Res> {
  factory $MobileBindUiStateCopyWith(
          MobileBindUiState value, $Res Function(MobileBindUiState) then) =
      _$MobileBindUiStateCopyWithImpl<$Res, MobileBindUiState>;
  @useResult
  $Res call({bool enableSend, String code, CommonUIEvent event});
}

/// @nodoc
class _$MobileBindUiStateCopyWithImpl<$Res, $Val extends MobileBindUiState>
    implements $MobileBindUiStateCopyWith<$Res> {
  _$MobileBindUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSend = null,
    Object? code = null,
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MobileBindUiStateImplCopyWith<$Res>
    implements $MobileBindUiStateCopyWith<$Res> {
  factory _$$MobileBindUiStateImplCopyWith(_$MobileBindUiStateImpl value,
          $Res Function(_$MobileBindUiStateImpl) then) =
      __$$MobileBindUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enableSend, String code, CommonUIEvent event});
}

/// @nodoc
class __$$MobileBindUiStateImplCopyWithImpl<$Res>
    extends _$MobileBindUiStateCopyWithImpl<$Res, _$MobileBindUiStateImpl>
    implements _$$MobileBindUiStateImplCopyWith<$Res> {
  __$$MobileBindUiStateImplCopyWithImpl(_$MobileBindUiStateImpl _value,
      $Res Function(_$MobileBindUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSend = null,
    Object? code = null,
    Object? event = null,
  }) {
    return _then(_$MobileBindUiStateImpl(
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$MobileBindUiStateImpl implements _MobileBindUiState {
  _$MobileBindUiStateImpl(
      {this.enableSend = false,
      this.code = '86',
      this.event = const EmptyEvent()});

  @override
  @JsonKey()
  final bool enableSend;
// RegionItem? phoneCodeRegion,
  @override
  @JsonKey()
  final String code;
  @override
  @JsonKey()
  final CommonUIEvent event;

  @override
  String toString() {
    return 'MobileBindUiState(enableSend: $enableSend, code: $code, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileBindUiStateImpl &&
            (identical(other.enableSend, enableSend) ||
                other.enableSend == enableSend) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enableSend, code, event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileBindUiStateImplCopyWith<_$MobileBindUiStateImpl> get copyWith =>
      __$$MobileBindUiStateImplCopyWithImpl<_$MobileBindUiStateImpl>(
          this, _$identity);
}

abstract class _MobileBindUiState implements MobileBindUiState {
  factory _MobileBindUiState(
      {final bool enableSend,
      final String code,
      final CommonUIEvent event}) = _$MobileBindUiStateImpl;

  @override
  bool get enableSend;
  @override // RegionItem? phoneCodeRegion,
  String get code;
  @override
  CommonUIEvent get event;
  @override
  @JsonKey(ignore: true)
  _$$MobileBindUiStateImplCopyWith<_$MobileBindUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
