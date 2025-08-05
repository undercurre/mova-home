import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/device_share/mine_share_permission_entity.dart';

class MineSharePermissionModel {
  String? title;
  int? height;
  String? imageUrl;
  String? smallImageUrl;
  String? desc;
  bool? isOn;
  String? permitKey;
  int clickCount = 0;
  MineSharePermissionEntity? entityValue;

  MineSharePermissionModel({
    required this.title,
    required this.height,
    required this.imageUrl,
    this.smallImageUrl,
    this.isOn,
    this.entityValue,
    required this.desc,
    required this.permitKey,
  });

  static Future<MineSharePermissionModel> fromEntity(
      MineSharePermissionEntity entityValue) async {
    String? title;
    String? desc;
    String currentLanguage = await LocalModule().getLangTag();

    MineSharePermissionEntity? entity;

    entity = entityValue;
    if (entity.permitInfo?.permitInfoDisplays != null) {
      final isContains =
          entity.permitInfo!.permitInfoDisplays!.keys.contains(currentLanguage);
      if (isContains) {
        title = entity
            .permitInfo!.permitInfoDisplays![currentLanguage]?.permitTitle;
        desc = entity
            .permitInfo!.permitInfoDisplays![currentLanguage]?.permitExplain;
      } else {
        // 未匹配到语言
        title = (currentLanguage == 'zh')
            ? entity.permitInfo!.permitInfoDisplays!['zh']?.permitTitle
            : entity.permitInfo!.permitInfoDisplays!['en']?.permitTitle;
        desc = (currentLanguage == 'zh')
            ? entity.permitInfo!.permitInfoDisplays!['zh']?.permitExplain
            : entity.permitInfo!.permitInfoDisplays!['en']?.permitExplain;
      }
    }

    // 计算cell高度的逻辑
    int height = 80; // 默认高度

    final imageUrl = entity.permitInfo?.permitImage?.imageUrl;
    final isOn = entity.isOn;
    final permitKey = entity.permitKey;
    return MineSharePermissionModel(
      title: title,
      height: height,
      desc: desc,
      isOn: isOn,
      imageUrl: imageUrl,
      entityValue: entityValue,
      permitKey: permitKey,
    );
  }
}
