// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warranty_cards_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WarrantyCardsUiState {
  String get title => throw _privateConstructorUsedError;
  set title(String value) => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  set url(String value) => throw _privateConstructorUsedError;
  UserInfoModel? get userInfo => throw _privateConstructorUsedError;
  set userInfo(UserInfoModel? value) => throw _privateConstructorUsedError;
  bool? get deviceListChecked => throw _privateConstructorUsedError;
  set deviceListChecked(bool? value) => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;
  set event(CommonUIEvent value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WarrantyCardsUiStateCopyWith<WarrantyCardsUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarrantyCardsUiStateCopyWith<$Res> {
  factory $WarrantyCardsUiStateCopyWith(WarrantyCardsUiState value,
          $Res Function(WarrantyCardsUiState) then) =
      _$WarrantyCardsUiStateCopyWithImpl<$Res, WarrantyCardsUiState>;
  @useResult
  $Res call(
      {String title,
      String url,
      UserInfoModel? userInfo,
      bool? deviceListChecked,
      CommonUIEvent event});

  $UserInfoModelCopyWith<$Res>? get userInfo;
}

/// @nodoc
class _$WarrantyCardsUiStateCopyWithImpl<$Res,
        $Val extends WarrantyCardsUiState>
    implements $WarrantyCardsUiStateCopyWith<$Res> {
  _$WarrantyCardsUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? userInfo = freezed,
    Object? deviceListChecked = freezed,
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      deviceListChecked: freezed == deviceListChecked
          ? _value.deviceListChecked
          : deviceListChecked // ignore: cast_nullable_to_non_nullable
              as bool?,
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
}

/// @nodoc
abstract class _$$WarrantyCardsUiStateImplCopyWith<$Res>
    implements $WarrantyCardsUiStateCopyWith<$Res> {
  factory _$$WarrantyCardsUiStateImplCopyWith(_$WarrantyCardsUiStateImpl value,
          $Res Function(_$WarrantyCardsUiStateImpl) then) =
      __$$WarrantyCardsUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String url,
      UserInfoModel? userInfo,
      bool? deviceListChecked,
      CommonUIEvent event});

  @override
  $UserInfoModelCopyWith<$Res>? get userInfo;
}

/// @nodoc
class __$$WarrantyCardsUiStateImplCopyWithImpl<$Res>
    extends _$WarrantyCardsUiStateCopyWithImpl<$Res, _$WarrantyCardsUiStateImpl>
    implements _$$WarrantyCardsUiStateImplCopyWith<$Res> {
  __$$WarrantyCardsUiStateImplCopyWithImpl(_$WarrantyCardsUiStateImpl _value,
      $Res Function(_$WarrantyCardsUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? userInfo = freezed,
    Object? deviceListChecked = freezed,
    Object? event = null,
  }) {
    return _then(_$WarrantyCardsUiStateImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      deviceListChecked: freezed == deviceListChecked
          ? _value.deviceListChecked
          : deviceListChecked // ignore: cast_nullable_to_non_nullable
              as bool?,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$WarrantyCardsUiStateImpl implements _WarrantyCardsUiState {
  _$WarrantyCardsUiStateImpl(
      {required this.title,
      required this.url,
      this.userInfo,
      this.deviceListChecked,
      this.event = const EmptyEvent()});

  @override
  String title;
  @override
  String url;
  @override
  UserInfoModel? userInfo;
  @override
  bool? deviceListChecked;
  @override
  @JsonKey()
  CommonUIEvent event;

  @override
  String toString() {
    return 'WarrantyCardsUiState(title: $title, url: $url, userInfo: $userInfo, deviceListChecked: $deviceListChecked, event: $event)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarrantyCardsUiStateImplCopyWith<_$WarrantyCardsUiStateImpl>
      get copyWith =>
          __$$WarrantyCardsUiStateImplCopyWithImpl<_$WarrantyCardsUiStateImpl>(
              this, _$identity);
}

abstract class _WarrantyCardsUiState implements WarrantyCardsUiState {
  factory _WarrantyCardsUiState(
      {required String title,
      required String url,
      UserInfoModel? userInfo,
      bool? deviceListChecked,
      CommonUIEvent event}) = _$WarrantyCardsUiStateImpl;

  @override
  String get title;
  set title(String value);
  @override
  String get url;
  set url(String value);
  @override
  UserInfoModel? get userInfo;
  set userInfo(UserInfoModel? value);
  @override
  bool? get deviceListChecked;
  set deviceListChecked(bool? value);
  @override
  CommonUIEvent get event;
  set event(CommonUIEvent value);
  @override
  @JsonKey(ignore: true)
  _$$WarrantyCardsUiStateImplCopyWith<_$WarrantyCardsUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
