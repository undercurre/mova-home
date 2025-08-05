import 'dart:io';

import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

enum SuggestReportMediaType {
  image,
  video,
  add,
}

class SuggestReportMedia {
  SuggestReportMediaType type;
  AssetEntity? assetEntity;
  SuggestReportMedia({
    required this.type,
    this.assetEntity,
  });

  static SuggestReportMedia from({required AssetEntity file}) {
    return SuggestReportMedia(
      type: file.type == AssetType.image
          ? SuggestReportMediaType.image
          : SuggestReportMediaType.video,
      assetEntity: file,
    );
  }
}
