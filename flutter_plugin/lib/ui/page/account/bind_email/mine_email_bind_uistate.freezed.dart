// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mine_email_bind_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MineEmailBindUiState {
  bool get enableSend => throw _privateConstructorUsedError;
  bool get agreed => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;
  bool get isbindEmail => throw _privateConstructorUsedError;
  bool get canSendMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MineEmailBindUiStateCopyWith<MineEmailBindUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MineEmailBindUiStateCopyWith<$Res> {
  factory $MineEmailBindUiStateCopyWith(MineEmailBindUiState value,
          $Res Function(MineEmailBindUiState) then) =
      _$MineEmailBindUiStateCopyWithImpl<$Res, MineEmailBindUiState>;
  @useResult
  $Res call(
      {bool enableSend,
      bool agreed,
      CommonUIEvent event,
      bool isbindEmail,
      bool canSendMessage});
}

/// @nodoc
class _$MineEmailBindUiStateCopyWithImpl<$Res,
        $Val extends MineEmailBindUiState>
    implements $MineEmailBindUiStateCopyWith<$Res> {
  _$MineEmailBindUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSend = null,
    Object? agreed = null,
    Object? event = null,
    Object? isbindEmail = null,
    Object? canSendMessage = null,
  }) {
    return _then(_value.copyWith(
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      agreed: null == agreed
          ? _value.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      isbindEmail: null == isbindEmail
          ? _value.isbindEmail
          : isbindEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      canSendMessage: null == canSendMessage
          ? _value.canSendMessage
          : canSendMessage // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MineEmailBindUiStateImplCopyWith<$Res>
    implements $MineEmailBindUiStateCopyWith<$Res> {
  factory _$$MineEmailBindUiStateImplCopyWith(_$MineEmailBindUiStateImpl value,
          $Res Function(_$MineEmailBindUiStateImpl) then) =
      __$$MineEmailBindUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableSend,
      bool agreed,
      CommonUIEvent event,
      bool isbindEmail,
      bool canSendMessage});
}

/// @nodoc
class __$$MineEmailBindUiStateImplCopyWithImpl<$Res>
    extends _$MineEmailBindUiStateCopyWithImpl<$Res, _$MineEmailBindUiStateImpl>
    implements _$$MineEmailBindUiStateImplCopyWith<$Res> {
  __$$MineEmailBindUiStateImplCopyWithImpl(_$MineEmailBindUiStateImpl _value,
      $Res Function(_$MineEmailBindUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSend = null,
    Object? agreed = null,
    Object? event = null,
    Object? isbindEmail = null,
    Object? canSendMessage = null,
  }) {
    return _then(_$MineEmailBindUiStateImpl(
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      agreed: null == agreed
          ? _value.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      isbindEmail: null == isbindEmail
          ? _value.isbindEmail
          : isbindEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      canSendMessage: null == canSendMessage
          ? _value.canSendMessage
          : canSendMessage // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MineEmailBindUiStateImpl implements _MineEmailBindUiState {
  _$MineEmailBindUiStateImpl(
      {this.enableSend = false,
      this.agreed = false,
      this.event = const EmptyEvent(),
      this.isbindEmail = false,
      this.canSendMessage = false});

  @override
  @JsonKey()
  final bool enableSend;
  @override
  @JsonKey()
  final bool agreed;
  @override
  @JsonKey()
  final CommonUIEvent event;
  @override
  @JsonKey()
  final bool isbindEmail;
  @override
  @JsonKey()
  final bool canSendMessage;

  @override
  String toString() {
    return 'MineEmailBindUiState(enableSend: $enableSend, agreed: $agreed, event: $event, isbindEmail: $isbindEmail, canSendMessage: $canSendMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MineEmailBindUiStateImpl &&
            (identical(other.enableSend, enableSend) ||
                other.enableSend == enableSend) &&
            (identical(other.agreed, agreed) || other.agreed == agreed) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.isbindEmail, isbindEmail) ||
                other.isbindEmail == isbindEmail) &&
            (identical(other.canSendMessage, canSendMessage) ||
                other.canSendMessage == canSendMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, enableSend, agreed, event, isbindEmail, canSendMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MineEmailBindUiStateImplCopyWith<_$MineEmailBindUiStateImpl>
      get copyWith =>
          __$$MineEmailBindUiStateImplCopyWithImpl<_$MineEmailBindUiStateImpl>(
              this, _$identity);
}

abstract class _MineEmailBindUiState implements MineEmailBindUiState {
  factory _MineEmailBindUiState(
      {final bool enableSend,
      final bool agreed,
      final CommonUIEvent event,
      final bool isbindEmail,
      final bool canSendMessage}) = _$MineEmailBindUiStateImpl;

  @override
  bool get enableSend;
  @override
  bool get agreed;
  @override
  CommonUIEvent get event;
  @override
  bool get isbindEmail;
  @override
  bool get canSendMessage;
  @override
  @JsonKey(ignore: true)
  _$$MineEmailBindUiStateImplCopyWith<_$MineEmailBindUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
