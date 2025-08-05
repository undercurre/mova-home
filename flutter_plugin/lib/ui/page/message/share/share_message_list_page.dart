import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/share/popup/device_share_popup.dart';
import 'package:flutter_plugin/ui/page/message/share/share_message_list_notifier.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/dateformat_utils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

class ShareMessageListPage extends BasePage {
  static const String routePath = '/message_share';

  const ShareMessageListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ShareMessageListState();
  }
}

class ShareMessageListState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  late EasyRefreshController _controller;

  @override
  void initPageState() {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void addObserver() {
    ref.listen(
        shareMessageListNotifierProvider.select((value) => value.uiEvent),
        (previous, next) {
      if (next != null) {
        responseFor(next);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initData() {
    ref
        .read(shareMessageListNotifierProvider.notifier)
        .refreshShareMessage(forceRead: true);
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    List<ShareMessageModel> msgList =
        ref.watch(shareMessageListNotifierProvider).shareMessageList;
    return NavBar(
      backHidden: false,
      itemAction: (tag) {
        if (tag == BarButtonTag.right) {
          if (msgList.isNotEmpty) {
            showCommonDialog(
                content: 'text_message_clear_config'.tr(),
                cancelContent: 'cancel'.tr(),
                confirmContent: 'confirm'.tr(),
                confirmCallback: () {
                  ref
                      .read(shareMessageListNotifierProvider.notifier)
                      .clearShareMessage();
                });
          } else {}
        } else if (tag == BarButtonTag.left) {
          GoRouter.of(context).pop();
        }
      },
      rightTitle: 'confirm_clear_cache'.tr(),
      title: 'text_share_message'.tr(),
      bgColor: style.bgGray,
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    List<ShareMessageModel> msgList =
        ref.watch(shareMessageListNotifierProvider).shareMessageList;
    return Container(
      color: style.bgGray,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
            visible: ref
                .watch(developerMenuPageStateNotifierProvider)
                .afterSaleEnable,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: AnimatedInputText(
                onTextChanged: (str) {
                  ref
                      .read(shareMessageListNotifierProvider.notifier)
                      .filterLocalData(str);
                },
                showCountryCode: false,
                showGetDynamicCode: false,
                underLineHeight: 1,
                animateLineHeight: 1,
                suffixChild: DMButton(
                  textColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  backgroundColor: style.click,
                  onClickCallback: (ctx) {
                    ref
                        .read(shareMessageListNotifierProvider.notifier)
                        .filterLocalData(ref
                            .read(shareMessageListNotifierProvider)
                            .searchKey);
                  },
                  text: '搜索',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: EasyRefresh(
                controller: _controller,
                onRefresh: () async {
                  await ref
                      .read(shareMessageListNotifierProvider.notifier)
                      .refreshShareMessage(forceRead: true);
                  _controller.finishRefresh();
                },
                onLoad: () async {
                  bool more = await ref
                      .read(shareMessageListNotifierProvider.notifier)
                      .loadMoreShareMessage();
                  _controller.finishLoad(
                      more ? IndicatorResult.success : IndicatorResult.noMore);
                },
                child: SlidableAutoCloseBehavior(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 12,
                        color: Colors.transparent,
                      );
                    },
                    itemBuilder: (context, index) {
                      if (msgList.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(top: 100),
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
                                    fontWeight: FontWeight.normal,
                                    color: style.textDisable,
                                    fontSize: style.middleText),
                              )
                            ],
                          ),
                        );
                      } else {
                        return _buildItem(style, resource, msgList[index]);
                      }
                    },
                    itemCount: msgList.isNotEmpty ? msgList.length : 1,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(StyleModel style, ResourceModel resource,
      ShareMessageModel shareMessage) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Slidable(
        key: ValueKey(shareMessage.messageId),
        groupTag: '0',
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const ScrollMotion(),
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    color: style.red1),
                child: Center(
                    child: Image.asset(
                            resource.getResource('icon_message_item_delete'),
                            width: 40,
                            height: 40)
                        .onClick(() {
                  ref
                      .read(shareMessageListNotifierProvider.notifier)
                      .deleteShareMessageByMsgId(shareMessage.messageId ?? '');
                })))
          ],
        ),
        child: _buildItemContent(style, resource, shareMessage),
      ),
    );
  }

  Widget _buildItemContent(StyleModel style, ResourceModel resource,
      ShareMessageModel shareMessage) {
    bool showStatus = shareMessage.ackResult == 0 //待接收
        ||
        shareMessage.ackResult == 1 //已接收
        ||
        shareMessage.ackResult == 2 //已拒绝
        ||
        shareMessage.ackResult == 3; //已过期
    Color statusColor = style.textSecond;
    String status = '';
    if (shareMessage.ackResult == 0) {
      statusColor = style.yellow;
      status = 'waiting_receive'.tr();
    } else if (shareMessage.ackResult == 1) {
      statusColor = style.green;
      status = 'already_accept'.tr();
    } else if (shareMessage.ackResult == 2) {
      status = 'already_reject'.tr();
    } else if (shareMessage.ackResult == 3) {
      status = 'already_invalid'.tr();
    }

    return GestureDetector(
        onTap: () {
          if (showStatus) {
            SmartDialog.show(
                clickMaskDismiss: false,
                animationType: SmartAnimationType.fade,
                builder: (context) {
                  return DeviceSharePopup(shareMessage.langTagDeviceName ?? '',
                      shareMessage.langTagMsg ?? '', shareMessage.img ?? '',
                      messageId: shareMessage.messageId,
                      ackResult: shareMessage.ackResult,
                      did: '${shareMessage.deviceId}',
                      model: shareMessage.model,
                      ownUid: shareMessage.ownUid,
                      dismissCallback: () => SmartDialog.dismiss());
                },
                onDismiss: () {});
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(style.circular12)),
              color: style.bgWhite),
          width: double.infinity,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.centerLeft,
                child: shareMessage.img.isEmpty == true
                    ? Image.asset(
                        resource.getResource('ic_placeholder_robot'),
                        width: 48,
                        height: 48,
                      )
                    : CachedNetworkImage(
                        imageUrl: shareMessage.img ?? '',
                        placeholder: (context, string) {
                          return Image.asset(
                            resource.getResource('ic_placeholder_robot'),
                            width: 48,
                            height: 48,
                          );
                        },
                        errorWidget: (context, string, _) {
                          return Image.asset(
                            resource.getResource('ic_placeholder_robot'),
                            width: 48,
                            height: 48,
                          );
                        },
                        width: 48,
                        height: 48,
                      ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 22,
                          child: Text(
                            shareMessage.langTagContent ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: style.textSecond,
                                fontSize: style.middleText),
                          ),
                        ),
                        Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            shareMessage.langTagDeviceName ?? '',
                            style: TextStyle(
                                color: style.textMain,
                                fontWeight: FontWeight.bold,
                                fontSize: style.largeText))
                      ])),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          DateFormatUtils.commonDateTimeFormat(
                              shareMessage.sendTime),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: style.textSecond,
                              fontSize: style.smallText)),
                      const SizedBox(
                        height: 8,
                      ),
                      showStatus
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: statusColor,
                                        fontSize: style.middleText),
                                    status),
                                const SizedBox(
                                  width: 6,
                                ),
                                Image.asset(
                                  resource.getResource('icon_arrow_right2'),
                                  width: 7,
                                  height: 13,
                                ).flipWithRTL(context)
                              ],
                            )
                          : const SizedBox(height: 12)
                    ]),
              )
            ],
          ),
        ));
  }
}
