// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mine_recent_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MineRecentUser _$MineRecentUserFromJson(Map<String, dynamic> json) {
  return _MineRecentUser.fromJson(json);
}

/// @nodoc
mixin _$MineRecentUser {
  String? get avatar => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get uid => throw _privateConstructorUsedError;
  int? get sharedStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MineRecentUserCopyWith<MineRecentUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MineRecentUserCopyWith<$Res> {
  factory $MineRecentUserCopyWith(
          MineRecentUser value, $Res Function(MineRecentUser) then) =
      _$MineRecentUserCopyWithImpl<$Res, MineRecentUser>;
  @useResult
  $Res call({String? avatar, String? name, String? uid, int? sharedStatus});
}

/// @nodoc
class _$MineRecentUserCopyWithImpl<$Res, $Val extends MineRecentUser>
    implements $MineRecentUserCopyWith<$Res> {
  _$MineRecentUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatar = freezed,
    Object? name = freezed,
    Object? uid = freezed,
    Object? sharedStatus = freezed,
  }) {
    return _then(_value.copyWith(
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedStatus: freezed == sharedStatus
          ? _value.sharedStatus
          : sharedStatus // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MineRecentUserImplCopyWith<$Res>
    implements $MineRecentUserCopyWith<$Res> {
  factory _$$MineRecentUserImplCopyWith(_$MineRecentUserImpl value,
          $Res Function(_$MineRecentUserImpl) then) =
      __$$MineRecentUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? avatar, String? name, String? uid, int? sharedStatus});
}

/// @nodoc
class __$$MineRecentUserImplCopyWithImpl<$Res>
    extends _$MineRecentUserCopyWithImpl<$Res, _$MineRecentUserImpl>
    implements _$$MineRecentUserImplCopyWith<$Res> {
  __$$MineRecentUserImplCopyWithImpl(
      _$MineRecentUserImpl _value, $Res Function(_$MineRecentUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatar = freezed,
    Object? name = freezed,
    Object? uid = freezed,
    Object? sharedStatus = freezed,
  }) {
    return _then(_$MineRecentUserImpl(
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      sharedStatus: freezed == sharedStatus
          ? _value.sharedStatus
          : sharedStatus // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MineRecentUserImpl implements _MineRecentUser {
  const _$MineRecentUserImpl(
      {this.avatar, this.name, this.uid, this.sharedStatus});

  factory _$MineRecentUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$MineRecentUserImplFromJson(json);

  @override
  final String? avatar;
  @override
  final String? name;
  @override
  final String? uid;
  @override
  final int? sharedStatus;

  @override
  String toString() {
    return 'MineRecentUser(avatar: $avatar, name: $name, uid: $uid, sharedStatus: $sharedStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MineRecentUserImpl &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.sharedStatus, sharedStatus) ||
                other.sharedStatus == sharedStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, avatar, name, uid, sharedStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MineRecentUserImplCopyWith<_$MineRecentUserImpl> get copyWith =>
      __$$MineRecentUserImplCopyWithImpl<_$MineRecentUserImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MineRecentUserImplToJson(
      this,
    );
  }
}

abstract class _MineRecentUser implements MineRecentUser {
  const factory _MineRecentUser(
      {final String? avatar,
      final String? name,
      final String? uid,
      final int? sharedStatus}) = _$MineRecentUserImpl;

  factory _MineRecentUser.fromJson(Map<String, dynamic> json) =
      _$MineRecentUserImpl.fromJson;

  @override
  String? get avatar;
  @override
  String? get name;
  @override
  String? get uid;
  @override
  int? get sharedStatus;
  @override
  @JsonKey(ignore: true)
  _$$MineRecentUserImplCopyWith<_$MineRecentUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
