// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recover_change_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecoverChangeUiState {
  bool get enableNext => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;
  bool get hidePassword => throw _privateConstructorUsedError;
  bool get configPassword => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecoverChangeUiStateCopyWith<RecoverChangeUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecoverChangeUiStateCopyWith<$Res> {
  factory $RecoverChangeUiStateCopyWith(RecoverChangeUiState value,
          $Res Function(RecoverChangeUiState) then) =
      _$RecoverChangeUiStateCopyWithImpl<$Res, RecoverChangeUiState>;
  @useResult
  $Res call(
      {bool enableNext,
      CommonUIEvent event,
      bool hidePassword,
      bool configPassword});
}

/// @nodoc
class _$RecoverChangeUiStateCopyWithImpl<$Res,
        $Val extends RecoverChangeUiState>
    implements $RecoverChangeUiStateCopyWith<$Res> {
  _$RecoverChangeUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableNext = null,
    Object? event = null,
    Object? hidePassword = null,
    Object? configPassword = null,
  }) {
    return _then(_value.copyWith(
      enableNext: null == enableNext
          ? _value.enableNext
          : enableNext // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      hidePassword: null == hidePassword
          ? _value.hidePassword
          : hidePassword // ignore: cast_nullable_to_non_nullable
              as bool,
      configPassword: null == configPassword
          ? _value.configPassword
          : configPassword // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecoverChangeUiStateImplCopyWith<$Res>
    implements $RecoverChangeUiStateCopyWith<$Res> {
  factory _$$RecoverChangeUiStateImplCopyWith(_$RecoverChangeUiStateImpl value,
          $Res Function(_$RecoverChangeUiStateImpl) then) =
      __$$RecoverChangeUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableNext,
      CommonUIEvent event,
      bool hidePassword,
      bool configPassword});
}

/// @nodoc
class __$$RecoverChangeUiStateImplCopyWithImpl<$Res>
    extends _$RecoverChangeUiStateCopyWithImpl<$Res, _$RecoverChangeUiStateImpl>
    implements _$$RecoverChangeUiStateImplCopyWith<$Res> {
  __$$RecoverChangeUiStateImplCopyWithImpl(_$RecoverChangeUiStateImpl _value,
      $Res Function(_$RecoverChangeUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableNext = null,
    Object? event = null,
    Object? hidePassword = null,
    Object? configPassword = null,
  }) {
    return _then(_$RecoverChangeUiStateImpl(
      enableNext: null == enableNext
          ? _value.enableNext
          : enableNext // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      hidePassword: null == hidePassword
          ? _value.hidePassword
          : hidePassword // ignore: cast_nullable_to_non_nullable
              as bool,
      configPassword: null == configPassword
          ? _value.configPassword
          : configPassword // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RecoverChangeUiStateImpl implements _RecoverChangeUiState {
  _$RecoverChangeUiStateImpl(
      {this.enableNext = false,
      this.event = const EmptyEvent(),
      this.hidePassword = true,
      this.configPassword = true});

  @override
  @JsonKey()
  final bool enableNext;
  @override
  @JsonKey()
  final CommonUIEvent event;
  @override
  @JsonKey()
  final bool hidePassword;
  @override
  @JsonKey()
  final bool configPassword;

  @override
  String toString() {
    return 'RecoverChangeUiState(enableNext: $enableNext, event: $event, hidePassword: $hidePassword, configPassword: $configPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecoverChangeUiStateImpl &&
            (identical(other.enableNext, enableNext) ||
                other.enableNext == enableNext) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.hidePassword, hidePassword) ||
                other.hidePassword == hidePassword) &&
            (identical(other.configPassword, configPassword) ||
                other.configPassword == configPassword));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, enableNext, event, hidePassword, configPassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecoverChangeUiStateImplCopyWith<_$RecoverChangeUiStateImpl>
      get copyWith =>
          __$$RecoverChangeUiStateImplCopyWithImpl<_$RecoverChangeUiStateImpl>(
              this, _$identity);
}

abstract class _RecoverChangeUiState implements RecoverChangeUiState {
  factory _RecoverChangeUiState(
      {final bool enableNext,
      final CommonUIEvent event,
      final bool hidePassword,
      final bool configPassword}) = _$RecoverChangeUiStateImpl;

  @override
  bool get enableNext;
  @override
  CommonUIEvent get event;
  @override
  bool get hidePassword;
  @override
  bool get configPassword;
  @override
  @JsonKey(ignore: true)
  _$$RecoverChangeUiStateImplCopyWith<_$RecoverChangeUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
