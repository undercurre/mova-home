// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_phone_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserPhoneUiState {
  String? get phoneNumber => throw _privateConstructorUsedError; //手机号
  String? get phoneCode => throw _privateConstructorUsedError; //验证码
  UserInfoModel? get userInfo => throw _privateConstructorUsedError; //用户信息
  SmsTrCodeRes? get smsRes => throw _privateConstructorUsedError; //验证码接口返回数据模型
  String? get phoneAreaCode => throw _privateConstructorUsedError; //手机区号码
  RegionItem? get selectRegion => throw _privateConstructorUsedError; //选择后的国家区域
  RegionItem get currentRegion => throw _privateConstructorUsedError; //默认的国家区域
  BindPhoneType get bindPhoneType =>
      throw _privateConstructorUsedError; //绑定手机号类型  1 表示已有手机号/ 2表示无手机号
  bool get enableBindButton => throw _privateConstructorUsedError; //绑定按钮
  bool get timerRunning => throw _privateConstructorUsedError; //按钮倒计时中
  bool get enableValidCodeButton => throw _privateConstructorUsedError; //验证码按钮
  String get sendMailCodeStr => throw _privateConstructorUsedError; //邮箱验证码文案
  bool get enableSend => throw _privateConstructorUsedError; //是否可以发送验证码
  bool get showChangeEmail => throw _privateConstructorUsedError; //更换邮箱
  CommonUIEvent get event => throw _privateConstructorUsedError; // 解除绑定
  String get unbindButtonText => throw _privateConstructorUsedError; //解除绑定按钮文案
  bool get enableUnbindButton => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserPhoneUiStateCopyWith<UserPhoneUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPhoneUiStateCopyWith<$Res> {
  factory $UserPhoneUiStateCopyWith(
          UserPhoneUiState value, $Res Function(UserPhoneUiState) then) =
      _$UserPhoneUiStateCopyWithImpl<$Res, UserPhoneUiState>;
  @useResult
  $Res call(
      {String? phoneNumber,
      String? phoneCode,
      UserInfoModel? userInfo,
      SmsTrCodeRes? smsRes,
      String? phoneAreaCode,
      RegionItem? selectRegion,
      RegionItem currentRegion,
      BindPhoneType bindPhoneType,
      bool enableBindButton,
      bool timerRunning,
      bool enableValidCodeButton,
      String sendMailCodeStr,
      bool enableSend,
      bool showChangeEmail,
      CommonUIEvent event,
      String unbindButtonText,
      bool enableUnbindButton});

  $UserInfoModelCopyWith<$Res>? get userInfo;
  $SmsTrCodeResCopyWith<$Res>? get smsRes;
}

/// @nodoc
class _$UserPhoneUiStateCopyWithImpl<$Res, $Val extends UserPhoneUiState>
    implements $UserPhoneUiStateCopyWith<$Res> {
  _$UserPhoneUiStateCopyWithImpl(this._value, this._then);

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
    Object? selectRegion = freezed,
    Object? currentRegion = null,
    Object? bindPhoneType = null,
    Object? enableBindButton = null,
    Object? timerRunning = null,
    Object? enableValidCodeButton = null,
    Object? sendMailCodeStr = null,
    Object? enableSend = null,
    Object? showChangeEmail = null,
    Object? event = null,
    Object? unbindButtonText = null,
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
      selectRegion: freezed == selectRegion
          ? _value.selectRegion
          : selectRegion // ignore: cast_nullable_to_non_nullable
              as RegionItem?,
      currentRegion: null == currentRegion
          ? _value.currentRegion
          : currentRegion // ignore: cast_nullable_to_non_nullable
              as RegionItem,
      bindPhoneType: null == bindPhoneType
          ? _value.bindPhoneType
          : bindPhoneType // ignore: cast_nullable_to_non_nullable
              as BindPhoneType,
      enableBindButton: null == enableBindButton
          ? _value.enableBindButton
          : enableBindButton // ignore: cast_nullable_to_non_nullable
              as bool,
      timerRunning: null == timerRunning
          ? _value.timerRunning
          : timerRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      enableValidCodeButton: null == enableValidCodeButton
          ? _value.enableValidCodeButton
          : enableValidCodeButton // ignore: cast_nullable_to_non_nullable
              as bool,
      sendMailCodeStr: null == sendMailCodeStr
          ? _value.sendMailCodeStr
          : sendMailCodeStr // ignore: cast_nullable_to_non_nullable
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
      unbindButtonText: null == unbindButtonText
          ? _value.unbindButtonText
          : unbindButtonText // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$UserPhoneUiStateImplCopyWith<$Res>
    implements $UserPhoneUiStateCopyWith<$Res> {
  factory _$$UserPhoneUiStateImplCopyWith(_$UserPhoneUiStateImpl value,
          $Res Function(_$UserPhoneUiStateImpl) then) =
      __$$UserPhoneUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? phoneNumber,
      String? phoneCode,
      UserInfoModel? userInfo,
      SmsTrCodeRes? smsRes,
      String? phoneAreaCode,
      RegionItem? selectRegion,
      RegionItem currentRegion,
      BindPhoneType bindPhoneType,
      bool enableBindButton,
      bool timerRunning,
      bool enableValidCodeButton,
      String sendMailCodeStr,
      bool enableSend,
      bool showChangeEmail,
      CommonUIEvent event,
      String unbindButtonText,
      bool enableUnbindButton});

  @override
  $UserInfoModelCopyWith<$Res>? get userInfo;
  @override
  $SmsTrCodeResCopyWith<$Res>? get smsRes;
}

