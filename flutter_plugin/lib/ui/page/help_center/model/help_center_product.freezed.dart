// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_center_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HelpCenterKindOfProduct _$HelpCenterKindOfProductFromJson(
    Map<String, dynamic> json) {
  return _HelpCenterKindOfProduct.fromJson(json);
}

/// @nodoc
mixin _$HelpCenterKindOfProduct {
  String get categoryId => throw _privateConstructorUsedError;
  int get categoryOrder => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<HelpCenterProduct> get childrenList =>
      throw _privateConstructorUsedError; // 调试字段
  bool get isSelected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HelpCenterKindOfProductCopyWith<HelpCenterKindOfProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HelpCenterKindOfProductCopyWith<$Res> {
  factory $HelpCenterKindOfProductCopyWith(HelpCenterKindOfProduct value,
          $Res Function(HelpCenterKindOfProduct) then) =
      _$HelpCenterKindOfProductCopyWithImpl<$Res, HelpCenterKindOfProduct>;
  @useResult
  $Res call(
      {String categoryId,
      int categoryOrder,
      String name,
      List<HelpCenterProduct> childrenList,
      bool isSelected});
}

/// @nodoc
class _$HelpCenterKindOfProductCopyWithImpl<$Res,
        $Val extends HelpCenterKindOfProduct>
    implements $HelpCenterKindOfProductCopyWith<$Res> {
  _$HelpCenterKindOfProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryOrder = null,
    Object? name = null,
    Object? childrenList = null,
    Object? isSelected = null,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryOrder: null == categoryOrder
          ? _value.categoryOrder
          : categoryOrder // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      childrenList: null == childrenList
          ? _value.childrenList
          : childrenList // ignore: cast_nullable_to_non_nullable
              as List<HelpCenterProduct>,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HelpCenterKindOfProductImplCopyWith<$Res>
    implements $HelpCenterKindOfProductCopyWith<$Res> {
  factory _$$HelpCenterKindOfProductImplCopyWith(
          _$HelpCenterKindOfProductImpl value,
          $Res Function(_$HelpCenterKindOfProductImpl) then) =
      __$$HelpCenterKindOfProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String categoryId,
      int categoryOrder,
      String name,
      List<HelpCenterProduct> childrenList,
      bool isSelected});
}

/// @nodoc
class __$$HelpCenterKindOfProductImplCopyWithImpl<$Res>
    extends _$HelpCenterKindOfProductCopyWithImpl<$Res,
        _$HelpCenterKindOfProductImpl>
    implements _$$HelpCenterKindOfProductImplCopyWith<$Res> {
  __$$HelpCenterKindOfProductImplCopyWithImpl(
      _$HelpCenterKindOfProductImpl _value,
      $Res Function(_$HelpCenterKindOfProductImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryOrder = null,
    Object? name = null,
    Object? childrenList = null,
    Object? isSelected = null,
  }) {
    return _then(_$HelpCenterKindOfProductImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryOrder: null == categoryOrder
          ? _value.categoryOrder
          : categoryOrder // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      childrenList: null == childrenList
          ? _value._childrenList
          : childrenList // ignore: cast_nullable_to_non_nullable
              as List<HelpCenterProduct>,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HelpCenterKindOfProductImpl implements _HelpCenterKindOfProduct {
  _$HelpCenterKindOfProductImpl(
      {this.categoryId = '',
      this.categoryOrder = -1,
      this.name = '',
      final List<HelpCenterProduct> childrenList = const [],
      this.isSelected = false})
      : _childrenList = childrenList;

  factory _$HelpCenterKindOfProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$HelpCenterKindOfProductImplFromJson(json);

  @override
  @JsonKey()
  final String categoryId;
  @override
  @JsonKey()
  final int categoryOrder;
  @override
  @JsonKey()
  final String name;
  final List<HelpCenterProduct> _childrenList;
  @override
  @JsonKey()
  List<HelpCenterProduct> get childrenList {
    if (_childrenList is EqualUnmodifiableListView) return _childrenList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childrenList);
  }

// 调试字段
  @override
  @JsonKey()
  final bool isSelected;

  @override
  String toString() {
    return 'HelpCenterKindOfProduct(categoryId: $categoryId, categoryOrder: $categoryOrder, name: $name, childrenList: $childrenList, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HelpCenterKindOfProductImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryOrder, categoryOrder) ||
                other.categoryOrder == categoryOrder) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._childrenList, _childrenList) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, categoryId, categoryOrder, name,
      const DeepCollectionEquality().hash(_childrenList), isSelected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HelpCenterKindOfProductImplCopyWith<_$HelpCenterKindOfProductImpl>
      get copyWith => __$$HelpCenterKindOfProductImplCopyWithImpl<
          _$HelpCenterKindOfProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HelpCenterKindOfProductImplToJson(
      this,
    );
  }
}

