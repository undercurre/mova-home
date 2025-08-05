// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/developer/developer_mode_page.dart';
import 'package:flutter_plugin/ui/page/developer/discuz_debug/discuz_debug_page.dart';
import 'package:flutter_plugin/ui/page/developer/gps_debug/gps_debug_page.dart';
import 'package:flutter_plugin/ui/page/developer/mall_debug/mall_debug_page.dart';
import 'package:flutter_plugin/ui/page/developer/warranty_debug/warranty_debug_page.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeveloperMenuPage extends BasePage {
  static const String routePath = '/mine/developer/menu';

  const DeveloperMenuPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DeveloperMenuPageState();
  }
}

class DeveloperMenuPageState extends BasePageState with ResponseForeUiEvent {
  final List<Pair> items = [
    Pair('开发者模式', 'developMode'),
    // Pair('首页调试', 'homeDebug'),
    Pair('售后功能', 'afterSale'),
    Pair('切换环境', 'switchENV'),
    Pair('手动过期token', 'invalidToken'),
    Pair('商城调试', 'mallDebug'),
    Pair('论坛调试', 'discuzDebug'),
    Pair('GPS锁区测试', 'GPSLock'),
    Pair('保修卡区域测试', 'warrantyDebug'),
    Pair('通用配网测试', 'commonPairNetDebug'),
    Pair('阿里飞燕调试', 'alifyTest'),
    Pair('还原本地商城包版本', 'clearLocalMallVersion'),
    Pair('SDK测试插件', 'sdkTest'),
    Pair('自定义Header设置', 'customHeaders'),
    Pair('会展模式', 'conventionCenter'),
  ];

  @override
  void initData() {
    ref
        .read(developerMenuPageStateNotifierProvider.notifier)
        .getAfterSaleEnable();
    ref
        .read(developerMenuPageStateNotifierProvider.notifier)
        .getCommonPairNetEnable();
    ref
        .read(developerMenuPageStateNotifierProvider.notifier)
        .getSDKTestPluginEnable();
    ref
        .read(developerMenuPageStateNotifierProvider.notifier)
        .getConventionCenterEnable();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        developerMenuPageStateNotifierProvider.select((value) => value.event),
            (previous, next) {
          responseFor(next);
        });
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: '开发者选项',
      bgColor: style.bgGray,
      itemAction: (tag) => {
        if (tag == BarButtonTag.left) {GoRouter.of(context).pop()}
      },
    );
  }

  Icon buildIcons(Pair pair, StyleModel style) {
    IconData icon = Icons.code;
    switch (pair.second) {
      case 'developMode':
        break;
      case 'afterSale':
        icon = ref.watch(developerMenuPageStateNotifierProvider).afterSaleEnable
            ? Icons.check
            : Icons.close;
        break;
      case 'switchENV':
        icon = Icons.cloud_sync;
        break;
      case 'invalidToken':
        icon = Icons.cloud_sync;
        break;
      case 'mallDebug':
      case 'GPSLock':
      case 'warrantyDebug':
      case 'homeDebug':
      case 'clearLocalMallVersion':
      case 'alifyTest':
      case 'customHeaders':
        icon = Icons.cloud_sync;
        break;
      case 'commonPairNetDebug':
        icon = ref
            .watch(developerMenuPageStateNotifierProvider)
            .commonPairNetEnable
            ? Icons.check
            : Icons.close;
        break;
      case 'sdkTest':
        icon = ref
            .watch(developerMenuPageStateNotifierProvider)
            .sdkTestPluginEnable
            ? Icons.check
            : Icons.close;
        break;
      case 'conventionCenter':
        icon = ref
                .read(developerMenuPageStateNotifierProvider)
                .enableConventionCenter
            ? Icons.check
            : Icons.close;
      default:
    }
    return Icon(icon, color: style.developerTextColor);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: buildIcons(items[index], style),
          title: Text(items[index].first, style: TextStyle(color: style.textMainBlack),),
          onTap: () async {
            switch (items[index].second) {
              case 'developMode':
                await GoRouter.of(context).push(DeveloperModePage.routePath);
                break;
              // case 'homeDebug':
              //   await GoRouter.of(context).push(HomeDebugPage.routePath);
              //   break;
              case 'afterSale':
                await ref
                    .read(developerMenuPageStateNotifierProvider.notifier)
                    .toggleAfterSaleEnable();
                break;
              case 'switchENV':
                await UIModule().switchAppEnv();
                break;
              case 'invalidToken':
                await AccountModule().invalidToken();
                DMHttpManager().reset();
                break;
              case 'mallDebug':
                await GoRouter.of(context).push(MallDebugPage.routePath);
                break;
              case 'discuzDebug':
                await GoRouter.of(context).push(DiscuzDebugPage.routePath);
                break;
              case 'GPSLock':
                await GoRouter.of(context).push(GPSDebugPage.routePath);
                break;
              case 'warrantyDebug':
                await GoRouter.of(context).push(WarrantyDebugPage.routePath);
                break;
              case 'commonPairNetDebug':
                await ref
                    .read(developerMenuPageStateNotifierProvider.notifier)
                    .toggleCommonPairNetEnable();
                break;
              case 'alifyTest':
                await UIModule().alifyTest();
                break;
              case 'clearLocalMallVersion':
                await ref
                    .read(developerMenuPageStateNotifierProvider.notifier)
                    .clearLocalMallVersion();
              case 'sdkTest':
                await ref
                    .read(developerMenuPageStateNotifierProvider.notifier)
                    .toggleSDKTestPluginEnable();
              case 'conventionCenter':
                await ref
                    .read(developerMenuPageStateNotifierProvider.notifier)
                    .toggleConventionCenterEnable();
                break;
              default:
                break;
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 0.5, color: style.gray3);
      },
    );
  }
}
