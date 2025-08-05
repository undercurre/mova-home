// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'js_map_navigation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

JSMapLocation _$JSMapLocationFromJson(Map<String, dynamic> json) {
  return _JSMapLocation.fromJson(json);
}

/// @nodoc
mixin _$JSMapLocation {
  String? get lon => throw _privateConstructorUsedError;
  String? get lat => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JSMapLocationCopyWith<JSMapLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JSMapLocationCopyWith<$Res> {
  factory $JSMapLocationCopyWith(
          JSMapLocation value, $Res Function(JSMapLocation) then) =
      _$JSMapLocationCopyWithImpl<$Res, JSMapLocation>;
  @useResult
  $Res call({String? lon, String? lat});
}

/// @nodoc
class _$JSMapLocationCopyWithImpl<$Res, $Val extends JSMapLocation>
    implements $JSMapLocationCopyWith<$Res> {
  _$JSMapLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lon = freezed,
    Object? lat = freezed,
  }) {
    return _then(_value.copyWith(
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JSMapLocationImplCopyWith<$Res>
    implements $JSMapLocationCopyWith<$Res> {
  factory _$$JSMapLocationImplCopyWith(
          _$JSMapLocationImpl value, $Res Function(_$JSMapLocationImpl) then) =
      __$$JSMapLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? lon, String? lat});
}

/// @nodoc
class __$$JSMapLocationImplCopyWithImpl<$Res>
    extends _$JSMapLocationCopyWithImpl<$Res, _$JSMapLocationImpl>
    implements _$$JSMapLocationImplCopyWith<$Res> {
  __$$JSMapLocationImplCopyWithImpl(
      _$JSMapLocationImpl _value, $Res Function(_$JSMapLocationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lon = freezed,
    Object? lat = freezed,
  }) {
    return _then(_$JSMapLocationImpl(
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JSMapLocationImpl implements _JSMapLocation {
  const _$JSMapLocationImpl({this.lon, this.lat});

  factory _$JSMapLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$JSMapLocationImplFromJson(json);

  @override
  final String? lon;
  @override
  final String? lat;

  @override
  String toString() {
    return 'JSMapLocation(lon: $lon, lat: $lat)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JSMapLocationImpl &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.lat, lat) || other.lat == lat));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, lon, lat);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JSMapLocationImplCopyWith<_$JSMapLocationImpl> get copyWith =>
      __$$JSMapLocationImplCopyWithImpl<_$JSMapLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JSMapLocationImplToJson(
      this,
    );
  }
}

abstract class _JSMapLocation implements JSMapLocation {
  const factory _JSMapLocation({final String? lon, final String? lat}) =
      _$JSMapLocationImpl;

  factory _JSMapLocation.fromJson(Map<String, dynamic> json) =
      _$JSMapLocationImpl.fromJson;

  @override
  String? get lon;
  @override
  String? get lat;
  @override
  @JsonKey(ignore: true)
  _$$JSMapLocationImplCopyWith<_$JSMapLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
