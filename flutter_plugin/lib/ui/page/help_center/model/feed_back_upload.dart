import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_back_upload.freezed.dart';
part 'feed_back_upload.g.dart';

@freezed
class FeedBackUpload with _$FeedBackUpload {
  factory FeedBackUpload({
    @Default('') String uploadUrl,
    @Default('') String url,
  }) = _FeedBackUpload;

  factory FeedBackUpload.fromJson(Map<String, dynamic> json) =>
      _$FeedBackUploadFromJson(json);
}
