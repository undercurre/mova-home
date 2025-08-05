// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'after_sale_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AfterSaleConfig _$AfterSaleConfigFromJson(Map<String, dynamic> json) {
  return _AfterSaleConfig.fromJson(json);
}

/// @nodoc
mixin _$AfterSaleConfig {
  String? get contactNumber => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get ext => throw _privateConstructorUsedError;
  int get onlineService => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AfterSaleConfigCopyWith<AfterSaleConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AfterSaleConfigCopyWith<$Res> {
  factory $AfterSaleConfigCopyWith(
          AfterSaleConfig value, $Res Function(AfterSaleConfig) then) =
      _$AfterSaleConfigCopyWithImpl<$Res, AfterSaleConfig>;
  @useResult
  $Res call(
      {String? contactNumber,
      String? website,
      String? email,
      String? country,
      String? ext,
      int onlineService});
}

/// @nodoc
class _$AfterSaleConfigCopyWithImpl<$Res, $Val extends AfterSaleConfig>
    implements $AfterSaleConfigCopyWith<$Res> {
  _$AfterSaleConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactNumber = freezed,
    Object? website = freezed,
    Object? email = freezed,
    Object? country = freezed,
    Object? ext = freezed,
    Object? onlineService = null,
  }) {
    return _then(_value.copyWith(
      contactNumber: freezed == contactNumber
          ? _value.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      ext: freezed == ext
          ? _value.ext
          : ext // ignore: cast_nullable_to_non_nullable
              as String?,
      onlineService: null == onlineService
          ? _value.onlineService
          : onlineService // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AfterSaleConfigImplCopyWith<$Res>
    implements $AfterSaleConfigCopyWith<$Res> {
  factory _$$AfterSaleConfigImplCopyWith(_$AfterSaleConfigImpl value,
          $Res Function(_$AfterSaleConfigImpl) then) =
      __$$AfterSaleConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? contactNumber,
      String? website,
      String? email,
      String? country,
      String? ext,
      int onlineService});
}

/// @nodoc
class __$$AfterSaleConfigImplCopyWithImpl<$Res>
    extends _$AfterSaleConfigCopyWithImpl<$Res, _$AfterSaleConfigImpl>
    implements _$$AfterSaleConfigImplCopyWith<$Res> {
  __$$AfterSaleConfigImplCopyWithImpl(
      _$AfterSaleConfigImpl _value, $Res Function(_$AfterSaleConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contactNumber = freezed,
    Object? website = freezed,
    Object? email = freezed,
    Object? country = freezed,
    Object? ext = freezed,
    Object? onlineService = null,
  }) {
    return _then(_$AfterSaleConfigImpl(
      contactNumber: freezed == contactNumber
          ? _value.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      ext: freezed == ext
          ? _value.ext
          : ext // ignore: cast_nullable_to_non_nullable
              as String?,
      onlineService: null == onlineService
          ? _value.onlineService
          : onlineService // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AfterSaleConfigImpl implements _AfterSaleConfig {
  _$AfterSaleConfigImpl(
      {this.contactNumber,
      this.website,
      this.email,
      this.country,
      this.ext,
      this.onlineService = 0});

  factory _$AfterSaleConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AfterSaleConfigImplFromJson(json);

  @override
  final String? contactNumber;
  @override
  final String? website;
  @override
  final String? email;
  @override
  final String? country;
  @override
  final String? ext;
  @override
  @JsonKey()
  final int onlineService;

  @override
  String toString() {
    return 'AfterSaleConfig(contactNumber: $contactNumber, website: $website, email: $email, country: $country, ext: $ext, onlineService: $onlineService)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AfterSaleConfigImpl &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.ext, ext) || other.ext == ext) &&
            (identical(other.onlineService, onlineService) ||
                other.onlineService == onlineService));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, contactNumber, website, email, country, ext, onlineService);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AfterSaleConfigImplCopyWith<_$AfterSaleConfigImpl> get copyWith =>
      __$$AfterSaleConfigImplCopyWithImpl<_$AfterSaleConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AfterSaleConfigImplToJson(
      this,
    );
  }
}

abstract class _AfterSaleConfig implements AfterSaleConfig {
  factory _AfterSaleConfig(
      {final String? contactNumber,
      final String? website,
      final String? email,
      final String? country,
      final String? ext,
      final int onlineService}) = _$AfterSaleConfigImpl;

  factory _AfterSaleConfig.fromJson(Map<String, dynamic> json) =
      _$AfterSaleConfigImpl.fromJson;

  @override
  String? get contactNumber;
  @override
  String? get website;
  @override
  String? get email;
  @override
  String? get country;
  @override
  String? get ext;
  @override
  int get onlineService;
  @override
  @JsonKey(ignore: true)
  _$$AfterSaleConfigImplCopyWith<_$AfterSaleConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
