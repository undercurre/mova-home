import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggest_report_param.freezed.dart';
part 'suggest_report_param.g.dart';

@freezed
class SuggestReportParam with _$SuggestReportParam {
  factory SuggestReportParam({
    @Default('') String appVersion,
    @Default('') String appVersionName,
    String? title,
    String? content,
    String? contact,
    @Default(0) int type,
    @Default(0) int os,
    @Default(0) int adviseType,
    @Default('') String did,
    @Default('') String model,
    @Default('') String plugin,
    String? adviseTagIds,
    List<String>? images,
    List<String>? videos,
  }) = _SuggestReportParam;

  factory SuggestReportParam.fromJson(Map<String, dynamic> json) =>
      _$SuggestReportParamFromJson(json);
}
