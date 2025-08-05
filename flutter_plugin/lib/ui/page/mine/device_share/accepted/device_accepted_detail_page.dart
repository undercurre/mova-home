import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/device_accepted_detail_state_notifier.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/mine_share_permission_model.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:go_router/go_router.dart';

class DeviceAcceptedDetailPage extends BasePage {
  static const String routePath = '/device_accepted/device_detail';

  const DeviceAcceptedDetailPage({
    super.key,
  });

  @override
  DeviceAcceptedDetailState createState() {
    return DeviceAcceptedDetailState();
  }
}

class DeviceAcceptedDetailState extends BasePageState with ResponseForeUiEvent {
  @override
  Future<void> initData() async {
    super.initData();
    var entity =
        AppRoutes().getGoRouterStateExtra<SharedDeviceThumbEntity>(context);
    if (entity != null) {
      ref
          .read(deviceAcceptedDetailStateNotifierProvider.notifier)
          .initData(entity);
      await ref
          .read(deviceAcceptedDetailStateNotifierProvider.notifier)
          .queryDevicePermissionInfo();
    }
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      backHidden: false,
      bgColor: style.bgGray,
      titleWidget: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'device_share'.tr(),
              style: TextStyle(
                color: style.textMain,
                fontSize: style.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
    var permissionList =
        ref.watch(deviceAcceptedDetailStateNotifierProvider).permissionList;
    final sharedEntity = ref.watch(deviceAcceptedDetailStateNotifierProvider
        .select((value) => value.sharedEntity));
    return Container(
      color: style.bgGray,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // 设备信息
          Container(
            height: 92,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: style.bgWhite,
              borderRadius: BorderRadius.all(Radius.circular(style.circular8)),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: sharedEntity?.mainImage?.imageUrl?.isEmpty == true
                        ? Image.asset(
                            resource.getResource('ic_placeholder_robot'),
                            width: 64,
                            height: 64,
                          )
                        : CachedNetworkImage(
                            imageUrl: sharedEntity?.mainImage?.imageUrl ?? '',
                            errorWidget: (context, string, _) => Image.asset(
                              resource.getResource('ic_placeholder_robot'),
                              width: 64,
                              height: 64,
                            ),
                            width: 64,
                            height: 64,
                          ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sharedEntity?.displayName ?? '',
                        style: TextStyle(
                            fontSize: 16.0,
                            overflow: TextOverflow.ellipsis,
                            color: style.textMain),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            color: style.bgGray,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'text_share_permissions'.tr(),
                   style: style.fifthStyle(),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'text_be_shared_permission_desc'.tr(),
                  style: style.textNormalStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24.0),
          ListView.separated(
            itemBuilder: (context, index) {
              return _buildItemContent(
                  context, style, resource, permissionList[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16.0);
            },
            itemCount: permissionList.length,
            shrinkWrap: true,
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildItemContent(
    BuildContext context,
    StyleModel style,
    ResourceModel resource,
    MineSharePermissionModel item,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: style.bgWhite,
        borderRadius: BorderRadius.circular(style.cellBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 权限开关
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    item.title ?? '',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: style.textMain,
                    ),
                  ),
                  const SizedBox(width: 4.0), // 增加间距
                  Image.asset(
                    resource.getResource('icon_share_introduce'),
                    width: 18,
                    height: 18,
                  ).withDynamic().onClick(() {
                    showMixableTextImageDialog(
                        item.desc ?? '', item.imageUrl, 'know'.tr(),
                        clickMaskDismiss: false);
                  }),
                ],
              ),
              SizedBox(
                height: 22,
                child: Center(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    item.isOn == true
                        ? 'text_permission_enable'.tr()
                        : 'text_permission_disable'.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          item.isOn == true ? style.green : style.textDisable,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
