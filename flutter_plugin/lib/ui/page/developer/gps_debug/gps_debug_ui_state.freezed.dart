// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gps_debug_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GPSDebugUiState {
  GPSDebugModel? get debugModel => throw _privateConstructorUsedError;
  set debugModel(GPSDebugModel? value) => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;
  set event(CommonUIEvent value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GPSDebugUiStateCopyWith<GPSDebugUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GPSDebugUiStateCopyWith<$Res> {
  factory $GPSDebugUiStateCopyWith(
          GPSDebugUiState value, $Res Function(GPSDebugUiState) then) =
      _$GPSDebugUiStateCopyWithImpl<$Res, GPSDebugUiState>;
  @useResult
  $Res call({GPSDebugModel? debugModel, CommonUIEvent event});

  $GPSDebugModelCopyWith<$Res>? get debugModel;
}

/// @nodoc
class _$GPSDebugUiStateCopyWithImpl<$Res, $Val extends GPSDebugUiState>
    implements $GPSDebugUiStateCopyWith<$Res> {
  _$GPSDebugUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? debugModel = freezed,
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      debugModel: freezed == debugModel
          ? _value.debugModel
          : debugModel // ignore: cast_nullable_to_non_nullable
              as GPSDebugModel?,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $GPSDebugModelCopyWith<$Res>? get debugModel {
    if (_value.debugModel == null) {
      return null;
    }

    return $GPSDebugModelCopyWith<$Res>(_value.debugModel!, (value) {
      return _then(_value.copyWith(debugModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GPSDebugUiStateImplCopyWith<$Res>
    implements $GPSDebugUiStateCopyWith<$Res> {
  factory _$$GPSDebugUiStateImplCopyWith(_$GPSDebugUiStateImpl value,
          $Res Function(_$GPSDebugUiStateImpl) then) =
      __$$GPSDebugUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GPSDebugModel? debugModel, CommonUIEvent event});

  @override
  $GPSDebugModelCopyWith<$Res>? get debugModel;
}

/// @nodoc
class __$$GPSDebugUiStateImplCopyWithImpl<$Res>
    extends _$GPSDebugUiStateCopyWithImpl<$Res, _$GPSDebugUiStateImpl>
    implements _$$GPSDebugUiStateImplCopyWith<$Res> {
  __$$GPSDebugUiStateImplCopyWithImpl(
      _$GPSDebugUiStateImpl _value, $Res Function(_$GPSDebugUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? debugModel = freezed,
    Object? event = null,
  }) {
    return _then(_$GPSDebugUiStateImpl(
      debugModel: freezed == debugModel
          ? _value.debugModel
          : debugModel // ignore: cast_nullable_to_non_nullable
              as GPSDebugModel?,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$GPSDebugUiStateImpl implements _GPSDebugUiState {
  _$GPSDebugUiStateImpl({this.debugModel, this.event = const EmptyEvent()});

  @override
  GPSDebugModel? debugModel;
  @override
  @JsonKey()
  CommonUIEvent event;

  @override
  String toString() {
    return 'GPSDebugUiState(debugModel: $debugModel, event: $event)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GPSDebugUiStateImplCopyWith<_$GPSDebugUiStateImpl> get copyWith =>
      __$$GPSDebugUiStateImplCopyWithImpl<_$GPSDebugUiStateImpl>(
          this, _$identity);
}

abstract class _GPSDebugUiState implements GPSDebugUiState {
  factory _GPSDebugUiState({GPSDebugModel? debugModel, CommonUIEvent event}) =
      _$GPSDebugUiStateImpl;

  @override
  GPSDebugModel? get debugModel;
  set debugModel(GPSDebugModel? value);
  @override
  CommonUIEvent get event;
  set event(CommonUIEvent value);
  @override
  @JsonKey(ignore: true)
  _$$GPSDebugUiStateImplCopyWith<_$GPSDebugUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
