import 'package:freezed_annotation/freezed_annotation.dart';

part 'rn_debug_packages.freezed.dart';
part 'rn_debug_packages.g.dart';

@unfreezed
class RNDebugPackages with _$RNDebugPackages {
  factory RNDebugPackages({
    @Default('') String ip,
    @Default(false) bool enable,
    List<Projects>? projects,
  }) = _RNDebugPackages;

  factory RNDebugPackages.fromJson(Map<String, dynamic> json) =>
      _$RNDebugPackagesFromJson(json);
}

@unfreezed
class Projects with _$Projects {
  factory Projects({
    String? packageName,
    String? model,
    int? id,
    @Default(false) bool? selected,
  }) = _Projects;

  factory Projects.fromJson(Map<String, dynamic> json) =>
      _$ProjectsFromJson(json);
}
