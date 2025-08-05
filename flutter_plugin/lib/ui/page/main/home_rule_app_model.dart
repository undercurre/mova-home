import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_rule_app_model.freezed.dart';
part 'home_rule_app_model.g.dart';

@freezed
class HomeRuleAppModel with _$HomeRuleAppModel {
  const factory HomeRuleAppModel({
    @JsonKey(name: 'appButtomRule_mova') // 指定JSON中的字段名
    HomeRuleAppButtomRuleMova? appButtomRuleMova,
  }) = _HomeRuleAppModel;

  factory HomeRuleAppModel.fromJson(Map<String, dynamic> json) =>
      _$HomeRuleAppModelFromJson(json);
}

@freezed
class HomeRuleAppButtomRuleMova with _$HomeRuleAppButtomRuleMova {
  const factory HomeRuleAppButtomRuleMova({
    @Default([]) List<HomeRuleAppTabItem> tabList,
    @Default(0) int defaultIndex,
  }) = _HomeRuleAppButtomRuleMova;

  factory HomeRuleAppButtomRuleMova.fromJson(Map<String, dynamic> json) =>
      _$HomeRuleAppButtomRuleMovaFromJson(json);
}

@freezed
class HomeRuleAppTabItem with _$HomeRuleAppTabItem {
  const factory HomeRuleAppTabItem({
    @Default('') String path,
    HomeRuleAppBadge? badge,
    @Default(0) int index,
    @Default('') String tabType,
    required HomeRuleAppStyle style,
    HomeRuleAppParams? params,
  }) = _HomeRuleAppTabItem;

  factory HomeRuleAppTabItem.fromJson(Map<String, dynamic> json) =>
      _$HomeRuleAppTabItemFromJson(json);
}

@freezed
class HomeRuleAppBadge with _$HomeRuleAppBadge {
  const factory HomeRuleAppBadge({
    String? bgColor,
    bool? dot,
    String? text,
    String? textColor,
  }) = _HomeRuleAppBadge;

  factory HomeRuleAppBadge.fromJson(Map<String, dynamic> json) =>
      _$HomeRuleAppBadgeFromJson(json);
}

@freezed
class HomeRuleAppStyle with _$HomeRuleAppStyle {
  const factory HomeRuleAppStyle({
    HomeRuleAppStyleItem? normal,
    String? lottie,
    HomeRuleAppStyleItem? selected,
  }) = _HomeRuleAppStyle;

  factory HomeRuleAppStyle.fromJson(Map<String, dynamic> json) =>
      _$HomeRuleAppStyleFromJson(json);
}

@freezed
class HomeRuleAppParams with _$HomeRuleAppParams {
  const factory HomeRuleAppParams({
    String? params2,
    String? params1,
  }) = _HomeRuleAppParams;

  factory HomeRuleAppParams.fromJson(Map<String, dynamic> json) =>
      _$HomeRuleAppParamsFromJson(json);
}

@freezed
class HomeRuleAppStyleItem with _$HomeRuleAppStyleItem {
  const factory HomeRuleAppStyleItem({
    String? icon,
    String? dark_icon,
    @Default('') String text,
    @Default('#000000') String textColor,
  }) = _HomeRuleAppStyleItem;

  factory HomeRuleAppStyleItem.fromJson(Map<String, dynamic> json) =>
      _$HomeRuleAppStyleItemFromJson(json);
}
