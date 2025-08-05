// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_mail_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserMailUiState {
  RegionItem get currentRegion => throw _privateConstructorUsedError;
  BindMailEnum get pageType => throw _privateConstructorUsedError;
  bool get enableBindButton => throw _privateConstructorUsedError; //绑定
  bool get timerRunning => throw _privateConstructorUsedError; //按钮倒计时中
  bool get enableMailCodeButton => throw _privateConstructorUsedError; //验证码
  bool get phoneFocus => throw _privateConstructorUsedError;
  bool get phoneCodeFocus => throw _privateConstructorUsedError;
  bool get agreed => throw _privateConstructorUsedError; //协议；
  CommonUIEvent get event => throw _privateConstructorUsedError;
  String get sendMailCodeStr => throw _privateConstructorUsedError; //邮箱验证码文案
  bool get enableSend => throw _privateConstructorUsedError; //是否可以发送验证码
  String? get emailAddress => throw _privateConstructorUsedError;
  String? get emailAddressCode => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  UserInfoModel? get userInfo => throw _privateConstructorUsedError; //用户信息
  SmsTrCodeRes? get smsResponse => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserMailUiStateCopyWith<UserMailUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMailUiStateCopyWith<$Res> {
  factory $UserMailUiStateCopyWith(
          UserMailUiState value, $Res Function(UserMailUiState) then) =
      _$UserMailUiStateCopyWithImpl<$Res, UserMailUiState>;
  @useResult
  $Res call(
      {RegionItem currentRegion,
      BindMailEnum pageType,
      bool enableBindButton,
      bool timerRunning,
      bool enableMailCodeButton,
      bool phoneFocus,
      bool phoneCodeFocus,
      bool agreed,
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
class _$UserMailUiStateCopyWithImpl<$Res, $Val extends UserMailUiState>
    implements $UserMailUiStateCopyWith<$Res> {
  _$UserMailUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRegion = null,
    Object? pageType = null,
    Object? enableBindButton = null,
    Object? timerRunning = null,
    Object? enableMailCodeButton = null,
    Object? phoneFocus = null,
    Object? phoneCodeFocus = null,
    Object? agreed = null,
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
      currentRegion: null == currentRegion
          ? _value.currentRegion
          : currentRegion // ignore: cast_nullable_to_non_nullable
              as RegionItem,
      pageType: null == pageType
          ? _value.pageType
          : pageType // ignore: cast_nullable_to_non_nullable
              as BindMailEnum,
      enableBindButton: null == enableBindButton
          ? _value.enableBindButton
          : enableBindButton // ignore: cast_nullable_to_non_nullable
              as bool,
      timerRunning: null == timerRunning
          ? _value.timerRunning
          : timerRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      enableMailCodeButton: null == enableMailCodeButton
          ? _value.enableMailCodeButton
          : enableMailCodeButton // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneFocus: null == phoneFocus
          ? _value.phoneFocus
          : phoneFocus // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneCodeFocus: null == phoneCodeFocus
          ? _value.phoneCodeFocus
          : phoneCodeFocus // ignore: cast_nullable_to_non_nullable
              as bool,
      agreed: null == agreed
          ? _value.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
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
abstract class _$$UserMailUiStateImplCopyWith<$Res>
    implements $UserMailUiStateCopyWith<$Res> {
  factory _$$UserMailUiStateImplCopyWith(_$UserMailUiStateImpl value,
          $Res Function(_$UserMailUiStateImpl) then) =
      __$$UserMailUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RegionItem currentRegion,
      BindMailEnum pageType,
      bool enableBindButton,
      bool timerRunning,
      bool enableMailCodeButton,
      bool phoneFocus,
      bool phoneCodeFocus,
      bool agreed,
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
class __$$UserMailUiStateImplCopyWithImpl<$Res>
    extends _$UserMailUiStateCopyWithImpl<$Res, _$UserMailUiStateImpl>
    implements _$$UserMailUiStateImplCopyWith<$Res> {
  __$$UserMailUiStateImplCopyWithImpl(
      _$UserMailUiStateImpl _value, $Res Function(_$UserMailUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRegion = null,
    Object? pageType = null,
    Object? enableBindButton = null,
    Object? timerRunning = null,
    Object? enableMailCodeButton = null,
    Object? phoneFocus = null,
    Object? phoneCodeFocus = null,
    Object? agreed = null,
    Object? event = null,
    Object? sendMailCodeStr = null,
    Object? enableSend = null,
    Object? emailAddress = freezed,
    Object? emailAddressCode = freezed,
    Object? password = freezed,
    Object? userInfo = freezed,
    Object? smsResponse = freezed,
  }) {
    return _then(_$UserMailUiStateImpl(
      currentRegion: null == currentRegion
          ? _value.currentRegion
          : currentRegion // ignore: cast_nullable_to_non_nullable
              as RegionItem,
      pageType: null == pageType
          ? _value.pageType
          : pageType // ignore: cast_nullable_to_non_nullable
              as BindMailEnum,
      enableBindButton: null == enableBindButton
          ? _value.enableBindButton
          : enableBindButton // ignore: cast_nullable_to_non_nullable
              as bool,
      timerRunning: null == timerRunning
          ? _value.timerRunning
          : timerRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      enableMailCodeButton: null == enableMailCodeButton
          ? _value.enableMailCodeButton
          : enableMailCodeButton // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneFocus: null == phoneFocus
          ? _value.phoneFocus
          : phoneFocus // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneCodeFocus: null == phoneCodeFocus
          ? _value.phoneCodeFocus
          : phoneCodeFocus // ignore: cast_nullable_to_non_nullable
              as bool,
      agreed: null == agreed
          ? _value.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
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

class _$UserMailUiStateImpl implements _UserMailUiState {
  _$UserMailUiStateImpl(
      {required this.currentRegion,
      this.pageType = BindMailEnum.notBindMailType,
      this.enableBindButton = false,
      this.timerRunning = false,
      this.enableMailCodeButton = false,
      this.phoneFocus = false,
      this.phoneCodeFocus = false,
      this.agreed = false,
      this.event = const EmptyEvent(),
      this.sendMailCodeStr = '',
      this.enableSend = true,
      this.emailAddress,
      this.emailAddressCode,
      this.password,
      this.userInfo,
      this.smsResponse});

  @override
  final RegionItem currentRegion;
  @override
  @JsonKey()
  final BindMailEnum pageType;
  @override
  @JsonKey()
  final bool enableBindButton;
//绑定
  @override
  @JsonKey()
  final bool timerRunning;
//按钮倒计时中
  @override
  @JsonKey()
  final bool enableMailCodeButton;
//验证码
  @override
  @JsonKey()
  final bool phoneFocus;
  @override
  @JsonKey()
  final bool phoneCodeFocus;
  @override
  @JsonKey()
  final bool agreed;
//协议；
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
    return 'UserMailUiState(currentRegion: $currentRegion, pageType: $pageType, enableBindButton: $enableBindButton, timerRunning: $timerRunning, enableMailCodeButton: $enableMailCodeButton, phoneFocus: $phoneFocus, phoneCodeFocus: $phoneCodeFocus, agreed: $agreed, event: $event, sendMailCodeStr: $sendMailCodeStr, enableSend: $enableSend, emailAddress: $emailAddress, emailAddressCode: $emailAddressCode, password: $password, userInfo: $userInfo, smsResponse: $smsResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMailUiStateImpl &&
            (identical(other.currentRegion, currentRegion) ||
                other.currentRegion == currentRegion) &&
            (identical(other.pageType, pageType) ||
                other.pageType == pageType) &&
            (identical(other.enableBindButton, enableBindButton) ||
                other.enableBindButton == enableBindButton) &&
            (identical(other.timerRunning, timerRunning) ||
                other.timerRunning == timerRunning) &&
            (identical(other.enableMailCodeButton, enableMailCodeButton) ||
                other.enableMailCodeButton == enableMailCodeButton) &&
            (identical(other.phoneFocus, phoneFocus) ||
                other.phoneFocus == phoneFocus) &&
            (identical(other.phoneCodeFocus, phoneCodeFocus) ||
                other.phoneCodeFocus == phoneCodeFocus) &&
            (identical(other.agreed, agreed) || other.agreed == agreed) &&
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
      currentRegion,
      pageType,
      enableBindButton,
      timerRunning,
      enableMailCodeButton,
      phoneFocus,
      phoneCodeFocus,
      agreed,
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
  _$$UserMailUiStateImplCopyWith<_$UserMailUiStateImpl> get copyWith =>
      __$$UserMailUiStateImplCopyWithImpl<_$UserMailUiStateImpl>(
          this, _$identity);
}

abstract class _UserMailUiState implements UserMailUiState {
  factory _UserMailUiState(
      {required final RegionItem currentRegion,
      final BindMailEnum pageType,
      final bool enableBindButton,
      final bool timerRunning,
      final bool enableMailCodeButton,
      final bool phoneFocus,
      final bool phoneCodeFocus,
      final bool agreed,
      final CommonUIEvent event,
      final String sendMailCodeStr,
      final bool enableSend,
      final String? emailAddress,
      final String? emailAddressCode,
      final String? password,
      final UserInfoModel? userInfo,
      final SmsTrCodeRes? smsResponse}) = _$UserMailUiStateImpl;

  @override
  RegionItem get currentRegion;
  @override
  BindMailEnum get pageType;
  @override
  bool get enableBindButton;
  @override //绑定
  bool get timerRunning;
  @override //按钮倒计时中
  bool get enableMailCodeButton;
  @override //验证码
  bool get phoneFocus;
  @override
  bool get phoneCodeFocus;
  @override
  bool get agreed;
  @override //协议；
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
  _$$UserMailUiStateImplCopyWith<_$UserMailUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
