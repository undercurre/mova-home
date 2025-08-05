import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/message/service/customer_indicator.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/device_accepted_list_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing/device_sharing_list_page.dart';
import 'package:flutter_plugin/ui/widget/common/keep_alive_wrapper.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dm_tab_item.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeviceSharePage extends BasePage {
  static const String routePath = '/device_share';
  int initialIndex;

  DeviceSharePage({super.key, this.initialIndex = 0});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DeviceSharePageState();
  }
}

class DeviceSharePageState extends BasePageState<DeviceSharePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey globalKey = GlobalKey();

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: 'device_share'.tr(),
      backHidden: false,
      bgColor: style.bgGray,
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          GoRouter.of(context).pop();
        }
      },
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      width: double.infinity,
      color: style.bgGray,
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Material(
          key: globalKey,
          color: style.bgGray,
          child: Column(
            children: [
              Theme(
                data: ThemeData(
                  useMaterial3: false,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    isScrollable: true,
                    tabs: [
                      DmTabItem(
                        tabTitle: 'message_setting_share'.tr(),
                        showDot: false,
                      ),
                      DmTabItem(
                        tabTitle: 'accept'.tr(),
                        showDot: false,
                      ),
                    ],
                    labelColor: style.textMain,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelColor: style.textSecond,
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    indicator: CustomTabIndicator(
                      color: style.deviceSharedTabIndicatorColor,
                      width: 20,
                      height: 4,
                    ),
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5).withRTL(context),
                width: double.infinity,
                height: 0.8,
                color: style.lightBlack1,
              ),
              const Expanded(
                flex: 1,
                child: TabBarView(
                  children: [
                    KeepAliveWrapper(child: DeviceSharingListPage()),
                    KeepAliveWrapper(child: DeviceAcceptedListPage()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
