// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mall_content_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MallContentStateUiState {
  CommonUIEvent get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MallContentStateUiStateCopyWith<MallContentStateUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MallContentStateUiStateCopyWith<$Res> {
  factory $MallContentStateUiStateCopyWith(MallContentStateUiState value,
          $Res Function(MallContentStateUiState) then) =
      _$MallContentStateUiStateCopyWithImpl<$Res, MallContentStateUiState>;
  @useResult
  $Res call({CommonUIEvent event});
}

/// @nodoc
class _$MallContentStateUiStateCopyWithImpl<$Res,
        $Val extends MallContentStateUiState>
    implements $MallContentStateUiStateCopyWith<$Res> {
  _$MallContentStateUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MallContentStateUiStateImplCopyWith<$Res>
    implements $MallContentStateUiStateCopyWith<$Res> {
  factory _$$MallContentStateUiStateImplCopyWith(
          _$MallContentStateUiStateImpl value,
          $Res Function(_$MallContentStateUiStateImpl) then) =
      __$$MallContentStateUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CommonUIEvent event});
}

/// @nodoc
class __$$MallContentStateUiStateImplCopyWithImpl<$Res>
    extends _$MallContentStateUiStateCopyWithImpl<$Res,
        _$MallContentStateUiStateImpl>
    implements _$$MallContentStateUiStateImplCopyWith<$Res> {
  __$$MallContentStateUiStateImplCopyWithImpl(
      _$MallContentStateUiStateImpl _value,
      $Res Function(_$MallContentStateUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
  }) {
    return _then(_$MallContentStateUiStateImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$MallContentStateUiStateImpl implements _MallContentStateUiState {
  const _$MallContentStateUiStateImpl({this.event = const EmptyEvent()});

  @override
  @JsonKey()
  final CommonUIEvent event;

  @override
  String toString() {
    return 'MallContentStateUiState(event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MallContentStateUiStateImpl &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MallContentStateUiStateImplCopyWith<_$MallContentStateUiStateImpl>
      get copyWith => __$$MallContentStateUiStateImplCopyWithImpl<
          _$MallContentStateUiStateImpl>(this, _$identity);
}

abstract class _MallContentStateUiState implements MallContentStateUiState {
  const factory _MallContentStateUiState({final CommonUIEvent event}) =
      _$MallContentStateUiStateImpl;

  @override
  CommonUIEvent get event;
  @override
  @JsonKey(ignore: true)
  _$$MallContentStateUiStateImplCopyWith<_$MallContentStateUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
