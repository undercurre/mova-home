import 'dart:async';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart'
    as local_storage;
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/configure/user_info_store.dart';
import 'package:flutter_plugin/common/network/http/mall_auth_manager.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/account/mall_my_info_res.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/email_collection_respository.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/mine_email_bind_page.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_page.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_page.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/language/language_picker_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/mall_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/mall_plugin_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/device_share_page.dart';
import 'package:flutter_plugin/ui/page/mine/mine_model.dart';
import 'package:flutter_plugin/ui/page/mine/mine_repository.dart';
import 'package:flutter_plugin/ui/page/mine/mine_ui_state.dart';
import 'package:flutter_plugin/ui/page/mine/mixin/store_vip_mixin.dart';
import 'package:flutter_plugin/ui/page/settings/about/about_page.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/common/common_settings_page.dart';
import 'package:flutter_plugin/ui/page/settings/settings_page.dart';
import 'package:flutter_plugin/ui/page/voice/voice_control_page.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mine_state_notifier.g.dart';

@riverpod
class MineStateNotifier extends _$MineStateNotifier with StoreVipMixin {
  @override
  MineUiState build() {
    return MineUiState();
  }

  Future<void> initData() async {
    await getUserInfo();
    await getMallMyInfo();
  }

  Future<void> getUserInfo() async {
    // 在请求获得之前，先获取原生的个人信息
    UserInfoModel? userInfo = await AccountModule().getUserInfo();
    unawaited(_checkSubScribeStatus());
    if (userInfo == null) return;
    state = state.copyWith(userInfo: userInfo);
    await getSettingItem();
  }

  /// 获取商城User 信息
  Future<void> getMallMyInfo() async {
    try {
      // 如果海外地区，不能获取商城信息
      final mallInfo =
          await ref.read(mallAuthManagerProvider.notifier).getMallMyInfo();
      if (mallInfo == null) return;
      _handleVipInfo(mallInfo, mallInfo.level, mallInfo.point);
    } catch (e) {
      _handleVipInfo(null, null, null);
      LogUtils.e('getMallMyInfo error: $e');
    }
    try {
      // 如果海外地区，不能获取商城信息
      final banners = await ref.read(mineRepositoryProvider).getMallBanner();
      final list = banners.where((element) => element.image != null).toList();
      state = state.copyWith(vipBanners: list);
    } catch (e) {
      LogUtils.e('getMallBanner error: $e');
    }
  }

  void _handleVipInfo(
      MallMyInfoRes? mallInfo, String? vipLevel, int? vipPoint) {
    switch (vipLevel?.toLowerCase()) {
      case 'v1': // 普通会员
        state = state.copyWith(
            mallInfo: mallInfo,
            vipLevel: '普通会员',
            vipPoint: vipPoint?.toString() ?? '--');
        break;
      case 'v2':
        // 白银会员
        state = state.copyWith(
            mallInfo: mallInfo,
            vipLevel: '白银会员',
            vipPoint: vipPoint?.toString() ?? '--');
        break;
      case 'v3':
        // 黄金会员
        state = state.copyWith(
            mallInfo: mallInfo,
            vipLevel: '黄金会员',
            vipPoint: vipPoint?.toString() ?? '--');
        break;
      case 'v4':
        // 钻石会员
        state = state.copyWith(
            mallInfo: mallInfo,
            vipLevel: '钻石会员',
            vipPoint: vipPoint?.toString() ?? '--');
        break;
      case 'v5':
        // 黑金会员
        state = state.copyWith(
            mallInfo: mallInfo,
            vipLevel: '黑金会员',
            vipPoint: vipPoint?.toString() ?? '--');
        break;
      default:
        state = state.copyWith(mallInfo: mallInfo, vipLevel: '--');
        break;
    }
  }

  /// 海外邮箱订阅
  Future<void> _checkSubScribeStatus() async {
    if (true) {
      return;
    }

    ///FIXME: 海外邮箱订阅
    ///FIXME: 海外邮箱订阅
    ///FIXME: 海外邮箱订阅
    bool show = await checkShouldShowSubscribe();
    state = state.copyWith(showSubscribe: show);
  }

