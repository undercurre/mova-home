import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/model/event/refresh_message_event.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/message/share/popup/device_share_popup.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/device_accepted_detail_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/device_accepted_list_state_notifier.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/device_sharing_utils.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class DeviceAcceptedListPage extends BasePage {
  const DeviceAcceptedListPage({super.key});

  @override
  DeviceAcceptedListPageState createState() {
    return DeviceAcceptedListPageState();
  }
}

class DeviceAcceptedListPageState extends BasePageState
    with ResponseForeUiEvent {
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  bool get showTitle => false;

  @override
  void initData() {
    ref
        .read(deviceAcceptedListStateNotifierProvider.notifier)
        .refreshSharedDeviceList();
    EventBusUtil.getInstance().register<RefreshMessageEvent>(this, (event) {
      ref
          .read(deviceAcceptedListStateNotifierProvider.notifier)
          .refreshSharedDeviceList();
    });
  }

  @override
  void addObserver() {
    ref.listen(
        deviceAcceptedListStateNotifierProvider
            .select((value) => value.uiEvent), (previous, next) {
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
    List<DeviceModel> deviceList =
        ref.watch(deviceAcceptedListStateNotifierProvider).deviceList;
    return Container(
      color: style.bgGray,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: EasyRefresh(
              controller: _controller,
              onRefresh: () async {
                await ref
                    .watch(deviceAcceptedListStateNotifierProvider.notifier)
                    .refreshSharedDeviceList();
                _controller.finishRefresh();
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
                    if (deviceList.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Image.asset(
                            resource.getResource('no_share_device'),
                            height: 264,
                            width: 264,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'text_no_device_from_others'.tr(),
                                style: TextStyle(
                                    color: style.textDisable,
                                    fontSize: style.middleText),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return _buildItem(style, resource, deviceList[index]);
                    }
                  },
                  itemCount: deviceList.isNotEmpty ? deviceList.length : 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
      StyleModel style, ResourceModel resource, DeviceModel device) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Slidable(
        key: ValueKey(device.deviceInfo?.productId),
        groupTag: '0',
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const ScrollMotion(),
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Container(
                  margin: const EdgeInsets.only(right: 20).withRTL(context),
                  child: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                            color: style.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Image.asset(
                                resource
                                    .getResource('icon_message_item_delete'),
                                width: 18,
                                height: 18)
                            .onClick(
                          () {
                            /// 删除
                            ref
                                .read(deviceAcceptedListStateNotifierProvider
                                    .notifier)
                                .deleteSharedDevice(device.did);
                          },
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
        child: _buildItemContent(style, resource, device),
      ),
    );
  }

  Widget _buildItemContent(
      StyleModel style, ResourceModel resource, DeviceModel device) {
    bool showStatus = device.sharedStatus == 0 //未确认
        ||
        device.sharedStatus == 1 //已确认
        ||
        device.sharedStatus == 2; //拒绝

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.cellBorder)),
          color: style.bgWhite),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: (device.deviceInfo?.mainImage.imageUrl ?? '').isEmpty == true
                ? Image.asset(
                    resource.getResource('ic_placeholder_robot'),
                    width: 64,
                    height: 64,
                  )
                : CachedNetworkImage(
                    imageUrl: device.deviceInfo?.mainImage.imageUrl ?? '',
                    width: 64,
                    height: 64,
                    placeholder: (context, url) => Image.asset(
                      resource.getResource('ic_placeholder_robot'),
                      width: 64,
                      height: 64,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      resource.getResource('ic_placeholder_robot'),
                      width: 64,
                      height: 64,
                    ),
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                  ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Text(
                    maxLines: 2,
                    device.getShowName(),
                    style: TextStyle(
                        color: style.textMain,
                        fontWeight: FontWeight.bold,
                        fontSize: style.largeText),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'share_from'.tr(args: [
                    device.masterName ?? '',
                  ]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: style.textSecond,
                      fontSize: style.middleText),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DeviceShareUtils.formatDateTimeString(
                        device.updateTime ?? ''),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: style.textSecond,
                        fontSize: style.smallText),
                  ),
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
                                  color: device.sharedStatus == 1
                                      ? style.green
                                      : style.yellow,
                                  fontSize: style.middleText),
                              device.sharedStatus == 1
                                  ? 'already_accept'.tr()
                                  : 'waiting_receive'.tr(),
                            ).onClick(() async {
                              await SmartDialog.show(
                                  clickMaskDismiss: false,
                                  animationType: SmartAnimationType.fade,
                                  builder: (context) {
                                    return DeviceSharePopup(
                                      device.deviceInfo?.displayName ?? '',
                                      'device_share_from'.tr(args: [
                                        device.masterName ?? '',
                                        device.deviceInfo?.displayName ?? '',
                                      ]),
                                      device.deviceInfo?.mainImage.imageUrl ??
                                          '',
                                      ackResult: device.sharedStatus,
                                      did: device.did,
                                      model: device.deviceInfo?.model ?? '',
                                      ownUid: device.masterUid,
                                      dismissCallback: () =>
                                          SmartDialog.dismiss(),
                                    );
                                  });
                            }),
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
    ).onClick(() {
      if (device.deviceInfo?.permit?.isNotEmpty == true) {
        var sharedEntity = SharedDeviceThumbEntity();
        sharedEntity.customName = device.customName;
        sharedEntity.did = device.did;
        sharedEntity.permit = device.deviceInfo?.permit;
        sharedEntity.displayName = device.deviceInfo?.displayName;
        sharedEntity.model = device.model;
        sharedEntity.mainImage = device.deviceInfo?.mainImage;
        sharedEntity.productId = device.deviceInfo?.productId;

        GoRouter.of(context).push(
          DeviceAcceptedDetailPage.routePath,
          extra: sharedEntity,
        );
      }
    });
  }
}
