// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discuz_debug_page_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DiscuzDebugPageUIState {
  bool get enable => throw _privateConstructorUsedError;
  String? get host => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DiscuzDebugPageUIStateCopyWith<DiscuzDebugPageUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscuzDebugPageUIStateCopyWith<$Res> {
  factory $DiscuzDebugPageUIStateCopyWith(DiscuzDebugPageUIState value,
          $Res Function(DiscuzDebugPageUIState) then) =
      _$DiscuzDebugPageUIStateCopyWithImpl<$Res, DiscuzDebugPageUIState>;
  @useResult
  $Res call({bool enable, String? host});
}

/// @nodoc
class _$DiscuzDebugPageUIStateCopyWithImpl<$Res,
        $Val extends DiscuzDebugPageUIState>
    implements $DiscuzDebugPageUIStateCopyWith<$Res> {
  _$DiscuzDebugPageUIStateCopyWithImpl(this._value, this._then);

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
abstract class _$$DiscuzDebugPageUIStateImplCopyWith<$Res>
    implements $DiscuzDebugPageUIStateCopyWith<$Res> {
  factory _$$DiscuzDebugPageUIStateImplCopyWith(
          _$DiscuzDebugPageUIStateImpl value,
          $Res Function(_$DiscuzDebugPageUIStateImpl) then) =
      __$$DiscuzDebugPageUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enable, String? host});
}

/// @nodoc
class __$$DiscuzDebugPageUIStateImplCopyWithImpl<$Res>
    extends _$DiscuzDebugPageUIStateCopyWithImpl<$Res,
        _$DiscuzDebugPageUIStateImpl>
    implements _$$DiscuzDebugPageUIStateImplCopyWith<$Res> {
  __$$DiscuzDebugPageUIStateImplCopyWithImpl(
      _$DiscuzDebugPageUIStateImpl _value,
      $Res Function(_$DiscuzDebugPageUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enable = null,
    Object? host = freezed,
  }) {
    return _then(_$DiscuzDebugPageUIStateImpl(
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

class _$DiscuzDebugPageUIStateImpl implements _DiscuzDebugPageUIState {
  _$DiscuzDebugPageUIStateImpl({this.enable = false, this.host = null});

  @override
  @JsonKey()
  final bool enable;
  @override
  @JsonKey()
  final String? host;

  @override
  String toString() {
    return 'DiscuzDebugPageUIState(enable: $enable, host: $host)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscuzDebugPageUIStateImpl &&
            (identical(other.enable, enable) || other.enable == enable) &&
            (identical(other.host, host) || other.host == host));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enable, host);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscuzDebugPageUIStateImplCopyWith<_$DiscuzDebugPageUIStateImpl>
      get copyWith => __$$DiscuzDebugPageUIStateImplCopyWithImpl<
          _$DiscuzDebugPageUIStateImpl>(this, _$identity);
}

abstract class _DiscuzDebugPageUIState implements DiscuzDebugPageUIState {
  factory _DiscuzDebugPageUIState({final bool enable, final String? host}) =
      _$DiscuzDebugPageUIStateImpl;

  @override
  bool get enable;
  @override
  String? get host;
  @override
  @JsonKey(ignore: true)
  _$$DiscuzDebugPageUIStateImplCopyWith<_$DiscuzDebugPageUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
