import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/event/refresh_message_event.dart';
import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/message/service/order/order_message_list_notifier.dart';
import 'package:flutter_plugin/ui/page/message/system/response_for_message.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/utils/dateformat_utils.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrderListPage extends BasePage {
  const OrderListPage({super.key});

  @override
  OrderListPageState createState() {
    return OrderListPageState();
  }
}

class OrderListPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  bool get showTitle => false;

  @override
  void initData() {
    ref
        .read(orderMessageListNotifierProvider.notifier)
        .refreshMessage(forceRead: true);
    EventBusUtil.getInstance().register<RefreshMessageEvent>(this, (event) {
      ref.read(orderMessageListNotifierProvider.notifier).refreshMessage();
    });
  }

  @override
  void addObserver() {
    ref.listen(
        orderMessageListNotifierProvider.select((value) => value.uiEvent),
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
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    List<CommonMsgRecord> msgList =
        ref.watch(orderMessageListNotifierProvider).orderMessageList;
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: style.bgGray,
        child: EasyRefresh(
            controller: _controller,
            onRefresh: () async {
              await ref
                  .read(orderMessageListNotifierProvider.notifier)
                  .refreshMessage(forceRead: true);
              _controller.finishRefresh();
            },
            onLoad: () async {
              bool more = await ref
                  .read(orderMessageListNotifierProvider.notifier)
                  .loadMoreMessage();
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
                      margin: const EdgeInsets.only(top: 40),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                  } else {
                    return _buildItem(style, resource, msgList[index]);
                  }
                },
                itemCount: msgList.isNotEmpty ? msgList.length : 1,
              ),
            )));
  }

  Widget _buildItem(
      StyleModel style, ResourceModel resource, CommonMsgRecord message) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Slidable(
        key: ValueKey(message.id),
        groupTag: '0',
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const ScrollMotion(),
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(style.circular8)),
                    color: style.red1),
                child: Center(
                    child: Image.asset(
                            resource.getResource('icon_message_item_delete'),
                            width: 40,
                            height: 40)
                        .onClick(() {
                  ref
                      .read(orderMessageListNotifierProvider.notifier)
                      .deleteMessageByMsgId(message.id ?? '');
                })))
          ],
        ),
        child: _buildItemContent(style, resource, message),
      ),
    );
  }

  Widget _buildItemContent(
      StyleModel style, ResourceModel resource, CommonMsgRecord message) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          LogUtils.d('订单消息点击');
          if (message.display == null ||
              message.display!.link == null ||
              message.display!.link == '') {
            return;
          }
          messageClick(message);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(style.circular8)),
              color: style.bgWhite),
          width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          message.display?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: style.textMain,
                              fontWeight: FontWeight.bold,
                              fontSize: style.largeText),
                        ),
                      ),
                      Text(
                        DateFormatUtils.commonDateTimeFormat(
                            message.createTime),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: style.textSecond,
                            fontSize: style.middleText),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      message.display?.content ?? '',
                      style: TextStyle(
                          color: style.textSecond, fontSize: style.middleText)),
                )
              ]),
        ));
  }
}
