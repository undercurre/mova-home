// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unbind_phone_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UnbindPhoneUiState {
  String? get phoneNumber => throw _privateConstructorUsedError; //手机号
  String? get phoneCode => throw _privateConstructorUsedError; //验证码
  UserInfoModel? get userInfo => throw _privateConstructorUsedError; //用户信息
  SmsTrCodeRes? get smsRes => throw _privateConstructorUsedError; //验证码接口返回数据模型
  String? get phoneAreaCode => throw _privateConstructorUsedError; //手机区号码
  String get sendPhoneCodeStr => throw _privateConstructorUsedError; //邮箱验证码文案
  bool get enableSend => throw _privateConstructorUsedError; //是否可以发送验证码
  bool get showChangeEmail => throw _privateConstructorUsedError; //更换邮箱
  CommonUIEvent get event => throw _privateConstructorUsedError; // 解除绑定
  bool get enableUnbindButton => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UnbindPhoneUiStateCopyWith<UnbindPhoneUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnbindPhoneUiStateCopyWith<$Res> {
  factory $UnbindPhoneUiStateCopyWith(
          UnbindPhoneUiState value, $Res Function(UnbindPhoneUiState) then) =
      _$UnbindPhoneUiStateCopyWithImpl<$Res, UnbindPhoneUiState>;
  @useResult
  $Res call(
      {String? phoneNumber,
      String? phoneCode,
      UserInfoModel? userInfo,
      SmsTrCodeRes? smsRes,
      String? phoneAreaCode,
      String sendPhoneCodeStr,
      bool enableSend,
      bool showChangeEmail,
      CommonUIEvent event,
      bool enableUnbindButton});

  $UserInfoModelCopyWith<$Res>? get userInfo;
  $SmsTrCodeResCopyWith<$Res>? get smsRes;
}

