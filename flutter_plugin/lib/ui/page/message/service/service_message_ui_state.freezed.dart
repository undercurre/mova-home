// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_message_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ServiceMessageUiState {
  bool get orderShowRedDot => throw _privateConstructorUsedError;
  bool get vipShowRedDot => throw _privateConstructorUsedError;
  bool get activityShowRedDot => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ServiceMessageUiStateCopyWith<ServiceMessageUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceMessageUiStateCopyWith<$Res> {
  factory $ServiceMessageUiStateCopyWith(ServiceMessageUiState value,
          $Res Function(ServiceMessageUiState) then) =
      _$ServiceMessageUiStateCopyWithImpl<$Res, ServiceMessageUiState>;
  @useResult
  $Res call(
      {bool orderShowRedDot, bool vipShowRedDot, bool activityShowRedDot});
}

/// @nodoc
class _$ServiceMessageUiStateCopyWithImpl<$Res,
        $Val extends ServiceMessageUiState>
    implements $ServiceMessageUiStateCopyWith<$Res> {
  _$ServiceMessageUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderShowRedDot = null,
    Object? vipShowRedDot = null,
    Object? activityShowRedDot = null,
  }) {
    return _then(_value.copyWith(
      orderShowRedDot: null == orderShowRedDot
          ? _value.orderShowRedDot
          : orderShowRedDot // ignore: cast_nullable_to_non_nullable
              as bool,
      vipShowRedDot: null == vipShowRedDot
          ? _value.vipShowRedDot
          : vipShowRedDot // ignore: cast_nullable_to_non_nullable
              as bool,
      activityShowRedDot: null == activityShowRedDot
          ? _value.activityShowRedDot
          : activityShowRedDot // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceMessageUiStateImplCopyWith<$Res>
    implements $ServiceMessageUiStateCopyWith<$Res> {
  factory _$$ServiceMessageUiStateImplCopyWith(
          _$ServiceMessageUiStateImpl value,
          $Res Function(_$ServiceMessageUiStateImpl) then) =
      __$$ServiceMessageUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool orderShowRedDot, bool vipShowRedDot, bool activityShowRedDot});
}

/// @nodoc
class __$$ServiceMessageUiStateImplCopyWithImpl<$Res>
    extends _$ServiceMessageUiStateCopyWithImpl<$Res,
        _$ServiceMessageUiStateImpl>
    implements _$$ServiceMessageUiStateImplCopyWith<$Res> {
  __$$ServiceMessageUiStateImplCopyWithImpl(_$ServiceMessageUiStateImpl _value,
      $Res Function(_$ServiceMessageUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderShowRedDot = null,
    Object? vipShowRedDot = null,
    Object? activityShowRedDot = null,
  }) {
    return _then(_$ServiceMessageUiStateImpl(
      orderShowRedDot: null == orderShowRedDot
          ? _value.orderShowRedDot
          : orderShowRedDot // ignore: cast_nullable_to_non_nullable
              as bool,
      vipShowRedDot: null == vipShowRedDot
          ? _value.vipShowRedDot
          : vipShowRedDot // ignore: cast_nullable_to_non_nullable
              as bool,
      activityShowRedDot: null == activityShowRedDot
          ? _value.activityShowRedDot
          : activityShowRedDot // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ServiceMessageUiStateImpl implements _ServiceMessageUiState {
  _$ServiceMessageUiStateImpl(
      {this.orderShowRedDot = false,
      this.vipShowRedDot = false,
      this.activityShowRedDot = false});

  @override
  @JsonKey()
  final bool orderShowRedDot;
  @override
  @JsonKey()
  final bool vipShowRedDot;
  @override
  @JsonKey()
  final bool activityShowRedDot;

  @override
  String toString() {
    return 'ServiceMessageUiState(orderShowRedDot: $orderShowRedDot, vipShowRedDot: $vipShowRedDot, activityShowRedDot: $activityShowRedDot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceMessageUiStateImpl &&
            (identical(other.orderShowRedDot, orderShowRedDot) ||
                other.orderShowRedDot == orderShowRedDot) &&
            (identical(other.vipShowRedDot, vipShowRedDot) ||
                other.vipShowRedDot == vipShowRedDot) &&
            (identical(other.activityShowRedDot, activityShowRedDot) ||
                other.activityShowRedDot == activityShowRedDot));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, orderShowRedDot, vipShowRedDot, activityShowRedDot);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceMessageUiStateImplCopyWith<_$ServiceMessageUiStateImpl>
      get copyWith => __$$ServiceMessageUiStateImplCopyWithImpl<
          _$ServiceMessageUiStateImpl>(this, _$identity);
}

abstract class _ServiceMessageUiState implements ServiceMessageUiState {
  factory _ServiceMessageUiState(
      {final bool orderShowRedDot,
      final bool vipShowRedDot,
      final bool activityShowRedDot}) = _$ServiceMessageUiStateImpl;

  @override
  bool get orderShowRedDot;
  @override
  bool get vipShowRedDot;
  @override
  bool get activityShowRedDot;
  @override
  @JsonKey(ignore: true)
  _$$ServiceMessageUiStateImplCopyWith<_$ServiceMessageUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
