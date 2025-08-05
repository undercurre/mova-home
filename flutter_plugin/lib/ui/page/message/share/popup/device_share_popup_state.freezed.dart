// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_share_popup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeviceSharePopupState {
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeviceSharePopupStateCopyWith<DeviceSharePopupState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceSharePopupStateCopyWith<$Res> {
  factory $DeviceSharePopupStateCopyWith(DeviceSharePopupState value,
          $Res Function(DeviceSharePopupState) then) =
      _$DeviceSharePopupStateCopyWithImpl<$Res, DeviceSharePopupState>;
  @useResult
  $Res call({CommonUIEvent? uiEvent});
}

/// @nodoc
class _$DeviceSharePopupStateCopyWithImpl<$Res,
        $Val extends DeviceSharePopupState>
    implements $DeviceSharePopupStateCopyWith<$Res> {
  _$DeviceSharePopupStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uiEvent = freezed,
  }) {
    return _then(_value.copyWith(
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceSharePopupStateImplCopyWith<$Res>
    implements $DeviceSharePopupStateCopyWith<$Res> {
  factory _$$DeviceSharePopupStateImplCopyWith(
          _$DeviceSharePopupStateImpl value,
          $Res Function(_$DeviceSharePopupStateImpl) then) =
      __$$DeviceSharePopupStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$DeviceSharePopupStateImplCopyWithImpl<$Res>
    extends _$DeviceSharePopupStateCopyWithImpl<$Res,
        _$DeviceSharePopupStateImpl>
    implements _$$DeviceSharePopupStateImplCopyWith<$Res> {
  __$$DeviceSharePopupStateImplCopyWithImpl(_$DeviceSharePopupStateImpl _value,
      $Res Function(_$DeviceSharePopupStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uiEvent = freezed,
  }) {
    return _then(_$DeviceSharePopupStateImpl(
      freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$DeviceSharePopupStateImpl implements _DeviceSharePopupState {
  _$DeviceSharePopupStateImpl(this.uiEvent);

  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'DeviceSharePopupState(uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceSharePopupStateImpl &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceSharePopupStateImplCopyWith<_$DeviceSharePopupStateImpl>
      get copyWith => __$$DeviceSharePopupStateImplCopyWithImpl<
          _$DeviceSharePopupStateImpl>(this, _$identity);
}

abstract class _DeviceSharePopupState implements DeviceSharePopupState {
  factory _DeviceSharePopupState(final CommonUIEvent? uiEvent) =
      _$DeviceSharePopupStateImpl;

  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$DeviceSharePopupStateImplCopyWith<_$DeviceSharePopupStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
