import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/model/event/account_info_event.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page.dart';
import 'package:flutter_plugin/ui/page/email_collection/userinfo_change_event.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';
import 'package:flutter_plugin/ui/page/message/message_main_page.dart';
import 'package:flutter_plugin/ui/page/mine/mine_model.dart';
import 'package:flutter_plugin/ui/page/mine/mine_state_notifier.dart';
import 'package:flutter_plugin/ui/page/mine/widget/vip_store_widget.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/settings_page.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_default_image.dart';
import 'package:flutter_plugin/ui/widget/dm_setting_item.dart';
import 'package:flutter_plugin/ui/widget/mine/mine_email_collection_card.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:go_router/go_router.dart';

class MinePage extends BasePage {
  static const routePath = '/mine';

  const MinePage({super.key});

  @override
  MinePageState createState() => MinePageState();
}

class MinePageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  double _contentTopMargin = 50;
  EasyRefreshController? _controller;

  @override
  bool get showTitle => false;

  @override
  Future<void> initPageState() async {
    showTitle = false;
    if (Platform.isIOS) {
      _contentTopMargin = await InfoModule().isNotchScreen() ? 60 : 30;
    }
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: false,
    );
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().unRegister(this);
    super.dispose();
    _controller?.dispose();
  }

  @override
  void onAppResumeAndActive() {
    super.onAppResumeAndActive();
    // 新增前后台切换,刷新用户信息
    if (ref.exists(mineStateNotifierProvider)) {
      ref.read(mineStateNotifierProvider.notifier).refreshUserInfo();
    }
  }

  @override
  Future<void> initData() async {
    await ref.watch(mineStateNotifierProvider.notifier).initData();
    EventBusUtil.getInstance().register<UserInfoChangeEvent>(this, (event) {
      ref
          .watch(mineStateNotifierProvider.notifier)
          .closeTheEmailCollectionCard();
    });
    EventBusUtil.getInstance().register<AccountInfoEvent>(this, (event) {
      ref.read(mineStateNotifierProvider.notifier).initData();
    });
    EventBusUtil.getInstance().register<SelectTabEvent>(this, (event) {
      _onTabActive(event.tabItemType);
    });

  }

  @override
  void addObserver() {
    ref.listen(
        mineStateNotifierProvider.select(
          (value) => value.event,
        ), (previous, next) {
      responseFor(next);
    });
    ref.listen(
        mineStateNotifierProvider.select(
          (value) => value.refreshing,
        ), (previous, next) {
      if (!next) {
        _controller?.finishRefresh();
      }
    });
  }

  void _onTabActive(TabItemType tabItemType) {
    if (ref.exists(mineStateNotifierProvider) &&
        tabItemType == TabItemType.mine) {
      ref.read(mineStateNotifierProvider.notifier).refreshUserInfo();
    }
  }

  void pushToSetting() {
    GoRouter.of(context).push(SettingsPage.routePath).then(
        (value) => ref.read(mineStateNotifierProvider.notifier).getUserInfo());
  }

  void pushToAccountSetting() {
    GoRouter.of(context).push(AccountSettingPage.routePath).then(
        (value) => ref.read(mineStateNotifierProvider.notifier).getUserInfo());
  }

  ///

  Widget buildList(BuildContext context, StyleModel style,
      ResourceModel resource, List<MineModel> mineModels) {
    return Column(
      children: [
        for (int i = 0; i < mineModels.length; i++)
          DmSettingItem(
            endWidget: Image.asset(
              resource.getResource('icon_arrow_right2'),
              width: 24,
              height: 24,
            ),
            leadingTitle: mineModels[i].leftText,
            leadingTextStyle: style.normalStyle(fontSize: style.largeText),
            onTap: (ctx) {
              if (mineModels[i].tag == 'develop') {
                GoRouter.of(context).push(DeveloperMenuPage.routePath);
              } else {
                Function? ontap = mineModels[i].onTouchUp;
                if (ontap != null) {
                  ontap.call();
                }
              }
            },
          ),
      ],
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    var mineList =
        ref.watch(mineStateNotifierProvider.select((value) => value.mineList));
    return ThemeWidget(builder: (context, style, resource) {
      double statusBarHeight = MediaQuery.of(context).padding.top + 20;
      return Container(
        decoration: ref
                .watch(appThemeStateNotifierProvider.notifier)
                .isDarkTheme()
            ? BoxDecoration(color: style.bgBlack)
            : BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image:
                        AssetImage(resource.getResource('ic_home_device_bg')),
                    fit: BoxFit.fitWidth),
              ),
        child: EasyRefresh(
          controller: _controller,
          onRefresh: () {
            ref.read(mineStateNotifierProvider.notifier).refreshUserInfo();
            _controller?.finishRefresh();
          },
          child: CustomScrollView(slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              buildHeader(context, style, resource, statusBarHeight),
              if (ref.watch(
                  mineStateNotifierProvider.select((value) => value.showMall)))
                VipStoreWidget(style: style, resource: resource),
              if (ref.watch(mineStateNotifierProvider
                  .select((value) => value.showSubscribe)))
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: MineEmailCollectionCard(
                    exitCallBack: () {
                      showAlertDialog(
                          content: 'email_collection_subscribe_alert'.tr(),
                          cancelContent: 'not_minder'.tr(),
                          confirmContent: 'close'.tr(),
                          confirmCallback: () {
                            ref
                                .read(mineStateNotifierProvider.notifier)
                                .closeTheEmailCollectionCard();
                          },
                          cancelCallback: () {
                            ref
                                .read(mineStateNotifierProvider.notifier)
                                .closeTheEmailCollectionCard(forToday: false);
                          });
                    },
                    bindCallBack: () {
                      ref
                          .read(mineStateNotifierProvider.notifier)
                          .pushToBindEmail(false);
                    },
                    subscribeCallBack: () {
                      ref
                          .read(mineStateNotifierProvider.notifier)
                          .pushToSubscribe();
                    },
                    email: ref.watch(mineStateNotifierProvider
                        .select((value) => value.userInfo?.email)),
                  ),
                ),
              const SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: style.bgWhite,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < mineList.length; i++)
                      buildList(context, style, resource, mineList[i])
                  ],
                ),
              )
            ])),
          ]),
        ),
      );
    });
  }

  Widget buildHeader(context, StyleModel style, ResourceModel resource,
      double statusBarHeight) {
    UserInfoModel? userinfo =
        ref.watch(mineStateNotifierProvider.select((value) => value.userInfo));
    String nickName = userinfo?.uid ?? '';
    String avatar = '';
    String id = '';
    if (userinfo != null) {
      if (userinfo.name != '') {
        nickName = userinfo.name;
      }
      if (userinfo.avatar.isNotEmpty) {
        avatar = userinfo.avatar;
      }
      if (userinfo.uid != '') {
        id = userinfo.uid;
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: statusBarHeight,
        ),
        // 客服和消息
        Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20).withRTL(context),
            child: Semantics(
              explicitChildNodes: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Visibility(
                      visible: ref.watch(homeStateNotifierProvider
                          .select((value) => value.showCustomerS)),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 20).withRTL(context),
                        child: Semantics(
                          label: 'contact_customer_service'.tr(),
                          child: Image(
                            width: 24,
                            height: 24,
                            image: AssetImage(
                                resource.getResource('ic_home_customer_service')),
                          ).withDynamic().onClick(() {
                            List<BaseDeviceModel> deviceList = [];
                            if (ref.exists(homeStateNotifierProvider)) {
                              deviceList = ref.read(homeStateNotifierProvider
                                  .select((value) => value.deviceList));
                            }
                            ref.read(helpCenterRepositoryProvider).pushToChat(
                                context: context, deviceList: deviceList);
                          }),
                        ),
                      )),
                  Stack(
                    children: [
                      Semantics(
                        label: 'go_to_message_page'.tr(),
                        child: Image(
                          width: 24,
                          height: 24,
                          image: AssetImage(resource.getResource('ic_home_msg')),
                        ).withDynamic().onClick(
                          () {
                            LogModule().eventReport(5, 2);
                            GoRouter.of(context)
                                .push(MessageMainPage.routePath)
                                .then((value) => ref
                                    .read(homeStateNotifierProvider.notifier)
                                    .refreshMsgCount());
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Opacity(
                            opacity: ref.watch(homeStateNotifierProvider
                                    .select((value) => value.showMsgTips))
                                ? 1
                                : 0,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: style.red1),
                            )),
                      )
                    ],
                  ),
                ],
              ),
            )),
        Semantics(
          explicitChildNodes: true,
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40).withRTL(context),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Stack(
                      children: [
                        Semantics(
                          label: 'enter_account_settings_page'.tr(),
                          child: GestureDetector(
                            onTap: () {
                              LogModule().eventReport(7, 23);
                              pushToAccountSetting();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              width: 65,
                              height: 65,
                              child: ClipOval(
                                  child: avatar.isEmpty
                                      ? DMDefaultAvatorImage(
                                          uid: id,
                                          width: 60,
                                          height: 60,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: avatar,
                                          errorWidget: (context, string, _) {
                                            return DMDefaultAvatorImage(
                                              uid: id,
                                              width: 60,
                                              height: 60,
                                            );
                                          },
                                          width: 60,
                                          height: 60,
                                        )),
                            ),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                                // color: Colors.green,
                                child: Image.asset(
                                    resource.getResource('ic_mine_edit'),
                                    width: 24,
                                    height: 24))),
                      ],
                    ),
                  const SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                            nickName,
                            style: TextStyle(
                                fontSize: style.large,
                                color: style.carbonBlack,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Text(
                                '${'account'.tr()} $id',
                                style: TextStyle(
                                  color: style.textSecondGray,
                                  fontSize: style.smallText,
                                ),
                              ),
                            Semantics(
                              label: 'copy_mova_id'.tr(),
                              child: DMButton(
                                  backgroundColor: Colors.transparent,
                                  prefixWidget: Image.asset(
                                          resource.getResource('ic_copy'),
                                          width: 16,
                                          height: 16)
                                      .withDynamic(),
                                  onClickCallback: (ctx) async {
                                    await Clipboard.setData(
                                        ClipboardData(text: userinfo?.uid ?? ''));
                                    SmartDialog.showToast('copyed'.tr());
                                  }),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
