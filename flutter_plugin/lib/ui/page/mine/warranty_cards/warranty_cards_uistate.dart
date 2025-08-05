import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'warranty_cards_uistate.freezed.dart';

@unfreezed
class WarrantyCardsUiState with _$WarrantyCardsUiState {
  factory WarrantyCardsUiState({
    required String title,
    required String url,
    UserInfoModel? userInfo,
    bool? deviceListChecked,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _WarrantyCardsUiState;
}
