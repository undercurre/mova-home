// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_setting_model.g.dart';
part 'message_setting_model.freezed.dart';

typedef OnValueCallback = void Function(bool value);

enum MessageSettingType {
  MessageSettingNone,
  MessageSettingTypeSystem,
  MessageSettingTypeShare,
  MessageSettingTypeService
}

@unfreezed
class ServiceSetingModel with _$ServiceSetingModel {
  factory ServiceSetingModel({
    @Default('') String title,
    @Default('') String subTitle,
    @Default(false) bool value,
    @Default(MessageSettingType.MessageSettingNone) MessageSettingType type,
  }) = _ServiceSetingModel;
}

/// 网络数据模型
@freezed
class MessageGetModel with _$MessageGetModel {
  factory MessageGetModel({
    bool? serviceMsgSwitch,
    bool? systemMsgSwitch,
  }) = _MessageGetModel;

  factory MessageGetModel.fromJson(Map<String, dynamic> json) =>
      _$MessageGetModelFromJson(json);
}

@freezed
class MessageSetModel with _$MessageSetModel {
  factory MessageSetModel({
    required bool msgSwitch,
    required String msgType,
  }) = _MessageSetModel;

  factory MessageSetModel.fromJson(Map<String, dynamic> json) =>
      _$MessageSetModelFromJson(json);
}

@freezed
class MessageSettingModel with _$MessageSettingModel {
  factory MessageSettingModel({
    bool? devNotify,
    bool? devShare,
    List<DeviceItemModel>? devices,
    bool? homeShare,
    bool? noDisturb,
    int? noDisturbFrom,
    int? noDisturbTo,
  }) = _MessageSettingModel;

  factory MessageSettingModel.fromJson(Map<String, dynamic> json) =>
      _$MessageSettingModelFromJson(json);
}

@freezed
class DeviceItemModel with _$DeviceItemModel {
  const factory DeviceItemModel({
    int? deviceId,
    String? deviceName,
    String? icon,
    String? model,
    bool? notify,
    String? region,
    int? share,
  }) = _DeviceModel;

  factory DeviceItemModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceItemModelFromJson(json);
}
