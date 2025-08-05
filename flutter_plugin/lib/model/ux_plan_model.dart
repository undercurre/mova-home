import 'package:freezed_annotation/freezed_annotation.dart';

part 'ux_plan_model.freezed.dart';
part 'ux_plan_model.g.dart';

@freezed
class UXPlanModel with _$UXPlanModel {
  const factory UXPlanModel({String? uid, int? value}) = _UXPlanModel;

  factory UXPlanModel.fromJson(Map<String, Object?> json) =>
      _$UXPlanModelFromJson(json);
}
