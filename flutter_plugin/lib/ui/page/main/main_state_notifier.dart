import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_plugin_tx_video/dreame_flutter_plugin_tx_video.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/quickjs/ffi.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/feature_module.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/configure/app_dynamic_res_config_provider.dart';
import 'package:flutter_plugin/common/configure/app_res_config_provider.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/event/account_info_event.dart';
import 'package:flutter_plugin/model/event/email_record_event.dart';
import 'package:flutter_plugin/model/event/refresh_message_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind/bind_page/mobile_bind_page.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/email_collection_respository.dart';
import 'package:flutter_plugin/ui/page/account/push/push_state_notifier.dart';
import 'package:flutter_plugin/ui/page/ads/home_ads_manager_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/call/video_call_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/main_repository.dart';
import 'package:flutter_plugin/ui/page/main/main_ui_state.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_handle_notifier.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/mall_plugin_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/message_main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/share/popup/device_share_popup.dart';
import 'package:flutter_plugin/ui/page/message/share/share_message_list_notifier.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_type.dart';
import 'package:flutter_plugin/ui/page/settings/upgrade/app_upgrade_state_notifier.dart';
import 'package:flutter_plugin/utils/burial_point_util.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/tx_event_report_impl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flutter_plugin/ui/page/main/home_rule_app_model.dart';

import 'scheme/scheme_type.dart';
part 'main_state_notifier.g.dart';

@riverpod
class MainStateNotifier extends _$MainStateNotifier {
  bool _shouldSwitchToPreviousTab = false;
  final Lock _lock = Lock();

  @override
  MainUIState build() {
    return const MainUIState();
  }

  void initData() {
    _lock.synchronized(() => _initData());
  }

  void _initData() {
    loadData();
    _registeMqttCallback();
    _checkPermission();
    _calcuBottomMargin();
    _loadSplashAdInfo();
    _checkMallUpgrade();
    _checkAppResConfig();
    _registePushToken();
    _initHomeDialog();
    doAlifyAuth();
    _checkMallUpgrade();
    _initHomeConfig();
    _initTxVideo();
  }

  void _initTxVideo() {
    TxVideoSdk().init(
        'https://license.vod2.myqcloud.com/license/v2/1344701477_1/v_cube.license',
        '16e93dfc413a5784799fe7d223879146');
    TxVideoSdk().eventReport = TxEventReportImpl();
  }

  Future<void> _checkPermission() async {
    await Permission.notification.request();
  }

  Future<void> _checkMallUpgrade() async {
    await ref
        .read(mallPluginNotifierProvider.notifier)
        .checkCommonMallPluginUpgrade(forceCheck: true);
  }

  Future<void> _calcuBottomMargin() async {
    bool isNotchScreen = await InfoModule().isNotchScreen();
    state = state.copyWith(tabBottomMargin: isNotchScreen ? 20 : 0);
  }

