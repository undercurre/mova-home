import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/message/service/activity/activity_message_list_page.dart';
import 'package:flutter_plugin/ui/page/message/service/customer_indicator.dart';
import 'package:flutter_plugin/ui/page/message/service/order/order_message_list_notifier.dart';
import 'package:flutter_plugin/ui/page/message/service/order/order_message_list_page.dart';
import 'package:flutter_plugin/ui/page/message/service/service_message_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/service/vip/vip_message_list_notifier.dart';
import 'package:flutter_plugin/ui/page/message/service/vip/vip_message_list_page.dart';
import 'package:flutter_plugin/ui/widget/common/keep_alive_wrapper.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_tab_item.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: implementation_imports
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:go_router/go_router.dart';

import 'activity/activity_message_list_notifier.dart';

class ServiceMessagePage extends BasePage {
  static const String routePath = '/message_service';
  int initialIndex;

  ServiceMessagePage({super.key, this.initialIndex = 0});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ServiceMessageState();
  }
}

class ServiceMessageState extends BasePageState
    with CommonDialog, SingleTickerProviderStateMixin {
  final GlobalKey globalKey = GlobalKey();

  @override
  void initData() {
    CategoryUnread? categoryUnread = GoRouterState.of(context).extra != null
        ? GoRouterState.of(context).extra as CategoryUnread
        : null;
    ref.read(serviceMessageStateNotifierProvider.notifier).initData(
        categoryUnread?.order_msg ?? 0,
        categoryUnread?.member_msg ?? 0,
        categoryUnread?.activity_msg ?? 0);
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      backHidden: false,
      itemAction: (tag) {
        if (tag == BarButtonTag.right) {
          var index =
              DefaultTabController.of(globalKey.currentState!.context).index;
          var msgList = <CommonMsgRecord>[];
          if (index == 0) {
            msgList =
                ref.watch(orderMessageListNotifierProvider).orderMessageList;
          } else if (index == 1) {
            msgList = ref.watch(vipMessageListNotifierProvider).vipMessageList;
          } else {
            msgList = ref
                .watch(activityMessageListNotifierProvider)
                .activityMessageList;
          }
          if (msgList.isNotEmpty) {
            showCommonDialog(
                content: 'text_message_clear_config'.tr(),
                cancelContent: 'cancel'.tr(),
                confirmContent: 'confirm'.tr(),
                confirmCallback: () {
                  if (index == 0) {
                    ref
                        .read(orderMessageListNotifierProvider.notifier)
                        .clearMessage();
                  } else if (index == 1) {
                    ref
                        .read(vipMessageListNotifierProvider.notifier)
                        .clearMessage();
                  } else {
                    ref
                        .read(activityMessageListNotifierProvider.notifier)
                        .clearMessage();
                  }
                });
          } else {}
        } else if (tag == BarButtonTag.left) {
          GoRouter.of(context).pop();
        }
      },
      rightTitle: 'confirm_clear_cache'.tr(),
      title: 'text_service_message'.tr(),
      bgColor: style.bgGray,
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    var orderTab = DmTabItem(
        tabTitle: '订单消息',
        showDot:
            ref.watch(serviceMessageStateNotifierProvider).orderShowRedDot);
    var vipTab = DmTabItem(
        tabTitle: '会员消息',
        showDot: ref.watch(serviceMessageStateNotifierProvider).vipShowRedDot);
    var activityTab = DmTabItem(
        tabTitle: '活动消息',
        showDot:
            ref.watch(serviceMessageStateNotifierProvider).activityShowRedDot);
    return Container(
        width: double.infinity,
        color: style.bgGray,
        child: DefaultTabController(
          initialIndex: (widget as ServiceMessagePage).initialIndex,
          length: [orderTab, vipTab, activityTab].length,
          child: Material(
              key: globalKey,
              color: style.bgGray,
              child: Column(
                children: [
                  Theme(
                    data: ThemeData(
                        useMaterial3: false,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent),
                    child: TabBar(
                      tabs: [orderTab, vipTab, activityTab],
                      labelColor: style.textMain,
                      unselectedLabelColor: style.textSecond,
                      indicator: CustomTabIndicator(
                          color: style.textBrand, width: 20, height: 3),
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
                    child: TabBarView(children: [
                      KeepAliveWrapper(child: OrderListPage()),
                      KeepAliveWrapper(child: VipListPage()),
                      KeepAliveWrapper(child: ActivityListPage()),
                    ]),
                  )
                ],
              )),
        ));
  }
}
