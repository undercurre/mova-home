// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggest_history_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SuggestHistoryUiState {
  CommonUIEvent get event => throw _privateConstructorUsedError;
  List<SuggestHistoryItem>? get records => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SuggestHistoryUiStateCopyWith<SuggestHistoryUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestHistoryUiStateCopyWith<$Res> {
  factory $SuggestHistoryUiStateCopyWith(SuggestHistoryUiState value,
          $Res Function(SuggestHistoryUiState) then) =
      _$SuggestHistoryUiStateCopyWithImpl<$Res, SuggestHistoryUiState>;
  @useResult
  $Res call({CommonUIEvent event, List<SuggestHistoryItem>? records});
}

/// @nodoc
class _$SuggestHistoryUiStateCopyWithImpl<$Res,
        $Val extends SuggestHistoryUiState>
    implements $SuggestHistoryUiStateCopyWith<$Res> {
  _$SuggestHistoryUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? records = freezed,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      records: freezed == records
          ? _value.records
          : records // ignore: cast_nullable_to_non_nullable
              as List<SuggestHistoryItem>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestHistoryUiStateImplCopyWith<$Res>
    implements $SuggestHistoryUiStateCopyWith<$Res> {
  factory _$$SuggestHistoryUiStateImplCopyWith(
          _$SuggestHistoryUiStateImpl value,
          $Res Function(_$SuggestHistoryUiStateImpl) then) =
      __$$SuggestHistoryUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CommonUIEvent event, List<SuggestHistoryItem>? records});
}

/// @nodoc
class __$$SuggestHistoryUiStateImplCopyWithImpl<$Res>
    extends _$SuggestHistoryUiStateCopyWithImpl<$Res,
        _$SuggestHistoryUiStateImpl>
    implements _$$SuggestHistoryUiStateImplCopyWith<$Res> {
  __$$SuggestHistoryUiStateImplCopyWithImpl(_$SuggestHistoryUiStateImpl _value,
      $Res Function(_$SuggestHistoryUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? records = freezed,
  }) {
    return _then(_$SuggestHistoryUiStateImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      records: freezed == records
          ? _value._records
          : records // ignore: cast_nullable_to_non_nullable
              as List<SuggestHistoryItem>?,
    ));
  }
}

/// @nodoc

class _$SuggestHistoryUiStateImpl implements _SuggestHistoryUiState {
  const _$SuggestHistoryUiStateImpl(
      {this.event = const EmptyEvent(),
      final List<SuggestHistoryItem>? records})
      : _records = records;

  @override
  @JsonKey()
  final CommonUIEvent event;
  final List<SuggestHistoryItem>? _records;
  @override
  List<SuggestHistoryItem>? get records {
    final value = _records;
    if (value == null) return null;
    if (_records is EqualUnmodifiableListView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SuggestHistoryUiState(event: $event, records: $records)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestHistoryUiStateImpl &&
            (identical(other.event, event) || other.event == event) &&
            const DeepCollectionEquality().equals(other._records, _records));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, event, const DeepCollectionEquality().hash(_records));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestHistoryUiStateImplCopyWith<_$SuggestHistoryUiStateImpl>
      get copyWith => __$$SuggestHistoryUiStateImplCopyWithImpl<
          _$SuggestHistoryUiStateImpl>(this, _$identity);
}

abstract class _SuggestHistoryUiState implements SuggestHistoryUiState {
  const factory _SuggestHistoryUiState(
      {final CommonUIEvent event,
      final List<SuggestHistoryItem>? records}) = _$SuggestHistoryUiStateImpl;

  @override
  CommonUIEvent get event;
  @override
  List<SuggestHistoryItem>? get records;
  @override
  @JsonKey(ignore: true)
  _$$SuggestHistoryUiStateImplCopyWith<_$SuggestHistoryUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
