// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_setting_password_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserSettingPasswordUiState {
  bool get enableCommitButton => throw _privateConstructorUsedError;
  String? get password1 => throw _privateConstructorUsedError;
  String? get password2 => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserSettingPasswordUiStateCopyWith<UserSettingPasswordUiState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingPasswordUiStateCopyWith<$Res> {
  factory $UserSettingPasswordUiStateCopyWith(UserSettingPasswordUiState value,
          $Res Function(UserSettingPasswordUiState) then) =
      _$UserSettingPasswordUiStateCopyWithImpl<$Res,
          UserSettingPasswordUiState>;
  @useResult
  $Res call({bool enableCommitButton, String? password1, String? password2});
}

/// @nodoc
class _$UserSettingPasswordUiStateCopyWithImpl<$Res,
        $Val extends UserSettingPasswordUiState>
    implements $UserSettingPasswordUiStateCopyWith<$Res> {
  _$UserSettingPasswordUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableCommitButton = null,
    Object? password1 = freezed,
    Object? password2 = freezed,
  }) {
    return _then(_value.copyWith(
      enableCommitButton: null == enableCommitButton
          ? _value.enableCommitButton
          : enableCommitButton // ignore: cast_nullable_to_non_nullable
              as bool,
      password1: freezed == password1
          ? _value.password1
          : password1 // ignore: cast_nullable_to_non_nullable
              as String?,
      password2: freezed == password2
          ? _value.password2
          : password2 // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSettingPasswordUiStateImplCopyWith<$Res>
    implements $UserSettingPasswordUiStateCopyWith<$Res> {
  factory _$$UserSettingPasswordUiStateImplCopyWith(
          _$UserSettingPasswordUiStateImpl value,
          $Res Function(_$UserSettingPasswordUiStateImpl) then) =
      __$$UserSettingPasswordUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enableCommitButton, String? password1, String? password2});
}

/// @nodoc
class __$$UserSettingPasswordUiStateImplCopyWithImpl<$Res>
    extends _$UserSettingPasswordUiStateCopyWithImpl<$Res,
        _$UserSettingPasswordUiStateImpl>
    implements _$$UserSettingPasswordUiStateImplCopyWith<$Res> {
  __$$UserSettingPasswordUiStateImplCopyWithImpl(
      _$UserSettingPasswordUiStateImpl _value,
      $Res Function(_$UserSettingPasswordUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableCommitButton = null,
    Object? password1 = freezed,
    Object? password2 = freezed,
  }) {
    return _then(_$UserSettingPasswordUiStateImpl(
      enableCommitButton: null == enableCommitButton
          ? _value.enableCommitButton
          : enableCommitButton // ignore: cast_nullable_to_non_nullable
              as bool,
      password1: freezed == password1
          ? _value.password1
          : password1 // ignore: cast_nullable_to_non_nullable
              as String?,
      password2: freezed == password2
          ? _value.password2
          : password2 // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UserSettingPasswordUiStateImpl implements _UserSettingPasswordUiState {
  _$UserSettingPasswordUiStateImpl(
      {this.enableCommitButton = false, this.password1, this.password2});

  @override
  @JsonKey()
  final bool enableCommitButton;
  @override
  final String? password1;
  @override
  final String? password2;

  @override
  String toString() {
    return 'UserSettingPasswordUiState(enableCommitButton: $enableCommitButton, password1: $password1, password2: $password2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingPasswordUiStateImpl &&
            (identical(other.enableCommitButton, enableCommitButton) ||
                other.enableCommitButton == enableCommitButton) &&
            (identical(other.password1, password1) ||
                other.password1 == password1) &&
            (identical(other.password2, password2) ||
                other.password2 == password2));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, enableCommitButton, password1, password2);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingPasswordUiStateImplCopyWith<_$UserSettingPasswordUiStateImpl>
      get copyWith => __$$UserSettingPasswordUiStateImplCopyWithImpl<
          _$UserSettingPasswordUiStateImpl>(this, _$identity);
}

abstract class _UserSettingPasswordUiState
    implements UserSettingPasswordUiState {
  factory _UserSettingPasswordUiState(
      {final bool enableCommitButton,
      final String? password1,
      final String? password2}) = _$UserSettingPasswordUiStateImpl;

  @override
  bool get enableCommitButton;
  @override
  String? get password1;
  @override
  String? get password2;
  @override
  @JsonKey(ignore: true)
  _$$UserSettingPasswordUiStateImplCopyWith<_$UserSettingPasswordUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
