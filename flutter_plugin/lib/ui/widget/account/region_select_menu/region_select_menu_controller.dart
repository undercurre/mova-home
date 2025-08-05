import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu_state.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'region_select_menu_controller.g.dart';

@riverpod
class RegionSelectMenuController extends _$RegionSelectMenuController {
  @override
  RegionSelectMenuState? build() {
    return null;
  }

  Future<void> initState() async {
    RegionItem item = await LocalModule().getCurrentCountry();
    bool isChinese = LanguageStore().isChinese();
    String regionName = isChinese ? item.name : item.en;
    state = RegionSelectMenuState(
      currentRegion: item,
      regionName: regionName,
    );
  }

  Future<void> updateRegion(RegionItem region) async {
    bool isChinese = LanguageStore().isChinese();
    String regionName = isChinese ? region.name : region.en;
    await RegionStore().updateRegion(region);
    state = RegionSelectMenuState(
      currentRegion: region,
      regionName: regionName,
    );
  }
}
