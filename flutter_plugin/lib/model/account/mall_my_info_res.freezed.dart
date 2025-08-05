// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mall_my_info_res.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BaseMallResponse<T> _$BaseMallResponseFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _BaseMallResponse<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$BaseMallResponse<T> {
  T? get data => throw _privateConstructorUsedError;
  String? get msg => throw _privateConstructorUsedError;
  int? get code => throw _privateConstructorUsedError;
  bool? get success => throw _privateConstructorUsedError;
  int? get iRet => throw _privateConstructorUsedError;
  String? get sMsg => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BaseMallResponseCopyWith<T, BaseMallResponse<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseMallResponseCopyWith<T, $Res> {
  factory $BaseMallResponseCopyWith(
          BaseMallResponse<T> value, $Res Function(BaseMallResponse<T>) then) =
      _$BaseMallResponseCopyWithImpl<T, $Res, BaseMallResponse<T>>;
  @useResult
  $Res call(
      {T? data,
      String? msg,
      int? code,
      bool? success,
      int? iRet,
      String? sMsg});
}

/// @nodoc
class _$BaseMallResponseCopyWithImpl<T, $Res, $Val extends BaseMallResponse<T>>
    implements $BaseMallResponseCopyWith<T, $Res> {
  _$BaseMallResponseCopyWithImpl(this._value, this._then);

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
    Object? iRet = freezed,
    Object? sMsg = freezed,
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
              as bool?,
      iRet: freezed == iRet
          ? _value.iRet
          : iRet // ignore: cast_nullable_to_non_nullable
              as int?,
      sMsg: freezed == sMsg
          ? _value.sMsg
          : sMsg // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BaseMallResponseCopyWith<T, $Res>
    implements $BaseMallResponseCopyWith<T, $Res> {
  factory _$$_BaseMallResponseCopyWith(_$_BaseMallResponse<T> value,
          $Res Function(_$_BaseMallResponse<T>) then) =
      __$$_BaseMallResponseCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {T? data,
      String? msg,
      int? code,
      bool? success,
      int? iRet,
      String? sMsg});
}

/// @nodoc
class __$$_BaseMallResponseCopyWithImpl<T, $Res>
    extends _$BaseMallResponseCopyWithImpl<T, $Res, _$_BaseMallResponse<T>>
    implements _$$_BaseMallResponseCopyWith<T, $Res> {
  __$$_BaseMallResponseCopyWithImpl(_$_BaseMallResponse<T> _value,
      $Res Function(_$_BaseMallResponse<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? msg = freezed,
    Object? code = freezed,
    Object? success = freezed,
    Object? iRet = freezed,
    Object? sMsg = freezed,
  }) {
    return _then(_$_BaseMallResponse<T>(
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
              as bool?,
      iRet: freezed == iRet
          ? _value.iRet
          : iRet // ignore: cast_nullable_to_non_nullable
              as int?,
      sMsg: freezed == sMsg
          ? _value.sMsg
          : sMsg // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$_BaseMallResponse<T>
    with DiagnosticableTreeMixin
    implements _BaseMallResponse<T> {
  const _$_BaseMallResponse(
      {this.data, this.msg, this.code, this.success, this.iRet, this.sMsg});

  factory _$_BaseMallResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$_BaseMallResponseFromJson(json, fromJsonT);

  @override
  final T? data;
  @override
  final String? msg;
  @override
  final int? code;
  @override
  final bool? success;
  @override
  final int? iRet;
  @override
  final String? sMsg;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BaseMallResponse<$T>(data: $data, msg: $msg, code: $code, success: $success, iRet: $iRet, sMsg: $sMsg)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'BaseMallResponse<$T>'))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('msg', msg))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('success', success))
      ..add(DiagnosticsProperty('iRet', iRet))
      ..add(DiagnosticsProperty('sMsg', sMsg));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BaseMallResponse<T> &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.iRet, iRet) || other.iRet == iRet) &&
            (identical(other.sMsg, sMsg) || other.sMsg == sMsg));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(data),
      msg,
      code,
      success,
      iRet,
      sMsg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BaseMallResponseCopyWith<T, _$_BaseMallResponse<T>> get copyWith =>
      __$$_BaseMallResponseCopyWithImpl<T, _$_BaseMallResponse<T>>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$_BaseMallResponseToJson<T>(this, toJsonT);
  }
}

abstract class _BaseMallResponse<T> implements BaseMallResponse<T> {
  const factory _BaseMallResponse(
      {final T? data,
      final String? msg,
      final int? code,
      final bool? success,
      final int? iRet,
      final String? sMsg}) = _$_BaseMallResponse<T>;

  factory _BaseMallResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$_BaseMallResponse<T>.fromJson;

  @override
  T? get data;
  @override
  String? get msg;
  @override
  int? get code;
  @override
  bool? get success;
  @override
  int? get iRet;
  @override
  String? get sMsg;
  @override
  @JsonKey(ignore: true)
  _$$_BaseMallResponseCopyWith<T, _$_BaseMallResponse<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
