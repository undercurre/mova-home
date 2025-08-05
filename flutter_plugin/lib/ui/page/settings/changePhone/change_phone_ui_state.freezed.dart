// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_phone_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChangePhoneUiState {
  String? get phoneNumber => throw _privateConstructorUsedError; //手机号
  String? get phoneCode => throw _privateConstructorUsedError; //验证码
  UserInfoModel? get userInfo => throw _privateConstructorUsedError; //用户信息
  SmsTrCodeRes? get smsRes => throw _privateConstructorUsedError; //验证码接口返回数据模型
  String? get phoneAreaCode => throw _privateConstructorUsedError; //手机区号码
  RegionItem? get selectRegion => throw _privateConstructorUsedError; //选择后的国家区域
  RegionItem get currentRegion => throw _privateConstructorUsedError; //默认的国家区域
  bool get enableBindButton => throw _privateConstructorUsedError; //绑定按钮
  bool get timerRunning => throw _privateConstructorUsedError; //按钮倒计时中
  bool get enableValidCodeButton => throw _privateConstructorUsedError; //验证码按钮
  String get sendMailCodeStr => throw _privateConstructorUsedError; //邮箱验证码文案
  bool get enableSend => throw _privateConstructorUsedError; //是否可以发送验证码
  CommonUIEvent get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChangePhoneUiStateCopyWith<ChangePhoneUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangePhoneUiStateCopyWith<$Res> {
  factory $ChangePhoneUiStateCopyWith(
          ChangePhoneUiState value, $Res Function(ChangePhoneUiState) then) =
      _$ChangePhoneUiStateCopyWithImpl<$Res, ChangePhoneUiState>;
  @useResult
  $Res call(
      {String? phoneNumber,
      String? phoneCode,
      UserInfoModel? userInfo,
      SmsTrCodeRes? smsRes,
      String? phoneAreaCode,
      RegionItem? selectRegion,
      RegionItem currentRegion,
      bool enableBindButton,
      bool timerRunning,
      bool enableValidCodeButton,
      String sendMailCodeStr,
      bool enableSend,
      CommonUIEvent event});

  $UserInfoModelCopyWith<$Res>? get userInfo;
  $SmsTrCodeResCopyWith<$Res>? get smsRes;
}

/// @nodoc
class _$ChangePhoneUiStateCopyWithImpl<$Res, $Val extends ChangePhoneUiState>
    implements $ChangePhoneUiStateCopyWith<$Res> {
  _$ChangePhoneUiStateCopyWithImpl(this._value, this._then);

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
    Object? enableBindButton = null,
    Object? timerRunning = null,
    Object? enableValidCodeButton = null,
    Object? sendMailCodeStr = null,
    Object? enableSend = null,
    Object? event = null,
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
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ChangePhoneUiStateImplCopyWith<$Res>
    implements $ChangePhoneUiStateCopyWith<$Res> {
  factory _$$ChangePhoneUiStateImplCopyWith(_$ChangePhoneUiStateImpl value,
          $Res Function(_$ChangePhoneUiStateImpl) then) =
      __$$ChangePhoneUiStateImplCopyWithImpl<$Res>;
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
      bool enableBindButton,
      bool timerRunning,
      bool enableValidCodeButton,
      String sendMailCodeStr,
      bool enableSend,
      CommonUIEvent event});

  @override
  $UserInfoModelCopyWith<$Res>? get userInfo;
  @override
  $SmsTrCodeResCopyWith<$Res>? get smsRes;
}

/// @nodoc
class __$$ChangePhoneUiStateImplCopyWithImpl<$Res>
    extends _$ChangePhoneUiStateCopyWithImpl<$Res, _$ChangePhoneUiStateImpl>
    implements _$$ChangePhoneUiStateImplCopyWith<$Res> {
  __$$ChangePhoneUiStateImplCopyWithImpl(_$ChangePhoneUiStateImpl _value,
      $Res Function(_$ChangePhoneUiStateImpl) _then)
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
    Object? enableBindButton = null,
    Object? timerRunning = null,
    Object? enableValidCodeButton = null,
    Object? sendMailCodeStr = null,
    Object? enableSend = null,
    Object? event = null,
  }) {
    return _then(_$ChangePhoneUiStateImpl(
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
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$ChangePhoneUiStateImpl implements _ChangePhoneUiState {
  _$ChangePhoneUiStateImpl(
      {this.phoneNumber,
      this.phoneCode,
      this.userInfo,
      this.smsRes,
      this.phoneAreaCode,
      this.selectRegion,
      required this.currentRegion,
      this.enableBindButton = false,
      this.timerRunning = false,
      this.enableValidCodeButton = false,
      this.sendMailCodeStr = '',
      this.enableSend = true,
      this.event = const EmptyEvent()});

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
  final CommonUIEvent event;

  @override
  String toString() {
    return 'ChangePhoneUiState(phoneNumber: $phoneNumber, phoneCode: $phoneCode, userInfo: $userInfo, smsRes: $smsRes, phoneAreaCode: $phoneAreaCode, selectRegion: $selectRegion, currentRegion: $currentRegion, enableBindButton: $enableBindButton, timerRunning: $timerRunning, enableValidCodeButton: $enableValidCodeButton, sendMailCodeStr: $sendMailCodeStr, enableSend: $enableSend, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePhoneUiStateImpl &&
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
            (identical(other.event, event) || other.event == event));
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
      enableBindButton,
      timerRunning,
      enableValidCodeButton,
      sendMailCodeStr,
      enableSend,
      event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePhoneUiStateImplCopyWith<_$ChangePhoneUiStateImpl> get copyWith =>
      __$$ChangePhoneUiStateImplCopyWithImpl<_$ChangePhoneUiStateImpl>(
          this, _$identity);
}

abstract class _ChangePhoneUiState implements ChangePhoneUiState {
  factory _ChangePhoneUiState(
      {final String? phoneNumber,
      final String? phoneCode,
      final UserInfoModel? userInfo,
      final SmsTrCodeRes? smsRes,
      final String? phoneAreaCode,
      final RegionItem? selectRegion,
      required final RegionItem currentRegion,
      final bool enableBindButton,
      final bool timerRunning,
      final bool enableValidCodeButton,
      final String sendMailCodeStr,
      final bool enableSend,
      final CommonUIEvent event}) = _$ChangePhoneUiStateImpl;

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
  CommonUIEvent get event;
  @override
  @JsonKey(ignore: true)
  _$$ChangePhoneUiStateImplCopyWith<_$ChangePhoneUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
