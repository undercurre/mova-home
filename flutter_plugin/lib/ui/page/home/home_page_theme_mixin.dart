import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';

mixin HomePageThemeMixin on BasePageState {
  Color listenToProgressChange(style) {
    final dynamicColor =
        changeToDarkIfNeeded() ? style.bgWhite : style.textMain;
    return dynamicColor;
  }

  bool isDeviceEmptyPage() {
    ref.watch(homeStateNotifierProvider.select((value) => value.currentIndex));
    final islastPage =
        ref.read(homeStateNotifierProvider.notifier).isLastPage();
    final isDeviceTab = ref
        .watch(mainStateNotifierProvider.notifier)
        .isTargetTab(TabItemType.device);
    return isDeviceTab && islastPage;
  }

  bool changeToDarkIfNeeded() {
    // ref.watch(videoStateProvider);
    // final isDark = ref.read(videoStateProvider).isDarkColor;
    return isDeviceEmptyPage();
  }

}
