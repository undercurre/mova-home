import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_tag.freezed.dart';
part 'feedback_tag.g.dart';

@freezed
class FeedBackTag with _$FeedBackTag {
  factory FeedBackTag({
    @Default('') String tagId,
    @Default('') String tagName,
    @Default(false) bool isSelected,
  }) = _FeedBackTag;

  factory FeedBackTag.fromJson(Map<String, dynamic> json) =>
      _$FeedBackTagFromJson(json);
}
