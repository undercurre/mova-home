// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unbind_mail_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UnbindMailUiState {
  bool get enableMailCodeButton => throw _privateConstructorUsedError; //验证码
  bool get enableUnbindButton =>
      throw _privateConstructorUsedError; //是否可以点击 解绑按钮
  bool get phoneFocus => throw _privateConstructorUsedError;
  bool get phoneCodeFocus => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;
  String get sendMailCodeStr => throw _privateConstructorUsedError; //邮箱验证码文案
  bool get enableSend => throw _privateConstructorUsedError; //是否可以发送验证码
  String? get emailAddress => throw _privateConstructorUsedError;
  String? get emailAddressCode => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  UserInfoModel? get userInfo => throw _privateConstructorUsedError; //用户信息
  SmsTrCodeRes? get smsResponse => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UnbindMailUiStateCopyWith<UnbindMailUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnbindMailUiStateCopyWith<$Res> {
  factory $UnbindMailUiStateCopyWith(
          UnbindMailUiState value, $Res Function(UnbindMailUiState) then) =
      _$UnbindMailUiStateCopyWithImpl<$Res, UnbindMailUiState>;
  @useResult
  $Res call(
      {bool enableMailCodeButton,
      bool enableUnbindButton,
      bool phoneFocus,
      bool phoneCodeFocus,
      CommonUIEvent event,
      String sendMailCodeStr,
      bool enableSend,
      String? emailAddress,
      String? emailAddressCode,
      String? password,
      UserInfoModel? userInfo,
      SmsTrCodeRes? smsResponse});

  $UserInfoModelCopyWith<$Res>? get userInfo;
  $SmsTrCodeResCopyWith<$Res>? get smsResponse;
}

