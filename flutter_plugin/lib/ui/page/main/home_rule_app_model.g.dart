// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_rule_app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeRuleAppModelImpl _$$HomeRuleAppModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeRuleAppModelImpl(
      appButtomRuleMova: json['appButtomRule_mova'] == null
          ? null
          : HomeRuleAppButtomRuleMova.fromJson(
              json['appButtomRule_mova'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$HomeRuleAppModelImplToJson(
        _$HomeRuleAppModelImpl instance) =>
    <String, dynamic>{
      'appButtomRule_mova': instance.appButtomRuleMova,
    };

_$HomeRuleAppButtomRuleMovaImpl _$$HomeRuleAppButtomRuleMovaImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeRuleAppButtomRuleMovaImpl(
      tabList: (json['tabList'] as List<dynamic>?)
              ?.map(
                  (e) => HomeRuleAppTabItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      defaultIndex: (json['defaultIndex'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HomeRuleAppButtomRuleMovaImplToJson(
        _$HomeRuleAppButtomRuleMovaImpl instance) =>
    <String, dynamic>{
      'tabList': instance.tabList,
      'defaultIndex': instance.defaultIndex,
    };

_$HomeRuleAppTabItemImpl _$$HomeRuleAppTabItemImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeRuleAppTabItemImpl(
      path: json['path'] as String? ?? '',
      badge: json['badge'] == null
          ? null
          : HomeRuleAppBadge.fromJson(json['badge'] as Map<String, dynamic>),
      index: (json['index'] as num?)?.toInt() ?? 0,
      tabType: json['tabType'] as String? ?? '',
      style: HomeRuleAppStyle.fromJson(json['style'] as Map<String, dynamic>),
      params: json['params'] == null
          ? null
          : HomeRuleAppParams.fromJson(json['params'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$HomeRuleAppTabItemImplToJson(
        _$HomeRuleAppTabItemImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'badge': instance.badge,
      'index': instance.index,
      'tabType': instance.tabType,
      'style': instance.style,
      'params': instance.params,
    };

_$HomeRuleAppBadgeImpl _$$HomeRuleAppBadgeImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeRuleAppBadgeImpl(
      bgColor: json['bgColor'] as String?,
      dot: json['dot'] as bool?,
      text: json['text'] as String?,
      textColor: json['textColor'] as String?,
    );

Map<String, dynamic> _$$HomeRuleAppBadgeImplToJson(
        _$HomeRuleAppBadgeImpl instance) =>
    <String, dynamic>{
      'bgColor': instance.bgColor,
      'dot': instance.dot,
      'text': instance.text,
      'textColor': instance.textColor,
    };

_$HomeRuleAppStyleImpl _$$HomeRuleAppStyleImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeRuleAppStyleImpl(
      normal: json['normal'] == null
          ? null
          : HomeRuleAppStyleItem.fromJson(
              json['normal'] as Map<String, dynamic>),
      lottie: json['lottie'] as String?,
      selected: json['selected'] == null
          ? null
          : HomeRuleAppStyleItem.fromJson(
              json['selected'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$HomeRuleAppStyleImplToJson(
        _$HomeRuleAppStyleImpl instance) =>
    <String, dynamic>{
      'normal': instance.normal,
      'lottie': instance.lottie,
      'selected': instance.selected,
    };

_$HomeRuleAppParamsImpl _$$HomeRuleAppParamsImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeRuleAppParamsImpl(
      params2: json['params2'] as String?,
      params1: json['params1'] as String?,
    );

Map<String, dynamic> _$$HomeRuleAppParamsImplToJson(
        _$HomeRuleAppParamsImpl instance) =>
    <String, dynamic>{
      'params2': instance.params2,
      'params1': instance.params1,
    };

_$HomeRuleAppStyleItemImpl _$$HomeRuleAppStyleItemImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeRuleAppStyleItemImpl(
      icon: json['icon'] as String?,
      dark_icon: json['dark_icon'] as String?,
      text: json['text'] as String? ?? '',
      textColor: json['textColor'] as String? ?? '#000000',
    );

Map<String, dynamic> _$$HomeRuleAppStyleItemImplToJson(
        _$HomeRuleAppStyleItemImpl instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'dark_icon': instance.dark_icon,
      'text': instance.text,
      'textColor': instance.textColor,
    };
