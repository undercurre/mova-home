// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'after_sale_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AfterSaleItem _$AfterSaleItemFromJson(Map<String, dynamic> json) {
  return _AfterSaleItem.fromJson(json);
}

/// @nodoc
mixin _$AfterSaleItem {
  String? get key => throw _privateConstructorUsedError;
  List<AfterSaleItemValue> get valueList => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AfterSaleItemCopyWith<AfterSaleItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AfterSaleItemCopyWith<$Res> {
  factory $AfterSaleItemCopyWith(
          AfterSaleItem value, $Res Function(AfterSaleItem) then) =
      _$AfterSaleItemCopyWithImpl<$Res, AfterSaleItem>;
  @useResult
  $Res call({String? key, List<AfterSaleItemValue> valueList});
}

/// @nodoc
class _$AfterSaleItemCopyWithImpl<$Res, $Val extends AfterSaleItem>
    implements $AfterSaleItemCopyWith<$Res> {
  _$AfterSaleItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? valueList = null,
  }) {
    return _then(_value.copyWith(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      valueList: null == valueList
          ? _value.valueList
          : valueList // ignore: cast_nullable_to_non_nullable
              as List<AfterSaleItemValue>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AfterSaleItemImplCopyWith<$Res>
    implements $AfterSaleItemCopyWith<$Res> {
  factory _$$AfterSaleItemImplCopyWith(
          _$AfterSaleItemImpl value, $Res Function(_$AfterSaleItemImpl) then) =
      __$$AfterSaleItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? key, List<AfterSaleItemValue> valueList});
}

/// @nodoc
class __$$AfterSaleItemImplCopyWithImpl<$Res>
    extends _$AfterSaleItemCopyWithImpl<$Res, _$AfterSaleItemImpl>
    implements _$$AfterSaleItemImplCopyWith<$Res> {
  __$$AfterSaleItemImplCopyWithImpl(
      _$AfterSaleItemImpl _value, $Res Function(_$AfterSaleItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? valueList = null,
  }) {
    return _then(_$AfterSaleItemImpl(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      valueList: null == valueList
          ? _value._valueList
          : valueList // ignore: cast_nullable_to_non_nullable
              as List<AfterSaleItemValue>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AfterSaleItemImpl implements _AfterSaleItem {
  _$AfterSaleItemImpl(
      {this.key, final List<AfterSaleItemValue> valueList = const []})
      : _valueList = valueList;

  factory _$AfterSaleItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AfterSaleItemImplFromJson(json);

  @override
  final String? key;
  final List<AfterSaleItemValue> _valueList;
  @override
  @JsonKey()
  List<AfterSaleItemValue> get valueList {
    if (_valueList is EqualUnmodifiableListView) return _valueList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_valueList);
  }

  @override
  String toString() {
    return 'AfterSaleItem(key: $key, valueList: $valueList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AfterSaleItemImpl &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality()
                .equals(other._valueList, _valueList));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, key, const DeepCollectionEquality().hash(_valueList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AfterSaleItemImplCopyWith<_$AfterSaleItemImpl> get copyWith =>
      __$$AfterSaleItemImplCopyWithImpl<_$AfterSaleItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AfterSaleItemImplToJson(
      this,
    );
  }
}

abstract class _AfterSaleItem implements AfterSaleItem {
  factory _AfterSaleItem(
      {final String? key,
      final List<AfterSaleItemValue> valueList}) = _$AfterSaleItemImpl;

  factory _AfterSaleItem.fromJson(Map<String, dynamic> json) =
      _$AfterSaleItemImpl.fromJson;

  @override
  String? get key;
  @override
  List<AfterSaleItemValue> get valueList;
  @override
  @JsonKey(ignore: true)
  _$$AfterSaleItemImplCopyWith<_$AfterSaleItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AfterSaleItemValue _$AfterSaleItemValueFromJson(Map<String, dynamic> json) {
  return _AfterSaleItemValue.fromJson(json);
}

/// @nodoc
mixin _$AfterSaleItemValue {
  String? get channelContent => throw _privateConstructorUsedError;
  String? get jumpContent => throw _privateConstructorUsedError;
  String? get androidJumpLink => throw _privateConstructorUsedError;
  String? get iosJumpLink => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AfterSaleItemValueCopyWith<AfterSaleItemValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AfterSaleItemValueCopyWith<$Res> {
  factory $AfterSaleItemValueCopyWith(
          AfterSaleItemValue value, $Res Function(AfterSaleItemValue) then) =
      _$AfterSaleItemValueCopyWithImpl<$Res, AfterSaleItemValue>;
  @useResult
  $Res call(
      {String? channelContent,
      String? jumpContent,
      String? androidJumpLink,
      String? iosJumpLink});
}

/// @nodoc
class _$AfterSaleItemValueCopyWithImpl<$Res, $Val extends AfterSaleItemValue>
    implements $AfterSaleItemValueCopyWith<$Res> {
  _$AfterSaleItemValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelContent = freezed,
    Object? jumpContent = freezed,
    Object? androidJumpLink = freezed,
    Object? iosJumpLink = freezed,
  }) {
    return _then(_value.copyWith(
      channelContent: freezed == channelContent
          ? _value.channelContent
          : channelContent // ignore: cast_nullable_to_non_nullable
              as String?,
      jumpContent: freezed == jumpContent
          ? _value.jumpContent
          : jumpContent // ignore: cast_nullable_to_non_nullable
              as String?,
      androidJumpLink: freezed == androidJumpLink
          ? _value.androidJumpLink
          : androidJumpLink // ignore: cast_nullable_to_non_nullable
              as String?,
      iosJumpLink: freezed == iosJumpLink
          ? _value.iosJumpLink
          : iosJumpLink // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AfterSaleItemValueImplCopyWith<$Res>
    implements $AfterSaleItemValueCopyWith<$Res> {
  factory _$$AfterSaleItemValueImplCopyWith(_$AfterSaleItemValueImpl value,
          $Res Function(_$AfterSaleItemValueImpl) then) =
      __$$AfterSaleItemValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? channelContent,
      String? jumpContent,
      String? androidJumpLink,
      String? iosJumpLink});
}

/// @nodoc
class __$$AfterSaleItemValueImplCopyWithImpl<$Res>
    extends _$AfterSaleItemValueCopyWithImpl<$Res, _$AfterSaleItemValueImpl>
    implements _$$AfterSaleItemValueImplCopyWith<$Res> {
  __$$AfterSaleItemValueImplCopyWithImpl(_$AfterSaleItemValueImpl _value,
      $Res Function(_$AfterSaleItemValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelContent = freezed,
    Object? jumpContent = freezed,
    Object? androidJumpLink = freezed,
    Object? iosJumpLink = freezed,
  }) {
    return _then(_$AfterSaleItemValueImpl(
      channelContent: freezed == channelContent
          ? _value.channelContent
          : channelContent // ignore: cast_nullable_to_non_nullable
              as String?,
      jumpContent: freezed == jumpContent
          ? _value.jumpContent
          : jumpContent // ignore: cast_nullable_to_non_nullable
              as String?,
      androidJumpLink: freezed == androidJumpLink
          ? _value.androidJumpLink
          : androidJumpLink // ignore: cast_nullable_to_non_nullable
              as String?,
      iosJumpLink: freezed == iosJumpLink
          ? _value.iosJumpLink
          : iosJumpLink // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AfterSaleItemValueImpl implements _AfterSaleItemValue {
  _$AfterSaleItemValueImpl(
      {this.channelContent,
      this.jumpContent,
      this.androidJumpLink,
      this.iosJumpLink});

  factory _$AfterSaleItemValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$AfterSaleItemValueImplFromJson(json);

  @override
  final String? channelContent;
  @override
  final String? jumpContent;
  @override
  final String? androidJumpLink;
  @override
  final String? iosJumpLink;

  @override
  String toString() {
    return 'AfterSaleItemValue(channelContent: $channelContent, jumpContent: $jumpContent, androidJumpLink: $androidJumpLink, iosJumpLink: $iosJumpLink)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AfterSaleItemValueImpl &&
            (identical(other.channelContent, channelContent) ||
                other.channelContent == channelContent) &&
            (identical(other.jumpContent, jumpContent) ||
                other.jumpContent == jumpContent) &&
            (identical(other.androidJumpLink, androidJumpLink) ||
                other.androidJumpLink == androidJumpLink) &&
            (identical(other.iosJumpLink, iosJumpLink) ||
                other.iosJumpLink == iosJumpLink));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, channelContent, jumpContent, androidJumpLink, iosJumpLink);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AfterSaleItemValueImplCopyWith<_$AfterSaleItemValueImpl> get copyWith =>
      __$$AfterSaleItemValueImplCopyWithImpl<_$AfterSaleItemValueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AfterSaleItemValueImplToJson(
      this,
    );
  }
}

abstract class _AfterSaleItemValue implements AfterSaleItemValue {
  factory _AfterSaleItemValue(
      {final String? channelContent,
      final String? jumpContent,
      final String? androidJumpLink,
      final String? iosJumpLink}) = _$AfterSaleItemValueImpl;

  factory _AfterSaleItemValue.fromJson(Map<String, dynamic> json) =
      _$AfterSaleItemValueImpl.fromJson;

  @override
  String? get channelContent;
  @override
  String? get jumpContent;
  @override
  String? get androidJumpLink;
  @override
  String? get iosJumpLink;
  @override
  @JsonKey(ignore: true)
  _$$AfterSaleItemValueImplCopyWith<_$AfterSaleItemValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