  void _registeMqttCallback() {
    MqttConnector().init();
    MqttConnector().setVideoCallCallback((did, timeout) {
      ref
          .read(videoCallStateNotifierProvider.notifier)
          .showVideoCall(did.toString(), timeout: timeout);
    });
    MqttConnector().setAppMessageCallback((type, body) async {
      // 首页刷新
      ref.read(homeStateNotifierProvider.notifier).refreshMsgCount();
      // 消息中心刷新
      await ref
          .read(messageMainStateNotifierProvider.notifier)
          .getMessageHomeRecord();
      await ref
          .read(shareMessageListNotifierProvider.notifier)
          .refreshShareMessage();
      if (type == 'DEVICE_SHARE') {
        Map<String, dynamic> map = jsonDecode(body ?? '');
        final shareMessage = ShareMessageModel.fromJson(map);
        final authBean = await AccountModule().getAuthBean();
        if (shareMessage.ackResult == 4 ||
            shareMessage.ackResult == 5 ||
            shareMessage.ackResult == 6) {
          // 0 未应答 1 接受 2 拒绝 3 失效 4delShare主人撤回 5 delBind被共享人解绑 6更新权限
          await ref
              .read(homeStateNotifierProvider.notifier)
              .refreshDevice(slience: true);
        }
        if (shareMessage.uid == authBean.uid &&
            OAuthModel.isOAuthModelValiad(authBean)) {
          if (shareMessage.needAck) {
            // to-do
            String langTag = await LocalModule().getLangTag();
            var title = shareMessage.localizationContents[langTag];
            if (title == null || title.isEmpty) {
              title = shareMessage.localizationContents['en'] ?? '';
            }
            var deviceName = shareMessage.localizationDeviceNames[langTag];
            if (deviceName == null || deviceName.isEmpty) {
              deviceName = shareMessage.localizationDeviceNames['en'] ?? '';
            }
            if (await UIModule().inFlutterPage()) {
              await SmartDialog.show(
                  tag: 'device_share_popup',
                  clickMaskDismiss: false,
                  animationType: SmartAnimationType.fade,
                  builder: (context) {
                    return DeviceSharePopup(
                        deviceName ?? '', title ?? '', shareMessage.img,
                        messageId: shareMessage.messageId,
                        ackResult: shareMessage.ackResult,
                        did: '${shareMessage.deviceId}',
                        model: shareMessage.model,
                        ownUid: shareMessage.ownUid,
                        dismissCallback: () =>
                            SmartDialog.dismiss(tag: 'device_share_popup'));
                  });
            } else {
              MessageChannel().showShareDialog(
                  deviceName,
                  title,
                  shareMessage.img,
                  shareMessage.messageId,
                  shareMessage.ackResult,
                  '${shareMessage.deviceId}',
                  shareMessage.model,
                  shareMessage.ownUid);
            }
          } else {
            // 刷分享消息的列表
            EventBusUtil.getInstance()
                .fire(ShareMessageEvent(shareMessage.deviceId.toString()));
          }
        } else {
          // 刷分享消息的列表
          EventBusUtil.getInstance()
              .fire(ShareMessageEvent(shareMessage.deviceId.toString()));
        }
      } else if (type == 'REFRESH_DEVICE') {
        EventBusUtil.getInstance().fire(RefreshMessageEvent());
      }
    });
  }

  void _registePushToken() {
    ref.watch(pushStateNotifierProvider.notifier).registerPushToken();
  }

  void doAlifyAuth() {
    AccountModule().doAlifyAuth();
  }

  void _initHomeConfig() {
    FeatureModule().initHomeConfig();
  }

  Future<void> _checkAppResConfig() async {
    await ref.read(appResConfigProviderProvider.notifier).checkAppResConfig();
    await ref
        .read(appDynamicResConfigProviderProvider.notifier)
        .checkAppDynamicResConfig();
  }

  Future<void> _initHomeDialog() async {
    await ref
        .read(dialogJobManagerProvider.notifier)
        .reset()
        .then(
            (value) => ref.watch(privacyPolicyProvider.notifier).checkPrivacy())
        .then((value) => BurialPointUtil().updateConfig(agreePrivacy: true))
        .then((value) => ref.read(mainRepositoryProvider).getUserInfo())
        .then((value) => ref
            .watch(appUpgradeStateNotifierProvider.notifier)
            .checkNewVersion())
        .then((value) =>
            _checkBindAlert(showImmediately: false, checkLocal: true))
        .then((value) => _checkOverSeaEmailCollection())
        .then((value) => ref
            .read(userConfigPageStateNotifierProvider
                .call(UserConfigType.uxPlan)
                .notifier)
            .checkUxPlanDialog())
        .then(
            (value) => ref.watch(homeAdsManagerProvider.notifier).loadHomeAd())
        .then((value) => _checkUserMark())
        .then((value) =>
            ref.read(homeStateNotifierProvider.notifier).checkDeviceGuide())
        .then((value) => _dialogJobReady())
        .catchError((e) => LogUtils.e('initHomeDialog error: $e'));
  }

