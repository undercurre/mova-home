import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/model/event/refresh_message_event.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing/device_sharing_list_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_add_contacts_state_notifier.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_contacts_detail_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_search_list_page.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_default_image.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:lifecycle/lifecycle.dart';

class DeviceSharingAddContactsPage extends BasePage {
  static const String routePath = '/device_share/add_contacts';

  // 添加构造函数参数
  const DeviceSharingAddContactsPage({
    super.key,
  });

  @override
  DeviceSharingAddContactsPageState createState() =>
      DeviceSharingAddContactsPageState();
}

class DeviceSharingAddContactsPageState extends BasePageState
    with ResponseForeUiEvent {
  late EasyRefreshController _controller;

  DeviceSharingAddContactsPageState();

  @override
  Future<void> initPageState() async {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: false,
    );
  }

  @override
  void initData() {
    super.initData();
    var state = GoRouterState.of(context);
    if (state.extra is Map<String, dynamic>) {
      var entity = SharedDeviceThumbEntity();
      var dict = state.extra as Map<String, dynamic>;
      entity.did = dict['did'];
      entity.displayName = dict['displayName'];
      entity.permit = dict['permit'];
      entity.productId = dict['productId'];
      ref
          .read(deviceSharingAddContactsStateNotifierProvider.notifier)
          .initData(entity);
    } else {
      final entity =
          AppRoutes().getGoRouterStateExtra<SharedDeviceThumbEntity>(context);
      if (entity != null) {
        ref
            .read(deviceSharingAddContactsStateNotifierProvider.notifier)
            .initData(entity);
      }
    }
    EventBusUtil.getInstance().register<ShareMessageEvent>(this, (event) {
      ref
          .read(deviceSharingAddContactsStateNotifierProvider.notifier)
          .fetchMineSharedUserList();
    });
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);
    if (event == LifecycleEvent.visible) {
      ref
          .read(deviceSharingAddContactsStateNotifierProvider.notifier)
          .fetchMineSharedUserList();
    }
  }

  @override
  void addObserver() {
    _controller.resetHeader();
    ref.listen(
        deviceSharingAddContactsStateNotifierProvider
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
  Widget? get titleWidget => ThemeWidget(
        builder: (_, style, resource) {
          final sharedEntity = ref.watch(
              deviceSharingAddContactsStateNotifierProvider
                  .select((value) => value.sharedEntity));
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
        },
      );

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    List<MineRecentUser> userList =
        ref.watch(deviceSharingAddContactsStateNotifierProvider).userList;
    final sharedEntity = ref.watch(deviceSharingAddContactsStateNotifierProvider
        .select((value) => value.sharedEntity));
    return Container(
      color: style.bgGray,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: EasyRefresh(
              controller: _controller,
              onRefresh: () async {
                await ref
                    .watch(
                        deviceSharingAddContactsStateNotifierProvider.notifier)
                    .fetchMineSharedUserList();
                _controller.finishRefresh();
                _controller.resetHeader();
              },
              child: CustomScrollView(
                slivers: [
                  if (userList.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: userList.length,
                          separatorBuilder: (context, index) {
                            if (index < userList.length - 1) {
                              return Divider(height: 1, color: style.lightBlack1);
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                          itemBuilder: (context, index) {
                            return _buildItem(
                              style,
                              resource,
                              userList,
                              index,
                            );
                          },
                        ),
                      ),
                    ),
                  if (userList.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.12,
                            ),
                            Image.asset(
                              resource.getResource('no_share_device'),
                              height: 264,
                              width: 264,
                            ),
                            Center(
                            child: Text(
                              'device_share_user_list'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: style.textDisable,
                                  fontSize: style.middleText),
                            ),
                          ),]
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: MediaQuery.of(context).padding.bottom + 16, // 考虑底部安全距离
            ),
            child: DMButton(
              width: double.infinity,
              height: 48,
              borderRadius: style.buttonBorder,
              backgroundGradient: style.confirmBtnGradient,
              text: 'text_add_user_to_share'.tr(),
              textColor: style.btnText,
              onClickCallback: (context) {
                GoRouter.of(context).push(DeviceSharingSearchListPage.routePath,
                    extra: sharedEntity);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    StyleModel style,
    ResourceModel resource,
    List<MineRecentUser> userList,
    int index,
  ) {
    MineRecentUser user = userList[index];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: style.bgWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Slidable(
        key: ValueKey(user.uid),
        groupTag: '0',
        endActionPane: ActionPane(
          extentRatio: 0.30,
          motion: const ScrollMotion(),
          children: [
            SlideAction(
              color: style.red1,
              title: 'cancel_share'.tr(),
              onPressed: (context) {
                ref
                    .read(
                        deviceSharingAddContactsStateNotifierProvider.notifier)
                    .cancelShareDevice(user.uid ?? '');
              },
              borderRadius: _buildBorderRadiusIfNeeded(index, userList),
            ),
          ],
        ),
        child: _buildItemContent(style, resource, userList, index),
      ),
    );
  }

  BorderRadius _buildBorderRadiusIfNeeded(
    int index,
    List<MineRecentUser> userList,
  ) {
    if (userList.length == 1) {
      return const BorderRadius.only(
        topRight: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      );
    } else if (index == 0) {
      return const BorderRadius.only(
        topRight: Radius.circular(12.0),
      );
    } else if (index == userList.length - 1) {
      return const BorderRadius.only(
        bottomRight: Radius.circular(12.0),
      );
    } else {
      return BorderRadius.zero;
    }
  }

  BoxDecoration? _buildDecorationIfNeeded(
    int index,
    List<MineRecentUser> userList,
    StyleModel style,
  ) {
    if (userList.length == 1) {
      return BoxDecoration(
        color: style.bgWhite,
        borderRadius: BorderRadius.all(Radius.circular(style.cellBorder)),
      );
    } else if (index == 0) {
      return BoxDecoration(
        color: style.bgWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(style.cellBorder),
          topRight: Radius.circular(style.cellBorder),
        ),
      );
    } else if (index == userList.length - 1) {
      return BoxDecoration(
        color: style.bgWhite,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(style.cellBorder),
          bottomRight: Radius.circular(style.cellBorder),
        ),
      );
    } else {
      return BoxDecoration(
        color: style.bgWhite,
      );
    }
  }

  Widget _buildItemContent(
    StyleModel style,
    ResourceModel resource,
    List<MineRecentUser> userList,
    int index,
  ) {
    MineRecentUser user = userList[index];

    bool showStatus = user.sharedStatus == 0 //待接收
        ||
        user.sharedStatus == 1 //已接收
        ||
        user.sharedStatus == 2 //已拒绝
        ||
        user.sharedStatus == 3; //已过期

    Color statusColor = style.textSecond;
    String status = '';
    if (user.sharedStatus == 0) {
      statusColor = style.yellow;
      status = 'waiting_receive'.tr();
    } else if (user.sharedStatus == 1) {
      statusColor = style.green;
      status = 'already_accept'.tr();
    } else if (user.sharedStatus == 2) {
      status = 'already_reject'.tr();
    } else if (user.sharedStatus == 3) {
      status = 'already_invalid'.tr();
    }
    final sharedEntity = ref.watch(deviceSharingAddContactsStateNotifierProvider
        .select((value) => value.sharedEntity));
    bool showDetail = sharedEntity?.permit?.isNotEmpty == true;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 64.0,
      decoration: _buildDecorationIfNeeded(index, userList, style),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: ClipOval(
              child: (user.avatar ?? '').isEmpty == true
                  ? DMDefaultAvatorImage(
                      uid: user.uid,
                      width: 42,
                      height: 42,
                    )
                  : CachedNetworkImage(
                      imageUrl: user.avatar ?? '',
                      width: 42,
                      height: 42,
                      errorWidget: (context, url, error) =>
                          DMDefaultAvatorImage(
                        uid: user.uid,
                        width: 42,
                        height: 42,
                      ),
                      placeholder: (context, url) => DMDefaultAvatorImage(
                        uid: user.uid,
                        width: 42,
                        height: 42,
                      ),
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 22,
                  child: Text(
                    user.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style.mainStyle(),
                  ),
                ),
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  'ID: ${user.uid}',
                  style: style.secondStyle(fontSize: 12),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                          showDetail
                              ? Image.asset(
                                  resource.getResource('icon_arrow_right2'),
                                  width: 7,
                                  height: 13,
                                )
                              : const SizedBox.shrink()
                        ],
                      )
                    : const SizedBox(height: 12)
              ],
            ),
          )
        ],
      ),
    ).onClick(() {
      if (showDetail) {
        sharedEntity?.sharedState = SharedState.editPermission;
        sharedEntity?.user = user;
        sharedEntity?.sharedUid = user.uid;
        GoRouter.of(context).push(
          DeviceSharingContactsDetailPage.routePath,
          extra: sharedEntity,
        );
      }
    });
  }
}

class SlideAction extends StatelessWidget {
  const SlideAction({
    super.key,
    required this.color,
    required this.title,
    this.onPressed,
    this.flex = 1,
    this.borderRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(0.0),
      bottomRight: Radius.circular(0.0),
    ),
  });

  final Color color;
  final String title;
  final int flex;
  final BorderRadius borderRadius;
  final SlidableActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      flex: flex,
      backgroundColor: color,
      foregroundColor: Colors.white,
      onPressed: onPressed,
      label: title,
      borderRadius: borderRadius,
    );
  }
}