/// @nodoc
class _$UnbindPhoneUiStateCopyWithImpl<$Res, $Val extends UnbindPhoneUiState>
    implements $UnbindPhoneUiStateCopyWith<$Res> {
  _$UnbindPhoneUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = freezed,
    Object? phoneCode = freezed,
    Object? userInfo = freezed,
    Object? smsRes = freezed,
    Object? phoneAreaCode = freezed,
    Object? sendPhoneCodeStr = null,
    Object? enableSend = null,
    Object? showChangeEmail = null,
    Object? event = null,
    Object? enableUnbindButton = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneCode: freezed == phoneCode
          ? _value.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as String?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      smsRes: freezed == smsRes
          ? _value.smsRes
          : smsRes // ignore: cast_nullable_to_non_nullable
              as SmsTrCodeRes?,
      phoneAreaCode: freezed == phoneAreaCode
          ? _value.phoneAreaCode
          : phoneAreaCode // ignore: cast_nullable_to_non_nullable
              as String?,
      sendPhoneCodeStr: null == sendPhoneCodeStr
          ? _value.sendPhoneCodeStr
          : sendPhoneCodeStr // ignore: cast_nullable_to_non_nullable
              as String,
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      showChangeEmail: null == showChangeEmail
          ? _value.showChangeEmail
          : showChangeEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      enableUnbindButton: null == enableUnbindButton
          ? _value.enableUnbindButton
          : enableUnbindButton // ignore: cast_nullable_to_non_nullable
              as bool,
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

  @override
  @pragma('vm:prefer-inline')
  $SmsTrCodeResCopyWith<$Res>? get smsRes {
    if (_value.smsRes == null) {
      return null;
    }

    return $SmsTrCodeResCopyWith<$Res>(_value.smsRes!, (value) {
      return _then(_value.copyWith(smsRes: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UnbindPhoneUiStateImplCopyWith<$Res>
    implements $UnbindPhoneUiStateCopyWith<$Res> {
  factory _$$UnbindPhoneUiStateImplCopyWith(_$UnbindPhoneUiStateImpl value,
          $Res Function(_$UnbindPhoneUiStateImpl) then) =
      __$$UnbindPhoneUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? phoneNumber,
      String? phoneCode,
      UserInfoModel? userInfo,
      SmsTrCodeRes? smsRes,
      String? phoneAreaCode,
      String sendPhoneCodeStr,
      bool enableSend,
      bool showChangeEmail,
      CommonUIEvent event,
      bool enableUnbindButton});

  @override
  $UserInfoModelCopyWith<$Res>? get userInfo;
  @override
  $SmsTrCodeResCopyWith<$Res>? get smsRes;
}

/// @nodoc
class __$$UnbindPhoneUiStateImplCopyWithImpl<$Res>
    extends _$UnbindPhoneUiStateCopyWithImpl<$Res, _$UnbindPhoneUiStateImpl>
    implements _$$UnbindPhoneUiStateImplCopyWith<$Res> {
  __$$UnbindPhoneUiStateImplCopyWithImpl(_$UnbindPhoneUiStateImpl _value,
      $Res Function(_$UnbindPhoneUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = freezed,
    Object? phoneCode = freezed,
    Object? userInfo = freezed,
    Object? smsRes = freezed,
    Object? phoneAreaCode = freezed,
    Object? sendPhoneCodeStr = null,
    Object? enableSend = null,
    Object? showChangeEmail = null,
    Object? event = null,
    Object? enableUnbindButton = null,
  }) {
    return _then(_$UnbindPhoneUiStateImpl(
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneCode: freezed == phoneCode
          ? _value.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as String?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      smsRes: freezed == smsRes
          ? _value.smsRes
          : smsRes // ignore: cast_nullable_to_non_nullable
              as SmsTrCodeRes?,
      phoneAreaCode: freezed == phoneAreaCode
          ? _value.phoneAreaCode
          : phoneAreaCode // ignore: cast_nullable_to_non_nullable
              as String?,
      sendPhoneCodeStr: null == sendPhoneCodeStr
          ? _value.sendPhoneCodeStr
          : sendPhoneCodeStr // ignore: cast_nullable_to_non_nullable
              as String,
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      showChangeEmail: null == showChangeEmail
          ? _value.showChangeEmail
          : showChangeEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      enableUnbindButton: null == enableUnbindButton
          ? _value.enableUnbindButton
          : enableUnbindButton // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UnbindPhoneUiStateImpl implements _UnbindPhoneUiState {
  _$UnbindPhoneUiStateImpl(
      {this.phoneNumber,
      this.phoneCode,
      this.userInfo,
      this.smsRes,
      this.phoneAreaCode,
      this.sendPhoneCodeStr = '',
      this.enableSend = true,
      this.showChangeEmail = false,
      this.event = const EmptyEvent(),
      this.enableUnbindButton = false});

  @override
  final String? phoneNumber;
//手机号
  @override
  final String? phoneCode;
//验证码
  @override
  final UserInfoModel? userInfo;
//用户信息
  @override
  final SmsTrCodeRes? smsRes;
//验证码接口返回数据模型
  @override
  final String? phoneAreaCode;
//手机区号码
  @override
  @JsonKey()
  final String sendPhoneCodeStr;
//邮箱验证码文案
  @override
  @JsonKey()
  final bool enableSend;
//是否可以发送验证码
  @override
  @JsonKey()
  final bool showChangeEmail;
//更换邮箱
  @override
  @JsonKey()
  final CommonUIEvent event;
// 解除绑定
  @override
  @JsonKey()
  final bool enableUnbindButton;

  @override
  String toString() {
    return 'UnbindPhoneUiState(phoneNumber: $phoneNumber, phoneCode: $phoneCode, userInfo: $userInfo, smsRes: $smsRes, phoneAreaCode: $phoneAreaCode, sendPhoneCodeStr: $sendPhoneCodeStr, enableSend: $enableSend, showChangeEmail: $showChangeEmail, event: $event, enableUnbindButton: $enableUnbindButton)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnbindPhoneUiStateImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.phoneCode, phoneCode) ||
                other.phoneCode == phoneCode) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.smsRes, smsRes) || other.smsRes == smsRes) &&
            (identical(other.phoneAreaCode, phoneAreaCode) ||
                other.phoneAreaCode == phoneAreaCode) &&
            (identical(other.sendPhoneCodeStr, sendPhoneCodeStr) ||
                other.sendPhoneCodeStr == sendPhoneCodeStr) &&
            (identical(other.enableSend, enableSend) ||
                other.enableSend == enableSend) &&
            (identical(other.showChangeEmail, showChangeEmail) ||
                other.showChangeEmail == showChangeEmail) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.enableUnbindButton, enableUnbindButton) ||
                other.enableUnbindButton == enableUnbindButton));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      phoneNumber,
      phoneCode,
      userInfo,
      smsRes,
      phoneAreaCode,
      sendPhoneCodeStr,
      enableSend,
      showChangeEmail,
      event,
      enableUnbindButton);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnbindPhoneUiStateImplCopyWith<_$UnbindPhoneUiStateImpl> get copyWith =>
      __$$UnbindPhoneUiStateImplCopyWithImpl<_$UnbindPhoneUiStateImpl>(
          this, _$identity);
}

abstract class _UnbindPhoneUiState implements UnbindPhoneUiState {
  factory _UnbindPhoneUiState(
      {final String? phoneNumber,
      final String? phoneCode,
      final UserInfoModel? userInfo,
      final SmsTrCodeRes? smsRes,
      final String? phoneAreaCode,
      final String sendPhoneCodeStr,
      final bool enableSend,
      final bool showChangeEmail,
      final CommonUIEvent event,
      final bool enableUnbindButton}) = _$UnbindPhoneUiStateImpl;

  @override
  String? get phoneNumber;
  @override //手机号
  String? get phoneCode;
  @override //验证码
  UserInfoModel? get userInfo;
  @override //用户信息
  SmsTrCodeRes? get smsRes;
  @override //验证码接口返回数据模型
  String? get phoneAreaCode;
  @override //手机区号码
  String get sendPhoneCodeStr;
  @override //邮箱验证码文案
  bool get enableSend;
  @override //是否可以发送验证码
  bool get showChangeEmail;
  @override //更换邮箱
  CommonUIEvent get event;
  @override // 解除绑定
  bool get enableUnbindButton;
  @override
  @JsonKey(ignore: true)
  _$$UnbindPhoneUiStateImplCopyWith<_$UnbindPhoneUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
