import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rn_version_model.freezed.dart';
part 'rn_version_model.g.dart';

@freezed
class RNVersionModel with _$RNVersionModel {
  const factory RNVersionModel({
    String? url,
    int? version,
    String? extensionId,
    String? md5,
    String? resPackageId,
    int? resPackageVersion,
    String? resPackageUrl,
    String? resPackageZipMd5,
    // 复制于公共扩展程序的ID
    String? sourceCommonExtensionId,
    // 复制于公共插件的ID
    String? sourceCommonPluginId,
    // 复制于公共插件的版本
    int? sourceCommonPluginVer,
  }) = _RNVersionModel;

  factory RNVersionModel.fromJson(Map<String, Object?> json) =>
      _$RNVersionModelFromJson(json);
}
