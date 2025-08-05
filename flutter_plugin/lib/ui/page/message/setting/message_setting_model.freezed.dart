// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_setting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ServiceSetingModel {
  String get title => throw _privateConstructorUsedError;
  set title(String value) => throw _privateConstructorUsedError;
  String get subTitle => throw _privateConstructorUsedError;
  set subTitle(String value) => throw _privateConstructorUsedError;
  bool get value => throw _privateConstructorUsedError;
  set value(bool value) => throw _privateConstructorUsedError;
  MessageSettingType get type => throw _privateConstructorUsedError;
  set type(MessageSettingType value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ServiceSetingModelCopyWith<ServiceSetingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceSetingModelCopyWith<$Res> {
  factory $ServiceSetingModelCopyWith(
          ServiceSetingModel value, $Res Function(ServiceSetingModel) then) =
      _$ServiceSetingModelCopyWithImpl<$Res, ServiceSetingModel>;
  @useResult
  $Res call(
      {String title, String subTitle, bool value, MessageSettingType type});
}

/// @nodoc
class _$ServiceSetingModelCopyWithImpl<$Res, $Val extends ServiceSetingModel>
    implements $ServiceSetingModelCopyWith<$Res> {
  _$ServiceSetingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? subTitle = null,
    Object? value = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subTitle: null == subTitle
          ? _value.subTitle
          : subTitle // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageSettingType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceSetingModelImplCopyWith<$Res>
    implements $ServiceSetingModelCopyWith<$Res> {
  factory _$$ServiceSetingModelImplCopyWith(_$ServiceSetingModelImpl value,
          $Res Function(_$ServiceSetingModelImpl) then) =
      __$$ServiceSetingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title, String subTitle, bool value, MessageSettingType type});
}

/// @nodoc
class __$$ServiceSetingModelImplCopyWithImpl<$Res>
    extends _$ServiceSetingModelCopyWithImpl<$Res, _$ServiceSetingModelImpl>
    implements _$$ServiceSetingModelImplCopyWith<$Res> {
  __$$ServiceSetingModelImplCopyWithImpl(_$ServiceSetingModelImpl _value,
      $Res Function(_$ServiceSetingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? subTitle = null,
    Object? value = null,
    Object? type = null,
  }) {
    return _then(_$ServiceSetingModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subTitle: null == subTitle
          ? _value.subTitle
          : subTitle // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageSettingType,
    ));
  }
}

/// @nodoc

class _$ServiceSetingModelImpl implements _ServiceSetingModel {
  _$ServiceSetingModelImpl(
      {this.title = '',
      this.subTitle = '',
      this.value = false,
      this.type = MessageSettingType.MessageSettingNone});

  @override
  @JsonKey()
  String title;
  @override
  @JsonKey()
  String subTitle;
  @override
  @JsonKey()
  bool value;
  @override
  @JsonKey()
  MessageSettingType type;

  @override
  String toString() {
    return 'ServiceSetingModel(title: $title, subTitle: $subTitle, value: $value, type: $type)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceSetingModelImplCopyWith<_$ServiceSetingModelImpl> get copyWith =>
      __$$ServiceSetingModelImplCopyWithImpl<_$ServiceSetingModelImpl>(
          this, _$identity);
}

abstract class _ServiceSetingModel implements ServiceSetingModel {
  factory _ServiceSetingModel(
      {String title,
      String subTitle,
      bool value,
      MessageSettingType type}) = _$ServiceSetingModelImpl;

