// ignore_for_file: avoid_public_notifier_properties
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_uistate.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'region_picker_page.dart';

part 'region_picker_controller.g.dart';

@riverpod
class RegionPickerController extends _$RegionPickerController {
  List<RegionItem> oriItems = [];
  List<RegionItem> searchItems = [];
  int currentPanSection = -1;
  ScrollController scrollerController = ScrollController();

  @override
  RegionPickerUiState build() {
    return RegionPickerUiState(boxs: [], selectRegion: null);
  }

  //初始化
  Future<void> onLoad() async {
    String jsonString = await loadAsset();
    var json = jsonDecode(jsonString);
    List<RegionItem> items = RegionItem.listFromMaps(json);
    oriItems = items;
    state = state.copyWith(
        isChinese: LanguageStore().getCurrentLanguage().isChinese());
    searchFor('');
  }

  //搜索
  void searchFor(String text) {
    state = state.copyWith(boxs: getBoxsFor(text));
  }

  void initData(RegionItem short, bool showChangeDialog) {
    state =
        state.copyWith(selectRegion: short, showChangeDialog: showChangeDialog);
  }

  void selectTheShort(RegionItem short) {
    state = state.copyWith(selectRegion: short);
  }

  void tapForOffset(double offset) {
    int clickIndex = offset ~/ 20.0;
    clickTheSearch(clickIndex);
  }

  void clickTheSearch(int section) {
    if (section >= state.boxs.length || section < 0) {
      return;
    }
    HapticFeedback.heavyImpact();
    scrollerController.jumpTo(state.boxs[section].headerPosition);
  }

  void panForOffset(double offset) {
    int clickIndex = offset ~/ 20.0;
    if (currentPanSection == clickIndex) {
      return;
    }
    currentPanSection = clickIndex;
    clickTheSearch(currentPanSection);
  }

  void panForStart() {
    currentPanSection = -1;
  }

  List<RegionBoxItem> getBoxsFor(String text) {
    List<RegionItem> searchItems = [];
    if (text.isEmpty) {
      searchItems = oriItems;
    } else {
      for (RegionItem item in oriItems) {
        bool result = item.code.contains(text);
        if (!result) {
          result = state.isChinese
              ? item.name.toLowerCase().contains(text.toLowerCase())
              : item.en.toLowerCase().contains(text.toLowerCase());
        }
        if (result) {
          searchItems.add(item);
        }
      }
    }

    return RegionBoxItem.getFromItems(searchItems, state.isChinese);
  }

  Future<String> loadAsset() async {
    // RegionItem.j
    return await rootBundle.loadString('assets/resource/country.json');
  }
}