/// @nodoc
class __$$UserPhoneUiStateImplCopyWithImpl<$Res>
    extends _$UserPhoneUiStateCopyWithImpl<$Res, _$UserPhoneUiStateImpl>
    implements _$$UserPhoneUiStateImplCopyWith<$Res> {
  __$$UserPhoneUiStateImplCopyWithImpl(_$UserPhoneUiStateImpl _value,
      $Res Function(_$UserPhoneUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = freezed,
    Object? phoneCode = freezed,
    Object? userInfo = freezed,
    Object? smsRes = freezed,
    Object? phoneAreaCode = freezed,
    Object? selectRegion = freezed,
    Object? currentRegion = null,
    Object? bindPhoneType = null,
    Object? enableBindButton = null,
    Object? timerRunning = null,
    Object? enableValidCodeButton = null,
    Object? sendMailCodeStr = null,
    Object? enableSend = null,
    Object? showChangeEmail = null,
    Object? event = null,
    Object? unbindButtonText = null,
    Object? enableUnbindButton = null,
  }) {
    return _then(_$UserPhoneUiStateImpl(
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
      selectRegion: freezed == selectRegion
          ? _value.selectRegion
          : selectRegion // ignore: cast_nullable_to_non_nullable
              as RegionItem?,
      currentRegion: null == currentRegion
          ? _value.currentRegion
          : currentRegion // ignore: cast_nullable_to_non_nullable
              as RegionItem,
      bindPhoneType: null == bindPhoneType
          ? _value.bindPhoneType
          : bindPhoneType // ignore: cast_nullable_to_non_nullable
              as BindPhoneType,
      enableBindButton: null == enableBindButton
          ? _value.enableBindButton
          : enableBindButton // ignore: cast_nullable_to_non_nullable
              as bool,
      timerRunning: null == timerRunning
          ? _value.timerRunning
          : timerRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      enableValidCodeButton: null == enableValidCodeButton
          ? _value.enableValidCodeButton
          : enableValidCodeButton // ignore: cast_nullable_to_non_nullable
              as bool,
      sendMailCodeStr: null == sendMailCodeStr
          ? _value.sendMailCodeStr
          : sendMailCodeStr // ignore: cast_nullable_to_non_nullable
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
      unbindButtonText: null == unbindButtonText
          ? _value.unbindButtonText
          : unbindButtonText // ignore: cast_nullable_to_non_nullable
              as String,
      enableUnbindButton: null == enableUnbindButton
          ? _value.enableUnbindButton
          : enableUnbindButton // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UserPhoneUiStateImpl implements _UserPhoneUiState {
  _$UserPhoneUiStateImpl(
      {this.phoneNumber,
      this.phoneCode,
      this.userInfo,
      this.smsRes,
      this.phoneAreaCode,
      this.selectRegion,
      required this.currentRegion,
      this.bindPhoneType = BindPhoneType.nonePhoneType,
      this.enableBindButton = false,
      this.timerRunning = false,
      this.enableValidCodeButton = false,
      this.sendMailCodeStr = '',
      this.enableSend = true,
      this.showChangeEmail = false,
      this.event = const EmptyEvent(),
      this.unbindButtonText = '',
      this.enableUnbindButton = true});

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
  final RegionItem? selectRegion;
//选择后的国家区域
  @override
  final RegionItem currentRegion;
//默认的国家区域
  @override
  @JsonKey()
  final BindPhoneType bindPhoneType;
//绑定手机号类型  1 表示已有手机号/ 2表示无手机号
  @override
  @JsonKey()
  final bool enableBindButton;
//绑定按钮
  @override
  @JsonKey()
  final bool timerRunning;
//按钮倒计时中
  @override
  @JsonKey()
  final bool enableValidCodeButton;
//验证码按钮
  @override
  @JsonKey()
  final String sendMailCodeStr;
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
  final String unbindButtonText;
//解除绑定按钮文案
  @override
  @JsonKey()
  final bool enableUnbindButton;

  @override
  String toString() {
    return 'UserPhoneUiState(phoneNumber: $phoneNumber, phoneCode: $phoneCode, userInfo: $userInfo, smsRes: $smsRes, phoneAreaCode: $phoneAreaCode, selectRegion: $selectRegion, currentRegion: $currentRegion, bindPhoneType: $bindPhoneType, enableBindButton: $enableBindButton, timerRunning: $timerRunning, enableValidCodeButton: $enableValidCodeButton, sendMailCodeStr: $sendMailCodeStr, enableSend: $enableSend, showChangeEmail: $showChangeEmail, event: $event, unbindButtonText: $unbindButtonText, enableUnbindButton: $enableUnbindButton)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPhoneUiStateImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.phoneCode, phoneCode) ||
                other.phoneCode == phoneCode) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.smsRes, smsRes) || other.smsRes == smsRes) &&
            (identical(other.phoneAreaCode, phoneAreaCode) ||
                other.phoneAreaCode == phoneAreaCode) &&
            (identical(other.selectRegion, selectRegion) ||
                other.selectRegion == selectRegion) &&
            (identical(other.currentRegion, currentRegion) ||
                other.currentRegion == currentRegion) &&
            (identical(other.bindPhoneType, bindPhoneType) ||
                other.bindPhoneType == bindPhoneType) &&
            (identical(other.enableBindButton, enableBindButton) ||
                other.enableBindButton == enableBindButton) &&
            (identical(other.timerRunning, timerRunning) ||
                other.timerRunning == timerRunning) &&
            (identical(other.enableValidCodeButton, enableValidCodeButton) ||
                other.enableValidCodeButton == enableValidCodeButton) &&
            (identical(other.sendMailCodeStr, sendMailCodeStr) ||
                other.sendMailCodeStr == sendMailCodeStr) &&
            (identical(other.enableSend, enableSend) ||
                other.enableSend == enableSend) &&
            (identical(other.showChangeEmail, showChangeEmail) ||
                other.showChangeEmail == showChangeEmail) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.unbindButtonText, unbindButtonText) ||
                other.unbindButtonText == unbindButtonText) &&
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
      selectRegion,
      currentRegion,
      bindPhoneType,
      enableBindButton,
      timerRunning,
      enableValidCodeButton,
      sendMailCodeStr,
      enableSend,
      showChangeEmail,
      event,
      unbindButtonText,
      enableUnbindButton);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPhoneUiStateImplCopyWith<_$UserPhoneUiStateImpl> get copyWith =>
      __$$UserPhoneUiStateImplCopyWithImpl<_$UserPhoneUiStateImpl>(
          this, _$identity);
}

