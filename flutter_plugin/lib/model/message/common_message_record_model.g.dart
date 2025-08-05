// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_message_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommonMsgRecordExtImpl _$$CommonMsgRecordExtImplFromJson(
        Map<String, dynamic> json) =>
    _$CommonMsgRecordExtImpl(
      goods_name: json['goods_name'] as String?,
      goods_num: json['goods_num'] as String?,
      link_url: json['link_url'] as String?,
    );

Map<String, dynamic> _$$CommonMsgRecordExtImplToJson(
        _$CommonMsgRecordExtImpl instance) =>
    <String, dynamic>{
      'goods_name': instance.goods_name,
      'goods_num': instance.goods_num,
      'link_url': instance.link_url,
    };

_$CommonMsgRecordDisplayImpl _$$CommonMsgRecordDisplayImplFromJson(
        Map<String, dynamic> json) =>
    _$CommonMsgRecordDisplayImpl(
      lang: json['lang'] as String?,
      content: json['content'] as String?,
      link: json['link'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$CommonMsgRecordDisplayImplToJson(
        _$CommonMsgRecordDisplayImpl instance) =>
    <String, dynamic>{
      'lang': instance.lang,
      'content': instance.content,
      'link': instance.link,
      'name': instance.name,
    };

_$CommonMsgRecordImpl _$$CommonMsgRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$CommonMsgRecordImpl(
      id: json['id'] as String?,
      multiLangDisplay: json['multiLangDisplay'] as String?,
      msgCategory: json['msgCategory'] as String?,
      jumpType: json['jumpType'] as String?,
      readStatus: (json['readStatus'] as num?)?.toInt(),
      readTime: json['readTime'] as String?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
      ext: json['ext'] as String?,
      extBean: json['extBean'] == null
          ? null
          : CommonMsgRecordExt.fromJson(
              json['extBean'] as Map<String, dynamic>),
      display: json['display'] == null
          ? null
          : CommonMsgRecordDisplay.fromJson(
              json['display'] as Map<String, dynamic>),
      imgUrl: json['imgUrl'] as String?,
    );

Map<String, dynamic> _$$CommonMsgRecordImplToJson(
        _$CommonMsgRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'multiLangDisplay': instance.multiLangDisplay,
      'msgCategory': instance.msgCategory,
      'jumpType': instance.jumpType,
      'readStatus': instance.readStatus,
      'readTime': instance.readTime,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'ext': instance.ext,
      'extBean': instance.extBean,
      'display': instance.display,
      'imgUrl': instance.imgUrl,
    };

_$CommonMsgRecordResImpl _$$CommonMsgRecordResImplFromJson(
        Map<String, dynamic> json) =>
    _$CommonMsgRecordResImpl(
      (json['records'] as List<dynamic>?)
          ?.map((e) => CommonMsgRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CommonMsgRecordResImplToJson(
        _$CommonMsgRecordResImpl instance) =>
    <String, dynamic>{
      'records': instance.records,
    };
