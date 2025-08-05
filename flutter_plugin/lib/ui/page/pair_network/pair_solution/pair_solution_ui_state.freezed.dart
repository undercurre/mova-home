// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pair_solution_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PairSolutionUiState {
  List<PairSolutionModel> get solutions => throw _privateConstructorUsedError;

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
  $Res call({List<PairSolutionModel> solutions});
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
    Object? solutions = null,
  }) {
    return _then(_value.copyWith(
      solutions: null == solutions
          ? _value.solutions
          : solutions // ignore: cast_nullable_to_non_nullable
              as List<PairSolutionModel>,
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
  $Res call({List<PairSolutionModel> solutions});
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
    Object? solutions = null,
  }) {
    return _then(_$PairSolutionUiStateImpl(
      solutions: null == solutions
          ? _value._solutions
          : solutions // ignore: cast_nullable_to_non_nullable
              as List<PairSolutionModel>,
    ));
  }
}

/// @nodoc

class _$PairSolutionUiStateImpl implements _PairSolutionUiState {
  _$PairSolutionUiStateImpl(
      {final List<PairSolutionModel> solutions = const []})
      : _solutions = solutions;

  final List<PairSolutionModel> _solutions;
  @override
  @JsonKey()
  List<PairSolutionModel> get solutions {
    if (_solutions is EqualUnmodifiableListView) return _solutions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_solutions);
  }

  @override
  String toString() {
    return 'PairSolutionUiState(solutions: $solutions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairSolutionUiStateImpl &&
            const DeepCollectionEquality()
                .equals(other._solutions, _solutions));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_solutions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PairSolutionUiStateImplCopyWith<_$PairSolutionUiStateImpl> get copyWith =>
      __$$PairSolutionUiStateImplCopyWithImpl<_$PairSolutionUiStateImpl>(
          this, _$identity);
}

abstract class _PairSolutionUiState implements PairSolutionUiState {
  factory _PairSolutionUiState({final List<PairSolutionModel> solutions}) =
      _$PairSolutionUiStateImpl;

  @override
  List<PairSolutionModel> get solutions;
  @override
  @JsonKey(ignore: true)
  _$$PairSolutionUiStateImplCopyWith<_$PairSolutionUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
