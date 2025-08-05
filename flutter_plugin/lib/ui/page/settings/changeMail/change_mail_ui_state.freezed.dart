// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_mail_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChangeMailUiState {
  RegionItem get currentRegion => throw _privateConstructorUsedError;
  bool get enableBindButton => throw _privateConstructorUsedError; //绑定
  bool get timerRunning => throw _privateConstructorUsedError; //按钮倒计时中
  bool get enableMailCodeButton => throw _privateConstructorUsedError; //验证码
  CommonUIEvent get event => throw _privateConstructorUsedError;
  bool get agreed => throw _privateConstructorUsedError; //协议；
  String get sendMailCodeStr => throw _privateConstructorUsedError; //邮箱验证码文案
  String? get emailAddress => throw _privateConstructorUsedError;
  String? get emailAddressCode => throw _privateConstructorUsedError;
  UserInfoModel? get userInfo => throw _privateConstructorUsedError; //用户信息
  RecaptchaModel? get recaptchaModel =>
      throw _privateConstructorUsedError; //验证码模型
  bool get enableSend => throw _privateConstructorUsedError; //是否可以发送验证码
  SmsTrCodeRes? get smsResponse => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChangeMailUiStateCopyWith<ChangeMailUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeMailUiStateCopyWith<$Res> {
  factory $ChangeMailUiStateCopyWith(
          ChangeMailUiState value, $Res Function(ChangeMailUiState) then) =
      _$ChangeMailUiStateCopyWithImpl<$Res, ChangeMailUiState>;
  @useResult
  $Res call(
      {RegionItem currentRegion,
      bool enableBindButton,
      bool timerRunning,
      bool enableMailCodeButton,
      CommonUIEvent event,
      bool agreed,
      String sendMailCodeStr,
      String? emailAddress,
      String? emailAddressCode,
      UserInfoModel? userInfo,
      RecaptchaModel? recaptchaModel,
      bool enableSend,
      SmsTrCodeRes? smsResponse});

  $UserInfoModelCopyWith<$Res>? get userInfo;
  $RecaptchaModelCopyWith<$Res>? get recaptchaModel;
  $SmsTrCodeResCopyWith<$Res>? get smsResponse;
}

