// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_call_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VideoCallState {
  BaseDeviceModel? get currentDevice => throw _privateConstructorUsedError;
  String? get deviceName => throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VideoCallStateCopyWith<VideoCallState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoCallStateCopyWith<$Res> {
  factory $VideoCallStateCopyWith(
          VideoCallState value, $Res Function(VideoCallState) then) =
      _$VideoCallStateCopyWithImpl<$Res, VideoCallState>;
  @useResult
  $Res call(
      {BaseDeviceModel? currentDevice,
      String? deviceName,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class _$VideoCallStateCopyWithImpl<$Res, $Val extends VideoCallState>
    implements $VideoCallStateCopyWith<$Res> {
  _$VideoCallStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentDevice = freezed,
    Object? deviceName = freezed,
    Object? uiEvent = freezed,
  }) {
    return _then(_value.copyWith(
      currentDevice: freezed == currentDevice
          ? _value.currentDevice
          : currentDevice // ignore: cast_nullable_to_non_nullable
              as BaseDeviceModel?,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoCallStateImplCopyWith<$Res>
    implements $VideoCallStateCopyWith<$Res> {
  factory _$$VideoCallStateImplCopyWith(_$VideoCallStateImpl value,
          $Res Function(_$VideoCallStateImpl) then) =
      __$$VideoCallStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BaseDeviceModel? currentDevice,
      String? deviceName,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$VideoCallStateImplCopyWithImpl<$Res>
    extends _$VideoCallStateCopyWithImpl<$Res, _$VideoCallStateImpl>
    implements _$$VideoCallStateImplCopyWith<$Res> {
  __$$VideoCallStateImplCopyWithImpl(
      _$VideoCallStateImpl _value, $Res Function(_$VideoCallStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentDevice = freezed,
    Object? deviceName = freezed,
    Object? uiEvent = freezed,
  }) {
    return _then(_$VideoCallStateImpl(
      currentDevice: freezed == currentDevice
          ? _value.currentDevice
          : currentDevice // ignore: cast_nullable_to_non_nullable
              as BaseDeviceModel?,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$VideoCallStateImpl implements _VideoCallState {
  _$VideoCallStateImpl({this.currentDevice, this.deviceName, this.uiEvent});

  @override
  final BaseDeviceModel? currentDevice;
  @override
  final String? deviceName;
  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'VideoCallState(currentDevice: $currentDevice, deviceName: $deviceName, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoCallStateImpl &&
            (identical(other.currentDevice, currentDevice) ||
                other.currentDevice == currentDevice) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, currentDevice, deviceName, uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoCallStateImplCopyWith<_$VideoCallStateImpl> get copyWith =>
      __$$VideoCallStateImplCopyWithImpl<_$VideoCallStateImpl>(
          this, _$identity);
}

abstract class _VideoCallState implements VideoCallState {
  factory _VideoCallState(
      {final BaseDeviceModel? currentDevice,
      final String? deviceName,
      final CommonUIEvent? uiEvent}) = _$VideoCallStateImpl;

  @override
  BaseDeviceModel? get currentDevice;
  @override
  String? get deviceName;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$VideoCallStateImplCopyWith<_$VideoCallStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
