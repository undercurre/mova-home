import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/account/mall_my_info_res.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/mine/mine_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mine_ui_state.freezed.dart';

typedef ClickCallback = void Function();

@unfreezed
class MineUiState with _$MineUiState {
  factory MineUiState({
    @Default([]) List<List<MineModel>> mineList,
    UserInfoModel? userInfo,
    @Default('0B') String cacheSize,
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(false) bool showSubscribe,
    MallMyInfoRes? mallInfo,
    @Default('--') String vipLevel,
    @Default('--') String vipPoint,
    @Default(false) bool showMall,
    @Default(false) bool refreshing,
    @Default([]) List<MallBannerRes> vipBanners,
  }) = _MineUiState;
}
