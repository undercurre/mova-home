// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_setting_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AccountSettingUiState {
  UserInfoModel? get userInfo => throw _privateConstructorUsedError;
  String? get regin =>
      throw _privateConstructorUsedError; //@Default('') String name,
  CommonUIEvent get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountSettingUiStateCopyWith<AccountSettingUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountSettingUiStateCopyWith<$Res> {
  factory $AccountSettingUiStateCopyWith(AccountSettingUiState value,
          $Res Function(AccountSettingUiState) then) =
      _$AccountSettingUiStateCopyWithImpl<$Res, AccountSettingUiState>;
  @useResult
  $Res call({UserInfoModel? userInfo, String? regin, CommonUIEvent uiEvent});

  $UserInfoModelCopyWith<$Res>? get userInfo;
}

/// @nodoc
class _$AccountSettingUiStateCopyWithImpl<$Res,
        $Val extends AccountSettingUiState>
    implements $AccountSettingUiStateCopyWith<$Res> {
  _$AccountSettingUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userInfo = freezed,
    Object? regin = freezed,
    Object? uiEvent = null,
  }) {
    return _then(_value.copyWith(
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      regin: freezed == regin
          ? _value.regin
          : regin // ignore: cast_nullable_to_non_nullable
              as String?,
      uiEvent: null == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserInfoModelCopyWith<$Res>? get userInfo {
    if (_value.userInfo == null) {
      return null;
    }

    return $UserInfoModelCopyWith<$Res>(_value.userInfo!, (value) {
      return _then(_value.copyWith(userInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountSettingUiStateImplCopyWith<$Res>
    implements $AccountSettingUiStateCopyWith<$Res> {
  factory _$$AccountSettingUiStateImplCopyWith(
          _$AccountSettingUiStateImpl value,
          $Res Function(_$AccountSettingUiStateImpl) then) =
      __$$AccountSettingUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserInfoModel? userInfo, String? regin, CommonUIEvent uiEvent});

  @override
  $UserInfoModelCopyWith<$Res>? get userInfo;
}

/// @nodoc
class __$$AccountSettingUiStateImplCopyWithImpl<$Res>
    extends _$AccountSettingUiStateCopyWithImpl<$Res,
        _$AccountSettingUiStateImpl>
    implements _$$AccountSettingUiStateImplCopyWith<$Res> {
  __$$AccountSettingUiStateImplCopyWithImpl(_$AccountSettingUiStateImpl _value,
      $Res Function(_$AccountSettingUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userInfo = freezed,
    Object? regin = freezed,
    Object? uiEvent = null,
  }) {
    return _then(_$AccountSettingUiStateImpl(
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      regin: freezed == regin
          ? _value.regin
          : regin // ignore: cast_nullable_to_non_nullable
              as String?,
      uiEvent: null == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$AccountSettingUiStateImpl implements _AccountSettingUiState {
  _$AccountSettingUiStateImpl(
      {this.userInfo, this.regin, this.uiEvent = const EmptyEvent()});

  @override
  final UserInfoModel? userInfo;
  @override
  final String? regin;
//@Default('') String name,
  @override
  @JsonKey()
  final CommonUIEvent uiEvent;

  @override
  String toString() {
    return 'AccountSettingUiState(userInfo: $userInfo, regin: $regin, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountSettingUiStateImpl &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.regin, regin) || other.regin == regin) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userInfo, regin, uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountSettingUiStateImplCopyWith<_$AccountSettingUiStateImpl>
      get copyWith => __$$AccountSettingUiStateImplCopyWithImpl<
          _$AccountSettingUiStateImpl>(this, _$identity);
}

abstract class _AccountSettingUiState implements AccountSettingUiState {
  factory _AccountSettingUiState(
      {final UserInfoModel? userInfo,
      final String? regin,
      final CommonUIEvent uiEvent}) = _$AccountSettingUiStateImpl;

  @override
  UserInfoModel? get userInfo;
  @override
  String? get regin;
  @override //@Default('') String name,
  CommonUIEvent get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$AccountSettingUiStateImplCopyWith<_$AccountSettingUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
