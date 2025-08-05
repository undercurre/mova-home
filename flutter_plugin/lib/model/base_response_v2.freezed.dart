// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_response_v2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BaseResponseV2<T> _$BaseResponseV2FromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _BaseResponseV2<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$BaseResponseV2<T> {
  T? get data => throw _privateConstructorUsedError;
  String? get msg => throw _privateConstructorUsedError;
  int? get code => throw _privateConstructorUsedError;
  dynamic get success => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BaseResponseV2CopyWith<T, BaseResponseV2<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseResponseV2CopyWith<T, $Res> {
  factory $BaseResponseV2CopyWith(
          BaseResponseV2<T> value, $Res Function(BaseResponseV2<T>) then) =
      _$BaseResponseV2CopyWithImpl<T, $Res, BaseResponseV2<T>>;
  @useResult
  $Res call({T? data, String? msg, int? code, dynamic success});
}

/// @nodoc
class _$BaseResponseV2CopyWithImpl<T, $Res, $Val extends BaseResponseV2<T>>
    implements $BaseResponseV2CopyWith<T, $Res> {
  _$BaseResponseV2CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? msg = freezed,
    Object? code = freezed,
    Object? success = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BaseResponseV2CopyWith<T, $Res>
    implements $BaseResponseV2CopyWith<T, $Res> {
  factory _$$_BaseResponseV2CopyWith(_$_BaseResponseV2<T> value,
          $Res Function(_$_BaseResponseV2<T>) then) =
      __$$_BaseResponseV2CopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T? data, String? msg, int? code, dynamic success});
}

/// @nodoc
class __$$_BaseResponseV2CopyWithImpl<T, $Res>
    extends _$BaseResponseV2CopyWithImpl<T, $Res, _$_BaseResponseV2<T>>
    implements _$$_BaseResponseV2CopyWith<T, $Res> {
  __$$_BaseResponseV2CopyWithImpl(
      _$_BaseResponseV2<T> _value, $Res Function(_$_BaseResponseV2<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? msg = freezed,
    Object? code = freezed,
    Object? success = freezed,
  }) {
    return _then(_$_BaseResponseV2<T>(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$_BaseResponseV2<T>
    with DiagnosticableTreeMixin
    implements _BaseResponseV2<T> {
  const _$_BaseResponseV2({this.data, this.msg, this.code, this.success});

  factory _$_BaseResponseV2.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$_BaseResponseV2FromJson(json, fromJsonT);

  @override
  final T? data;
  @override
  final String? msg;
  @override
  final int? code;
  @override
  final dynamic success;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BaseResponseV2<$T>(data: $data, msg: $msg, code: $code, success: $success)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'BaseResponseV2<$T>'))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('msg', msg))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('success', success));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BaseResponseV2<T> &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            (identical(other.code, code) || other.code == code) &&
            const DeepCollectionEquality().equals(other.success, success));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(data),
      msg,
      code,
      const DeepCollectionEquality().hash(success));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BaseResponseV2CopyWith<T, _$_BaseResponseV2<T>> get copyWith =>
      __$$_BaseResponseV2CopyWithImpl<T, _$_BaseResponseV2<T>>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$_BaseResponseV2ToJson<T>(this, toJsonT);
  }
}

abstract class _BaseResponseV2<T> implements BaseResponseV2<T> {
  const factory _BaseResponseV2(
      {final T? data,
      final String? msg,
      final int? code,
      final dynamic success}) = _$_BaseResponseV2<T>;

  factory _BaseResponseV2.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$_BaseResponseV2<T>.fromJson;

  @override
  T? get data;
  @override
  String? get msg;
  @override
  int? get code;
  @override
  dynamic get success;
  @override
  @JsonKey(ignore: true)
  _$$_BaseResponseV2CopyWith<T, _$_BaseResponseV2<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
