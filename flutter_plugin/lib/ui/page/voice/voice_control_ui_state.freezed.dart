// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_control_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VoiceControlUiState {
  List<AiSoundModel> get soundList => throw _privateConstructorUsedError;
  bool get isForeign => throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VoiceControlUiStateCopyWith<VoiceControlUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoiceControlUiStateCopyWith<$Res> {
  factory $VoiceControlUiStateCopyWith(
          VoiceControlUiState value, $Res Function(VoiceControlUiState) then) =
      _$VoiceControlUiStateCopyWithImpl<$Res, VoiceControlUiState>;
  @useResult
  $Res call(
      {List<AiSoundModel> soundList, bool isForeign, CommonUIEvent? uiEvent});
}

/// @nodoc
class _$VoiceControlUiStateCopyWithImpl<$Res, $Val extends VoiceControlUiState>
    implements $VoiceControlUiStateCopyWith<$Res> {
  _$VoiceControlUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? soundList = null,
    Object? isForeign = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_value.copyWith(
      soundList: null == soundList
          ? _value.soundList
          : soundList // ignore: cast_nullable_to_non_nullable
              as List<AiSoundModel>,
      isForeign: null == isForeign
          ? _value.isForeign
          : isForeign // ignore: cast_nullable_to_non_nullable
              as bool,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VoiceControlUiStateImplCopyWith<$Res>
    implements $VoiceControlUiStateCopyWith<$Res> {
  factory _$$VoiceControlUiStateImplCopyWith(_$VoiceControlUiStateImpl value,
          $Res Function(_$VoiceControlUiStateImpl) then) =
      __$$VoiceControlUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AiSoundModel> soundList, bool isForeign, CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$VoiceControlUiStateImplCopyWithImpl<$Res>
    extends _$VoiceControlUiStateCopyWithImpl<$Res, _$VoiceControlUiStateImpl>
    implements _$$VoiceControlUiStateImplCopyWith<$Res> {
  __$$VoiceControlUiStateImplCopyWithImpl(_$VoiceControlUiStateImpl _value,
      $Res Function(_$VoiceControlUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? soundList = null,
    Object? isForeign = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_$VoiceControlUiStateImpl(
      soundList: null == soundList
          ? _value._soundList
          : soundList // ignore: cast_nullable_to_non_nullable
              as List<AiSoundModel>,
      isForeign: null == isForeign
          ? _value.isForeign
          : isForeign // ignore: cast_nullable_to_non_nullable
              as bool,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$VoiceControlUiStateImpl implements _VoiceControlUiState {
  _$VoiceControlUiStateImpl(
      {final List<AiSoundModel> soundList = const [],
      this.isForeign = false,
      this.uiEvent})
      : _soundList = soundList;

  final List<AiSoundModel> _soundList;
  @override
  @JsonKey()
  List<AiSoundModel> get soundList {
    if (_soundList is EqualUnmodifiableListView) return _soundList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_soundList);
  }

  @override
  @JsonKey()
  final bool isForeign;
  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'VoiceControlUiState(soundList: $soundList, isForeign: $isForeign, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoiceControlUiStateImpl &&
            const DeepCollectionEquality()
                .equals(other._soundList, _soundList) &&
            (identical(other.isForeign, isForeign) ||
                other.isForeign == isForeign) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_soundList), isForeign, uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VoiceControlUiStateImplCopyWith<_$VoiceControlUiStateImpl> get copyWith =>
      __$$VoiceControlUiStateImplCopyWithImpl<_$VoiceControlUiStateImpl>(
          this, _$identity);
}

abstract class _VoiceControlUiState implements VoiceControlUiState {
  factory _VoiceControlUiState(
      {final List<AiSoundModel> soundList,
      final bool isForeign,
      final CommonUIEvent? uiEvent}) = _$VoiceControlUiStateImpl;

  @override
  List<AiSoundModel> get soundList;
  @override
  bool get isForeign;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$VoiceControlUiStateImplCopyWith<_$VoiceControlUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
