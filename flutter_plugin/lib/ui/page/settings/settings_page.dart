import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/about/about_page.dart';
import 'package:flutter_plugin/ui/page/settings/common/common_settings_page.dart';
import 'package:flutter_plugin/ui/page/settings/settings_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/upgrade/app_upgrade_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_setting_item.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends BasePage {
  static const String routePath = '/settings';

  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends BasePageState {
  @override
  String get centerTitle => 'setting'.tr();

  @override
  void initData() {
    super.initData();
    ref.read(settingsPageNotifierProvider.notifier).initData();
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      color: style.bgClear,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
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
                leadingTitle: 'mine_common_setting'.tr(),
                showDivider: false,
                onTap: (ctx) {
                  GoRouter.of(ctx).push(CommonSettingsPage.routePath);
                },
              ),
              DmSettingItem(
                showEndIcon: true,
                endWidget: Image.asset(
                  resource.getResource('icon_arrow_right2'),
                  width: 24,
                  height: 24,
                ),
                leadingTitle: 'mine_message_setting'.tr(),
                showDivider: false,
                onTap: (p0) {
                  GoRouter.of(context).push(MessageSettingPage.routePath);
                },
              ),
              ref.watch(settingsPageNotifierProvider
                      .select((value) => value.devOption == true))
                  ? DmSettingItem(
                      showEndIcon: true,
                      endWidget: Image.asset(
                        resource.getResource('icon_arrow_right2'),
                        width: 24,
                        height: 24,
                      ),
                      leadingTitle: '开发者选项',
                      showDivider: false,
                      onTap: (p0) {
                        GoRouter.of(context).push(DeveloperMenuPage.routePath);
                      },
                    )
                  : const SizedBox.shrink(),
              DmSettingItem(
                showEndIcon: true,
                endWidget: Image.asset(
                  resource.getResource('icon_arrow_right2'),
                  width: 24,
                  height: 24,
                ),
                leadingTitle: 'about'.tr(),
                showRedDot:
                    ref.watch(appUpgradeStateNotifierProvider).hasNewVersion,
                onTap: (_) {
                  GoRouter.of(context).push(AboutPage.routePath);
                },
              )
            ]),
          )
        ],
      ),
    );
  }
}
