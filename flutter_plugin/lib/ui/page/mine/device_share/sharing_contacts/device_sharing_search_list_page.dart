import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing/device_sharing_list_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_contacts_detail_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_search_list_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_default_image.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:go_router/go_router.dart';

class DeviceSharingSearchListPage extends BasePage {
  static const String routePath = '/device_sharing/search_list';

  const DeviceSharingSearchListPage({
    super.key,
  });

  @override
  DeviceSharingSearchListState createState() {
    return DeviceSharingSearchListState();
  }
}

class DeviceSharingSearchListState extends BasePageState
    with ResponseForeUiEvent {
  late EasyRefreshController _controller;

  @override
  void initPageState() {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void initData() {
    var entity =
        AppRoutes().getGoRouterStateExtra<SharedDeviceThumbEntity>(context);
    if (entity != null) {
      ref
          .read(deviceSharingSearchListStateNotifierProvider.notifier)
          .initData(entity);
    }
  }

  @override
  void addObserver() {
    super.addObserver();

    ref.listen(
        deviceSharingSearchListStateNotifierProvider
            .select((value) => value.uiEvent), (previous, next) {
      responseFor(next);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget? get titleWidget => ThemeWidget(
        builder: (_, style, resource) {
          final sharedEntity = ref.watch(
              deviceSharingSearchListStateNotifierProvider
                  .select((value) => value.sharedEntity));
          return GestureDetector(
            onTap: () {},
            child: Column(
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
            ),
          );
        },
      );

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    bool nextStepEnable = ref.watch(deviceSharingSearchListStateNotifierProvider
        .select((value) => value.nextStepEnable));
    List userList = ref.watch(deviceSharingSearchListStateNotifierProvider
        .select((value) => value.userList));
    bool clickable = true;
    String searchedKeyword =
        ref.watch(deviceSharingSearchListStateNotifierProvider).searchedKeyword;
    return Container(
      color: style.bgGray,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: style.bgWhite,
                  borderRadius: BorderRadius.circular(style.circular12)),
              child: DMTextFieldItem(
                width: double.infinity,
                height: 50,
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                borderRadius: style.circular8,
                autofocus: true,
                showClear: true,
                obscureText: false,
                showBottomDivider: false,
                text: searchedKeyword,
                rightWidget: const SizedBox(),
                leftWidget: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Image.asset(resource.getResource('search'))),
                inputStyle: TextStyle(
                  color: style.textMain,
                  fontSize: style.middleText,
                ),
                placeText: 'login_user_hint'.tr(),
                onChanged: (value) {
                  ref
                      .read(
                          deviceSharingSearchListStateNotifierProvider.notifier)
                      .updateSearchedKeyword(value);
                },
                onSubmitted: (value) {
                  ref
                      .read(
                          deviceSharingSearchListStateNotifierProvider.notifier)
                      .updateSearchedKeyword(value);
                  handleForUserSearchAction();
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: DMCommonClickButton.gradient(
              borderRadius: style.buttonBorder,
              text: 'next'.tr(),
              textColor: style.enableBtnTextColor,
              disableTextColor: style.disableBtnTextColor,
              backgroundGradient: style.confirmBtnGradient,
              disableBackgroundGradient: style.disableBtnGradient,
              enable: nextStepEnable,
              onClickCallback: () {
                // tricky code for debouncing
                if (clickable) {
                  clickable = false;
                  handleForUserSearchAction();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    clickable = true;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 36),
          // List
          if (userList.isNotEmpty) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 0, bottom: 12),
              color: Colors.transparent,
              child: Text(
                'share_recent_contact'.tr(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: style.textMain,
                ),
              ),
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userList.length,
                separatorBuilder: (context, index) {
                  if (index < userList.length - 1) {
                    return const SizedBox(height: 12);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                itemBuilder: (context, index) {
                  return _buildItemContent(
                      context, style, resource, userList[index]);
                },
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemContent(
    BuildContext context,
    StyleModel style,
    ResourceModel resource,
    MineRecentUser user,
  ) {
    return Container(
      decoration: BoxDecoration(
          color: style.bgWhite,
          borderRadius: BorderRadius.all(Radius.circular(style.circular12))
      ),
      height: 96.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Avatar
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: ClipOval(
              child: (user.avatar ?? '').isEmpty == true
                  ? DMDefaultAvatorImage(
                      uid: user.uid,
                      height: 42,
                      width: 42,
                    )
                  : CachedNetworkImage(
                      imageUrl: user.avatar ?? '',
                      errorWidget: (context, string, _) {
                        return DMDefaultAvatorImage(
                          uid: user.uid,
                          height: 42,
                          width: 42,
                        );
                      },
                      placeholder: (context, url) => DMDefaultAvatorImage(
                        uid: user.uid,
                        width: 42,
                        height: 42,
                      ),
                      height: 42,
                      width: 42,
                    ),
            ),
          ),
          const SizedBox(width: 12.0),
          // Message and ID
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? '',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: style.textMain,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'ID: ${user.uid}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: style.textNormal,
                  ),
                ),
              ],
            ),
          ),
          // Right arrow
          Image.asset(
            resource.getResource('icon_arrow_right2'),
            width: 7,
            height: 13,
          ).flipWithRTL(context),
        ],
      ),
    ).onClick(() async {
      await checkUserBeforePush(user);
    });
  }

  void routerToUserDetail(MineRecentUser user) {
    var sharedEntity = ref.watch(deviceSharingSearchListStateNotifierProvider
        .select((value) => value.sharedEntity));
    sharedEntity?.user = user;
    sharedEntity?.sharedUid = user.uid;
    sharedEntity?.sharedState = SharedState.toShare;
    GoRouter.of(context).push(
      DeviceSharingContactsDetailPage.routePath,
      extra: sharedEntity,
    );
  }

  // 处理用户搜索
  Future<void> handleForUserSearchAction() async {
    final searchUserResult = await ref
        .read(deviceSharingSearchListStateNotifierProvider.notifier)
        .searchUser();
    if (searchUserResult.isNotEmpty == true) {
      MineRecentUser user = searchUserResult[0];
      await checkUserBeforePush(user);
    }
  }

  Future<void> checkUserBeforePush(MineRecentUser user) async {
    var sharedEntity = ref.watch(deviceSharingSearchListStateNotifierProvider
        .select((value) => value.sharedEntity));
    final statusResult = await ref
        .read(deviceSharingSearchListStateNotifierProvider.notifier)
        .checkDeviceShareStatus(
          sharedEntity?.did ?? '',
          user.uid ?? '',
          sharedEntity?.model ?? '',
        );
    if (statusResult) {
      dismissLoading();
      routerToUserDetail(user);
    }
  }
}
