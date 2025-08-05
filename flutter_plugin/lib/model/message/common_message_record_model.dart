import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_message_record_model.freezed.dart';
part 'common_message_record_model.g.dart';

@freezed
class CommonMsgRecordExt with _$CommonMsgRecordExt {
  factory CommonMsgRecordExt({
    String? goods_name,
    String? goods_num,
    String? link_url,
  }) = _CommonMsgRecordExt;

  factory CommonMsgRecordExt.fromJson(Map<String, dynamic> json) =>
      _$CommonMsgRecordExtFromJson(json);
}

@freezed
class CommonMsgRecordDisplay with _$CommonMsgRecordDisplay {
  factory CommonMsgRecordDisplay({
    String? lang,
    String? content,
    String? link,
    String? name,
  }) = _CommonMsgRecordDisplay;

  factory CommonMsgRecordDisplay.fromJson(Map<String, dynamic> json) =>
      _$CommonMsgRecordDisplayFromJson(json);
}

@freezed
class CommonMsgRecord with _$CommonMsgRecord {
  factory CommonMsgRecord({
    String? id,
    String? multiLangDisplay,
    String? msgCategory,
    String? jumpType,
    int? readStatus,
    String? readTime,
    String? createTime,
    String? updateTime,
    String? ext,
    CommonMsgRecordExt? extBean,
    CommonMsgRecordDisplay? display,
    String? imgUrl,
  }) = _CommonMsgRecord;

  factory CommonMsgRecord.fromJson(Map<String, dynamic> json) =>
      _$CommonMsgRecordFromJson(json);
}

@freezed
class CommonMsgRecordRes with _$CommonMsgRecordRes {
  factory CommonMsgRecordRes(List<CommonMsgRecord>? records) =
      _CommonMsgRecordRes;

  factory CommonMsgRecordRes.fromJson(Map<String, dynamic> json) =>
      _$CommonMsgRecordResFromJson(json);
}