  /// 海外邮箱订阅
  Future<bool> checkShouldShowSubscribe() async {
    if (RegionStore().currentRegion.countryCode.toLowerCase() == 'cn') {
      return false;
    }

    UserInfoModel? userInfo = await AccountModule().getUserInfo();
    String? uid = userInfo?.uid;
    if (uid == null) return false;
    int? timestamp = await local_storage.LocalStorage().getLong(
        'overser_emall_device_collection_mine_$uid',
        fileName: 'keepWithoutUid');

    if (timestamp != null) {
      if (timestamp == 1) {
        //代表永远不弹
        return false;
      }
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      DateTime today = DateTime.now();

      if (dateTime.year == today.year &&
          dateTime.month == today.month &&
          dateTime.day == today.day) {
        return false;
      }
    }
    await ref.read(emailCollectionRespositoryProvider.notifier).updateEmail();
    bool? subscribed = await ref
        .read(emailCollectionRespositoryProvider.notifier)
        .getSubscribeStatus();
    if (subscribed == null) return false;
    return !subscribed;
  }

  Future<void> refreshUserInfo({bool silence = true}) async {
    try {
      var time = 0;
      if (!silence) {
        time = DateTime.now().millisecond;
        state = state.copyWith(refreshing: true);
      }
      UserInfoModel? userInfo =
          await ref.read(mineRepositoryProvider).getUserInfo();
      if (!silence) {
        state = state.copyWith(refreshing: false);
        time = DateTime.now().millisecond - time;
      }
      // 经验值 延迟800ms,finish 不然动画不流畅
      if (time < 800) {
        await Future.delayed(Duration(milliseconds: 800 - time), () {
          state = state.copyWith(userInfo: userInfo);
        });
      } else {
        state = state.copyWith(userInfo: userInfo);
      }
      unawaited(getMallMyInfo());

      // 获取未读消息接口
      if (ref.exists(homeStateNotifierProvider)) {
        ref.read(homeStateNotifierProvider.notifier).refreshMsgCount();
      }
    } catch (error) {
      LogUtils.d(error);
    }
  }

  List<List<MineModel>> overSeaItems() {
    List<List<MineModel>> overseaItems = [
      [
        MineModel(
          icon: '',
          leftText: 'device_share'.tr(),
          onTouchUp: pushToShare,
        ),
        MineModel(
          icon: '',
          leftText: 'Me_VoiceControl_Title'.tr(),
          onTouchUp: pushToVoiceController,
        ),
        MineModel(
          icon: '',
          leftText: 'widget'.tr(),
          onTouchUp: pushToWeiget,
        ),
        MineModel(
          icon: '',
          leftText: 'text_help_and_feedback'.tr(),
          onTouchUp: pushToHelpCenter,
        ),
        MineModel(
          icon: '',
          leftText: 'setting'.tr(),
          onTouchUp: pushSetting,
        ),
      ]
    ];

    return overseaItems;
  }

  List<List<MineModel>> zhItems() {
    List<List<MineModel>> zhItems = [
      [
        MineModel(
          icon: '',
          leftText: 'text_product_register'.tr(),
          onTouchUp: pushToProductRegister,
        ),
        MineModel(
          icon: '',
          leftText: 'device_share'.tr(),
          onTouchUp: pushToShare,
        ),
        MineModel(
          icon: '',
          leftText: 'Me_VoiceControl_Title'.tr(),
          onTouchUp: pushToVoiceController,
        ),
        MineModel(
          icon: '',
          leftText: 'widget'.tr(),
          onTouchUp: pushToWeiget,
        ),
        MineModel(
          icon: '',
          leftText: 'text_help_and_feedback'.tr(),
          onTouchUp: pushToHelpCenter,
        ),
        MineModel(
          icon: '',
          leftText: 'setting'.tr(),
          onTouchUp: pushSetting,
        ),
      ]
    ];
    return zhItems;
  }

