import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'suggest_history_box.freezed.dart';
part 'suggest_history_box.g.dart';

@freezed
class SuggestHistoryBox with _$SuggestHistoryBox {
  factory SuggestHistoryBox({
    List<SuggestHistory>? records,
  }) = _SuggestHistoryBox;

  factory SuggestHistoryBox.fromJson(Map<String, dynamic> json) =>
      _$SuggestHistoryBoxFromJson(json);
}

@freezed
class SuggestHistory with _$SuggestHistory {
  factory SuggestHistory({
    @Default('') String id,
    @Default(0) int status,
    @Default(0) double createTime,
    @Default('') String content,
    @Default('') String deviceIconUrl,
    @Default('') String modelName,
    @Default(0) int type,
    List<String>? adviseTagNames,
    List<String>? images,
    List<String>? videos,
  }) = _SuggestHistory;

  factory SuggestHistory.fromJson(Map<String, dynamic> json) =>
      _$SuggestHistoryFromJson(json);
}

class SuggestHistoryItem {
  String deviceIconUrl = '';
  String name = '';
  String time = '';
  String content = '';
  int type = 0;
  List<String>? tags;
  List<SuggestHistoryMedia>? medias;

  static SuggestHistoryItem fromSuggestHistory(SuggestHistory history) {
    SuggestHistoryItem item = SuggestHistoryItem();

    int time = history.createTime.toInt();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedTime = fmt.format(dateTime);
    item.deviceIconUrl = history.deviceIconUrl;
    item.name = history.modelName;
    item.time = formattedTime;
    item.content = history.content;
    item.tags = history.adviseTagNames;
    item.type = history.type;

    List<SuggestHistoryMedia> medias = [];

    if (history.images != null) {
      for (String image in history.images!) {
        SuggestHistoryMedia media = SuggestHistoryMedia();
        media.url = image;
        media.thumbUrl = image;
        medias.add(media);
      }
    }
    if (history.videos != null) {
      for (String video in history.videos!) {
        SuggestHistoryMedia media = SuggestHistoryMedia();
        media.url = video;
        media.thumbUrl = video;
        media.isVideo = true;
        medias.add(media);
      }
    }
    item.medias = medias.isNotEmpty ? medias : null;
    return item;
  }
}

class SuggestHistoryMedia {
  String url = '';
  String thumbUrl = '';
  bool isVideo = false;
}
