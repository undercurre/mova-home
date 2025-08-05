// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_collection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EmailCollectionState {
  bool? get subscribed => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EmailCollectionStateCopyWith<EmailCollectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailCollectionStateCopyWith<$Res> {
  factory $EmailCollectionStateCopyWith(EmailCollectionState value,
          $Res Function(EmailCollectionState) then) =
      _$EmailCollectionStateCopyWithImpl<$Res, EmailCollectionState>;
  @useResult
  $Res call({bool? subscribed, String? email});
}

/// @nodoc
class _$EmailCollectionStateCopyWithImpl<$Res,
        $Val extends EmailCollectionState>
    implements $EmailCollectionStateCopyWith<$Res> {
  _$EmailCollectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscribed = freezed,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      subscribed: freezed == subscribed
          ? _value.subscribed
          : subscribed // ignore: cast_nullable_to_non_nullable
              as bool?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmailCollectionStateImplCopyWith<$Res>
    implements $EmailCollectionStateCopyWith<$Res> {
  factory _$$EmailCollectionStateImplCopyWith(_$EmailCollectionStateImpl value,
          $Res Function(_$EmailCollectionStateImpl) then) =
      __$$EmailCollectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? subscribed, String? email});
}

/// @nodoc
class __$$EmailCollectionStateImplCopyWithImpl<$Res>
    extends _$EmailCollectionStateCopyWithImpl<$Res, _$EmailCollectionStateImpl>
    implements _$$EmailCollectionStateImplCopyWith<$Res> {
  __$$EmailCollectionStateImplCopyWithImpl(_$EmailCollectionStateImpl _value,
      $Res Function(_$EmailCollectionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscribed = freezed,
    Object? email = freezed,
  }) {
    return _then(_$EmailCollectionStateImpl(
      subscribed: freezed == subscribed
          ? _value.subscribed
          : subscribed // ignore: cast_nullable_to_non_nullable
              as bool?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$EmailCollectionStateImpl implements _EmailCollectionState {
  _$EmailCollectionStateImpl({this.subscribed, this.email});

  @override
  final bool? subscribed;
  @override
  final String? email;

  @override
  String toString() {
    return 'EmailCollectionState(subscribed: $subscribed, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailCollectionStateImpl &&
            (identical(other.subscribed, subscribed) ||
                other.subscribed == subscribed) &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, subscribed, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailCollectionStateImplCopyWith<_$EmailCollectionStateImpl>
      get copyWith =>
          __$$EmailCollectionStateImplCopyWithImpl<_$EmailCollectionStateImpl>(
              this, _$identity);
}

abstract class _EmailCollectionState implements EmailCollectionState {
  factory _EmailCollectionState({final bool? subscribed, final String? email}) =
      _$EmailCollectionStateImpl;

  @override
  bool? get subscribed;
  @override
  String? get email;
  @override
  @JsonKey(ignore: true)
  _$$EmailCollectionStateImplCopyWith<_$EmailCollectionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
