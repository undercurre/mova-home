import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/event/app_lifecycle_event.dart';
import 'package:flutter_plugin/model/event/email_record_event.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/email_collection/email_collection_check_mixin.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/home/user_dialog_mixin.dart';
import 'package:flutter_plugin/ui/page/home/user_mark_mixin.dart';
import 'package:flutter_plugin/ui/page/main/main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/open_install_mixin.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_handle_notifier.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_upgrade_mixin.dart';
import 'package:flutter_plugin/ui/page/settings/about/user_experience_plan/ux_plan_mixin.dart';
import 'package:flutter_plugin/ui/page/voice/alexa/alexa_auth_page.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dialog/email_check_dialog.dart';
import 'package:flutter_plugin/ui/widget/nav/custom_navigation_bar.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:io';

class MainPage extends BasePage {
  static const String routePath = '/main_page';
  final int defaultPage;

  MainPage({super.key, this.defaultPage = 0});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends BasePageState
    with
        PrivacyPolicyUpgradeMixin,
        CommonDialog,
        UserMarkMixin,
        UxPlanMixin,
        ResponseForeUiEvent,
        EmailCollectionCheckMixin,
        UserDialogMixin {
  late PageController tabPageController;
  int _lastExitTime = 0;

  @override
  void initState() {
    super.initState();
    tabPageController =
        PageController(initialPage: (widget as MainPage).defaultPage);
    isMainPage = true;
    processPendingWakeupDataIfNeeded();
  }

  @override
  void initPageState() {
    showTitle = false;
    openInstallinitSDK();
  }

  @override
  void onAppResume() {
    super.onAppResume();

    /// 上报参数,android已安装的情况下，会通过微信开放标签打开APP，
    /// 所以将信息存在SP中，在这里读取上报
    if(Platform.isAndroid) {
      reportData();
    }
  }

  @override
  Future<void> initData() async {
    ref.read(mainStateNotifierProvider.notifier).initData();
    await MqttConnector().initMqttClient();
    LogModule()
        .eventReport(5, 1, str1: await FlutterTimezone.getLocalTimezone());
    EventBusUtil.getInstance().register<EmailRecordDialogEvent>(this, (event) {
      ref
          .read(mainStateNotifierProvider.notifier)
          .showEmailCheckDialog(shouldSwitchToPreviousTab: false);
    });
    await reportRegister();

    // 冷启动时,延迟800ms处理scheme事件
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        ref.read(schemeHandleNotifierProvider.notifier).dispatchSchemeEvent();
        LogUtils.i('main_page: [scheme] HandleNotifierProvider end');
      }
    });
  }

  @override
  void dispose() {
    MqttConnector().dispose();
    tabPageController.dispose();
    EventBusUtil.getInstance().unRegister(this);
    isMainPage = false;
    super.dispose();
  }

  @override
  void addObserver() {
    // 这里要要判断一下海外和国内，不然会调用多次监听ref.listen(dialogJobManagerProvider
    handleUserDialog(
        dialogTypes: RegionStore().isChinaServer()
            ? [
                DialogType.guide,
                DialogType.personalizedAd,
                DialogType.ad,
                DialogType.privacy,
                DialogType.upgrade,
                DialogType.bindPhone,
                DialogType.userMark,
                DialogType.uxPlan,
                DialogType.emailCollect,
              ]
            : []);

    ref.listen(mainStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });

    ref.listen(mainStateNotifierProvider.select((value) => value.isLoading),
        (previous, next) {
      if (next) {
        SmartDialog.showLoading();
      } else {
        SmartDialog.dismiss();
      }
    });
    ref.listen(
        mainStateNotifierProvider.select((value) => value.showEmailCheckDialog),
        (previous, next) {
      if (previous != next) {
        if (next) {
          _showEmailCheckDialog();
        }
      }
    });

    ref.listen(mainStateNotifierProvider.select((value) => value.currentPage),
        (previous, next) {
      if (tabPageController.hasClients && mounted) {
        // 添加额外的安全检查
        try {
          tabPageController.jumpToPage(next);
        } catch (e) {
          LogUtils.e('[MainPage] jumpToPage error: $e');
        }
      }
    });
    ref.listen(schemeHandleNotifierProvider.select((value) => value.schemeType),
        (previous, next) {
      LogUtils.i(
          '[Scheme] MainPageState addObserver previous: $previous, next: $next, [listen schemeHandleNotifierProvider]');
      handleSchemeEvent(next);
    });
    ref.listen(schemeHandleNotifierProvider.select((value) => value.uiEvent),
        (_, next) => _handleSchemePageEvent(next));
    ref.listen(pluginProvider, (previous, next) {});
  }

  void handleSchemeEvent(String next) {
    if (next.isNotEmpty) {
      Navigator.popUntil(context, (route) {
        return route.isFirst;
      });
      ref.read(schemeHandleNotifierProvider.notifier).handleSchemeEvent();
    }
  }

  /// scheme/推送/广告页面跳转事件
  Future<void> _handleSchemePageEvent(CommonUIEvent? event) async {
    if (event != null) {
      LogUtils.i('[Scheme] MainPageState _handleSchemePageEvent event is not null');
      if (event is SchemeEvent) {
        LogUtils.i(
            '[Scheme] MainPageState _handleSchemePageEvent event: ${event.type.name}');
        switch (event.type) {
          case 'APP':
            await UIModule().openPage(event.ext as String);
            break;
          case 'WEB_EXTERNAL':
            await launchUrlString(event.ext as String);
            break;
          case 'WX_APPLET':
            Map<String, String> ext = event.ext as Map<String, String>;
            int code = await UIModule()
                .openMiniProgram(ext['id'] ?? '', path: ext['path'] ?? '');
            if (code == 101) {
              responseFor(ToastEvent(
                  text: 'text_wechat_uninstall_operate_failed'.tr()));
            }
            break;
          case 'HOME_TAB':
            ref
                .read(mainStateNotifierProvider.notifier)
                .changeTab(event.ext as TabItemType);
            break;
          case 'ALEXA_AUTH':
            await AppRoutes().push(AlexaAuthPage.routePath, extra: event.ext);
            break;
          default:
            debugPrint('scheme type error type: ${event.type}');
            break;
        }
      } else {
        LogUtils.i('[Scheme] MainPageState _handleSchemePageEvent event is null');
        responseFor(event);
      }
    }
  }

  @override
  Widget? buildBottomNavigationBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      color: style.bgWhite,
      padding: EdgeInsets.only(
          bottom: ref.watch(mainStateNotifierProvider
              .select((value) => value.tabBottomMargin))).withRTL(context),
      child: CustomNavigationBar(
        items: ref
            .watch(mainStateNotifierProvider.select((value) => value.tabBars)),
        onSelected: (i) async {
          if (mounted) {
            try {
              // 添加延迟确保 Widget 树稳定
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted) {
                await ref
                    .read(mainStateNotifierProvider.notifier)
                    .selectIndex(i);
              }
            } catch (e) {
              LogUtils.e('[MainPage] selectIndex error: $e');
            }
          }
        },
        selectedIndex: ref.watch(
            mainStateNotifierProvider.select((value) => value.currentPage)),
      ),
    );
  }

  @override
  Future<bool> onBackClick() {
    if (DateTime.now().millisecondsSinceEpoch - _lastExitTime < 2000) {
      LogModule().close();
      return Future.value(true);
    }
    showToast('logout_back_again'.tr());
    _lastExitTime = DateTime.now().millisecondsSinceEpoch;
    return Future.value(false);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabPageController,
        children: ref.watch(
            mainStateNotifierProvider.select((value) => value.tabPages)));
  }

  Future<void> _showEmailCheckDialog() async {
    var email = (await AccountModule().getUserInfo())?.email;
    await SmartDialog.show(
      tag: 'email_check_dialog',
      builder: (context) {
        return EmailCheckDialogWidget(email: email, (email, code) async {
          bool result = await ref
              .read(mainStateNotifierProvider.notifier)
              .verificationEmailCheckCode(email, code);
          if (result) {
            await SmartDialog.dismiss(tag: 'email_check_dialog');
          }
        }, onSendClickCallback: (email) async {
          return ref
              .read(mainStateNotifierProvider.notifier)
              .sendEmailCheckVerificationCode(email);
        }, cancelCallback: () {
          ref.read(mainStateNotifierProvider.notifier).emailCheckDialogCancel();
          SmartDialog.dismiss(tag: 'email_check_dialog');
          EventBusUtil.getInstance().fire(EmailRecordDialogResultEvent(
              result: EmailRecordDialogResult.cancel));
        });
      },
      clickMaskDismiss: false,
    );
  }
}
