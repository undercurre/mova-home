// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mall_debug_page_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MallDebugPageUIState {
  bool get enable => throw _privateConstructorUsedError;
  String? get host => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MallDebugPageUIStateCopyWith<MallDebugPageUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MallDebugPageUIStateCopyWith<$Res> {
  factory $MallDebugPageUIStateCopyWith(MallDebugPageUIState value,
          $Res Function(MallDebugPageUIState) then) =
      _$MallDebugPageUIStateCopyWithImpl<$Res, MallDebugPageUIState>;
  @useResult
  $Res call({bool enable, String? host});
}

/// @nodoc
class _$MallDebugPageUIStateCopyWithImpl<$Res,
        $Val extends MallDebugPageUIState>
    implements $MallDebugPageUIStateCopyWith<$Res> {
  _$MallDebugPageUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enable = null,
    Object? host = freezed,
  }) {
    return _then(_value.copyWith(
      enable: null == enable
          ? _value.enable
          : enable // ignore: cast_nullable_to_non_nullable
              as bool,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MallDebugPageUIStateImplCopyWith<$Res>
    implements $MallDebugPageUIStateCopyWith<$Res> {
  factory _$$MallDebugPageUIStateImplCopyWith(_$MallDebugPageUIStateImpl value,
          $Res Function(_$MallDebugPageUIStateImpl) then) =
      __$$MallDebugPageUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enable, String? host});
}

/// @nodoc
class __$$MallDebugPageUIStateImplCopyWithImpl<$Res>
    extends _$MallDebugPageUIStateCopyWithImpl<$Res, _$MallDebugPageUIStateImpl>
    implements _$$MallDebugPageUIStateImplCopyWith<$Res> {
  __$$MallDebugPageUIStateImplCopyWithImpl(_$MallDebugPageUIStateImpl _value,
      $Res Function(_$MallDebugPageUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enable = null,
    Object? host = freezed,
  }) {
    return _then(_$MallDebugPageUIStateImpl(
      enable: null == enable
          ? _value.enable
          : enable // ignore: cast_nullable_to_non_nullable
              as bool,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MallDebugPageUIStateImpl implements _MallDebugPageUIState {
  _$MallDebugPageUIStateImpl({this.enable = false, this.host = null});

  @override
  @JsonKey()
  final bool enable;
  @override
  @JsonKey()
  final String? host;

  @override
  String toString() {
    return 'MallDebugPageUIState(enable: $enable, host: $host)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MallDebugPageUIStateImpl &&
            (identical(other.enable, enable) || other.enable == enable) &&
            (identical(other.host, host) || other.host == host));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enable, host);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MallDebugPageUIStateImplCopyWith<_$MallDebugPageUIStateImpl>
      get copyWith =>
          __$$MallDebugPageUIStateImplCopyWithImpl<_$MallDebugPageUIStateImpl>(
              this, _$identity);
}

abstract class _MallDebugPageUIState implements MallDebugPageUIState {
  factory _MallDebugPageUIState({final bool enable, final String? host}) =
      _$MallDebugPageUIStateImpl;

  @override
  bool get enable;
  @override
  String? get host;
  @override
  @JsonKey(ignore: true)
  _$$MallDebugPageUIStateImplCopyWith<_$MallDebugPageUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