abstract class _UserPhoneUiState implements UserPhoneUiState {
  factory _UserPhoneUiState(
      {final String? phoneNumber,
      final String? phoneCode,
      final UserInfoModel? userInfo,
      final SmsTrCodeRes? smsRes,
      final String? phoneAreaCode,
      final RegionItem? selectRegion,
      required final RegionItem currentRegion,
      final BindPhoneType bindPhoneType,
      final bool enableBindButton,
      final bool timerRunning,
      final bool enableValidCodeButton,
      final String sendMailCodeStr,
      final bool enableSend,
      final bool showChangeEmail,
      final CommonUIEvent event,
      final String unbindButtonText,
      final bool enableUnbindButton}) = _$UserPhoneUiStateImpl;

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
  RegionItem? get selectRegion;
  @override //选择后的国家区域
  RegionItem get currentRegion;
  @override //默认的国家区域
  BindPhoneType get bindPhoneType;
  @override //绑定手机号类型  1 表示已有手机号/ 2表示无手机号
  bool get enableBindButton;
  @override //绑定按钮
  bool get timerRunning;
  @override //按钮倒计时中
  bool get enableValidCodeButton;
  @override //验证码按钮
  String get sendMailCodeStr;
  @override //邮箱验证码文案
  bool get enableSend;
  @override //是否可以发送验证码
  bool get showChangeEmail;
  @override //更换邮箱
  CommonUIEvent get event;
  @override // 解除绑定
  String get unbindButtonText;
  @override //解除绑定按钮文案
  bool get enableUnbindButton;
  @override
  @JsonKey(ignore: true)
  _$$UserPhoneUiStateImplCopyWith<_$UserPhoneUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
