// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tab_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TabConfig _$TabConfigFromJson(Map<String, dynamic> json) {
  return _TabConfig.fromJson(json);
}

/// @nodoc
mixin _$TabConfig {
  String? get type => throw _privateConstructorUsedError;
  set type(String? value) => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  set url(String? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TabConfigCopyWith<TabConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TabConfigCopyWith<$Res> {
  factory $TabConfigCopyWith(TabConfig value, $Res Function(TabConfig) then) =
      _$TabConfigCopyWithImpl<$Res, TabConfig>;
  @useResult
  $Res call({String? type, String? url});
}

/// @nodoc
class _$TabConfigCopyWithImpl<$Res, $Val extends TabConfig>
    implements $TabConfigCopyWith<$Res> {
  _$TabConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TabConfigImplCopyWith<$Res>
    implements $TabConfigCopyWith<$Res> {
  factory _$$TabConfigImplCopyWith(
          _$TabConfigImpl value, $Res Function(_$TabConfigImpl) then) =
      __$$TabConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? type, String? url});
}

/// @nodoc
class __$$TabConfigImplCopyWithImpl<$Res>
    extends _$TabConfigCopyWithImpl<$Res, _$TabConfigImpl>
    implements _$$TabConfigImplCopyWith<$Res> {
  __$$TabConfigImplCopyWithImpl(
      _$TabConfigImpl _value, $Res Function(_$TabConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? url = freezed,
  }) {
    return _then(_$TabConfigImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TabConfigImpl extends _TabConfig {
  _$TabConfigImpl({this.type, this.url}) : super._();

  factory _$TabConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TabConfigImplFromJson(json);

  @override
  String? type;
  @override
  String? url;

  @override
  String toString() {
    return 'TabConfig(type: $type, url: $url)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TabConfigImplCopyWith<_$TabConfigImpl> get copyWith =>
      __$$TabConfigImplCopyWithImpl<_$TabConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TabConfigImplToJson(
      this,
    );
  }
}

abstract class _TabConfig extends TabConfig {
  factory _TabConfig({String? type, String? url}) = _$TabConfigImpl;
  _TabConfig._() : super._();

  factory _TabConfig.fromJson(Map<String, dynamic> json) =
      _$TabConfigImpl.fromJson;

  @override
  String? get type;
  set type(String? value);
  @override
  String? get url;
  set url(String? value);
  @override
  @JsonKey(ignore: true)
  _$$TabConfigImplCopyWith<_$TabConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