/// @nodoc
class _$ChangeMailUiStateCopyWithImpl<$Res, $Val extends ChangeMailUiState>
    implements $ChangeMailUiStateCopyWith<$Res> {
  _$ChangeMailUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRegion = null,
    Object? enableBindButton = null,
    Object? timerRunning = null,
    Object? enableMailCodeButton = null,
    Object? event = null,
    Object? agreed = null,
    Object? sendMailCodeStr = null,
    Object? emailAddress = freezed,
    Object? emailAddressCode = freezed,
    Object? userInfo = freezed,
    Object? recaptchaModel = freezed,
    Object? enableSend = null,
    Object? smsResponse = freezed,
  }) {
    return _then(_value.copyWith(
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
      enableMailCodeButton: null == enableMailCodeButton
          ? _value.enableMailCodeButton
          : enableMailCodeButton // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      agreed: null == agreed
          ? _value.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
      sendMailCodeStr: null == sendMailCodeStr
          ? _value.sendMailCodeStr
          : sendMailCodeStr // ignore: cast_nullable_to_non_nullable
              as String,
      emailAddress: freezed == emailAddress
          ? _value.emailAddress
          : emailAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      emailAddressCode: freezed == emailAddressCode
          ? _value.emailAddressCode
          : emailAddressCode // ignore: cast_nullable_to_non_nullable
              as String?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      recaptchaModel: freezed == recaptchaModel
          ? _value.recaptchaModel
          : recaptchaModel // ignore: cast_nullable_to_non_nullable
              as RecaptchaModel?,
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
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
  $RecaptchaModelCopyWith<$Res>? get recaptchaModel {
    if (_value.recaptchaModel == null) {
      return null;
    }

    return $RecaptchaModelCopyWith<$Res>(_value.recaptchaModel!, (value) {
      return _then(_value.copyWith(recaptchaModel: value) as $Val);
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
abstract class _$$ChangeMailUiStateImplCopyWith<$Res>
    implements $ChangeMailUiStateCopyWith<$Res> {
  factory _$$ChangeMailUiStateImplCopyWith(_$ChangeMailUiStateImpl value,
          $Res Function(_$ChangeMailUiStateImpl) then) =
      __$$ChangeMailUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RegionItem currentRegion,
      bool enableBindButton,
      bool timerRunning,
      bool enableMailCodeButton,
      CommonUIEvent event,
      bool agreed,
      String sendMailCodeStr,
      String? emailAddress,
      String? emailAddressCode,
      UserInfoModel? userInfo,
      RecaptchaModel? recaptchaModel,
      bool enableSend,
      SmsTrCodeRes? smsResponse});

  @override
  $UserInfoModelCopyWith<$Res>? get userInfo;
  @override
  $RecaptchaModelCopyWith<$Res>? get recaptchaModel;
  @override
  $SmsTrCodeResCopyWith<$Res>? get smsResponse;
}

/// @nodoc
class __$$ChangeMailUiStateImplCopyWithImpl<$Res>
    extends _$ChangeMailUiStateCopyWithImpl<$Res, _$ChangeMailUiStateImpl>
    implements _$$ChangeMailUiStateImplCopyWith<$Res> {
  __$$ChangeMailUiStateImplCopyWithImpl(_$ChangeMailUiStateImpl _value,
      $Res Function(_$ChangeMailUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRegion = null,
    Object? enableBindButton = null,
    Object? timerRunning = null,
    Object? enableMailCodeButton = null,
    Object? event = null,
    Object? agreed = null,
    Object? sendMailCodeStr = null,
    Object? emailAddress = freezed,
    Object? emailAddressCode = freezed,
    Object? userInfo = freezed,
    Object? recaptchaModel = freezed,
    Object? enableSend = null,
    Object? smsResponse = freezed,
  }) {
    return _then(_$ChangeMailUiStateImpl(
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
      enableMailCodeButton: null == enableMailCodeButton
          ? _value.enableMailCodeButton
          : enableMailCodeButton // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      agreed: null == agreed
          ? _value.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
      sendMailCodeStr: null == sendMailCodeStr
          ? _value.sendMailCodeStr
          : sendMailCodeStr // ignore: cast_nullable_to_non_nullable
              as String,
      emailAddress: freezed == emailAddress
          ? _value.emailAddress
          : emailAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      emailAddressCode: freezed == emailAddressCode
          ? _value.emailAddressCode
          : emailAddressCode // ignore: cast_nullable_to_non_nullable
              as String?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      recaptchaModel: freezed == recaptchaModel
          ? _value.recaptchaModel
          : recaptchaModel // ignore: cast_nullable_to_non_nullable
              as RecaptchaModel?,
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      smsResponse: freezed == smsResponse
          ? _value.smsResponse
          : smsResponse // ignore: cast_nullable_to_non_nullable
              as SmsTrCodeRes?,
    ));
  }
}

/// @nodoc

class _$ChangeMailUiStateImpl implements _ChangeMailUiState {
  _$ChangeMailUiStateImpl(
      {required this.currentRegion,
      this.enableBindButton = false,
      this.timerRunning = false,
      this.enableMailCodeButton = false,
      this.event = const EmptyEvent(),
      this.agreed = false,
      this.sendMailCodeStr = '',
      this.emailAddress,
      this.emailAddressCode,
      this.userInfo,
      this.recaptchaModel,
      this.enableSend = true,
      this.smsResponse});

  @override
  final RegionItem currentRegion;
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
  final CommonUIEvent event;
  @override
  @JsonKey()
  final bool agreed;
//协议；
  @override
  @JsonKey()
  final String sendMailCodeStr;
//邮箱验证码文案
  @override
  final String? emailAddress;
  @override
  final String? emailAddressCode;
  @override
  final UserInfoModel? userInfo;
//用户信息
  @override
  final RecaptchaModel? recaptchaModel;
//验证码模型
  @override
  @JsonKey()
  final bool enableSend;
//是否可以发送验证码
  @override
  final SmsTrCodeRes? smsResponse;

  @override
  String toString() {
    return 'ChangeMailUiState(currentRegion: $currentRegion, enableBindButton: $enableBindButton, timerRunning: $timerRunning, enableMailCodeButton: $enableMailCodeButton, event: $event, agreed: $agreed, sendMailCodeStr: $sendMailCodeStr, emailAddress: $emailAddress, emailAddressCode: $emailAddressCode, userInfo: $userInfo, recaptchaModel: $recaptchaModel, enableSend: $enableSend, smsResponse: $smsResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeMailUiStateImpl &&
            (identical(other.currentRegion, currentRegion) ||
                other.currentRegion == currentRegion) &&
            (identical(other.enableBindButton, enableBindButton) ||
                other.enableBindButton == enableBindButton) &&
            (identical(other.timerRunning, timerRunning) ||
                other.timerRunning == timerRunning) &&
            (identical(other.enableMailCodeButton, enableMailCodeButton) ||
                other.enableMailCodeButton == enableMailCodeButton) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.agreed, agreed) || other.agreed == agreed) &&
            (identical(other.sendMailCodeStr, sendMailCodeStr) ||
                other.sendMailCodeStr == sendMailCodeStr) &&
            (identical(other.emailAddress, emailAddress) ||
                other.emailAddress == emailAddress) &&
            (identical(other.emailAddressCode, emailAddressCode) ||
                other.emailAddressCode == emailAddressCode) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.recaptchaModel, recaptchaModel) ||
                other.recaptchaModel == recaptchaModel) &&
            (identical(other.enableSend, enableSend) ||
                other.enableSend == enableSend) &&
            (identical(other.smsResponse, smsResponse) ||
                other.smsResponse == smsResponse));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentRegion,
      enableBindButton,
      timerRunning,
      enableMailCodeButton,
      event,
      agreed,
      sendMailCodeStr,
      emailAddress,
      emailAddressCode,
      userInfo,
      recaptchaModel,
      enableSend,
      smsResponse);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeMailUiStateImplCopyWith<_$ChangeMailUiStateImpl> get copyWith =>
      __$$ChangeMailUiStateImplCopyWithImpl<_$ChangeMailUiStateImpl>(
          this, _$identity);
}

