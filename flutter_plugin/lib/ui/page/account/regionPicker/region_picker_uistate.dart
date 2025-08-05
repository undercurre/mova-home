import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_page.dart';

class RegionPickerUiState {
  RegionPickerUiState(
      {required this.boxs,
      required this.selectRegion,
      this.isChinese = true,
      this.showChangeDialog = false});

  final List<RegionBoxItem> boxs;
  final RegionItem? selectRegion;
  final bool isChinese;
  final bool showChangeDialog;

  RegionPickerUiState copyWith(
      {List<RegionBoxItem>? boxs,
      RegionItem? selectRegion,
      bool? isChinese,
      bool? showChangeDialog}) {
    return RegionPickerUiState(
      boxs: boxs ?? this.boxs,
      selectRegion: selectRegion ?? this.selectRegion,
      isChinese: isChinese ?? this.isChinese,
      showChangeDialog: showChangeDialog ?? this.showChangeDialog,
    );
  }
}
