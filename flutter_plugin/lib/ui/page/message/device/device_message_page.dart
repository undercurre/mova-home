import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/model/event/refresh_message_event.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/message/device/device_message_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/device/device_message_ui_state.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/home/home_download_widget.dart';
import 'package:flutter_plugin/utils/dateformat_utils.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:group_list_view/group_list_view.dart';

class DeviceMessagePage extends BasePage {
  static const String routePath = '/device_message';

  const DeviceMessagePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DeviceMessagePage();
  }
}

class _DeviceMessagePage extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  late EasyRefreshController _controller;

  @override
  void initData() {
    int did = GoRouterState.of(context).extra as int;
    ref
        .watch(deviceMessageStateNotifierProvider.notifier)
        .initDeviceData(did.toString());
    ref
        .watch(deviceMessageStateNotifierProvider.notifier)
        .refreshMessageList(forceRead: true);
    EventBusUtil.getInstance().register<RefreshMessageEvent>(this, (event) {
      ref
          .read(deviceMessageStateNotifierProvider.notifier)
          .refreshMessageList();
    });
  }

  @override
  void initPageState() {
    super.initPageState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void addObserver() {
    ref.listen(
        deviceMessageStateNotifierProvider.select((value) => value.uiEvent),
        (previous, next) {
      if (next != null) {
        responseFor(next);
      }
    });
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().unRegister(this);
    super.dispose();
    _controller.dispose();
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    bool isEdit = ref.watch(deviceMessageStateNotifierProvider
        .select((deviceMessageUIState) => deviceMessageUIState.isEdit));
    bool isSelectAll = ref.watch(deviceMessageStateNotifierProvider
        .select((deviceMessageUIState) => deviceMessageUIState.isSelectAll));
    BaseDeviceModel? currentDevice = ref.watch(
        deviceMessageStateNotifierProvider.select(
            (deviceMessageUIState) => deviceMessageUIState.currentDevice));

    Map<String, List<Content>>? msgList = ref.watch(
        deviceMessageStateNotifierProvider.select(
            (deviceMessageUIState) => deviceMessageUIState.messageList));
    return NavBar(
      backHidden: false,
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          if (isEdit) {
            ref
                .read(deviceMessageStateNotifierProvider.notifier)
                .setEdit(false);
          } else {
            GoRouter.of(context).pop();
          }
        } else if (tag == BarButtonTag.right) {
          LogModule().eventReport(6, 10);
          if (isEdit) {
            ref
                .read(deviceMessageStateNotifierProvider.notifier)
                .setSelectAll(!isSelectAll);
          } else {
            if (msgList == null || msgList.isNotEmpty) {
              ref
                  .read(deviceMessageStateNotifierProvider.notifier)
                  .setEdit(true);
            }
          }
        }
      },
      title: (currentDevice?.customName?.isEmpty == true)
          ? currentDevice?.deviceInfo?.displayName
          : currentDevice?.customName,
      bgColor: style.bgGray,
      rightImg: isEdit
          ? (isSelectAll ? 'icon_edit_select' : 'icon_edit_unselect')
          : 'ic_msg_edit',
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    DeviceMessageUIState deviceMessageUIState =
        ref.watch(deviceMessageStateNotifierProvider);
    return EasyRefresh(
      controller: _controller,
      onRefresh: () async {
        await ref
            .read(deviceMessageStateNotifierProvider.notifier)
            .refreshMessageList(forceRead: true);
        _controller.finishRefresh();
      },
      onLoad: () async {
        bool hasMore = await ref
            .watch(deviceMessageStateNotifierProvider.notifier)
            .loadMoreMessageList();
        _controller.finishLoad(
            hasMore ? IndicatorResult.success : IndicatorResult.noMore);
      },
      child: Container(
          width: double.infinity,
          height: double.infinity,
          color: style.bgGray,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: GroupListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemBuilder: ((context, index) {
                      if (deviceMessageUIState.messageList?.isNotEmpty ==
                          true) {
                        Content? content = deviceMessageUIState
                            .messageList?.values
                            .toList()[index.section][index.index];
                        // text: '${DateFormatUtils.formatLocal(content.sendTime!)}${content.localizationTitle}'
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              deviceMessageUIState.isEdit
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8)
                                          .withRTL(context),
                                      child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            ref
                                                .read(
                                                    deviceMessageStateNotifierProvider
                                                        .notifier)
                                                .setItemSelectStatus(content);
                                          },
                                          child: Image.asset(
                                            resource.getResource((content
                                                        ?.isSelect ==
                                                    true)
                                                ? 'icon_device_msg_select'
                                                : 'icon_device_msg_unselect'),
                                            width: 18,
                                            height: 18,
                                          )))
                                  : const SizedBox.shrink(),
                              Text(
                                DateFormatUtils.formatLocal(
                                    content?.sendTime ?? ''),
                                style: TextStyle(
                                    height: 1.2,
                                    color: style.textNormal,
                                    fontSize: style.middleText),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        LogModule().eventReport(6, 9);
                                        ref
                                            .read(
                                                deviceMessageStateNotifierProvider
                                                    .notifier)
                                            .openPlugin(
                                              content?.type == 1,
                                              content?.source,
                                            );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    style.cellBorder)),
                                            color: style.bgWhite),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: RichText(
                                                    text: TextSpan(
                                                        style: TextStyle(
                                                            height: 1.2,
                                                            color:
                                                                style.textMain,
                                                            fontSize: style
                                                                .middleText),
                                                        text: content
                                                            ?.localizationTitle,
                                                        children: [
                                                  content?.type == 1
                                                      ? TextSpan(
                                                          text:
                                                              'text_view_solutions'
                                                                  .tr(),
                                                          style: TextStyle(
                                                              height: 1.2,
                                                              color:
                                                                  style.click,
                                                              fontSize: style
                                                                  .middleText),
                                                        )
                                                      : const TextSpan()
                                                ]))),
                                            const SizedBox(width: 12),
                                            Image.asset(
                                              resource.getResource(
                                                  'icon_arrow_right2'),
                                              width: 7,
                                              height: 13,
                                            ).flipWithRTL(context)
                                          ],
                                        ),
                                      )))
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          margin:
                              const EdgeInsets.only(top: 100).withRTL(context),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                          ),
                        );
                      }
                    }),
                    sectionsCount: (deviceMessageUIState.messageList == null ||
                            deviceMessageUIState.messageList?.isEmpty == true)
                        ? 1
                        : (deviceMessageUIState.messageList?.keys
                                .toList()
                                .length ??
                            0),
                    groupHeaderBuilder: (context, section) {
                      if (deviceMessageUIState.messageList == null ||
                          deviceMessageUIState.messageList?.isEmpty == true) {
                        return SizedBox.shrink();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 8)
                              .withRTL(context),
                          child: Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: style.smallText,
                                  color: style.textDisable),
                              deviceMessageUIState.messageList?.keys
                                      .toList()[section] ??
                                  ''),
                        );
                      }
                    },
                    countOfItemInSection: (section) {
                      return (deviceMessageUIState.messageList == null ||
                              deviceMessageUIState.messageList?.isEmpty == true)
                          ? 1
                          : (deviceMessageUIState.messageList?.values
                                  .toList()[section]
                                  .length ??
                              0);
                    }),
              ),
              deviceMessageUIState.isEdit
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        LogModule().eventReport(6, 11);
                        ref
                            .read(deviceMessageStateNotifierProvider.notifier)
                            .checkoutSelectMessage();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 72,
                        decoration: BoxDecoration(color: style.red1),
                        child: Center(
                          child: Image.asset(
                            resource.getResource('icon_device_msg_delete'),
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ))
                  : const SizedBox.shrink()
            ],
          )),
    );
  }
}
