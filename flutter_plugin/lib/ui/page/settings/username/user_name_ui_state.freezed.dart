// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_name_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserNameUiState {
  bool get enableSaveButton => throw _privateConstructorUsedError; //修改
  String get userName =>
      throw _privateConstructorUsedError; //@Default('') String name,
  bool get dataPrepared => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserNameUiStateCopyWith<UserNameUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserNameUiStateCopyWith<$Res> {
  factory $UserNameUiStateCopyWith(
          UserNameUiState value, $Res Function(UserNameUiState) then) =
      _$UserNameUiStateCopyWithImpl<$Res, UserNameUiState>;
  @useResult
  $Res call({bool enableSaveButton, String userName, bool dataPrepared});
}

/// @nodoc
class _$UserNameUiStateCopyWithImpl<$Res, $Val extends UserNameUiState>
    implements $UserNameUiStateCopyWith<$Res> {
  _$UserNameUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSaveButton = null,
    Object? userName = null,
    Object? dataPrepared = null,
  }) {
    return _then(_value.copyWith(
      enableSaveButton: null == enableSaveButton
          ? _value.enableSaveButton
          : enableSaveButton // ignore: cast_nullable_to_non_nullable
              as bool,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      dataPrepared: null == dataPrepared
          ? _value.dataPrepared
          : dataPrepared // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserNameUiStateImplCopyWith<$Res>
    implements $UserNameUiStateCopyWith<$Res> {
  factory _$$UserNameUiStateImplCopyWith(_$UserNameUiStateImpl value,
          $Res Function(_$UserNameUiStateImpl) then) =
      __$$UserNameUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enableSaveButton, String userName, bool dataPrepared});
}

/// @nodoc
class __$$UserNameUiStateImplCopyWithImpl<$Res>
    extends _$UserNameUiStateCopyWithImpl<$Res, _$UserNameUiStateImpl>
    implements _$$UserNameUiStateImplCopyWith<$Res> {
  __$$UserNameUiStateImplCopyWithImpl(
      _$UserNameUiStateImpl _value, $Res Function(_$UserNameUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSaveButton = null,
    Object? userName = null,
    Object? dataPrepared = null,
  }) {
    return _then(_$UserNameUiStateImpl(
      enableSaveButton: null == enableSaveButton
          ? _value.enableSaveButton
          : enableSaveButton // ignore: cast_nullable_to_non_nullable
              as bool,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      dataPrepared: null == dataPrepared
          ? _value.dataPrepared
          : dataPrepared // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UserNameUiStateImpl implements _UserNameUiState {
  _$UserNameUiStateImpl(
      {this.enableSaveButton = false,
      this.userName = '',
      this.dataPrepared = false});

  @override
  @JsonKey()
  final bool enableSaveButton;
//修改
  @override
  @JsonKey()
  final String userName;
//@Default('') String name,
  @override
  @JsonKey()
  final bool dataPrepared;

  @override
  String toString() {
    return 'UserNameUiState(enableSaveButton: $enableSaveButton, userName: $userName, dataPrepared: $dataPrepared)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserNameUiStateImpl &&
            (identical(other.enableSaveButton, enableSaveButton) ||
                other.enableSaveButton == enableSaveButton) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.dataPrepared, dataPrepared) ||
                other.dataPrepared == dataPrepared));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, enableSaveButton, userName, dataPrepared);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserNameUiStateImplCopyWith<_$UserNameUiStateImpl> get copyWith =>
      __$$UserNameUiStateImplCopyWithImpl<_$UserNameUiStateImpl>(
          this, _$identity);
}

abstract class _UserNameUiState implements UserNameUiState {
  factory _UserNameUiState(
      {final bool enableSaveButton,
      final String userName,
      final bool dataPrepared}) = _$UserNameUiStateImpl;

  @override
  bool get enableSaveButton;
  @override //修改
  String get userName;
  @override //@Default('') String name,
  bool get dataPrepared;
  @override
  @JsonKey(ignore: true)
  _$$UserNameUiStateImplCopyWith<_$UserNameUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
