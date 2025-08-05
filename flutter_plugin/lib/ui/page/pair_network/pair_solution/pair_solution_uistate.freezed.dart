// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pair_solution_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PairSolutionUiState {
  List<String> get listContent => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PairSolutionUiStateCopyWith<PairSolutionUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairSolutionUiStateCopyWith<$Res> {
  factory $PairSolutionUiStateCopyWith(
          PairSolutionUiState value, $Res Function(PairSolutionUiState) then) =
      _$PairSolutionUiStateCopyWithImpl<$Res, PairSolutionUiState>;
  @useResult
  $Res call({List<String> listContent, CommonUIEvent event});
}

/// @nodoc
class _$PairSolutionUiStateCopyWithImpl<$Res, $Val extends PairSolutionUiState>
    implements $PairSolutionUiStateCopyWith<$Res> {
  _$PairSolutionUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? listContent = null,
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      listContent: null == listContent
          ? _value.listContent
          : listContent // ignore: cast_nullable_to_non_nullable
              as List<String>,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PairSolutionUiStateImplCopyWith<$Res>
    implements $PairSolutionUiStateCopyWith<$Res> {
  factory _$$PairSolutionUiStateImplCopyWith(_$PairSolutionUiStateImpl value,
          $Res Function(_$PairSolutionUiStateImpl) then) =
      __$$PairSolutionUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> listContent, CommonUIEvent event});
}

/// @nodoc
class __$$PairSolutionUiStateImplCopyWithImpl<$Res>
    extends _$PairSolutionUiStateCopyWithImpl<$Res, _$PairSolutionUiStateImpl>
    implements _$$PairSolutionUiStateImplCopyWith<$Res> {
  __$$PairSolutionUiStateImplCopyWithImpl(_$PairSolutionUiStateImpl _value,
      $Res Function(_$PairSolutionUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? listContent = null,
    Object? event = null,
  }) {
    return _then(_$PairSolutionUiStateImpl(
      listContent: null == listContent
          ? _value._listContent
          : listContent // ignore: cast_nullable_to_non_nullable
              as List<String>,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$PairSolutionUiStateImpl implements _PairSolutionUiState {
  const _$PairSolutionUiStateImpl(
      {final List<String> listContent = const [],
      this.event = const EmptyEvent()})
      : _listContent = listContent;

  final List<String> _listContent;
  @override
  @JsonKey()
  List<String> get listContent {
    if (_listContent is EqualUnmodifiableListView) return _listContent;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listContent);
  }

  @override
  @JsonKey()
  final CommonUIEvent event;

  @override
  String toString() {
    return 'PairSolutionUiState(listContent: $listContent, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairSolutionUiStateImpl &&
            const DeepCollectionEquality()
                .equals(other._listContent, _listContent) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_listContent), event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PairSolutionUiStateImplCopyWith<_$PairSolutionUiStateImpl> get copyWith =>
      __$$PairSolutionUiStateImplCopyWithImpl<_$PairSolutionUiStateImpl>(
          this, _$identity);
}

abstract class _PairSolutionUiState implements PairSolutionUiState {
  const factory _PairSolutionUiState(
      {final List<String> listContent,
      final CommonUIEvent event}) = _$PairSolutionUiStateImpl;

  @override
  List<String> get listContent;
  @override
  CommonUIEvent get event;
  @override
  @JsonKey(ignore: true)
  _$$PairSolutionUiStateImplCopyWith<_$PairSolutionUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