abstract class _ChangeMailUiState implements ChangeMailUiState {
  factory _ChangeMailUiState(
      {required final RegionItem currentRegion,
      final bool enableBindButton,
      final bool timerRunning,
      final bool enableMailCodeButton,
      final CommonUIEvent event,
      final bool agreed,
      final String sendMailCodeStr,
      final String? emailAddress,
      final String? emailAddressCode,
      final UserInfoModel? userInfo,
      final RecaptchaModel? recaptchaModel,
      final bool enableSend,
      final SmsTrCodeRes? smsResponse}) = _$ChangeMailUiStateImpl;

  @override
  RegionItem get currentRegion;
  @override
  bool get enableBindButton;
  @override //绑定
  bool get timerRunning;
  @override //按钮倒计时中
  bool get enableMailCodeButton;
  @override //验证码
  CommonUIEvent get event;
  @override
  bool get agreed;
  @override //协议；
  String get sendMailCodeStr;
  @override //邮箱验证码文案
  String? get emailAddress;
  @override
  String? get emailAddressCode;
  @override
  UserInfoModel? get userInfo;
  @override //用户信息
  RecaptchaModel? get recaptchaModel;
  @override //验证码模型
  bool get enableSend;
  @override //是否可以发送验证码
  SmsTrCodeRes? get smsResponse;
  @override
  @JsonKey(ignore: true)
  _$$ChangeMailUiStateImplCopyWith<_$ChangeMailUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
