// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pair_type_selection_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PairTypeSelectionUIState {
  PairConnectMethod get connectMethod => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PairTypeSelectionUIStateCopyWith<PairTypeSelectionUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairTypeSelectionUIStateCopyWith<$Res> {
  factory $PairTypeSelectionUIStateCopyWith(PairTypeSelectionUIState value,
          $Res Function(PairTypeSelectionUIState) then) =
      _$PairTypeSelectionUIStateCopyWithImpl<$Res, PairTypeSelectionUIState>;
  @useResult
  $Res call({PairConnectMethod connectMethod});
}

/// @nodoc
class _$PairTypeSelectionUIStateCopyWithImpl<$Res,
        $Val extends PairTypeSelectionUIState>
    implements $PairTypeSelectionUIStateCopyWith<$Res> {
  _$PairTypeSelectionUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectMethod = null,
  }) {
    return _then(_value.copyWith(
      connectMethod: null == connectMethod
          ? _value.connectMethod
          : connectMethod // ignore: cast_nullable_to_non_nullable
              as PairConnectMethod,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PairTypeSelectionUIStateImplCopyWith<$Res>
    implements $PairTypeSelectionUIStateCopyWith<$Res> {
  factory _$$PairTypeSelectionUIStateImplCopyWith(
          _$PairTypeSelectionUIStateImpl value,
          $Res Function(_$PairTypeSelectionUIStateImpl) then) =
      __$$PairTypeSelectionUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PairConnectMethod connectMethod});
}

/// @nodoc
class __$$PairTypeSelectionUIStateImplCopyWithImpl<$Res>
    extends _$PairTypeSelectionUIStateCopyWithImpl<$Res,
        _$PairTypeSelectionUIStateImpl>
    implements _$$PairTypeSelectionUIStateImplCopyWith<$Res> {
  __$$PairTypeSelectionUIStateImplCopyWithImpl(
      _$PairTypeSelectionUIStateImpl _value,
      $Res Function(_$PairTypeSelectionUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectMethod = null,
  }) {
    return _then(_$PairTypeSelectionUIStateImpl(
      connectMethod: null == connectMethod
          ? _value.connectMethod
          : connectMethod // ignore: cast_nullable_to_non_nullable
              as PairConnectMethod,
    ));
  }
}

/// @nodoc

class _$PairTypeSelectionUIStateImpl implements _PairTypeSelectionUIState {
  const _$PairTypeSelectionUIStateImpl(
      {this.connectMethod = PairConnectMethod.WIFI});

  @override
  @JsonKey()
  final PairConnectMethod connectMethod;

  @override
  String toString() {
    return 'PairTypeSelectionUIState(connectMethod: $connectMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairTypeSelectionUIStateImpl &&
            (identical(other.connectMethod, connectMethod) ||
                other.connectMethod == connectMethod));
  }

  @override
  int get hashCode => Object.hash(runtimeType, connectMethod);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PairTypeSelectionUIStateImplCopyWith<_$PairTypeSelectionUIStateImpl>
      get copyWith => __$$PairTypeSelectionUIStateImplCopyWithImpl<
          _$PairTypeSelectionUIStateImpl>(this, _$identity);
}

abstract class _PairTypeSelectionUIState implements PairTypeSelectionUIState {
  const factory _PairTypeSelectionUIState(
      {final PairConnectMethod connectMethod}) = _$PairTypeSelectionUIStateImpl;

  @override
  PairConnectMethod get connectMethod;
  @override
  @JsonKey(ignore: true)
  _$$PairTypeSelectionUIStateImplCopyWith<_$PairTypeSelectionUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
