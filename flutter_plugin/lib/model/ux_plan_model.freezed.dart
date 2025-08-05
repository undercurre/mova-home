// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ux_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UXPlanModel _$UXPlanModelFromJson(Map<String, dynamic> json) {
  return _UXPlanModel.fromJson(json);
}

/// @nodoc
mixin _$UXPlanModel {
  String? get uid => throw _privateConstructorUsedError;
  int? get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UXPlanModelCopyWith<UXPlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UXPlanModelCopyWith<$Res> {
  factory $UXPlanModelCopyWith(
          UXPlanModel value, $Res Function(UXPlanModel) then) =
      _$UXPlanModelCopyWithImpl<$Res, UXPlanModel>;
  @useResult
  $Res call({String? uid, int? value});
}

/// @nodoc
class _$UXPlanModelCopyWithImpl<$Res, $Val extends UXPlanModel>
    implements $UXPlanModelCopyWith<$Res> {
  _$UXPlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UXPlanModelImplCopyWith<$Res>
    implements $UXPlanModelCopyWith<$Res> {
  factory _$$UXPlanModelImplCopyWith(
          _$UXPlanModelImpl value, $Res Function(_$UXPlanModelImpl) then) =
      __$$UXPlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? uid, int? value});
}

/// @nodoc
class __$$UXPlanModelImplCopyWithImpl<$Res>
    extends _$UXPlanModelCopyWithImpl<$Res, _$UXPlanModelImpl>
    implements _$$UXPlanModelImplCopyWith<$Res> {
  __$$UXPlanModelImplCopyWithImpl(
      _$UXPlanModelImpl _value, $Res Function(_$UXPlanModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? value = freezed,
  }) {
    return _then(_$UXPlanModelImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UXPlanModelImpl implements _UXPlanModel {
  const _$UXPlanModelImpl({this.uid, this.value});

  factory _$UXPlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UXPlanModelImplFromJson(json);

  @override
  final String? uid;
  @override
  final int? value;

  @override
  String toString() {
    return 'UXPlanModel(uid: $uid, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UXPlanModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UXPlanModelImplCopyWith<_$UXPlanModelImpl> get copyWith =>
      __$$UXPlanModelImplCopyWithImpl<_$UXPlanModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UXPlanModelImplToJson(
      this,
    );
  }
}

abstract class _UXPlanModel implements UXPlanModel {
  const factory _UXPlanModel({final String? uid, final int? value}) =
      _$UXPlanModelImpl;

  factory _UXPlanModel.fromJson(Map<String, dynamic> json) =
      _$UXPlanModelImpl.fromJson;

  @override
  String? get uid;
  @override
  int? get value;
  @override
  @JsonKey(ignore: true)
  _$$UXPlanModelImplCopyWith<_$UXPlanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
