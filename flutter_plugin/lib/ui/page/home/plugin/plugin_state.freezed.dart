// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plugin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PluginState {
  String? get currentModel => throw _privateConstructorUsedError;
  set currentModel(String? value) => throw _privateConstructorUsedError;
  bool get needsUpdate => throw _privateConstructorUsedError;
  set needsUpdate(bool value) => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError;
  set progress(int value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PluginStateCopyWith<PluginState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PluginStateCopyWith<$Res> {
  factory $PluginStateCopyWith(
          PluginState value, $Res Function(PluginState) then) =
      _$PluginStateCopyWithImpl<$Res, PluginState>;
  @useResult
  $Res call({String? currentModel, bool needsUpdate, int progress});
}

/// @nodoc
class _$PluginStateCopyWithImpl<$Res, $Val extends PluginState>
    implements $PluginStateCopyWith<$Res> {
  _$PluginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentModel = freezed,
    Object? needsUpdate = null,
    Object? progress = null,
  }) {
    return _then(_value.copyWith(
      currentModel: freezed == currentModel
          ? _value.currentModel
          : currentModel // ignore: cast_nullable_to_non_nullable
              as String?,
      needsUpdate: null == needsUpdate
          ? _value.needsUpdate
          : needsUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PluginStateImplCopyWith<$Res>
    implements $PluginStateCopyWith<$Res> {
  factory _$$PluginStateImplCopyWith(
          _$PluginStateImpl value, $Res Function(_$PluginStateImpl) then) =
      __$$PluginStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? currentModel, bool needsUpdate, int progress});
}

/// @nodoc
class __$$PluginStateImplCopyWithImpl<$Res>
    extends _$PluginStateCopyWithImpl<$Res, _$PluginStateImpl>
    implements _$$PluginStateImplCopyWith<$Res> {
  __$$PluginStateImplCopyWithImpl(
      _$PluginStateImpl _value, $Res Function(_$PluginStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentModel = freezed,
    Object? needsUpdate = null,
    Object? progress = null,
  }) {
    return _then(_$PluginStateImpl(
      currentModel: freezed == currentModel
          ? _value.currentModel
          : currentModel // ignore: cast_nullable_to_non_nullable
              as String?,
      needsUpdate: null == needsUpdate
          ? _value.needsUpdate
          : needsUpdate // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PluginStateImpl implements _PluginState {
  _$PluginStateImpl(
      {this.currentModel, this.needsUpdate = false, this.progress = 0});

  @override
  String? currentModel;
  @override
  @JsonKey()
  bool needsUpdate;
  @override
  @JsonKey()
  int progress;

  @override
  String toString() {
    return 'PluginState(currentModel: $currentModel, needsUpdate: $needsUpdate, progress: $progress)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PluginStateImplCopyWith<_$PluginStateImpl> get copyWith =>
      __$$PluginStateImplCopyWithImpl<_$PluginStateImpl>(this, _$identity);
}

abstract class _PluginState implements PluginState {
  factory _PluginState({String? currentModel, bool needsUpdate, int progress}) =
      _$PluginStateImpl;

  @override
  String? get currentModel;
  set currentModel(String? value);
  @override
  bool get needsUpdate;
  set needsUpdate(bool value);
  @override
  int get progress;
  set progress(int value);
  @override
  @JsonKey(ignore: true)
  _$$PluginStateImplCopyWith<_$PluginStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
