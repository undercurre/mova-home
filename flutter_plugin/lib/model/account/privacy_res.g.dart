// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacyUpgradeRes _$PrivacyUpgradeResFromJson(Map<String, dynamic> json) =>
    PrivacyUpgradeRes(
      privacyList: (json['privacyList'] as List<dynamic>)
          .map((e) => PrivacyListBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrivacyUpgradeResToJson(PrivacyUpgradeRes instance) =>
    <String, dynamic>{
      'privacyList': instance.privacyList.map((e) => e.toJson()).toList(),
    };

PrivacyListBean _$PrivacyListBeanFromJson(Map<String, dynamic> json) =>
    PrivacyListBean(
      version: (json['version'] as num).toInt(),
      model: json['model'] as String,
      type: json['type'] as String,
      tag: json['tag'] as String,
      changelog: json['changelog'] as String,
      lang: json['lang'] as String,
      langs: (json['langs'] as List<dynamic>).map((e) => e as String).toList(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$PrivacyListBeanToJson(PrivacyListBean instance) =>
    <String, dynamic>{
      'version': instance.version,
      'model': instance.model,
      'type': instance.type,
      'tag': instance.tag,
      'changelog': instance.changelog,
      'lang': instance.lang,
      'langs': instance.langs,
      'url': instance.url,
    };

PrivacyInfoBean _$PrivacyInfoBeanFromJson(Map<String, dynamic> json) =>
    PrivacyInfoBean(
      privacyVersion: (json['privacyVersion'] as num).toInt(),
      privacyChangelog: json['privacyChangelog'] as String?,
      privacyUrl: json['privacyUrl'] as String,
      agreementVersion: (json['agreementVersion'] as num).toInt(),
      agreementChangelog: json['agreementChangelog'] as String?,
      agreementUrl: json['agreementUrl'] as String,
      countryCode: json['countryCode'] as String?,
    );

Map<String, dynamic> _$PrivacyInfoBeanToJson(PrivacyInfoBean instance) =>
    <String, dynamic>{
      'privacyVersion': instance.privacyVersion,
      'privacyChangelog': instance.privacyChangelog,
      'privacyUrl': instance.privacyUrl,
      'agreementVersion': instance.agreementVersion,
      'agreementChangelog': instance.agreementChangelog,
      'agreementUrl': instance.agreementUrl,
      'countryCode': instance.countryCode,
    };