abstract class _HelpCenterKindOfProduct implements HelpCenterKindOfProduct {
  factory _HelpCenterKindOfProduct(
      {final String categoryId,
      final int categoryOrder,
      final String name,
      final List<HelpCenterProduct> childrenList,
      final bool isSelected}) = _$HelpCenterKindOfProductImpl;

  factory _HelpCenterKindOfProduct.fromJson(Map<String, dynamic> json) =
      _$HelpCenterKindOfProductImpl.fromJson;

  @override
  String get categoryId;
  @override
  int get categoryOrder;
  @override
  String get name;
  @override
  List<HelpCenterProduct> get childrenList;
  @override // 调试字段
  bool get isSelected;
  @override
  @JsonKey(ignore: true)
  _$$HelpCenterKindOfProductImplCopyWith<_$HelpCenterKindOfProductImpl>
      get copyWith => throw _privateConstructorUsedError;
}

HelpCenterProduct _$HelpCenterProductFromJson(Map<String, dynamic> json) {
  return _HelpCenterProduct.fromJson(json);
}

/// @nodoc
mixin _$HelpCenterProduct {
  String? get displayName => throw _privateConstructorUsedError;
  set displayName(String? value) => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  set model(String? value) => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  set productId(String? value) => throw _privateConstructorUsedError;
  HelpCenterProductImage? get mainImage => throw _privateConstructorUsedError;
  set mainImage(HelpCenterProductImage? value) =>
      throw _privateConstructorUsedError;
  Map<String, String> get quickConnects => throw _privateConstructorUsedError;
  set quickConnects(Map<String, String> value) =>
      throw _privateConstructorUsedError;
  int get tag => throw _privateConstructorUsedError;
  set tag(int value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HelpCenterProductCopyWith<HelpCenterProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HelpCenterProductCopyWith<$Res> {
  factory $HelpCenterProductCopyWith(
          HelpCenterProduct value, $Res Function(HelpCenterProduct) then) =
      _$HelpCenterProductCopyWithImpl<$Res, HelpCenterProduct>;
  @useResult
  $Res call(
      {String? displayName,
      String? model,
      String? productId,
      HelpCenterProductImage? mainImage,
      Map<String, String> quickConnects,
      int tag});

  $HelpCenterProductImageCopyWith<$Res>? get mainImage;
}

/// @nodoc
class _$HelpCenterProductCopyWithImpl<$Res, $Val extends HelpCenterProduct>
    implements $HelpCenterProductCopyWith<$Res> {
  _$HelpCenterProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = freezed,
    Object? model = freezed,
    Object? productId = freezed,
    Object? mainImage = freezed,
    Object? quickConnects = null,
    Object? tag = null,
  }) {
    return _then(_value.copyWith(
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      mainImage: freezed == mainImage
          ? _value.mainImage
          : mainImage // ignore: cast_nullable_to_non_nullable
              as HelpCenterProductImage?,
      quickConnects: null == quickConnects
          ? _value.quickConnects
          : quickConnects // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HelpCenterProductImageCopyWith<$Res>? get mainImage {
    if (_value.mainImage == null) {
      return null;
    }

    return $HelpCenterProductImageCopyWith<$Res>(_value.mainImage!, (value) {
      return _then(_value.copyWith(mainImage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HelpCenterProductImplCopyWith<$Res>
    implements $HelpCenterProductCopyWith<$Res> {
  factory _$$HelpCenterProductImplCopyWith(_$HelpCenterProductImpl value,
          $Res Function(_$HelpCenterProductImpl) then) =
      __$$HelpCenterProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? displayName,
      String? model,
      String? productId,
      HelpCenterProductImage? mainImage,
      Map<String, String> quickConnects,
      int tag});

  @override
  $HelpCenterProductImageCopyWith<$Res>? get mainImage;
}

/// @nodoc
class __$$HelpCenterProductImplCopyWithImpl<$Res>
    extends _$HelpCenterProductCopyWithImpl<$Res, _$HelpCenterProductImpl>
    implements _$$HelpCenterProductImplCopyWith<$Res> {
  __$$HelpCenterProductImplCopyWithImpl(_$HelpCenterProductImpl _value,
      $Res Function(_$HelpCenterProductImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = freezed,
    Object? model = freezed,
    Object? productId = freezed,
    Object? mainImage = freezed,
    Object? quickConnects = null,
    Object? tag = null,
  }) {
    return _then(_$HelpCenterProductImpl(
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      mainImage: freezed == mainImage
          ? _value.mainImage
          : mainImage // ignore: cast_nullable_to_non_nullable
              as HelpCenterProductImage?,
      quickConnects: null == quickConnects
          ? _value.quickConnects
          : quickConnects // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HelpCenterProductImpl implements _HelpCenterProduct {
  _$HelpCenterProductImpl(
      {this.displayName,
      this.model,
      this.productId,
      this.mainImage,
      this.quickConnects = const {},
      this.tag = 0});

  factory _$HelpCenterProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$HelpCenterProductImplFromJson(json);

  @override
  String? displayName;
  @override
  String? model;
  @override
  String? productId;
  @override
  HelpCenterProductImage? mainImage;
  @override
  @JsonKey()
  Map<String, String> quickConnects;
  @override
  @JsonKey()
  int tag;

  @override
  String toString() {
    return 'HelpCenterProduct(displayName: $displayName, model: $model, productId: $productId, mainImage: $mainImage, quickConnects: $quickConnects, tag: $tag)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HelpCenterProductImplCopyWith<_$HelpCenterProductImpl> get copyWith =>
      __$$HelpCenterProductImplCopyWithImpl<_$HelpCenterProductImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HelpCenterProductImplToJson(
      this,
    );
  }
}

abstract class _HelpCenterProduct implements HelpCenterProduct {
  factory _HelpCenterProduct(
      {String? displayName,
      String? model,
      String? productId,
      HelpCenterProductImage? mainImage,
      Map<String, String> quickConnects,
      int tag}) = _$HelpCenterProductImpl;

  factory _HelpCenterProduct.fromJson(Map<String, dynamic> json) =
      _$HelpCenterProductImpl.fromJson;

  @override
  String? get displayName;
  set displayName(String? value);
  @override
  String? get model;
  set model(String? value);
  @override
  String? get productId;
  set productId(String? value);
  @override
  HelpCenterProductImage? get mainImage;
  set mainImage(HelpCenterProductImage? value);
  @override
  Map<String, String> get quickConnects;
  set quickConnects(Map<String, String> value);
  @override
  int get tag;
  set tag(int value);
  @override
  @JsonKey(ignore: true)
  _$$HelpCenterProductImplCopyWith<_$HelpCenterProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HelpCenterProductImage _$HelpCenterProductImageFromJson(
    Map<String, dynamic> json) {
  return _HelpCenterProductImage.fromJson(json);
}

/// @nodoc
mixin _$HelpCenterProductImage {
  String? get as => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get smallImageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HelpCenterProductImageCopyWith<HelpCenterProductImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HelpCenterProductImageCopyWith<$Res> {
  factory $HelpCenterProductImageCopyWith(HelpCenterProductImage value,
          $Res Function(HelpCenterProductImage) then) =
      _$HelpCenterProductImageCopyWithImpl<$Res, HelpCenterProductImage>;
  @useResult
  $Res call(
      {String? as,
      String? caption,
      int height,
      int width,
      String? imageUrl,
      String? smallImageUrl});
}

/// @nodoc
class _$HelpCenterProductImageCopyWithImpl<$Res,
        $Val extends HelpCenterProductImage>
    implements $HelpCenterProductImageCopyWith<$Res> {
  _$HelpCenterProductImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? as = freezed,
    Object? caption = freezed,
    Object? height = null,
    Object? width = null,
    Object? imageUrl = freezed,
    Object? smallImageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      as: freezed == as
          ? _value.as
          : as // ignore: cast_nullable_to_non_nullable
              as String?,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      smallImageUrl: freezed == smallImageUrl
          ? _value.smallImageUrl
          : smallImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HelpCenterProductImageImplCopyWith<$Res>
    implements $HelpCenterProductImageCopyWith<$Res> {
  factory _$$HelpCenterProductImageImplCopyWith(
          _$HelpCenterProductImageImpl value,
          $Res Function(_$HelpCenterProductImageImpl) then) =
      __$$HelpCenterProductImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? as,
      String? caption,
      int height,
      int width,
      String? imageUrl,
      String? smallImageUrl});
}

/// @nodoc
class __$$HelpCenterProductImageImplCopyWithImpl<$Res>
    extends _$HelpCenterProductImageCopyWithImpl<$Res,
        _$HelpCenterProductImageImpl>
    implements _$$HelpCenterProductImageImplCopyWith<$Res> {
  __$$HelpCenterProductImageImplCopyWithImpl(
      _$HelpCenterProductImageImpl _value,
      $Res Function(_$HelpCenterProductImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? as = freezed,
    Object? caption = freezed,
    Object? height = null,
    Object? width = null,
    Object? imageUrl = freezed,
    Object? smallImageUrl = freezed,
  }) {
    return _then(_$HelpCenterProductImageImpl(
      as: freezed == as
          ? _value.as
          : as // ignore: cast_nullable_to_non_nullable
              as String?,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      smallImageUrl: freezed == smallImageUrl
          ? _value.smallImageUrl
          : smallImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HelpCenterProductImageImpl implements _HelpCenterProductImage {
  _$HelpCenterProductImageImpl(
      {this.as,
      this.caption,
      this.height = 0,
      this.width = 0,
      this.imageUrl,
      this.smallImageUrl});

  factory _$HelpCenterProductImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$HelpCenterProductImageImplFromJson(json);

  @override
  final String? as;
  @override
  final String? caption;
  @override
  @JsonKey()
  final int height;
  @override
  @JsonKey()
  final int width;
  @override
  final String? imageUrl;
  @override
  final String? smallImageUrl;

  @override
  String toString() {
    return 'HelpCenterProductImage(as: $as, caption: $caption, height: $height, width: $width, imageUrl: $imageUrl, smallImageUrl: $smallImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HelpCenterProductImageImpl &&
            (identical(other.as, as) || other.as == as) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.smallImageUrl, smallImageUrl) ||
                other.smallImageUrl == smallImageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, as, caption, height, width, imageUrl, smallImageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HelpCenterProductImageImplCopyWith<_$HelpCenterProductImageImpl>
      get copyWith => __$$HelpCenterProductImageImplCopyWithImpl<
          _$HelpCenterProductImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HelpCenterProductImageImplToJson(
      this,
    );
  }
}

abstract class _HelpCenterProductImage implements HelpCenterProductImage {
  factory _HelpCenterProductImage(
      {final String? as,
      final String? caption,
      final int height,
      final int width,
      final String? imageUrl,
      final String? smallImageUrl}) = _$HelpCenterProductImageImpl;

  factory _HelpCenterProductImage.fromJson(Map<String, dynamic> json) =
      _$HelpCenterProductImageImpl.fromJson;

  @override
  String? get as;
  @override
  String? get caption;
  @override
  int get height;
  @override
  int get width;
  @override
  String? get imageUrl;
  @override
  String? get smallImageUrl;
  @override
  @JsonKey(ignore: true)
  _$$HelpCenterProductImageImplCopyWith<_$HelpCenterProductImageImpl>
      get copyWith => throw _privateConstructorUsedError;
}