  @override
  String get title;
  set title(String value);
  @override
  String get subTitle;
  set subTitle(String value);
  @override
  bool get value;
  set value(bool value);
  @override
  MessageSettingType get type;
  set type(MessageSettingType value);
  @override
  @JsonKey(ignore: true)
  _$$ServiceSetingModelImplCopyWith<_$ServiceSetingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageGetModel _$MessageGetModelFromJson(Map<String, dynamic> json) {
  return _MessageGetModel.fromJson(json);
}

/// @nodoc
mixin _$MessageGetModel {
  bool? get serviceMsgSwitch => throw _privateConstructorUsedError;
  bool? get systemMsgSwitch => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageGetModelCopyWith<MessageGetModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageGetModelCopyWith<$Res> {
  factory $MessageGetModelCopyWith(
          MessageGetModel value, $Res Function(MessageGetModel) then) =
      _$MessageGetModelCopyWithImpl<$Res, MessageGetModel>;
  @useResult
  $Res call({bool? serviceMsgSwitch, bool? systemMsgSwitch});
}

/// @nodoc
class _$MessageGetModelCopyWithImpl<$Res, $Val extends MessageGetModel>
    implements $MessageGetModelCopyWith<$Res> {
  _$MessageGetModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceMsgSwitch = freezed,
    Object? systemMsgSwitch = freezed,
  }) {
    return _then(_value.copyWith(
      serviceMsgSwitch: freezed == serviceMsgSwitch
          ? _value.serviceMsgSwitch
          : serviceMsgSwitch // ignore: cast_nullable_to_non_nullable
              as bool?,
      systemMsgSwitch: freezed == systemMsgSwitch
          ? _value.systemMsgSwitch
          : systemMsgSwitch // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageGetModelImplCopyWith<$Res>
    implements $MessageGetModelCopyWith<$Res> {
  factory _$$MessageGetModelImplCopyWith(_$MessageGetModelImpl value,
          $Res Function(_$MessageGetModelImpl) then) =
      __$$MessageGetModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? serviceMsgSwitch, bool? systemMsgSwitch});
}

/// @nodoc
class __$$MessageGetModelImplCopyWithImpl<$Res>
    extends _$MessageGetModelCopyWithImpl<$Res, _$MessageGetModelImpl>
    implements _$$MessageGetModelImplCopyWith<$Res> {
  __$$MessageGetModelImplCopyWithImpl(
      _$MessageGetModelImpl _value, $Res Function(_$MessageGetModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceMsgSwitch = freezed,
    Object? systemMsgSwitch = freezed,
  }) {
    return _then(_$MessageGetModelImpl(
      serviceMsgSwitch: freezed == serviceMsgSwitch
          ? _value.serviceMsgSwitch
          : serviceMsgSwitch // ignore: cast_nullable_to_non_nullable
              as bool?,
      systemMsgSwitch: freezed == systemMsgSwitch
          ? _value.systemMsgSwitch
          : systemMsgSwitch // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageGetModelImpl implements _MessageGetModel {
  _$MessageGetModelImpl({this.serviceMsgSwitch, this.systemMsgSwitch});

  factory _$MessageGetModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageGetModelImplFromJson(json);

  @override
  final bool? serviceMsgSwitch;
  @override
  final bool? systemMsgSwitch;

  @override
  String toString() {
    return 'MessageGetModel(serviceMsgSwitch: $serviceMsgSwitch, systemMsgSwitch: $systemMsgSwitch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageGetModelImpl &&
            (identical(other.serviceMsgSwitch, serviceMsgSwitch) ||
                other.serviceMsgSwitch == serviceMsgSwitch) &&
            (identical(other.systemMsgSwitch, systemMsgSwitch) ||
                other.systemMsgSwitch == systemMsgSwitch));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, serviceMsgSwitch, systemMsgSwitch);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageGetModelImplCopyWith<_$MessageGetModelImpl> get copyWith =>
      __$$MessageGetModelImplCopyWithImpl<_$MessageGetModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageGetModelImplToJson(
      this,
    );
  }
}

abstract class _MessageGetModel implements MessageGetModel {
  factory _MessageGetModel(
      {final bool? serviceMsgSwitch,
      final bool? systemMsgSwitch}) = _$MessageGetModelImpl;

  factory _MessageGetModel.fromJson(Map<String, dynamic> json) =
      _$MessageGetModelImpl.fromJson;

  @override
  bool? get serviceMsgSwitch;
  @override
  bool? get systemMsgSwitch;
  @override
  @JsonKey(ignore: true)
  _$$MessageGetModelImplCopyWith<_$MessageGetModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageSetModel _$MessageSetModelFromJson(Map<String, dynamic> json) {
  return _MessageSetModel.fromJson(json);
}

/// @nodoc
mixin _$MessageSetModel {
  bool get msgSwitch => throw _privateConstructorUsedError;
  String get msgType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageSetModelCopyWith<MessageSetModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageSetModelCopyWith<$Res> {
  factory $MessageSetModelCopyWith(
          MessageSetModel value, $Res Function(MessageSetModel) then) =
      _$MessageSetModelCopyWithImpl<$Res, MessageSetModel>;
  @useResult
  $Res call({bool msgSwitch, String msgType});
}

/// @nodoc
class _$MessageSetModelCopyWithImpl<$Res, $Val extends MessageSetModel>
    implements $MessageSetModelCopyWith<$Res> {
  _$MessageSetModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? msgSwitch = null,
    Object? msgType = null,
  }) {
    return _then(_value.copyWith(
      msgSwitch: null == msgSwitch
          ? _value.msgSwitch
          : msgSwitch // ignore: cast_nullable_to_non_nullable
              as bool,
      msgType: null == msgType
          ? _value.msgType
          : msgType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageSetModelImplCopyWith<$Res>
    implements $MessageSetModelCopyWith<$Res> {
  factory _$$MessageSetModelImplCopyWith(_$MessageSetModelImpl value,
          $Res Function(_$MessageSetModelImpl) then) =
      __$$MessageSetModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool msgSwitch, String msgType});
}

/// @nodoc
class __$$MessageSetModelImplCopyWithImpl<$Res>
    extends _$MessageSetModelCopyWithImpl<$Res, _$MessageSetModelImpl>
    implements _$$MessageSetModelImplCopyWith<$Res> {
  __$$MessageSetModelImplCopyWithImpl(
      _$MessageSetModelImpl _value, $Res Function(_$MessageSetModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? msgSwitch = null,
    Object? msgType = null,
  }) {
    return _then(_$MessageSetModelImpl(
      msgSwitch: null == msgSwitch
          ? _value.msgSwitch
          : msgSwitch // ignore: cast_nullable_to_non_nullable
              as bool,
      msgType: null == msgType
          ? _value.msgType
          : msgType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageSetModelImpl implements _MessageSetModel {
  _$MessageSetModelImpl({required this.msgSwitch, required this.msgType});

  factory _$MessageSetModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageSetModelImplFromJson(json);

  @override
  final bool msgSwitch;
  @override
  final String msgType;

  @override
  String toString() {
    return 'MessageSetModel(msgSwitch: $msgSwitch, msgType: $msgType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageSetModelImpl &&
            (identical(other.msgSwitch, msgSwitch) ||
                other.msgSwitch == msgSwitch) &&
            (identical(other.msgType, msgType) || other.msgType == msgType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, msgSwitch, msgType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageSetModelImplCopyWith<_$MessageSetModelImpl> get copyWith =>
      __$$MessageSetModelImplCopyWithImpl<_$MessageSetModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageSetModelImplToJson(
      this,
    );
  }
}

abstract class _MessageSetModel implements MessageSetModel {
  factory _MessageSetModel(
      {required final bool msgSwitch,
      required final String msgType}) = _$MessageSetModelImpl;

  factory _MessageSetModel.fromJson(Map<String, dynamic> json) =
      _$MessageSetModelImpl.fromJson;

  @override
  bool get msgSwitch;
  @override
  String get msgType;
  @override
  @JsonKey(ignore: true)
  _$$MessageSetModelImplCopyWith<_$MessageSetModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageSettingModel _$MessageSettingModelFromJson(Map<String, dynamic> json) {
  return _MessageSettingModel.fromJson(json);
}

/// @nodoc
mixin _$MessageSettingModel {
  bool? get devNotify => throw _privateConstructorUsedError;
  bool? get devShare => throw _privateConstructorUsedError;
  List<DeviceItemModel>? get devices => throw _privateConstructorUsedError;
  bool? get homeShare => throw _privateConstructorUsedError;
  bool? get noDisturb => throw _privateConstructorUsedError;
  int? get noDisturbFrom => throw _privateConstructorUsedError;
  int? get noDisturbTo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageSettingModelCopyWith<MessageSettingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageSettingModelCopyWith<$Res> {
  factory $MessageSettingModelCopyWith(
          MessageSettingModel value, $Res Function(MessageSettingModel) then) =
      _$MessageSettingModelCopyWithImpl<$Res, MessageSettingModel>;
  @useResult
  $Res call(
      {bool? devNotify,
      bool? devShare,
      List<DeviceItemModel>? devices,
      bool? homeShare,
      bool? noDisturb,
      int? noDisturbFrom,
      int? noDisturbTo});
}

/// @nodoc
class _$MessageSettingModelCopyWithImpl<$Res, $Val extends MessageSettingModel>
    implements $MessageSettingModelCopyWith<$Res> {
  _$MessageSettingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devNotify = freezed,
    Object? devShare = freezed,
    Object? devices = freezed,
    Object? homeShare = freezed,
    Object? noDisturb = freezed,
    Object? noDisturbFrom = freezed,
    Object? noDisturbTo = freezed,
  }) {
    return _then(_value.copyWith(
      devNotify: freezed == devNotify
          ? _value.devNotify
          : devNotify // ignore: cast_nullable_to_non_nullable
              as bool?,
      devShare: freezed == devShare
          ? _value.devShare
          : devShare // ignore: cast_nullable_to_non_nullable
              as bool?,
      devices: freezed == devices
          ? _value.devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<DeviceItemModel>?,
      homeShare: freezed == homeShare
          ? _value.homeShare
          : homeShare // ignore: cast_nullable_to_non_nullable
              as bool?,
      noDisturb: freezed == noDisturb
          ? _value.noDisturb
          : noDisturb // ignore: cast_nullable_to_non_nullable
              as bool?,
      noDisturbFrom: freezed == noDisturbFrom
          ? _value.noDisturbFrom
          : noDisturbFrom // ignore: cast_nullable_to_non_nullable
              as int?,
      noDisturbTo: freezed == noDisturbTo
          ? _value.noDisturbTo
          : noDisturbTo // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageSettingModelImplCopyWith<$Res>
    implements $MessageSettingModelCopyWith<$Res> {
  factory _$$MessageSettingModelImplCopyWith(_$MessageSettingModelImpl value,
          $Res Function(_$MessageSettingModelImpl) then) =
      __$$MessageSettingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? devNotify,
      bool? devShare,
      List<DeviceItemModel>? devices,
      bool? homeShare,
      bool? noDisturb,
      int? noDisturbFrom,
      int? noDisturbTo});
}

/// @nodoc
class __$$MessageSettingModelImplCopyWithImpl<$Res>
    extends _$MessageSettingModelCopyWithImpl<$Res, _$MessageSettingModelImpl>
    implements _$$MessageSettingModelImplCopyWith<$Res> {
  __$$MessageSettingModelImplCopyWithImpl(_$MessageSettingModelImpl _value,
      $Res Function(_$MessageSettingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devNotify = freezed,
    Object? devShare = freezed,
    Object? devices = freezed,
    Object? homeShare = freezed,
    Object? noDisturb = freezed,
    Object? noDisturbFrom = freezed,
    Object? noDisturbTo = freezed,
  }) {
    return _then(_$MessageSettingModelImpl(
      devNotify: freezed == devNotify
          ? _value.devNotify
          : devNotify // ignore: cast_nullable_to_non_nullable
              as bool?,
      devShare: freezed == devShare
          ? _value.devShare
          : devShare // ignore: cast_nullable_to_non_nullable
              as bool?,
      devices: freezed == devices
          ? _value._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<DeviceItemModel>?,
      homeShare: freezed == homeShare
          ? _value.homeShare
          : homeShare // ignore: cast_nullable_to_non_nullable
              as bool?,
      noDisturb: freezed == noDisturb
          ? _value.noDisturb
          : noDisturb // ignore: cast_nullable_to_non_nullable
              as bool?,
      noDisturbFrom: freezed == noDisturbFrom
          ? _value.noDisturbFrom
          : noDisturbFrom // ignore: cast_nullable_to_non_nullable
              as int?,
      noDisturbTo: freezed == noDisturbTo
          ? _value.noDisturbTo
          : noDisturbTo // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageSettingModelImpl implements _MessageSettingModel {
  _$MessageSettingModelImpl(
      {this.devNotify,
      this.devShare,
      final List<DeviceItemModel>? devices,
      this.homeShare,
      this.noDisturb,
      this.noDisturbFrom,
      this.noDisturbTo})
      : _devices = devices;

  factory _$MessageSettingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageSettingModelImplFromJson(json);

  @override
  final bool? devNotify;
  @override
  final bool? devShare;
  final List<DeviceItemModel>? _devices;
  @override
  List<DeviceItemModel>? get devices {
    final value = _devices;
    if (value == null) return null;
    if (_devices is EqualUnmodifiableListView) return _devices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? homeShare;
  @override
  final bool? noDisturb;
  @override
  final int? noDisturbFrom;
  @override
  final int? noDisturbTo;

  @override
  String toString() {
    return 'MessageSettingModel(devNotify: $devNotify, devShare: $devShare, devices: $devices, homeShare: $homeShare, noDisturb: $noDisturb, noDisturbFrom: $noDisturbFrom, noDisturbTo: $noDisturbTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageSettingModelImpl &&
            (identical(other.devNotify, devNotify) ||
                other.devNotify == devNotify) &&
            (identical(other.devShare, devShare) ||
                other.devShare == devShare) &&
            const DeepCollectionEquality().equals(other._devices, _devices) &&
            (identical(other.homeShare, homeShare) ||
                other.homeShare == homeShare) &&
            (identical(other.noDisturb, noDisturb) ||
                other.noDisturb == noDisturb) &&
            (identical(other.noDisturbFrom, noDisturbFrom) ||
                other.noDisturbFrom == noDisturbFrom) &&
            (identical(other.noDisturbTo, noDisturbTo) ||
                other.noDisturbTo == noDisturbTo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      devNotify,
      devShare,
      const DeepCollectionEquality().hash(_devices),
      homeShare,
      noDisturb,
      noDisturbFrom,
      noDisturbTo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageSettingModelImplCopyWith<_$MessageSettingModelImpl> get copyWith =>
      __$$MessageSettingModelImplCopyWithImpl<_$MessageSettingModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageSettingModelImplToJson(
      this,
    );
  }
}

abstract class _MessageSettingModel implements MessageSettingModel {
  factory _MessageSettingModel(
      {final bool? devNotify,
      final bool? devShare,
      final List<DeviceItemModel>? devices,
      final bool? homeShare,
      final bool? noDisturb,
      final int? noDisturbFrom,
      final int? noDisturbTo}) = _$MessageSettingModelImpl;

  factory _MessageSettingModel.fromJson(Map<String, dynamic> json) =
      _$MessageSettingModelImpl.fromJson;

  @override
  bool? get devNotify;
  @override
  bool? get devShare;
  @override
  List<DeviceItemModel>? get devices;
  @override
  bool? get homeShare;
  @override
  bool? get noDisturb;
  @override
  int? get noDisturbFrom;
  @override
  int? get noDisturbTo;
  @override
  @JsonKey(ignore: true)
  _$$MessageSettingModelImplCopyWith<_$MessageSettingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceItemModel _$DeviceItemModelFromJson(Map<String, dynamic> json) {
  return _DeviceModel.fromJson(json);
}

/// @nodoc
mixin _$DeviceItemModel {
  int? get deviceId => throw _privateConstructorUsedError;
  String? get deviceName => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  bool? get notify => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;
  int? get share => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceItemModelCopyWith<DeviceItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceItemModelCopyWith<$Res> {
  factory $DeviceItemModelCopyWith(
          DeviceItemModel value, $Res Function(DeviceItemModel) then) =
      _$DeviceItemModelCopyWithImpl<$Res, DeviceItemModel>;
  @useResult
  $Res call(
      {int? deviceId,
      String? deviceName,
      String? icon,
      String? model,
      bool? notify,
      String? region,
      int? share});
}

/// @nodoc
class _$DeviceItemModelCopyWithImpl<$Res, $Val extends DeviceItemModel>
    implements $DeviceItemModelCopyWith<$Res> {
  _$DeviceItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = freezed,
    Object? deviceName = freezed,
    Object? icon = freezed,
    Object? model = freezed,
    Object? notify = freezed,
    Object? region = freezed,
    Object? share = freezed,
  }) {
    return _then(_value.copyWith(
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as int?,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      notify: freezed == notify
          ? _value.notify
          : notify // ignore: cast_nullable_to_non_nullable
              as bool?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      share: freezed == share
          ? _value.share
          : share // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceModelImplCopyWith<$Res>
    implements $DeviceItemModelCopyWith<$Res> {
  factory _$$DeviceModelImplCopyWith(
          _$DeviceModelImpl value, $Res Function(_$DeviceModelImpl) then) =
      __$$DeviceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? deviceId,
      String? deviceName,
      String? icon,
      String? model,
      bool? notify,
      String? region,
      int? share});
}

/// @nodoc
class __$$DeviceModelImplCopyWithImpl<$Res>
    extends _$DeviceItemModelCopyWithImpl<$Res, _$DeviceModelImpl>
    implements _$$DeviceModelImplCopyWith<$Res> {
  __$$DeviceModelImplCopyWithImpl(
      _$DeviceModelImpl _value, $Res Function(_$DeviceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = freezed,
    Object? deviceName = freezed,
    Object? icon = freezed,
    Object? model = freezed,
    Object? notify = freezed,
    Object? region = freezed,
    Object? share = freezed,
  }) {
    return _then(_$DeviceModelImpl(
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as int?,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      notify: freezed == notify
          ? _value.notify
          : notify // ignore: cast_nullable_to_non_nullable
              as bool?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      share: freezed == share
          ? _value.share
          : share // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceModelImpl implements _DeviceModel {
  const _$DeviceModelImpl(
      {this.deviceId,
      this.deviceName,
      this.icon,
      this.model,
      this.notify,
      this.region,
      this.share});

  factory _$DeviceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceModelImplFromJson(json);

  @override
  final int? deviceId;
  @override
  final String? deviceName;
  @override
  final String? icon;
  @override
  final String? model;
  @override
  final bool? notify;
  @override
  final String? region;
  @override
  final int? share;

  @override
  String toString() {
    return 'DeviceItemModel(deviceId: $deviceId, deviceName: $deviceName, icon: $icon, model: $model, notify: $notify, region: $region, share: $share)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceModelImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.notify, notify) || other.notify == notify) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.share, share) || other.share == share));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, deviceId, deviceName, icon, model, notify, region, share);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceModelImplCopyWith<_$DeviceModelImpl> get copyWith =>
      __$$DeviceModelImplCopyWithImpl<_$DeviceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceModelImplToJson(
      this,
    );
  }
}

abstract class _DeviceModel implements DeviceItemModel {
  const factory _DeviceModel(
      {final int? deviceId,
      final String? deviceName,
      final String? icon,
      final String? model,
      final bool? notify,
      final String? region,
      final int? share}) = _$DeviceModelImpl;

  factory _DeviceModel.fromJson(Map<String, dynamic> json) =
      _$DeviceModelImpl.fromJson;

  @override
  int? get deviceId;
  @override
  String? get deviceName;
  @override
  String? get icon;
  @override
  String? get model;
  @override
  bool? get notify;
  @override
  String? get region;
  @override
  int? get share;
  @override
  @JsonKey(ignore: true)
  _$$DeviceModelImplCopyWith<_$DeviceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
