import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'app_faq.g.dart';

class AppFaq {
  String title = '';
  LocalizationDisplayMedia localizationDisplayMedia = LocalizationDisplayMedia.empty();
  List<FaqContent> bodyItems = [];
  bool isExpand = false;

  AppFaq({
    required this.title,
    required this.bodyItems,
    required this.isExpand,
    required this.localizationDisplayMedia,
  });

  factory AppFaq.fromJson(Map<String, dynamic> json) {
    final String title = json['title'] ?? '';
    final dynamic bodyItemsJson = json['bodyItems'];
    final List<FaqContent> bodyItems = <FaqContent>[];

    if (bodyItemsJson is List) {
      for (var item in bodyItemsJson) {
        if (item is Map<String, dynamic>) {
          try {
            bodyItems.add(FaqContent.fromJson(item));
          } catch (e) {
            // 忽略非法条目或记录日志
            continue;
          }
        }
      }
    }

    final bool isExpand = json['isExpand'] ?? false;

    final LocalizationDisplayMedia? localizationDisplayMedia =
    json['localizationDisplayMedia'] != null
        ? LocalizationDisplayMedia.fromJson(json['localizationDisplayMedia'] as Map<String, dynamic>)
        : null;

    return AppFaq(
      title: title,
      bodyItems: bodyItems,
      isExpand: isExpand,
      localizationDisplayMedia:
      localizationDisplayMedia ?? LocalizationDisplayMedia.empty(),
    );
  }
}

@JsonSerializable(includeIfNull: false)
class LocalizationDisplayMedia {
  String? id;
  String? filePath;
  String? fileName;
  String? etag;
  int? mediaOrder;

  LocalizationDisplayMedia({
    this.id,
    this.filePath,
    this.fileName,
    this.etag,
    this.mediaOrder,
  });

  factory LocalizationDisplayMedia.fromJson(Map<String, dynamic> json) =>
      _$LocalizationDisplayMediaFromJson(json);

  Map<String, dynamic> toJson() => _$LocalizationDisplayMediaToJson(this);

  static LocalizationDisplayMedia empty() {
    return LocalizationDisplayMedia(
      id: '-1',
      filePath: '',
      fileName: '',
      etag: '',
      mediaOrder: -1,
    );
  }
}

class FaqContent {
  String content = '';
  FaqContent({required this.content});

  factory FaqContent.fromJson(Map<String, dynamic> json) {
    final String content = json['content'] ?? '';
    return FaqContent(content: content);
  }
}
