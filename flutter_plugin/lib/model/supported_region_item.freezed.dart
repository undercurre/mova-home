// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supported_region_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SupportedRegionItem _$SupportedRegionItemFromJson(Map<String, dynamic> json) {
  return _SupportedRegionItem.fromJson(json);
}

/// @nodoc
mixin _$SupportedRegionItem {
  @JsonKey(name: 'id')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'country_code')
  String? get countryCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_enabled')
  int? get isEnabled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupportedRegionItemCopyWith<SupportedRegionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupportedRegionItemCopyWith<$Res> {
  factory $SupportedRegionItemCopyWith(
          SupportedRegionItem value, $Res Function(SupportedRegionItem) then) =
      _$SupportedRegionItemCopyWithImpl<$Res, SupportedRegionItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'country_code') String? countryCode,
      @JsonKey(name: 'is_enabled') int? isEnabled});
}

/// @nodoc
class _$SupportedRegionItemCopyWithImpl<$Res, $Val extends SupportedRegionItem>
    implements $SupportedRegionItemCopyWith<$Res> {
  _$SupportedRegionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? countryCode = freezed,
    Object? isEnabled = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnabled: freezed == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupportedRegionItemImplCopyWith<$Res>
    implements $SupportedRegionItemCopyWith<$Res> {
  factory _$$SupportedRegionItemImplCopyWith(_$SupportedRegionItemImpl value,
          $Res Function(_$SupportedRegionItemImpl) then) =
      __$$SupportedRegionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'country_code') String? countryCode,
      @JsonKey(name: 'is_enabled') int? isEnabled});
}

/// @nodoc
class __$$SupportedRegionItemImplCopyWithImpl<$Res>
    extends _$SupportedRegionItemCopyWithImpl<$Res, _$SupportedRegionItemImpl>
    implements _$$SupportedRegionItemImplCopyWith<$Res> {
  __$$SupportedRegionItemImplCopyWithImpl(_$SupportedRegionItemImpl _value,
      $Res Function(_$SupportedRegionItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? countryCode = freezed,
    Object? isEnabled = freezed,
  }) {
    return _then(_$SupportedRegionItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isEnabled: freezed == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupportedRegionItemImpl implements _SupportedRegionItem {
  _$SupportedRegionItemImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'country_code') this.countryCode,
      @JsonKey(name: 'is_enabled') this.isEnabled});

  factory _$SupportedRegionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupportedRegionItemImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'country_code')
  final String? countryCode;
  @override
  @JsonKey(name: 'is_enabled')
  final int? isEnabled;

  @override
  String toString() {
    return 'SupportedRegionItem(id: $id, countryCode: $countryCode, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupportedRegionItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, countryCode, isEnabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupportedRegionItemImplCopyWith<_$SupportedRegionItemImpl> get copyWith =>
      __$$SupportedRegionItemImplCopyWithImpl<_$SupportedRegionItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupportedRegionItemImplToJson(
      this,
    );
  }
}

abstract class _SupportedRegionItem implements SupportedRegionItem {
  factory _SupportedRegionItem(
          {@JsonKey(name: 'id') final int? id,
          @JsonKey(name: 'country_code') final String? countryCode,
          @JsonKey(name: 'is_enabled') final int? isEnabled}) =
      _$SupportedRegionItemImpl;

  factory _SupportedRegionItem.fromJson(Map<String, dynamic> json) =
      _$SupportedRegionItemImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int? get id;
  @override
  @JsonKey(name: 'country_code')
  String? get countryCode;
  @override
  @JsonKey(name: 'is_enabled')
  int? get isEnabled;
  @override
  @JsonKey(ignore: true)
  _$$SupportedRegionItemImplCopyWith<_$SupportedRegionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
