// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_mark_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserMarkModel _$UserMarkModelFromJson(Map<String, dynamic> json) {
  return _UserMarkModel.fromJson(json);
}

/// @nodoc
mixin _$UserMarkModel {
  bool get needDialog => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserMarkModelCopyWith<UserMarkModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMarkModelCopyWith<$Res> {
  factory $UserMarkModelCopyWith(
          UserMarkModel value, $Res Function(UserMarkModel) then) =
      _$UserMarkModelCopyWithImpl<$Res, UserMarkModel>;
  @useResult
  $Res call({bool needDialog});
}

/// @nodoc
class _$UserMarkModelCopyWithImpl<$Res, $Val extends UserMarkModel>
    implements $UserMarkModelCopyWith<$Res> {
  _$UserMarkModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? needDialog = null,
  }) {
    return _then(_value.copyWith(
      needDialog: null == needDialog
          ? _value.needDialog
          : needDialog // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserMarkModelImplCopyWith<$Res>
    implements $UserMarkModelCopyWith<$Res> {
  factory _$$UserMarkModelImplCopyWith(
          _$UserMarkModelImpl value, $Res Function(_$UserMarkModelImpl) then) =
      __$$UserMarkModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool needDialog});
}

/// @nodoc
class __$$UserMarkModelImplCopyWithImpl<$Res>
    extends _$UserMarkModelCopyWithImpl<$Res, _$UserMarkModelImpl>
    implements _$$UserMarkModelImplCopyWith<$Res> {
  __$$UserMarkModelImplCopyWithImpl(
      _$UserMarkModelImpl _value, $Res Function(_$UserMarkModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? needDialog = null,
  }) {
    return _then(_$UserMarkModelImpl(
      needDialog: null == needDialog
          ? _value.needDialog
          : needDialog // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserMarkModelImpl implements _UserMarkModel {
  _$UserMarkModelImpl({this.needDialog = false});

  factory _$UserMarkModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserMarkModelImplFromJson(json);

  @override
  @JsonKey()
  final bool needDialog;

  @override
  String toString() {
    return 'UserMarkModel(needDialog: $needDialog)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMarkModelImpl &&
            (identical(other.needDialog, needDialog) ||
                other.needDialog == needDialog));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, needDialog);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserMarkModelImplCopyWith<_$UserMarkModelImpl> get copyWith =>
      __$$UserMarkModelImplCopyWithImpl<_$UserMarkModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserMarkModelImplToJson(
      this,
    );
  }
}

abstract class _UserMarkModel implements UserMarkModel {
  factory _UserMarkModel({final bool needDialog}) = _$UserMarkModelImpl;

  factory _UserMarkModel.fromJson(Map<String, dynamic> json) =
      _$UserMarkModelImpl.fromJson;

  @override
  bool get needDialog;
  @override
  @JsonKey(ignore: true)
  _$$UserMarkModelImplCopyWith<_$UserMarkModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
