import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'privacy_res.g.dart';

@JsonSerializable(explicitToJson: true)
class PrivacyUpgradeRes {
  List<PrivacyListBean> privacyList;
  PrivacyUpgradeRes({
    required this.privacyList,
  });

  factory PrivacyUpgradeRes.fromJson(Map<String, dynamic> json) =>
      _$PrivacyUpgradeResFromJson(json);

  Map<String, dynamic> toJson() => _$PrivacyUpgradeResToJson(this);
}

/// @property version 版本号
/// @property model 通过model，type，tag，lang从富文本接口点击调用跳转
/// @property type  版本id_版本号_类型（用户协议1 隐私政策2）1：用户协议 2：隐私政策
/// @property tag  XXXXXX_1_1   XXXXXX_1_2 通过主键id，verion，type组合
/// @property changelog 更新日志
/// @property lang 富文本配置的语言（中国大陆地区：默认中文，可切换英语 海外地区：默认英语，可切换其他小语种）
/// @property langs 支持的语言
/// @property url 前端协议url拼参数
///
@JsonSerializable()
class PrivacyListBean {
  int version;
  String model;
  String type;
  String tag;
  String changelog;
  String lang;
  List<String> langs;
  String url;

  PrivacyListBean({
    required this.version,
    required this.model,
    required this.type,
    required this.tag,
    required this.changelog,
    required this.lang,
    required this.langs,
    required this.url,
  });

  factory PrivacyListBean.fromJson(Map<String, dynamic> json) =>
      _$PrivacyListBeanFromJson(json);

  Map<String, dynamic> toJson() => _$PrivacyListBeanToJson(this);
}

/// 隐私Bean
@JsonSerializable()
class PrivacyInfoBean {
  /// 隐私
  int privacyVersion;
  String? privacyChangelog;
  String privacyUrl;

  /// 用户协议
  int agreementVersion;
  String? agreementChangelog;
  String agreementUrl;
  String? countryCode;

  static PrivacyInfoBean create() {
    return PrivacyInfoBean(
        privacyVersion: -1,
        privacyChangelog: '',
        privacyUrl: '',
        agreementVersion: -1,
        agreementChangelog: '',
        agreementUrl: '',
        countryCode: '');
  }

  /// 判断对象是否有效
  bool isValid() {
    return privacyVersion != -1 &&
        agreementVersion != -1 &&
        privacyUrl != '' &&
        agreementUrl != '';
  }

  PrivacyInfoBean(
      {required this.privacyVersion,
      required this.privacyChangelog,
      required this.privacyUrl,

      /// 用户协议
      required this.agreementVersion,
      required this.agreementChangelog,
      required this.agreementUrl,
      required this.countryCode});

  factory PrivacyInfoBean.fromJson(Map<String, dynamic> json) =>
      _$PrivacyInfoBeanFromJson(json);

  Map<String, dynamic> toJson() => _$PrivacyInfoBeanToJson(this);
}
