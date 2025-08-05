// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'key_value_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

KVModel _$KVModelFromJson(Map<String, dynamic> json) {
  return _KVModel.fromJson(json);
}

/// @nodoc
mixin _$KVModel {
  String get key => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KVModelCopyWith<KVModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KVModelCopyWith<$Res> {
  factory $KVModelCopyWith(KVModel value, $Res Function(KVModel) then) =
      _$KVModelCopyWithImpl<$Res, KVModel>;
  @useResult
  $Res call({String key, dynamic value});
}

/// @nodoc
class _$KVModelCopyWithImpl<$Res, $Val extends KVModel>
    implements $KVModelCopyWith<$Res> {
  _$KVModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KVModelImplCopyWith<$Res> implements $KVModelCopyWith<$Res> {
  factory _$$KVModelImplCopyWith(
          _$KVModelImpl value, $Res Function(_$KVModelImpl) then) =
      __$$KVModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, dynamic value});
}

/// @nodoc
class __$$KVModelImplCopyWithImpl<$Res>
    extends _$KVModelCopyWithImpl<$Res, _$KVModelImpl>
    implements _$$KVModelImplCopyWith<$Res> {
  __$$KVModelImplCopyWithImpl(
      _$KVModelImpl _value, $Res Function(_$KVModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = freezed,
  }) {
    return _then(_$KVModelImpl(
      null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KVModelImpl implements _KVModel {
  _$KVModelImpl(this.key, this.value);

  factory _$KVModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$KVModelImplFromJson(json);

  @override
  final String key;
  @override
  final dynamic value;

  @override
  String toString() {
    return 'KVModel(key: $key, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KVModelImpl &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, key, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KVModelImplCopyWith<_$KVModelImpl> get copyWith =>
      __$$KVModelImplCopyWithImpl<_$KVModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KVModelImplToJson(
      this,
    );
  }
}

abstract class _KVModel implements KVModel {
  factory _KVModel(final String key, final dynamic value) = _$KVModelImpl;

  factory _KVModel.fromJson(Map<String, dynamic> json) = _$KVModelImpl.fromJson;

  @override
  String get key;
  @override
  dynamic get value;
  @override
  @JsonKey(ignore: true)
  _$$KVModelImplCopyWith<_$KVModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
