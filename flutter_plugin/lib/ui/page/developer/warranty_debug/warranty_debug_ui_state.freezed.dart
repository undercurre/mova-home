// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warranty_debug_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WarrantyDebugUiState {
  bool? get isDebug => throw _privateConstructorUsedError;
  set isDebug(bool? value) => throw _privateConstructorUsedError;
  WarrantyDebugModel? get debugModel => throw _privateConstructorUsedError;
  set debugModel(WarrantyDebugModel? value) =>
      throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;
  set event(CommonUIEvent value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WarrantyDebugUiStateCopyWith<WarrantyDebugUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarrantyDebugUiStateCopyWith<$Res> {
  factory $WarrantyDebugUiStateCopyWith(WarrantyDebugUiState value,
          $Res Function(WarrantyDebugUiState) then) =
      _$WarrantyDebugUiStateCopyWithImpl<$Res, WarrantyDebugUiState>;
  @useResult
  $Res call(
      {bool? isDebug, WarrantyDebugModel? debugModel, CommonUIEvent event});

  $WarrantyDebugModelCopyWith<$Res>? get debugModel;
}

/// @nodoc
class _$WarrantyDebugUiStateCopyWithImpl<$Res,
        $Val extends WarrantyDebugUiState>
    implements $WarrantyDebugUiStateCopyWith<$Res> {
  _$WarrantyDebugUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDebug = freezed,
    Object? debugModel = freezed,
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      isDebug: freezed == isDebug
          ? _value.isDebug
          : isDebug // ignore: cast_nullable_to_non_nullable
              as bool?,
      debugModel: freezed == debugModel
          ? _value.debugModel
          : debugModel // ignore: cast_nullable_to_non_nullable
              as WarrantyDebugModel?,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WarrantyDebugModelCopyWith<$Res>? get debugModel {
    if (_value.debugModel == null) {
      return null;
    }

    return $WarrantyDebugModelCopyWith<$Res>(_value.debugModel!, (value) {
      return _then(_value.copyWith(debugModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WarrantyDebugUiStateImplCopyWith<$Res>
    implements $WarrantyDebugUiStateCopyWith<$Res> {
  factory _$$WarrantyDebugUiStateImplCopyWith(_$WarrantyDebugUiStateImpl value,
          $Res Function(_$WarrantyDebugUiStateImpl) then) =
      __$$WarrantyDebugUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? isDebug, WarrantyDebugModel? debugModel, CommonUIEvent event});

  @override
  $WarrantyDebugModelCopyWith<$Res>? get debugModel;
}

/// @nodoc
class __$$WarrantyDebugUiStateImplCopyWithImpl<$Res>
    extends _$WarrantyDebugUiStateCopyWithImpl<$Res, _$WarrantyDebugUiStateImpl>
    implements _$$WarrantyDebugUiStateImplCopyWith<$Res> {
  __$$WarrantyDebugUiStateImplCopyWithImpl(_$WarrantyDebugUiStateImpl _value,
      $Res Function(_$WarrantyDebugUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDebug = freezed,
    Object? debugModel = freezed,
    Object? event = null,
  }) {
    return _then(_$WarrantyDebugUiStateImpl(
      isDebug: freezed == isDebug
          ? _value.isDebug
          : isDebug // ignore: cast_nullable_to_non_nullable
              as bool?,
      debugModel: freezed == debugModel
          ? _value.debugModel
          : debugModel // ignore: cast_nullable_to_non_nullable
              as WarrantyDebugModel?,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$WarrantyDebugUiStateImpl implements _WarrantyDebugUiState {
  _$WarrantyDebugUiStateImpl(
      {this.isDebug, this.debugModel, this.event = const EmptyEvent()});

  @override
  bool? isDebug;
  @override
  WarrantyDebugModel? debugModel;
  @override
  @JsonKey()
  CommonUIEvent event;

  @override
  String toString() {
    return 'WarrantyDebugUiState(isDebug: $isDebug, debugModel: $debugModel, event: $event)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarrantyDebugUiStateImplCopyWith<_$WarrantyDebugUiStateImpl>
      get copyWith =>
          __$$WarrantyDebugUiStateImplCopyWithImpl<_$WarrantyDebugUiStateImpl>(
              this, _$identity);
}

abstract class _WarrantyDebugUiState implements WarrantyDebugUiState {
  factory _WarrantyDebugUiState(
      {bool? isDebug,
      WarrantyDebugModel? debugModel,
      CommonUIEvent event}) = _$WarrantyDebugUiStateImpl;

  @override
  bool? get isDebug;
  set isDebug(bool? value);
  @override
  WarrantyDebugModel? get debugModel;
  set debugModel(WarrantyDebugModel? value);
  @override
  CommonUIEvent get event;
  set event(CommonUIEvent value);
  @override
  @JsonKey(ignore: true)
  _$$WarrantyDebugUiStateImplCopyWith<_$WarrantyDebugUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
