import 'package:freezed_annotation/freezed_annotation.dart';
part 'app_dynamic_resource.freezed.dart';
part 'app_dynamic_resource.g.dart';

@freezed
class AppDynamicResource with _$AppDynamicResource {
  const factory AppDynamicResource({
    @Default(0) int startDate,
    @Default(0) int endDate,
    @Default('') String appLaunch,
    @Default('') String addDeviceBg,
    @Default('') String appLaunchType,
    @Default('') String addDeviceBgType,
    @Default('') String addDeviceBgCover,
    @Default(false) bool isExpired,
  }) = _AppDynamicResource;

  factory AppDynamicResource.fromJson(Map<String, dynamic> json) =>
      _$AppDynamicResourceFromJson(json);
}
