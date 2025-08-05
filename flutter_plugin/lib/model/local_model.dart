import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'local_model.freezed.dart';

@freezed
class LocalModel with _$LocalModel {
  const factory LocalModel({
    OAuthModel? oAuthBean,
    String? region,
    String? timeZone,
    RegionItem? regionItem,
    UserInfoModel? userInfo,
    @Default(true) bool isAgreedProtocal,
  }) = _LocalModel;
}
