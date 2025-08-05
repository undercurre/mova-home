import 'dart:async';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:dreame_flutter_plugin_tx_video/dreame_flutter_plugin_tx_video.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/model/event/app_lifecycle_event.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/common/configure/app_config_prodiver.dart';
import 'package:flutter_plugin/common/configure/app_dynamic_res_config_provider.dart';
import 'package:flutter_plugin/common/configure/app_res_config_provider.dart';
import 'package:flutter_plugin/common/network/http/mall_auth_manager.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/common/providers/account_info_provider.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/email_collection_respository.dart';
import 'package:flutter_plugin/ui/page/account/push/push_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/device_status/key_define_provider.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_type.dart';
import 'package:flutter_plugin/utils/burial_point_util.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LifeCycleManager {
  LifeCycleManager._internal();

  factory LifeCycleManager() => _instance;
  static final LifeCycleManager _instance = LifeCycleManager._internal();
  late WidgetRef ref;
  bool _isFirstLogin = false;

  void attach(WidgetRef ref) {
    this.ref = ref;
    MessageChannel().attach(ref);
  }

  /// 清除push token,退出账号
  /// [logoutFuture] 退出/删除账号的异步操作，Future成功后进行数据清除，退到登录页面
  Future<void> logOut(
      {Future<bool> Function()? logoutFuture, bool resetStack = true}) async {
    LogModule().eventReport(100, 7, rawStr: StackTrace.current.toString());
    bool logoutSuccess = true;
    if (logoutFuture != null) {
      logoutSuccess = false;
      await ref.read(pushStateNotifierProvider.notifier).removePushToken();

      try {
        // 退出/删除账号

        logoutSuccess = await logoutFuture.call();
      } catch (e) {
        LogUtils.e('LifeCycleManager logOut error: $e');
      }
    }
    if (logoutSuccess) {
      // 取消所有请求
      DMHttpManager().cancelRequest();
      DMHttpManager().reset();
      await realLogout(resetStack: resetStack);
      await ref.read(homeStateNotifierProvider.notifier).homeDeviceVideoPlayerImpl.disposePlayer();
    }
  }

  /// 退出到登录页面
  /// 此方法中不能再调接口
  ///
  Future<void> realLogout({bool resetStack = true}) async {
    ref.read(privacyPolicyProvider.notifier).reset(null);
    MqttConnector().disconnect();
    await LocalStorage().clear();
    await ref.read(keyDefineProvider.notifier).clearKeyDefine();
    await ref.read(keyDefineProvider.notifier).init();
    await ref
        .read(pluginProvider.notifier)
        .clearCommonPlugin(type: CommonPluginType.appSource.value);
    ref.read(appResConfigProviderProvider.notifier).reset();
    ref.read(appDynamicResConfigProviderProvider.notifier).reset();
    TxVideoSdk().logout();
    EventBusUtil.destory();
    BurialPointUtil().clearUid();
    try {
      await AccountModule().prepareLogout();
    } catch (e) {
      LogUtils.e('--------- realLogout prepareLogout--------- $e');
    }

    if (!resetStack) {
      return;
    }
    if (!OAuthModel.isEmpty(ref.read(accountInfoProvider))) {
      ref.read(accountInfoProvider.notifier).refreshOAuthBean(null);
      await ref.read(appConfigProvider.notifier).resetApp();

    } else {
      // 判断当前页面是否在登录页,然后跳转
      var value = ref.read(appConfigProvider).asData?.value;
      var oAuthBean = value?.oAuthBean;
      LogUtils.i(
          '------------ isLoginOrSignOn 判断当前页面是否在登录页,然后跳转 ------------ $value');
      if (!OAuthModel.isEmpty(oAuthBean)) {
        ref.read(accountInfoProvider.notifier).refreshOAuthBean(null);
        await ref.read(appConfigProvider.notifier).resetApp();
      }
    }
  }

  Future<void> logingSuccess() async {
    _isFirstLogin = true;
    ref.read(emailCollectionRespositoryProvider.notifier).reset();
    EventBusUtil.getInstance().fire(ReportRegisterEvent());
    await ref.read(accountInfoProvider.notifier).initAuthBean();
    await ref
        .read(userConfigPageStateNotifierProvider
            .call(UserConfigType.uxPlan)
            .notifier)
        .agreeUXPlan();
    await AccountModule().loginSuccess();
    try {
      await checkLoginForMall();
    } catch (e) {
      LogUtils.e('LifeCycleManager logingSuccess error: $e');
    }
  }

  /// logingSuccess 方法不再做默认刷新RootPage操作
  Future<void> gotoMainPage() async {
    await ref.read(appConfigProvider.notifier).resetApp();
    await BurialPointUtil().updateConfig(agreePrivacy: true);
  }

  Future<void> checkLoginForMall() async {
    await ref
        .read(mallAuthManagerProvider.notifier)
        .getMallAuthInfo();
  }

  /// 是否是第一次登录
  bool checkFirstLogin() => _isFirstLogin;

  void setFirstLogin(bool isFirstLogin) {
    _isFirstLogin = isFirstLogin;
  }

  /// 注册成功后, 发起主动扫描附近设备
  Future<void> newUserRegisterSuccess() async {
    /// 记录一下,
    await LocalStorage().putBool('newUserRegisterSuccess', true);
  }
}
