// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggest_history_detail_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SuggestHistoryDetailUiState {
  CommonUIEvent get event => throw _privateConstructorUsedError;
  SuggestHistoryItem? get history => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SuggestHistoryDetailUiStateCopyWith<SuggestHistoryDetailUiState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestHistoryDetailUiStateCopyWith<$Res> {
  factory $SuggestHistoryDetailUiStateCopyWith(
          SuggestHistoryDetailUiState value,
          $Res Function(SuggestHistoryDetailUiState) then) =
      _$SuggestHistoryDetailUiStateCopyWithImpl<$Res,
          SuggestHistoryDetailUiState>;
  @useResult
  $Res call({CommonUIEvent event, SuggestHistoryItem? history});
}

/// @nodoc
class _$SuggestHistoryDetailUiStateCopyWithImpl<$Res,
        $Val extends SuggestHistoryDetailUiState>
    implements $SuggestHistoryDetailUiStateCopyWith<$Res> {
  _$SuggestHistoryDetailUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? history = freezed,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      history: freezed == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as SuggestHistoryItem?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestHistoryDetailUiStateImplCopyWith<$Res>
    implements $SuggestHistoryDetailUiStateCopyWith<$Res> {
  factory _$$SuggestHistoryDetailUiStateImplCopyWith(
          _$SuggestHistoryDetailUiStateImpl value,
          $Res Function(_$SuggestHistoryDetailUiStateImpl) then) =
      __$$SuggestHistoryDetailUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CommonUIEvent event, SuggestHistoryItem? history});
}

/// @nodoc
class __$$SuggestHistoryDetailUiStateImplCopyWithImpl<$Res>
    extends _$SuggestHistoryDetailUiStateCopyWithImpl<$Res,
        _$SuggestHistoryDetailUiStateImpl>
    implements _$$SuggestHistoryDetailUiStateImplCopyWith<$Res> {
  __$$SuggestHistoryDetailUiStateImplCopyWithImpl(
      _$SuggestHistoryDetailUiStateImpl _value,
      $Res Function(_$SuggestHistoryDetailUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? history = freezed,
  }) {
    return _then(_$SuggestHistoryDetailUiStateImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      history: freezed == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as SuggestHistoryItem?,
    ));
  }
}

/// @nodoc

class _$SuggestHistoryDetailUiStateImpl
    implements _SuggestHistoryDetailUiState {
  const _$SuggestHistoryDetailUiStateImpl(
      {this.event = const EmptyEvent(), this.history});

  @override
  @JsonKey()
  final CommonUIEvent event;
  @override
  final SuggestHistoryItem? history;

  @override
  String toString() {
    return 'SuggestHistoryDetailUiState(event: $event, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestHistoryDetailUiStateImpl &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.history, history) || other.history == history));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event, history);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestHistoryDetailUiStateImplCopyWith<_$SuggestHistoryDetailUiStateImpl>
      get copyWith => __$$SuggestHistoryDetailUiStateImplCopyWithImpl<
          _$SuggestHistoryDetailUiStateImpl>(this, _$identity);
}

abstract class _SuggestHistoryDetailUiState
    implements SuggestHistoryDetailUiState {
  const factory _SuggestHistoryDetailUiState(
      {final CommonUIEvent event,
      final SuggestHistoryItem? history}) = _$SuggestHistoryDetailUiStateImpl;

  @override
  CommonUIEvent get event;
  @override
  SuggestHistoryItem? get history;
  @override
  @JsonKey(ignore: true)
  _$$SuggestHistoryDetailUiStateImplCopyWith<_$SuggestHistoryDetailUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
