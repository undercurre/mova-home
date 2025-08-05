// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_resource_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductResourceConfigModel _$ProductResourceConfigModelFromJson(
    Map<String, dynamic> json) {
  return _ProductResourceConfigModel.fromJson(json);
}

/// @nodoc
mixin _$ProductResourceConfigModel {
  String? get productId => throw _privateConstructorUsedError;
  String? get dictKey => throw _privateConstructorUsedError;
  String? get dictValue => throw _privateConstructorUsedError;
  String? get fileName => throw _privateConstructorUsedError;
  String? get filePath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductResourceConfigModelCopyWith<ProductResourceConfigModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductResourceConfigModelCopyWith<$Res> {
  factory $ProductResourceConfigModelCopyWith(ProductResourceConfigModel value,
          $Res Function(ProductResourceConfigModel) then) =
      _$ProductResourceConfigModelCopyWithImpl<$Res,
          ProductResourceConfigModel>;
  @useResult
  $Res call(
      {String? productId,
      String? dictKey,
      String? dictValue,
      String? fileName,
      String? filePath});
}

/// @nodoc
class _$ProductResourceConfigModelCopyWithImpl<$Res,
        $Val extends ProductResourceConfigModel>
    implements $ProductResourceConfigModelCopyWith<$Res> {
  _$ProductResourceConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? dictKey = freezed,
    Object? dictValue = freezed,
    Object? fileName = freezed,
    Object? filePath = freezed,
  }) {
    return _then(_value.copyWith(
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      dictKey: freezed == dictKey
          ? _value.dictKey
          : dictKey // ignore: cast_nullable_to_non_nullable
              as String?,
      dictValue: freezed == dictValue
          ? _value.dictValue
          : dictValue // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductResourceConfigModelImplCopyWith<$Res>
    implements $ProductResourceConfigModelCopyWith<$Res> {
  factory _$$ProductResourceConfigModelImplCopyWith(
          _$ProductResourceConfigModelImpl value,
          $Res Function(_$ProductResourceConfigModelImpl) then) =
      __$$ProductResourceConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? productId,
      String? dictKey,
      String? dictValue,
      String? fileName,
      String? filePath});
}

/// @nodoc
class __$$ProductResourceConfigModelImplCopyWithImpl<$Res>
    extends _$ProductResourceConfigModelCopyWithImpl<$Res,
        _$ProductResourceConfigModelImpl>
    implements _$$ProductResourceConfigModelImplCopyWith<$Res> {
  __$$ProductResourceConfigModelImplCopyWithImpl(
      _$ProductResourceConfigModelImpl _value,
      $Res Function(_$ProductResourceConfigModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? dictKey = freezed,
    Object? dictValue = freezed,
    Object? fileName = freezed,
    Object? filePath = freezed,
  }) {
    return _then(_$ProductResourceConfigModelImpl(
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      dictKey: freezed == dictKey
          ? _value.dictKey
          : dictKey // ignore: cast_nullable_to_non_nullable
              as String?,
      dictValue: freezed == dictValue
          ? _value.dictValue
          : dictValue // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductResourceConfigModelImpl implements _ProductResourceConfigModel {
  const _$ProductResourceConfigModelImpl(
      {this.productId,
      this.dictKey,
      this.dictValue,
      this.fileName,
      this.filePath});

  factory _$ProductResourceConfigModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ProductResourceConfigModelImplFromJson(json);

  @override
  final String? productId;
  @override
  final String? dictKey;
  @override
  final String? dictValue;
  @override
  final String? fileName;
  @override
  final String? filePath;

  @override
  String toString() {
    return 'ProductResourceConfigModel(productId: $productId, dictKey: $dictKey, dictValue: $dictValue, fileName: $fileName, filePath: $filePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductResourceConfigModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.dictKey, dictKey) || other.dictKey == dictKey) &&
            (identical(other.dictValue, dictValue) ||
                other.dictValue == dictValue) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, productId, dictKey, dictValue, fileName, filePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductResourceConfigModelImplCopyWith<_$ProductResourceConfigModelImpl>
      get copyWith => __$$ProductResourceConfigModelImplCopyWithImpl<
          _$ProductResourceConfigModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductResourceConfigModelImplToJson(
      this,
    );
  }
}

abstract class _ProductResourceConfigModel
    implements ProductResourceConfigModel {
  const factory _ProductResourceConfigModel(
      {final String? productId,
      final String? dictKey,
      final String? dictValue,
      final String? fileName,
      final String? filePath}) = _$ProductResourceConfigModelImpl;

  factory _ProductResourceConfigModel.fromJson(Map<String, dynamic> json) =
      _$ProductResourceConfigModelImpl.fromJson;

  @override
  String? get productId;
  @override
  String? get dictKey;
  @override
  String? get dictValue;
  @override
  String? get fileName;
  @override
  String? get filePath;
  @override
  @JsonKey(ignore: true)
  _$$ProductResourceConfigModelImplCopyWith<_$ProductResourceConfigModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