   void _dialogJobReady() {
    if (RegionStore().isChinaServer()) {
      ref.read(dialogJobManagerProvider.notifier).areUReady();
    }
  }

  Future<void> _checkOverSeaEmailCollection() async {
    try {
      if (RegionStore().currentRegion.countryCode.toLowerCase() == 'cn') return;
      UserInfoModel? userInfo = await AccountModule().getUserInfo();
      String? uid = userInfo?.uid;
      if (uid == null) return;
      int? timestamp = await LocalStorage().getLong(
          'overser_emall_device_collection_$uid',
          fileName: 'keepWithoutUid');

      if (timestamp != null) {
        if (timestamp == 1) {
          //代表永远不弹
          return;
        }
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        DateTime today = DateTime.now();

        if (dateTime.year == today.year &&
            dateTime.month == today.month &&
            dateTime.day == today.day) {
          return;
        }
      }

      await ref.read(emailCollectionRespositoryProvider.notifier).updateEmail();
      bool? subscribed = await ref
          .read(emailCollectionRespositoryProvider.notifier)
          .getSubscribeStatus();
      if (subscribed == null) return;
      if (subscribed == false) {
        // ref
        //     .read(dialogJobManagerProvider.notifier)
        //     .sendJobMessage(DialogJob(DialogType.emailCollect));
      }
    } catch (e) {
      LogUtils.e('_checkOverSeaEmailCollection error: $e');
    }
  }

  /// 检查是否提示绑定手机号
  Future<bool> checkBindAlert() async {
    if (!RegionStore().isChinaServer()) return false;
    UserInfoModel? info = await AccountModule().getUserInfo();
    LogUtils.i('showBindAlert: ${info?.toString()}');
    if (info == null || info.uid.isEmpty) {
      info = await ref.read(mainRepositoryProvider).getUserInfo();
    }
    int phoneLength = info.phone?.length ?? 0;
    if (phoneLength > 0) return false;
    return true;
  }

  /// checkLocal true为是否要判断本地存储信息，以此来判断是否需要弹出，用于进入首页是否自动弹出绑定弹窗
  Future<bool> _checkBindAlert(
      {bool showImmediately = true, bool checkLocal = false}) async {
    bool showBind = await checkBindAlert();
    if (!showBind) return false;
    UserInfoModel? info = await AccountModule().getUserInfo();
    if (checkLocal) {
      String? alertUid = await LocalStorage()
          .getString('alert_phone_bind', fileName: 'saveNotLogin');
      if (alertUid == info?.uid) {
        return false;
      }
    }

    var alertEvent = AlertEvent(
      title: 'set_phone'.tr(),
      content: 'bind_signin_phone_code'.tr(),
      cancelContent: 'text_bind_skip'.tr(),
      confirmContent: 'Text_3rdPartyBundle_CreateDreameBundled_Now'.tr(),
      confirmCallback: _pushToBind,
    );
    if (showImmediately) {
      state = state.copyWith(event: alertEvent);
    } else {
      alertEvent.cancelCallback = () {
        saveNotLoginForAlertPhoneBind();
      };
      ref
          .read(dialogJobManagerProvider.notifier)
          .sendJobMessage(DialogJob(DialogType.bindPhone, bundle: alertEvent));
    }
    return true;
  }

  Future<void> saveNotLoginForAlertPhoneBind() async {
    UserInfoModel? info = await AccountModule().getUserInfo();
    await LocalStorage().putString('alert_phone_bind', info?.uid ?? '',
        fileName: 'saveNotLogin');
    ref.read(dialogJobManagerProvider.notifier).nextJob();
  }

  /// 检查用户评价弹窗
  Future<void> _checkUserMark() async {
    try {
      final show = await ref.read(mainRepositoryProvider).queryUserMarkStatus();
      if (show) {
        ref
            .read(dialogJobManagerProvider.notifier)
            .sendJobMessage(DialogJob(DialogType.userMark));
      }
    } catch (e) {
      LogUtils.e('checkUserMark error: $e');
    }
  }