  Future<void> getSettingItem() async {
    final country = await LocalModule().getCurrentCountry();
    final region = country.countryCode;
    bool showMall = false;
    if (region.toLowerCase() == 'cn' &&
        state.userInfo?.phoneCode == '86' &&
        state.userInfo?.phone?.length == 11) {
      showMall = true;
    }
    if (showMall) {
      final minItemList = zhItems();
      state = state.copyWith(mineList: minItemList, showMall: showMall);
    } else {
      final minItemList = overSeaItems();
      state = state.copyWith(mineList: minItemList, showMall: showMall);
    }
  }

  List<MineModel> getMallServiceItems() {
    List<MineModel> items = [
      MineModel(
        leftText: '我的订单',
        icon: 'ic_mine_order_new',
        onTouchUp: pushToOrder,
      ),
      MineModel(
        leftText: '退换售后',
        icon: 'ic_mine_excharge_new',
        onTouchUp: pushToAfterSales,
      ),
      MineModel(
        leftText: '商品评价',
        icon: 'ic_mine_comment_new',
        onTouchUp: pushToCNComments,
      ),
      MineModel(
        leftText: '收货地址',
        icon: 'ic_mine_address_new',
        onTouchUp: pushToReceiveAddress,
      ),
    ];

    return items;
  }

  void updateEvent(CommonUIEvent event) {
    state = state.copyWith(event: event);
  }

  Future<void> updateRegion(RegionItem item) async {
    await RegionStore().updateRegion(item);
    MqttConnector().disconnect();
    MessageChannel().changeCountry(item.countryCode);
    updateEvent(ToastEvent(text: 'setting_success'.tr()));
    // await getSettingItem();
  }
}

extension MineProviderItemClick on MineStateNotifier {
  //跳转到设备共享
  void pushToShare() {
    LogModule().eventReport(7, 13);
    PushEvent event = PushEvent(
      path: DeviceSharePage.routePath,
    );
    updateEvent(event);
  }

  //跳转到语音控制
  void pushToVoiceController() {
    LogModule().eventReport(7, 30);
    PushEvent event = PushEvent(
      path: VoiceControlPage.routePath,
    );
    updateEvent(event);
    // UIModule().openPage('/app/voiceControl');
  }

  //跳转到小组件
  Future<void> pushToWeiget() async {
    String lang = await LocalModule().getLangTag();
    String tenantId = await AccountModule().getTenantId();

    if (Platform.isIOS) {
      var url =
          'https://app-privacy-cn.iot.mova-tech.com/widget/index.html?tenantId=${tenantId}&lang=${lang}';
      PushEvent event = PushEvent(
        path: WebPage.routePath,
        extra: WebViewRequest(uri: WebUri(url), defaultTitle: 'widget'.tr()),
      );
      updateEvent(event);
    } else {
      await UIModule().openPage('/widget/appwidget/select');
    }

  }

  //跳转到语言选择
  void pushToLanguage() {
    LogModule().eventReport(7, 11);
    // LanguagePickerPage
    PushEvent event = PushEvent(
      path: LanguagePickerPage.routePath,
    );
    updateEvent(event);
  }

  //跳转到地区选择
  Future<void> pushToRegion() async {
    LogModule().eventReport(7, 12);
    RegionItem currentItem = await LocalModule().getCurrentCountry();
    PushEvent event = PushEvent(
      path: RegionPickerPage.routePath,
      extra: RegionPickerPage.createExtra(currentItem, showChangeDialog: true),
      pushCallback: (value) {
        if ((value is RegionItem) == false) return;
        updateRegion(value as RegionItem);
      },
    );
    updateEvent(event);
  }

  //跳转到消息设置
  void pushToMessage() {
    LogModule().eventReport(7, 8);
    updateEvent(PushEvent(path: MessageSettingPage.routePath));
  }

  //跳转到帮助中心
  void pushToHelpCenter() {
    LogModule().eventReport(7, 16);
    updateEvent(PushEvent(path: HelpCenterPage.routePath));
  }

  //跳转到关于
  void pushToAbout() {
    LogModule().eventReport(7, 31);
    updateEvent(PushEvent(path: AboutPage.routePath));
  }

  //跳转到通用设置
  void pushCommonSetting() {
    updateEvent(PushEvent(path: CommonSettingsPage.routePath));
  }

