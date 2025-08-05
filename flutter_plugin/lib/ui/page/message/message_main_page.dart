import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/message/device/device_message_page.dart';
import 'package:flutter_plugin/ui/page/message/message_main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/message_main_ui_state.dart';
import 'package:flutter_plugin/ui/page/message/service/service_message_page.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_page.dart';
import 'package:flutter_plugin/ui/page/message/share/share_message_list_page.dart';
import 'package:flutter_plugin/ui/page/message/system/system_message_list_page.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/rtl_util.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class MessageMainPage extends BasePage {
  static const String routePath = '/message_main';

  const MessageMainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MessageMainPage();
  }
}

class _MessageMainPage extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  late EasyRefreshController _controller;
  bool pause = false;

  @override
  void initPageState() {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initData() {
    ref.watch(messageMainStateNotifierProvider.notifier).getMessageHomeRecord();
    ref
        .watch(messageMainStateNotifierProvider.notifier)
        .getNotificationPermission();
  }

  @override
  void addObserver() {
    ref.listen(
        messageMainStateNotifierProvider.select((value) => value.uiEvent),
        (previous, next) {
      if (next != null) {
        responseFor(next);
      }
    });
  }

  @override
  void onAppResume() {
    super.onAppResume();
    LogUtils.d('statusNotification onAppResume');
    if (pause) {
      pause = false;
      ref
          .watch(messageMainStateNotifierProvider.notifier)
          .getNotificationPermission();
    }
  }

  @override
  void onAppPaused() {
    super.onAppPaused();
    LogUtils.d('statusNotification onAppPause');
    pause = true;
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      backHidden: false,
      itemAction: (tag) {
        if (tag == BarButtonTag.right) {
          LogModule().eventReport(6, 3);
          GoRouter.of(context).push(MessageSettingPage.routePath);
        } else if (tag == BarButtonTag.left) {
          GoRouter.of(context).pop();
        }
      },
      rightImg: 'ic_msg_setting',
      titleWidget: Container(
        alignment: Alignment.center,
        child: DMButton(
          fontsize: style.secondary,
          textColor: style.textMain,
          fontWidget: FontWeight.w600,
          text: 'message'.tr(),
          backgroundColor: Colors.transparent,
          onClickCallback: (ctx) {
            LogModule().eventReport(6, 4);
            ref
                .read(messageMainStateNotifierProvider.notifier)
                .markAllMessageRead();
          },
          prefixWidget: Padding(
            padding: const EdgeInsets.only(right: 28.0).withRTL(context),
          ),
          surffixWidget: Padding(
            padding: const EdgeInsets.only(left: 8.0).withRTL(context),
            child: Image.asset(
              resource.getResource('ic_msg_all_read'),
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
      bgColor: style.bgGray,
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    MessageMainUIState messageMainUIState =
        ref.watch(messageMainStateNotifierProvider);
    return EasyRefresh(
      controller: _controller,
      // footer: const ClassicFooter(),
      onRefresh: () async {
        await ref
            .watch(messageMainStateNotifierProvider.notifier)
            .getMessageHomeRecord();
        _controller.finishRefresh();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: style.bgGray,
        child: SlidableAutoCloseBehavior(
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                messageMainUIState.showNoticePermission
                    ? showOpenNotification(style, resource)
                    : const SizedBox(
                        height: 8,
                      ),
                ...messageMainUIState.headMsgs
                    .map((e) => buildItem(style, resource, e)),
                Container(
                  height: 0.5,
                  margin: const EdgeInsets.only(
                      left: 30, right: 30, top: 20, bottom: 20),
                  decoration: BoxDecoration(color: style.lightBlack1),
                ),
                messageMainUIState.deviceMsgs.isEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            height:
                                messageMainUIState.headMsgs.isEmpty ? 120 : 0,
                          ),
                          Image.asset(
                            resource.getResource('ic_msg_empty'),
                            width: 264,
                            height: 264,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'message_list_empty'.tr(),
                            style: TextStyle(
                                color: style.textDisable,
                                fontSize: style.middleText),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          ...messageMainUIState.deviceMsgs
                              .map((e) => buildItem(style, resource, e))
                        ],
                      )
              ]))
            ],
          ),
        ),
      ),
    );
  }

  Widget showOpenNotification(StyleModel style, ResourceModel resource) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0).withRTL(context),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
              color: style.bgWhite,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                resource.getResource('ic_msg_notification'),
                width: 24,
                height: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: Text(
                'text_notification_enable_tip'.tr(),
                style: TextStyle(
                    color:style.textMain,
                    fontSize: style.middleText, fontWeight: FontWeight.w500),
              )),
              DMButton(
                backgroundColor: Colors.transparent,
                onClickCallback: (ctx) {
                  AppSettings.openAppSettings(
                      type: AppSettingsType.notification);
                },
                text: 'text_goto_open'.tr(),
                fontWidget: FontWeight.w500,
                textColor: style.click,
                fontsize: style.middleText,
                surffixWidget: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 10)
                      .withRTL(context),
                  child: Image.asset(
                    resource.getResource('ic_gold_arrow_right'),
                    width: 4,
                    height: 8,
                    color: style.click,
                  ).flipWithRTL(context),
                ),
              )
            ],
          ),
        ),
        Positioned(
            top: 10,
            left: isRTL(context) ? 10 : null,
            right: isRTL(context) ? null : 10,
            child: DMButton(
              backgroundColor: Colors.transparent,
              onClickCallback: (ctx) => ref
                  .watch(messageMainStateNotifierProvider.notifier)
                  .closeTips(),
              prefixWidget: Image.asset(
                resource.getResource('ic_notification_cancel'),
                width: 24,
                height: 24,
              ),
            ))
      ],
    );
  }

  Widget buildItem(StyleModel style, ResourceModel resource,
      MessageItemModel messageItemModel) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (messageItemModel.type == 'service_msg') {
          // ServiceMsg serviceMsg = messageItemModel.rawData as ServiceMsg;
          GoRouter.of(context)
              .push(ServiceMessagePage.routePath,
                  extra: messageItemModel.categoryUnread)
              .then((value) => {
                    ref
                        .watch(messageMainStateNotifierProvider.notifier)
                        .getMessageHomeRecord()
                  });
        } else if (messageItemModel.type == 'system_msg') {
          GoRouter.of(context).push(SystemMessageListPage.routePath).then(
              (value) => {
                    ref
                        .watch(messageMainStateNotifierProvider.notifier)
                        .getMessageHomeRecord()
                  });
        } else if (messageItemModel.type == 'share_msg') {
          GoRouter.of(context).push(ShareMessageListPage.routePath).then(
              (value) => {
                    ref
                        .watch(messageMainStateNotifierProvider.notifier)
                        .getMessageHomeRecord()
                  });
        } else if (messageItemModel.type == 'device_msg') {
          LogModule().eventReport(6, 7);
          DeviceMsg msg = messageItemModel.rawData as DeviceMsg;
          GoRouter.of(context)
              .push(DeviceMessagePage.routePath, extra: msg.deviceId)
              .then((value) => {
                    ref
                        .watch(messageMainStateNotifierProvider.notifier)
                        .getMessageHomeRecord()
                  });
        }
      },
      child: Slidable(
        groupTag: '0',
        key: ValueKey(messageItemModel.hashCode),
        enabled: messageItemModel.type == 'device_msg',
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const ScrollMotion(),
          children: [
            DMButton(
              width: MediaQuery.of(context).size.width * 0.2,
              backgroundColor: style.red1,
              onClickCallback: (ctx) async {
                LogModule().eventReport(6, 8);
                await ref
                    .read(messageMainStateNotifierProvider.notifier)
                    .deleteMessages({
                  'deviceId':
                      '${(messageItemModel.rawData as DeviceMsg).deviceId}'
                });
              },
              prefixWidget: Image.asset(
                  resource.getResource('icon_message_item_delete'),
                  width: 40,
                  height: 40),
            )
          ],
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 6, 20, 6).withRTL(context),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16).withRTL(context),
          decoration: BoxDecoration(
              color: style.bgWhite,
              borderRadius: BorderRadius.all(Radius.circular(style.circular12))),
          child: Row(
            children: [
              messageItemModel.img.isEmpty
                  ? Image.asset(
                      resource.getResource(messageItemModel.defaultImg),
                      width: 48,
                      height: 48,
                    )
                  : CachedNetworkImage(
                      imageUrl: messageItemModel.img,
                      placeholder: (context, string) {
                        return Image.asset(
                          resource.getResource(messageItemModel.defaultImg),
                          width: 48,
                          height: 48,
                        );
                      },
                      errorWidget: (context, string, _) {
                        return Image.asset(
                          resource.getResource(messageItemModel.defaultImg),
                          width: 48,
                          height: 48,
                        );
                      },
                      width: 48,
                      height: 48,
                    ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: RichText(
                                  text: TextSpan(children: [
                                    WidgetSpan(
                                        child: messageItemModel.showShared
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                        right: 10)
                                                    .withRTL(context),
                                                decoration: BoxDecoration(
                                                    color: style.blueShare,
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            style.circular4))),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        6, 4, 6, 3),
                                                child: RichText(
                                                  text: TextSpan(
                                                    text:
                                                        'message_setting_share'
                                                            .tr(),
                                                    style: TextStyle(
                                                      height: 1,
                                                      color: style.textWhite,
                                                      fontSize: style.miniText,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink()),
                                    TextSpan(
                                      text: messageItemModel.title,
                                      style: TextStyle(
                                          height: 1.4,
                                          fontWeight: FontWeight.w600,
                                          color: style.textMain,
                                          fontSize: style.largeText),
                                    ),
                                  ]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                              // Expanded(
                              //   flex: 1,
                              //   child: Text(
                              //     messageItemModel.title,
                              //     overflow: TextOverflow.ellipsis,
                              //     style: TextStyle(
                              //         color: style.textMain,
                              //         fontSize: style.largeText),
                              //   ),
                              // ),
                              // messageItemModel.showShared
                              //     ? Container(
                              //         margin: const EdgeInsets.only(left: 5)
                              //             .withRTL(context),
                              //         decoration: BoxDecoration(
                              //             color: style.yellow,
                              //             borderRadius:
                              //                 BorderRadius.circular(4)),
                              //         padding: const EdgeInsets.symmetric(
                              //             vertical: 3, horizontal: 7),
                              //         child: Text(
                              //           'message_setting_share'.tr(),
                              //           style: TextStyle(
                              //             color: style.textWhite,
                              //             fontSize: style.miniText,
                              //           ),
                              //         ),
                              //       )
                              //     : const SizedBox.shrink()
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10).withRTL(context),
                          child: Text(
                            messageItemModel.date,
                            style: TextStyle(
                                color: style.textDisable,
                                fontSize: style.smallText),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 22,
                            child: Text(
                              messageItemModel.subTitle,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: style.textSecond,
                                  fontSize: style.middleText),
                            ),
                          ),
                        ),
                        messageItemModel.unread > 0
                            ? Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                    color: style.red1,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                              )
                            : const SizedBox.shrink()
                      ],
                    )
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
