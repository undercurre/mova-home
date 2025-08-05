import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/model/event/refresh_message_event.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing/device_sharing_list_state_notifier.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_add_contacts_page.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class DeviceSharingListPage extends BasePage {
  const DeviceSharingListPage({super.key});

  @override
  DeviceSharingListPageState createState() {
    return DeviceSharingListPageState();
  }
}

class DeviceSharingListPageState extends BasePageState
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
        .read(deviceSharingListStateNotifierProvider.notifier)
        .refreshSharingDeviceList();
    EventBusUtil.getInstance().register<RefreshMessageEvent>(this, (event) {
      ref
          .read(deviceSharingListStateNotifierProvider.notifier)
          .refreshSharingDeviceList();
    });
    EventBusUtil.getInstance().register<ShareMessageEvent>(this, (event) {
      ref
          .read(deviceSharingListStateNotifierProvider.notifier)
          .refreshSharingDeviceList();
    });
  }

  @override
  void addObserver() {
    ref.listen(
        deviceSharingListStateNotifierProvider.select((value) => value.uiEvent),
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
    List<DeviceModel> deviceList =
        ref.watch(deviceSharingListStateNotifierProvider).deviceList.where((element) => element.supportShare()).toList();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: style.bgGray,
      child: EasyRefresh(
        controller: _controller,
        onRefresh: () async {
          await ref
              .read(deviceSharingListStateNotifierProvider.notifier)
              .refreshSharingDeviceList();
          _controller.finishRefresh();
        },
        onLoad: () async {
          _controller.finishLoad();
        },
        child: SlidableAutoCloseBehavior(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 20),
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'text_no_device_to_share'.tr(),
                          style: TextStyle(
                              color: style.textDisable,
                              fontSize: style.middleText),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return _buildItemContent(style, resource, deviceList[index]);
              }
            },
            itemCount: deviceList.isNotEmpty ? deviceList.length : 1,
          ),
        ),
      ),
    );
  }

  Widget _buildItemContent(
    StyleModel style,
    ResourceModel resource,
    DeviceModel device,
  ) {
    Color statusColor = style.textSecond;
    String status = '';
    if (device.sharedTimes == 0) {
      statusColor = style.textSecond;
      status = 'not_share'.tr();
    } else {
      statusColor = style.green;
      status = 'shared'.tr();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      decoration: BoxDecoration(
        color: style.bgWhite,
        borderRadius: BorderRadius.all(Radius.circular(style.cellBorder)),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                    placeholder: (context, string) {
                      return Image.asset(
                        resource.getResource('ic_placeholder_robot'),
                        width: 64,
                        height: 64,
                      );
                    },
                    errorWidget: (context, string, _) {
                      return Image.asset(
                        resource.getResource('ic_placeholder_robot'),
                        width: 64,
                        height: 64,
                      );
                    },
                    width: 64,
                    height: 64,
                  ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  maxLines: 1,
                  device.getShowName(),
                  style: TextStyle(
                      color: style.carbonBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: statusColor,
                    fontSize: style.middleText,
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Image.asset(
                  resource.getResource('icon_arrow_right2'),
                  width: 7,
                  height: 13,
                ).flipWithRTL(context)
              ],
            ),
          )
        ],
      ),
    ).onClick(() {
      var sharedEntity = SharedDeviceThumbEntity();
      sharedEntity.customName = device.customName;
      sharedEntity.did = device.did;
      sharedEntity.displayName = device.deviceInfo?.displayName;
      sharedEntity.model = device.model;
      sharedEntity.mainImage = device.deviceInfo?.mainImage;
      sharedEntity.productId = device.deviceInfo?.productId;
      sharedEntity.permit = device.deviceInfo?.permit;
      sharedEntity.sharedState = SharedState.editPermission;
      GoRouter.of(context)
          .push(DeviceSharingAddContactsPage.routePath, extra: sharedEntity);
    });
  }
}

enum SharedState {
  toShare,
  editPermission,
}