  //跳转到设置
  void pushSetting() {
    updateEvent(PushEvent(path: SettingsPage.routePath));
  }

  //跳转到消息设置
  void pushMessageSetting() {
    updateEvent(PushEvent(path: MessageSettingPage.routePath));
  }

  //跳转到账号设置
  void pushToAccountSetting() {
    updateEvent(PushEvent(path: AccountSettingPage.routePath));
  }

  //跳转到清除缓存
  void pushToClear() {
    LogModule().eventReport(7, 35);
    showAlert(
      text: 'clear_cache_confirm'.tr(),
      confirmString: 'dialog_determine'.tr(),
      confirmCallBack: () {
        LogModule().eventReport(7, 37);
        clear();
      },
      cancelCallback: () {
        LogModule().eventReport(7, 36);
      },
    );
  }

//这里是清楚缓存
  Future<void> clear() async {
    SmartDialog.showLoading();
    await clearCache();
    SmartDialog.dismiss(status: SmartStatus.loading);
    ToastEvent alert = ToastEvent(text: 'clear_cache_success'.tr());
    updateEvent(alert);
  }

  // 跳转到绑定邮箱
  void pushToBindEmail(bool forbind) {
    updateEvent(PushEvent(
        path: MineEmailBindPage.routePath,
        extra: forbind ? 'set_new_email'.tr() : 'change_email'.tr()));
  }

  void pushToSubscribe() {
    String email = state.userInfo?.email ?? '';
    if (email.isEmpty) {
      //跳转进绑定并且订阅
      pushToBindEmail(true);
    } else {
      //跳转进订阅
      subscribe();
    }
  }

  Future<void> closeTheEmailCollectionCard({bool forToday = true}) async {
    UserInfoModel? userInfo = await AccountModule().getUserInfo();
    String? uid = userInfo?.uid;
    if (uid == null) return;
    int timestamp = 1;
    if (forToday) {
      DateTime now = DateTime.now();
      timestamp = now.millisecondsSinceEpoch;
    }
    await local_storage.LocalStorage().putLong(
        'overser_emall_device_collection_mine_$uid', timestamp,
        fileName: 'keepWithoutUid');
    await _checkSubScribeStatus();
  }

  Future<void> subscribe() async {
    SmartDialog.showLoading();
    try {
      bool success = await ref
          .read(emailCollectionRespositoryProvider.notifier)
          .subscribe();

      SmartDialog.dismiss(status: SmartStatus.loading);
      if (success) {
        SmartDialog.showToast('operate_success'.tr());
      } else {
        SmartDialog.showToast('operate_failed'.tr());
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      SmartDialog.showToast('operate_failed'.tr());
    }
    await _checkSubScribeStatus();
  }

  Future<void> clearCache() async {
    await ref.read(pluginProvider.notifier).clear();
    ref.read(mallPluginNotifierProvider.notifier).clear();
    await UIModule().clearCache();
  }

  //跳转到我的订单
  void pushToOrder() {
    pushToMallWeb('pagesA/order/order');
  }

  //跳转到售后
  void pushToAfterSales() {
    pushToMallWeb('pagesA/refund/refund');
  }

  //跳转到收货地址
  void pushToReceiveAddress() {
    pushToMallWeb('pagesA/address/address-list');
  }

  //跳转到产品注册
  void pushToProductRegister() {
    pushToMallWeb('pagesA/serve/serve');
  }

  // 跳转到开发者选项
  void pushToDeveloper() {
    UIModule().openPage('/common/developer');
  }

  Future<void> pushToMallWeb(String path) async {
    PushEvent event = PushEvent(
      path: MallPage.routePath,
      extra: path,
    );
    updateEvent(event);
  }

  void showAlert(
      {required String text,
      String? cancelString,
      String? confirmString,
      Function()? confirmCallBack,
      Function()? cancelCallback}) {
    AlertEvent alert = AlertEvent(
      content: text,
      cancelContent: cancelString ?? 'cancel'.tr(),
      confirmContent: confirmString ?? 'confirm'.tr(),
      confirmCallback: confirmCallBack,
      cancelCallback: cancelCallback,
    );
    updateEvent(alert);
  }
}
