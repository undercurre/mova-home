import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/theme/index.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/settings/common/common_setting_extension.dart';
import 'package:flutter_plugin/ui/page/settings/common/common_setting_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/common/common_setting_ui_state.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_setting_item.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommonSettingsPage extends BasePage {
  static const String routePath = '/settings/common';

  const CommonSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return CommonSettingsPageState();
  }
}

class CommonSettingsPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  void initData() {
    super.initData();
    ref.read(commonSettingStateNotifierProvider.notifier).refreshData();
    ref.read(commonSettingStateNotifierProvider.notifier).getCurrentRegin();
  }

  @override
  String get centerTitle => 'mine_common_setting'.tr();

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    CommonSettingPageUiState state =
        ref.watch(commonSettingStateNotifierProvider);
    final themeName = ref.watch(appThemeStateNotifierProvider.notifier).currentSettingThemeName();
    return Container(
      color: style.bgColor,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 12, 20, 20).withRTL(context),
            decoration: BoxDecoration(
                color: style.bgWhite,
                borderRadius:
                    BorderRadius.all(Radius.circular(style.circular8))),
            child: Column(children: [
              DmSettingItem(
                showEndIcon: true,
                endWidget: Image.asset(
                  resource.getResource('icon_arrow_right2'),
                  width: 24,
                  height: 24,
                ),
                leadingTitle: 'mine_account_setting'.tr(),
                onTap: (ctx) {
                  pushToAccountSetting();
                },
              ),
              DmSettingItem(
                showEndIcon: true,
                endWidget: Image.asset(
                  resource.getResource('icon_arrow_right2'),
                  width: 24,
                  height: 24,
                ),
                leadingTitle: 'mine_language'.tr(),
                trailingText: state.displayLang,
                onTap: (ctx) {
                  pushToLanguage();
                },
              ),
              DmSettingItem(
                showEndIcon: true,
                endWidget: Image.asset(
                  resource.getResource('icon_arrow_right2'),
                  width: 24,
                  height: 24,
                ),
                leadingTitle: 'location'.tr(),
                trailingText: state.reginDisplay,
                onTap: (ctx) {
                  pushToChangeRegion();
                },
              ),
              DmSettingItem(
                showEndIcon: true,
                endWidget: Image.asset(
                  resource.getResource('icon_arrow_right2'),
                  width: 24,
                  height: 24,
                ),
                leadingTitle: 'app_theme_set'.tr(),
                trailingText: themeName,
                onTap: (ctx) {
                  pushToThemeMode();
                },
              ),
              DmSettingItem(
                showEndIcon: true,
                endWidget: Image.asset(
                  resource.getResource('icon_arrow_right2'),
                  width: 24,
                  height: 24,
                ),
                leadingTitle: 'mine_clear_cache'.tr(),
                trailingText: state.cacheSize,
                onTap: (ctx) {
                  clearCache();
                },
              )
            ]),
          )
        ],
      ),
    );
  }
}
