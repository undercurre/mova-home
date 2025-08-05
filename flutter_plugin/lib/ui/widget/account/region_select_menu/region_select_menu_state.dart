import 'package:flutter_plugin/model/region_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'region_select_menu_state.freezed.dart';

@freezed
class RegionSelectMenuState with _$RegionSelectMenuState {
  factory RegionSelectMenuState({
    RegionItem? currentRegion,
    String? regionName,
  }) = _RegionSelectMenuState;
}