  /// 更新用户评价状态
  Future<void> updateUserMark(int markType) async {
    try {
      await ref.read(mainRepositoryProvider).updateUserMark(markType);
    } catch (e) {
      LogUtils.e('submitUserMark error: $e');
    }
  }

  void changeTab(TabItemType tabType) {
    LogUtils.i('[Scheme]changeTab: ${tabType.name}  ，state.currentTab：${state
        .currentTab.name}');
    if (state.currentTab == tabType) { return; }
    int index = state.tabs.indexWhere((element) => element.type == tabType);
    LogUtils.i('[Scheme] index: $index');
    if (index == -1) return;
    // 使用addPostFrameCallback确保在Widget树构建完成后再执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectIndex(index);
    });
  }

  Future<void> selectIndex(int page) async {
    // 添加边界检查
    if (page < 0 || page >= state.tabs.length) {
      LogUtils.e('[MainStateNotifier] selectIndex: invalid page index $page');
      return;
    }

    TabItem tab = state.tabs[page];
    if (tab.type == TabItemType.explore || tab.type == TabItemType.mall) {
      if (await _checkBindAlert()) return;
    }
    UserInfoModel? info = await AccountModule().getUserInfo();
    if (tab.type == TabItemType.overseasMall) {
      if (info == null ||
          info.email == null ||
          info.email?.isEmpty == true ||
          info.mailChecked == 0) {
        showEmailCheckDialog(shouldSwitchToPreviousTab: true);
      }
      var currentPage = state.currentPage;
      state = state.copyWith(
        currentPage: page,
        prePage: currentPage,
        showEmailCheckDialog: false,
        userEmail: info?.email,
        currentTab: tab.type,
      );
    }
    EventBusUtil.getInstance().fire(SelectTabEvent(tabItemType: tab.type));
    var currentPage = state.currentPage;
    state = state.copyWith(
      currentPage: page,
      prePage: currentPage,
      showEmailCheckDialog: false,
      userEmail: info?.email,
      currentTab: tab.type,
    );
  }

  bool haveTargetTab(TabItemType tabType) {
    LogUtils.i(
        '[Scheme] tabType : ${tabType.name} ,state.tabs.length: ${state.tabs.length}');
    return state.tabs.any((element) => element.type == tabType);
  }

  /// 当前tab是否是目标tab
  bool isTargetTab(TabItemType targetTab) {
    int targetIndex =
        state.tabs.indexWhere((element) => element.type == targetTab);
    return state.currentPage == targetIndex;
  }

  Future<void> selectThemeType(TabItemType type) async {
    int index = state.tabs.indexWhere((element) => element.type == type);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectIndex(index);
    });
  }

  void _pushToBind() {
    state = state.copyWith(
      event: PushEvent(
        path: MobileBindPage.routePath,
        func: RouterFunc.push,
      ),
    );
  }

  void showToast(String text,
      {Duration duration = const Duration(seconds: 10)}) {
    Future.delayed(duration, () {
      state = state.copyWith(event: ToastEvent(text: text));
    });
  }

  void showLoading(bool isLoading) {
    state = state.copyWith(event: LoadingEvent(isLoading: isLoading));
  }

  /// 处理广告弹窗点击事件跳转
  void handleAdJump(ADModel adModel) {
    LogUtils.i(
        '[Scheme] MainStateNotifier handleAdJump adModel: ${adModel.jumpType}, ${adModel.androidJumpLink}, ${adModel.iosJumpLink}');
    String type = adModel.jumpType;
    Map<String, dynamic> extMap = {};
    String jumpLink =
        Platform.isAndroid ? adModel.androidJumpLink : adModel.iosJumpLink;
    if (type == 'web') {
      extMap['url'] = jumpLink;
    } else if (type == 'web_external') {
      extMap['url'] = jumpLink;
    } else if (type == 'app') {
      extMap['page'] = jumpLink;
    } else if (type == 'mall') {
      extMap['url'] = jumpLink;
    } else if (type == 'wx_applet') {
      if (adModel.ext != null && adModel.ext!.isNotEmpty) {
        Map<String, dynamic> extJson = jsonDecode(adModel.ext!);
        extMap['id'] = extJson['applet_id'];
        extMap['path'] = jumpLink;
      }
    } else if (type == 'home_tab') {
      extMap['type'] = type;
    } else if (type == 'community') {
      extMap['url'] = jumpLink;
    }
    ref
        .read(schemeHandleNotifierProvider.notifier)
        .handleSchemeJump(SchemeType(type.toUpperCase()), extMap);
  }

  Future<void> loadData() async {
    List<TabItem> items = [];
    if (RegionStore().isChinaServer()) {
      HomeRuleAppModel? serTabConfigs;
      // 1. 先尝试并发获取接口和缓存
      Future<HomeRuleAppModel?> onlineFuture =
          ref.read(mainRepositoryProvider).getHomeOnlineConfig();
      Future<HomeRuleAppModel?> cacheFuture =
          ref.read(mainRepositoryProvider).readCacheAppRuleList();

      try {
        // 2. 300ms内优先用接口数据，超时则用缓存
        serTabConfigs = await onlineFuture.timeout(
          const Duration(milliseconds: 300),
          onTimeout: () async => await cacheFuture,
        );
      } catch (e) {
        // 3. 两者都失败，走本地json
        LogUtils.e('load app config error = $e');
        serTabConfigs = null;
      }

      // 4. 如果缓存也没有，再用本地json
      if (serTabConfigs == null || serTabConfigs.appButtomRuleMova == null) {
        Map<String, dynamic> json = jsonDecode(
            await rootBundle.loadString('assets/resource/app_config.json'));
        // 如果serTabConfigs为空，使用本地json
        LogUtils.i('Using local app_config.json as fallback');
        serTabConfigs = HomeRuleAppModel.fromJson(json);
      }
      
      // 5. 构建TabItem
      if (serTabConfigs.appButtomRuleMova != null) {
        items =
            await tabbarListWithDataSource(serTabConfigs.appButtomRuleMova!);
      }

      int index = serTabConfigs.appButtomRuleMova?.defaultIndex ?? 0;

      String schemeType =
          ref.read(schemeHandleNotifierProvider.notifier).state.schemeType;
      if (schemeType.isNotEmpty) {
        // 如果有scheme跳转，优先使用scheme跳转的tab
        // 这种方式，如果不toLowerCase转换，启动会白屏无法进入
        // index = items.indexWhere((element) => element.type.name.toLowerCase() == schemeType.toLowerCase());
        for (int i = 0; i < items.length; i++) {
          if (items[i].type.name == schemeType.toLowerCase()) {
            index = i;
            break; // 找到匹配项后立即退出循环
          }
        }
      }

      state = state.copyWith(
        tabs: items,
        tabPages: items.map((e) => e.content).toList(),
        tabBars: items.map((e) => e.bean).toList(),
        currentPage: index,
        currentTab: items[index].type,
      );
    } else {
      // 海外服务器逻辑
      items = [
        TabItem.overSeaCreate(type: TabItemType.device),
        TabItem.overSeaCreate(type: TabItemType.overseaMine),
      ];
      int index =
          items.indexWhere((element) => element.type == TabItemType.device);
      state = state.copyWith(
        tabs: items,
        tabPages: items.map((e) => e.content).toList(),
        tabBars: items.map((e) => e.bean).toList(),
        currentPage: index,
        currentTab: TabItemType.device,
      );
      unawaited(checkTabConfig());
    }
  }

  Future<List<TabItem>> tabbarListWithDataSource(
      HomeRuleAppButtomRuleMova source) {
    List<TabItem> itemList = [];
    for (int i = 0; i < source.tabList.length; i++) {
      if (source.tabList[i].tabType == 'device') {
        // 设备页tab
        TabItem item = TabItem.createWith(
          type: TabItemType.device,
          style: source.tabList[i].style,
        );
        itemList.add(item);
        continue;
      } else if (source.tabList[i].tabType == 'mall') {
        // 海外发现tab
        TabItem item = TabItem.createWith(
          type: TabItemType.mall,
          style: source.tabList[i].style,
          extraData: {'path': source.tabList[i].path},

        );
        itemList.add(item);
        continue; // 设备tab不需要添加
      } else if (source.tabList[i].tabType == 'explore') {
        // 海外发现tab
        TabItem item = TabItem.createWith(
          type: TabItemType.explore,
          style: source.tabList[i].style,
          extraData: {'path': source.tabList[i].path},
        );
        itemList.add(item);
        continue;
      } else if (source.tabList[i].tabType == 'web') {
        // 自定义Web
        TabItem item = TabItem.createWith(
          type: TabItemType.explore,
          style: source.tabList[i].style,
          extraData: {'path': source.tabList[i].path},
        );
        itemList.add(item);
        continue;
      } else if (source.tabList[i].tabType == 'mine') {
        // 海外商城tab
        TabItem item = TabItem.createWith(
          type: TabItemType.mine,
          style: source.tabList[i].style,
          extraData: {'path': source.tabList[i].path},
          
        );
        itemList.add(item);
        continue;
      }
    }
    return Future.value(itemList);
  }

  Future<void> checkTabConfig() async {
    try {
      final serTabConfigs =
          await ref.read(mainRepositoryProvider).checkTabConfig();
      // 比较tabConfigs和serTabConfigs内容是否一致
      // 实际目前商城Url每次请求都不一样,所以总会reload
      if (serTabConfigs.isNotEmpty) {
        reloadTabItems(TabItem.createList(serTabConfigs));
      }
    } catch (e) {
      LogUtils.e('main_state_notifier checkTabConfig error: $e');
    }
  }

  void reloadTabItems(List<TabItem> oversaeTabs) {
    List<TabItem> tabs = List.from(state.tabs);
    TabItem deviceItem = tabs.firstWhereOrNull((element) {
          return element.type == TabItemType.device;
        }) ??
        TabItem.overSeaCreate(type: TabItemType.device);
    TabItem mineInfoItem = tabs.firstWhereOrNull((element) {
          return element.type == TabItemType.overseaMine;
        }) ??
        TabItem.overSeaCreate(type: TabItemType.overseaMine);
    List<TabItem> items = [deviceItem, ...oversaeTabs, mineInfoItem];
    int index =
        items.indexWhere((element) => element.type == TabItemType.device);
    state = state.copyWith(
      tabs: items,
      tabPages: items.map((e) => e.content).toList(),
      tabBars: items.map((e) => e.bean).toList(),
      currentPage: index,
      currentTab: TabItemType.device,
    );
  }

  Future<void> updateUserInfo([String? defaultUrl]) async {
    try {
      var info = await ref.read(mainRepositoryProvider).getUserInfo();
      EventBusUtil.getInstance().fire(EmailRecordDialogResultEvent(
          result: EmailRecordDialogResult.success));
      if (info.mailChecked == 1) {
        var country = await LocalModule().getCountryCode();
        String? shopifyUrl = await ref
            .read(mainRepositoryProvider)
            .getShopifyUrl(info.email ?? '', country);
        if (shopifyUrl != null && shopifyUrl.isNotEmpty) {
          EventBusUtil.getInstance()
              .fire(RefreshOverseasMalldEvent(url: shopifyUrl));
        }
      }
      state = state.copyWith(userEmail: info.email);
    } catch (e) {
      LogUtils.e('updateUserInfo error: $e');
    }
  }

  Future<bool> sendEmailCheckVerificationCode(String? email) async {
    if (email != null && email.length > 45) {
      showToast('email_too_long'.tr(), duration: Duration.zero);
      return false;
    }
    state = state.copyWith(isLoading: true, smsTrCodeRes: null);
    String lang = await LocalModule().getLangTag();
    try {
      var ret = await ref
          .read(mainRepositoryProvider)
          .sendEmailCheckVerificationCode(email ?? '', lang);
      state = state.copyWith(smsTrCodeRes: ret);
      showToast('send_success'.tr(), duration: Duration.zero);
      return true;
    } catch (e) {
      if (e is DreameException) {
        var code = e.code;
        switch (code) {
          case 10007:
            showToast('mail_error'.tr(), duration: Duration.zero);
            break;
          case 11002:
            showToast('send_email_code_error'.tr(), duration: Duration.zero);
            break;
          case 11003:
            showToast('send_sms_too_frequent'.tr(), duration: Duration.zero);
            break;
          case 11004:
            showToast('reset_original_password_too_much'.tr(),
                duration: Duration.zero);
            break;
          case 30911:
            showToast('change_email_has_registered'.tr(),
                duration: Duration.zero);
            break;
          case 30913:
            showToast('can_not_change_original_email'.tr(),
                duration: Duration.zero);
            break;
          case 30410:
            showToast('user_not_exist'.tr(), duration: Duration.zero);
            break;
          case 30901:
            showToast('change_email_has_registered'.tr(),
                duration: Duration.zero);
            break;
          default:
            showToast('send_sms_code_error'.tr(), duration: Duration.zero);
            break;
        }
      } else {
        showToast('send_sms_code_error'.tr(), duration: Duration.zero);
      }
    } finally {
      showLoading(false);
    }
    return false;
  }

  Future<bool> verificationEmailCheckCode(
      String email, String codeValue) async {
    showLoading(true);
    String region = await LocalModule().getCountryCode();
    try {
      await ref.read(mainRepositoryProvider).verificationEmailCheckCode(
          email, state.smsTrCodeRes?.codeKey ?? '', codeValue, region);
      EventBusUtil.getInstance().fire(AccountInfoEvent());
      unawaited(updateUserInfo());
      return true;
    } catch (e) {
      LogUtils.e('main emailCheckDialogSend error: $e');
      if (e is DreameException) {
        var code = e.code;
        switch (code) {
          case 11010:
          case 11000:
            // 邮箱格式错误
            showToast('sms_code_invalid_expired'.tr(), duration: Duration.zero);
            break;
          case 11011:
          case 11001:
            showToast('email_code_invalid'.tr(), duration: Duration.zero);
            break;
          case 30901:
            showToast('change_email_has_registered'.tr(),
                duration: Duration.zero);
            break;
          default:
            // 其他错误
            showToast('operate_failed'.tr(), duration: Duration.zero);
            break;
        }
      } else {
        showToast('operate_failed'.tr(), duration: Duration.zero);
      }
    } finally {
      showLoading(false);
    }
    return false;
  }

  void emailCheckDialogCancel() {
    state = state.copyWith(showEmailCheckDialog: false);

    if (_shouldSwitchToPreviousTab == false) {
      return;
    }
    // 使用addPostFrameCallback确保在Widget树构建完成后再执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectIndex(state.prePage);
    });
    //取消进入海外商城埋点
    LogModule().eventReport(16, 1, int1: 2);
  }

  void showEmailCheckDialog({required bool shouldSwitchToPreviousTab}) {
    _shouldSwitchToPreviousTab = shouldSwitchToPreviousTab;
    state = state.copyWith(showEmailCheckDialog: true);
  }

  void _loadSplashAdInfo() {
    ref.watch(homeAdsManagerProvider.notifier).loadSplashAdInfo();
  }

  void reportChannelData(String value) {
    try {
      unawaited(ref.read(mainRepositoryProvider).reportChannelData(value));
    } catch (e) {
      LogUtils.e('reportChannelData error: $e');
    }
  }
  
  void setMallPath(String? path) {
    state = state.copyWith(mallPath: path);
    if (null != path) {
      changeTab(TabItemType.explore);
    }
  }
}