/// @nodoc
class _$UnbindMailUiStateCopyWithImpl<$Res, $Val extends UnbindMailUiState>
    implements $UnbindMailUiStateCopyWith<$Res> {
  _$UnbindMailUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableMailCodeButton = null,
    Object? enableUnbindButton = null,
    Object? phoneFocus = null,
    Object? phoneCodeFocus = null,
    Object? event = null,
    Object? sendMailCodeStr = null,
    Object? enableSend = null,
    Object? emailAddress = freezed,
    Object? emailAddressCode = freezed,
    Object? password = freezed,
    Object? userInfo = freezed,
    Object? smsResponse = freezed,
  }) {
    return _then(_value.copyWith(
      enableMailCodeButton: null == enableMailCodeButton
          ? _value.enableMailCodeButton
          : enableMailCodeButton // ignore: cast_nullable_to_non_nullable
              as bool,
      enableUnbindButton: null == enableUnbindButton
          ? _value.enableUnbindButton
          : enableUnbindButton // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneFocus: null == phoneFocus
          ? _value.phoneFocus
          : phoneFocus // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneCodeFocus: null == phoneCodeFocus
          ? _value.phoneCodeFocus
          : phoneCodeFocus // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      sendMailCodeStr: null == sendMailCodeStr
          ? _value.sendMailCodeStr
          : sendMailCodeStr // ignore: cast_nullable_to_non_nullable
              as String,
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      emailAddress: freezed == emailAddress
          ? _value.emailAddress
          : emailAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      emailAddressCode: freezed == emailAddressCode
          ? _value.emailAddressCode
          : emailAddressCode // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      smsResponse: freezed == smsResponse
          ? _value.smsResponse
          : smsResponse // ignore: cast_nullable_to_non_nullable
              as SmsTrCodeRes?,
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
  $SmsTrCodeResCopyWith<$Res>? get smsResponse {
    if (_value.smsResponse == null) {
      return null;
    }

    return $SmsTrCodeResCopyWith<$Res>(_value.smsResponse!, (value) {
      return _then(_value.copyWith(smsResponse: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UnbindMailUiStateImplCopyWith<$Res>
    implements $UnbindMailUiStateCopyWith<$Res> {
  factory _$$UnbindMailUiStateImplCopyWith(_$UnbindMailUiStateImpl value,
          $Res Function(_$UnbindMailUiStateImpl) then) =
      __$$UnbindMailUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableMailCodeButton,
      bool enableUnbindButton,
      bool phoneFocus,
      bool phoneCodeFocus,
      CommonUIEvent event,
      String sendMailCodeStr,
      bool enableSend,
      String? emailAddress,
      String? emailAddressCode,
      String? password,
      UserInfoModel? userInfo,
      SmsTrCodeRes? smsResponse});

  @override
  $UserInfoModelCopyWith<$Res>? get userInfo;
  @override
  $SmsTrCodeResCopyWith<$Res>? get smsResponse;
}

/// @nodoc
class __$$UnbindMailUiStateImplCopyWithImpl<$Res>
    extends _$UnbindMailUiStateCopyWithImpl<$Res, _$UnbindMailUiStateImpl>
    implements _$$UnbindMailUiStateImplCopyWith<$Res> {
  __$$UnbindMailUiStateImplCopyWithImpl(_$UnbindMailUiStateImpl _value,
      $Res Function(_$UnbindMailUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableMailCodeButton = null,
    Object? enableUnbindButton = null,
    Object? phoneFocus = null,
    Object? phoneCodeFocus = null,
    Object? event = null,
    Object? sendMailCodeStr = null,
    Object? enableSend = null,
    Object? emailAddress = freezed,
    Object? emailAddressCode = freezed,
    Object? password = freezed,
    Object? userInfo = freezed,
    Object? smsResponse = freezed,
  }) {
    return _then(_$UnbindMailUiStateImpl(
      enableMailCodeButton: null == enableMailCodeButton
          ? _value.enableMailCodeButton
          : enableMailCodeButton // ignore: cast_nullable_to_non_nullable
              as bool,
      enableUnbindButton: null == enableUnbindButton
          ? _value.enableUnbindButton
          : enableUnbindButton // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneFocus: null == phoneFocus
          ? _value.phoneFocus
          : phoneFocus // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneCodeFocus: null == phoneCodeFocus
          ? _value.phoneCodeFocus
          : phoneCodeFocus // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      sendMailCodeStr: null == sendMailCodeStr
          ? _value.sendMailCodeStr
          : sendMailCodeStr // ignore: cast_nullable_to_non_nullable
              as String,
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      emailAddress: freezed == emailAddress
          ? _value.emailAddress
          : emailAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      emailAddressCode: freezed == emailAddressCode
          ? _value.emailAddressCode
          : emailAddressCode // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      smsResponse: freezed == smsResponse
          ? _value.smsResponse
          : smsResponse // ignore: cast_nullable_to_non_nullable
              as SmsTrCodeRes?,
    ));
  }
}

/// @nodoc

class _$UnbindMailUiStateImpl implements _UnbindMailUiState {
  _$UnbindMailUiStateImpl(
      {this.enableMailCodeButton = false,
      this.enableUnbindButton = false,
      this.phoneFocus = false,
      this.phoneCodeFocus = false,
      this.event = const EmptyEvent(),
      this.sendMailCodeStr = '',
      this.enableSend = true,
      this.emailAddress,
      this.emailAddressCode,
      this.password,
      this.userInfo,
      this.smsResponse});

  @override
  @JsonKey()
  final bool enableMailCodeButton;
//验证码
  @override
  @JsonKey()
  final bool enableUnbindButton;
//是否可以点击 解绑按钮
  @override
  @JsonKey()
  final bool phoneFocus;
  @override
  @JsonKey()
  final bool phoneCodeFocus;
  @override
  @JsonKey()
  final CommonUIEvent event;
  @override
  @JsonKey()
  final String sendMailCodeStr;
//邮箱验证码文案
  @override
  @JsonKey()
  final bool enableSend;
//是否可以发送验证码
  @override
  final String? emailAddress;
  @override
  final String? emailAddressCode;
  @override
  final String? password;
  @override
  final UserInfoModel? userInfo;
//用户信息
  @override
  final SmsTrCodeRes? smsResponse;

  @override
  String toString() {
    return 'UnbindMailUiState(enableMailCodeButton: $enableMailCodeButton, enableUnbindButton: $enableUnbindButton, phoneFocus: $phoneFocus, phoneCodeFocus: $phoneCodeFocus, event: $event, sendMailCodeStr: $sendMailCodeStr, enableSend: $enableSend, emailAddress: $emailAddress, emailAddressCode: $emailAddressCode, password: $password, userInfo: $userInfo, smsResponse: $smsResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnbindMailUiStateImpl &&
            (identical(other.enableMailCodeButton, enableMailCodeButton) ||
                other.enableMailCodeButton == enableMailCodeButton) &&
            (identical(other.enableUnbindButton, enableUnbindButton) ||
                other.enableUnbindButton == enableUnbindButton) &&
            (identical(other.phoneFocus, phoneFocus) ||
                other.phoneFocus == phoneFocus) &&
            (identical(other.phoneCodeFocus, phoneCodeFocus) ||
                other.phoneCodeFocus == phoneCodeFocus) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.sendMailCodeStr, sendMailCodeStr) ||
                other.sendMailCodeStr == sendMailCodeStr) &&
            (identical(other.enableSend, enableSend) ||
                other.enableSend == enableSend) &&
            (identical(other.emailAddress, emailAddress) ||
                other.emailAddress == emailAddress) &&
            (identical(other.emailAddressCode, emailAddressCode) ||
                other.emailAddressCode == emailAddressCode) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.smsResponse, smsResponse) ||
                other.smsResponse == smsResponse));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      enableMailCodeButton,
      enableUnbindButton,
      phoneFocus,
      phoneCodeFocus,
      event,
      sendMailCodeStr,
      enableSend,
      emailAddress,
      emailAddressCode,
      password,
      userInfo,
      smsResponse);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnbindMailUiStateImplCopyWith<_$UnbindMailUiStateImpl> get copyWith =>
      __$$UnbindMailUiStateImplCopyWithImpl<_$UnbindMailUiStateImpl>(
          this, _$identity);
}

abstract class _UnbindMailUiState implements UnbindMailUiState {
  factory _UnbindMailUiState(
      {final bool enableMailCodeButton,
      final bool enableUnbindButton,
      final bool phoneFocus,
      final bool phoneCodeFocus,
      final CommonUIEvent event,
      final String sendMailCodeStr,
      final bool enableSend,
      final String? emailAddress,
      final String? emailAddressCode,
      final String? password,
      final UserInfoModel? userInfo,
      final SmsTrCodeRes? smsResponse}) = _$UnbindMailUiStateImpl;

  @override
  bool get enableMailCodeButton;
  @override //验证码
  bool get enableUnbindButton;
  @override //是否可以点击 解绑按钮
  bool get phoneFocus;
  @override
  bool get phoneCodeFocus;
  @override
  CommonUIEvent get event;
  @override
  String get sendMailCodeStr;
  @override //邮箱验证码文案
  bool get enableSend;
  @override //是否可以发送验证码
  String? get emailAddress;
  @override
  String? get emailAddressCode;
  @override
  String? get password;
  @override
  UserInfoModel? get userInfo;
  @override //用户信息
  SmsTrCodeRes? get smsResponse;
  @override
  @JsonKey(ignore: true)
  _$$UnbindMailUiStateImplCopyWith<_$UnbindMailUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
