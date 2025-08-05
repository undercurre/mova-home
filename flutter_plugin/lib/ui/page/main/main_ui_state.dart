import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';
import 'package:flutter_plugin/ui/widget/nav/custom_navigation_bar.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_ui_state.freezed.dart';

@freezed
class MainUIState with _$MainUIState {
  const factory MainUIState({
    @Default(0) double tabBottomMargin,
    @Default([]) List<TabItem> tabs,
    @Default([]) List<Widget> tabPages,
    @Default([]) List<NavigationItemProtocol> tabBars,
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(0) int currentPage,
    @Default(TabItemType.device) TabItemType currentTab,
    @Default(0) int prePage,
    @Default(false) bool showEmailCheckDialog,
    String? userEmail,
    SmsTrCodeRes? smsTrCodeRes,
    @Default(false) bool isLoading,
    String? mallPath,
  }) = _MainUIState;
}
