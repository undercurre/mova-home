import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/mine_share_permission_model.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing/device_sharing_list_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_contacts_detail_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_default_image.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../widget/dm_switch.dart';

class DeviceSharingContactsDetailPage extends BasePage {
  static const String routePath = '/device_sharing/contacts_detail';

  const DeviceSharingContactsDetailPage({
    super.key,
  });

  @override
  DeviceSharingContactDetailState createState() {
    return DeviceSharingContactDetailState();
  }
}

class DeviceSharingContactDetailState extends BasePageState
    with ResponseForeUiEvent {
  @override
  void initData() {
    super.initData();

    var entity =
        AppRoutes().getGoRouterStateExtra<SharedDeviceThumbEntity>(context);
    if (entity != null) {
      ref
          .read(deviceSharingContactsDetailStateNotifierProvider.notifier)
          .initData(entity);

      ref
          .read(deviceSharingContactsDetailStateNotifierProvider.notifier)
          .queryDevicePermissionInfo();
    }
  }

  @override
  void addObserver() {
    ref.listen(
        deviceSharingContactsDetailStateNotifierProvider
            .select((value) => value.uiEvent), (previous, next) {
      if (next != null) {
        responseFor(next);
      }
    });
  }

  Widget _getNavWidget(StyleModel style) {
    final sharedEntity = ref.watch(
        deviceSharingContactsDetailStateNotifierProvider
            .select((value) => value.sharedEntity));
    if (sharedEntity?.sharedState == SharedState.toShare) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (sharedEntity?.customName ?? '').isNotEmpty
                ? sharedEntity?.customName ?? ''
                : sharedEntity?.displayName ?? '',
            style: TextStyle(
              color: style.textMain,
              fontSize: style.secondary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'my_feedback_device'.tr(),
            style: TextStyle(
              color: style.textSecond,
              fontSize: style.middleText,
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'text_permission_update'.tr(),
            style: TextStyle(
              color: style.textMain,
              fontSize: style.largeText,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ],
      );
    }
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    bool isEditable =
        ref.watch(deviceSharingContactsDetailStateNotifierProvider).isEditable;
    final sharedEntity = ref.watch(
        deviceSharingContactsDetailStateNotifierProvider
            .select((value) => value.sharedEntity));
    return NavBar(
      backHidden: false,
      bgColor: style.bgGray,
      titleWidget: Container(
        alignment: Alignment.center,
        child: _getNavWidget(style),
      ),
      rightWidget: sharedEntity?.sharedState == SharedState.editPermission
          ? Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(right: 24),
              child: isEditable
                  ? Image.asset(
                      resource.getResource('search_right'),
                      width: 24,
                      height: 24,
                      color: style.textMainBlack,
                    )
                  : Image.asset(
                      resource.getResource('search_right'),
                      width: 24,
                      height: 24,
                      color: Colors.grey,
                    ),
            ).onClick(
              () {
                if (isEditable) {
                  ref
                      .read(deviceSharingContactsDetailStateNotifierProvider
                          .notifier)
                      .savePermissionUpdate();
                }
              },
            )
          : const SizedBox(height: 52, width: 60),
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          if (isEditable &&
              sharedEntity?.sharedState == SharedState.editPermission) {
            _showSaveAlert(context);
          } else {
            GoRouter.of(context).pop();
          }
        }
      },
    );
  }

  void _showSaveAlert(BuildContext context) {
    showCustomCommonDialog(
      content: 'text_permission_update_confirm_msg'.tr(),
      cancelContent: 'cancel'.tr(),
      confirmContent: 'save'.tr(),
      confirmCallback: () {
        ref
            .read(deviceSharingContactsDetailStateNotifierProvider.notifier)
            .savePermissionUpdate();
        GoRouter.of(context).pop();
      },
      cancelCallback: () {
        GoRouter.of(context).pop();
      },
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    var permissionList = ref
        .watch(deviceSharingContactsDetailStateNotifierProvider)
        .permissionList;
    final sharedEntity = ref.watch(
        deviceSharingContactsDetailStateNotifierProvider
            .select((value) => value.sharedEntity));
    return Container(
      color: style.bgGray,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // 头像和消息
          Container(
            height: 96.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: style.bgWhite,
              borderRadius: BorderRadius.all(Radius.circular(style.circular12)),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipOval(
                    child: (sharedEntity?.user?.avatar == null ||
                            sharedEntity?.user?.avatar?.isEmpty == true)
                        ? DMDefaultAvatorImage(
                            uid: sharedEntity?.user?.uid ?? '',
                            width: 56,
                            height: 56,
                          )
                        : CachedNetworkImage(
                            imageUrl: sharedEntity?.user?.avatar ?? '',
                            errorWidget: (context, string, _) =>
                                DMDefaultAvatorImage(
                              uid: sharedEntity?.user?.uid ?? '',
                              width: 56,
                              height: 56,
                            ),
                            width: 56,
                            height: 56,
                            placeholder: (context, string) =>
                                DMDefaultAvatorImage(
                              uid: sharedEntity?.user?.uid ?? '',
                              width: 56,
                              height: 56,
                            ),
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
                        sharedEntity?.user?.name ?? '',
                        style: TextStyle(
                          color: style.textMain,
                          fontSize: style.large,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'MOVA ID: ${sharedEntity?.user?.uid ?? ''}',
                        style: style.secondStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          permissionList.isNotEmpty
              ? Container(
                  color: style.bgGray,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'text_share_permissions'.tr(),
                        style:  TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: style.textMainBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'text_share_permissions_description'.tr(),
                        style: style.secondStyle(fontSize: 12),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),

          const SizedBox(height: 16.0),
          permissionList.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return _buildItemContent(
                        context, style, resource, permissionList[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12.0);
                  },
                  itemCount: permissionList.length,
                  shrinkWrap: true,
                )
              : const SizedBox(height: 40),

          sharedEntity?.sharedState == SharedState.toShare
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: 4, right: 4, top: 44, bottom: 16),
                  child: DMCommonClickButton.gradient(
                    borderRadius: style.buttonBorder,
                    width: double.infinity,
                    height: 48,
                    textColor: style.enableBtnTextColor,
                    disableTextColor: style.disableBtnTextColor,
                    backgroundGradient: style.confirmBtnGradient,
                    disableBackgroundGradient: style.disableBtnGradient,
                    text: 'share'.tr(),
                    onClickCallback: () async {
                      // 先检查设备分享权限, 然后添加分享者
                      final checkResult = await ref
                          .read(deviceSharingContactsDetailStateNotifierProvider
                              .notifier)
                          .checkDeviceShareStatus();

                      if (checkResult == true) {
                        final shareResult = await ref
                            .read(
                                deviceSharingContactsDetailStateNotifierProvider
                                    .notifier)
                            .shareWithUser();
                        if (shareResult == true) {
                          LogUtils.d('DeviceSharing: shareWithUser success');
                        } else {
                          LogUtils.d('DeviceSharing: shareWithUser error');
                        }
                      }
                    },
                  ),
                )
              : const SizedBox.shrink(),
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
        borderRadius: BorderRadius.circular(style.circular8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 文本内容
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: item.title ?? '',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: style.textMain,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () {
                        showMixableTextImageDialog(
                            item.desc ?? '', item.imageUrl, 'know'.tr(),
                            clickMaskDismiss: false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Image.asset(
                          resource.getResource('icon_share_introduce'),
                          width: 15,
                          height: 15,
                        ).withDynamic(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 间距
          const SizedBox(width: 16),
          // CupertinoSwitch
          SizedBox(
            width: 60,
            height: 24,
            child: DMSwitch(
              width: 46,
              height: 24,
              activeImage: AssetImage(resource.getResource('btn_switch_on')),
              inActiveImage: AssetImage(resource.getResource('btn_switch_off')),
              value: item.isOn ?? false,
              onChanged: (value) {
                if (item.permitKey != null) {
                  item.clickCount++;
                  bool shouldSaveAsTrue = item.clickCount % 2 != 0;

                  ref
                      .read(deviceSharingContactsDetailStateNotifierProvider
                          .notifier)
                      .updatePermission(
                          {item.permitKey!: value}, shouldSaveAsTrue);
                  item.isOn = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
