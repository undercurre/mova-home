// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warranty_debug_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WarrantyDebugModel _$WarrantyDebugModelFromJson(Map<String, dynamic> json) {
  return _WarrantyDebugModel.fromJson(json);
}

/// @nodoc
mixin _$WarrantyDebugModel {
  String get countryCode => throw _privateConstructorUsedError;
  set countryCode(String value) => throw _privateConstructorUsedError;
  bool get useCNShopifyLink => throw _privateConstructorUsedError;
  set useCNShopifyLink(bool value) => throw _privateConstructorUsedError;
  bool get showOverseaMall => throw _privateConstructorUsedError;
  set showOverseaMall(bool value) => throw _privateConstructorUsedError;
  bool get isDebug => throw _privateConstructorUsedError;
  set isDebug(bool value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WarrantyDebugModelCopyWith<WarrantyDebugModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarrantyDebugModelCopyWith<$Res> {
  factory $WarrantyDebugModelCopyWith(
          WarrantyDebugModel value, $Res Function(WarrantyDebugModel) then) =
      _$WarrantyDebugModelCopyWithImpl<$Res, WarrantyDebugModel>;
  @useResult
  $Res call(
      {String countryCode,
      bool useCNShopifyLink,
      bool showOverseaMall,
      bool isDebug});
}

/// @nodoc
class _$WarrantyDebugModelCopyWithImpl<$Res, $Val extends WarrantyDebugModel>
    implements $WarrantyDebugModelCopyWith<$Res> {
  _$WarrantyDebugModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryCode = null,
    Object? useCNShopifyLink = null,
    Object? showOverseaMall = null,
    Object? isDebug = null,
  }) {
    return _then(_value.copyWith(
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      useCNShopifyLink: null == useCNShopifyLink
          ? _value.useCNShopifyLink
          : useCNShopifyLink // ignore: cast_nullable_to_non_nullable
              as bool,
      showOverseaMall: null == showOverseaMall
          ? _value.showOverseaMall
          : showOverseaMall // ignore: cast_nullable_to_non_nullable
              as bool,
      isDebug: null == isDebug
          ? _value.isDebug
          : isDebug // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WarrantyDebugModelImplCopyWith<$Res>
    implements $WarrantyDebugModelCopyWith<$Res> {
  factory _$$WarrantyDebugModelImplCopyWith(_$WarrantyDebugModelImpl value,
          $Res Function(_$WarrantyDebugModelImpl) then) =
      __$$WarrantyDebugModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String countryCode,
      bool useCNShopifyLink,
      bool showOverseaMall,
      bool isDebug});
}

/// @nodoc
class __$$WarrantyDebugModelImplCopyWithImpl<$Res>
    extends _$WarrantyDebugModelCopyWithImpl<$Res, _$WarrantyDebugModelImpl>
    implements _$$WarrantyDebugModelImplCopyWith<$Res> {
  __$$WarrantyDebugModelImplCopyWithImpl(_$WarrantyDebugModelImpl _value,
      $Res Function(_$WarrantyDebugModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countryCode = null,
    Object? useCNShopifyLink = null,
    Object? showOverseaMall = null,
    Object? isDebug = null,
  }) {
    return _then(_$WarrantyDebugModelImpl(
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      useCNShopifyLink: null == useCNShopifyLink
          ? _value.useCNShopifyLink
          : useCNShopifyLink // ignore: cast_nullable_to_non_nullable
              as bool,
      showOverseaMall: null == showOverseaMall
          ? _value.showOverseaMall
          : showOverseaMall // ignore: cast_nullable_to_non_nullable
              as bool,
      isDebug: null == isDebug
          ? _value.isDebug
          : isDebug // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WarrantyDebugModelImpl implements _WarrantyDebugModel {
  _$WarrantyDebugModelImpl(
      {this.countryCode = '',
      this.useCNShopifyLink = false,
      this.showOverseaMall = false,
      this.isDebug = false});

  factory _$WarrantyDebugModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarrantyDebugModelImplFromJson(json);

  @override
  @JsonKey()
  String countryCode;
  @override
  @JsonKey()
  bool useCNShopifyLink;
  @override
  @JsonKey()
  bool showOverseaMall;
  @override
  @JsonKey()
  bool isDebug;

  @override
  String toString() {
    return 'WarrantyDebugModel(countryCode: $countryCode, useCNShopifyLink: $useCNShopifyLink, showOverseaMall: $showOverseaMall, isDebug: $isDebug)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarrantyDebugModelImplCopyWith<_$WarrantyDebugModelImpl> get copyWith =>
      __$$WarrantyDebugModelImplCopyWithImpl<_$WarrantyDebugModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarrantyDebugModelImplToJson(
      this,
    );
  }
}

abstract class _WarrantyDebugModel implements WarrantyDebugModel {
  factory _WarrantyDebugModel(
      {String countryCode,
      bool useCNShopifyLink,
      bool showOverseaMall,
      bool isDebug}) = _$WarrantyDebugModelImpl;

  factory _WarrantyDebugModel.fromJson(Map<String, dynamic> json) =
      _$WarrantyDebugModelImpl.fromJson;

  @override
  String get countryCode;
  set countryCode(String value);
  @override
  bool get useCNShopifyLink;
  set useCNShopifyLink(bool value);
  @override
  bool get showOverseaMall;
  set showOverseaMall(bool value);
  @override
  bool get isDebug;
  set isDebug(bool value);
  @override
  @JsonKey(ignore: true)
  _$$WarrantyDebugModelImplCopyWith<_$WarrantyDebugModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
