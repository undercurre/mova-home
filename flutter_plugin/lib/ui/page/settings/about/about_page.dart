import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/common/configure/app_config_prodiver.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/settings/about/about_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_page.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_type.dart';
import 'package:flutter_plugin/ui/page/settings/upgrade/app_upgrade_sheet.dart';
import 'package:flutter_plugin/ui/page/settings/upgrade/app_upgrade_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_setting_item.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends BasePage {
  static const String routePath = '/settings/about';

  const AboutPage({super.key});

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  int _clickCount = 0;
  int _clickTime = 0;

  @override
  String get centerTitle => 'about'.tr();

  @override
  void initData() {
    ref.read(aboutPageStateNotifierProvider.notifier).initData();
  }

  @override
  void addObserver() {
    ref.listen(
        aboutPageStateNotifierProvider.select((value) => value.uiNewVersion),
        (previous, next) {
      if (next) {
        SmartDialog.show(
          alignment: Alignment.bottomCenter,
          clickMaskDismiss: false,
          backDismiss: !ref.read(appUpgradeStateNotifierProvider).isForce,
          onDismiss: () {
            ref
                .read(appUpgradeStateNotifierProvider.notifier)
                .cancelDownloadTask();
          },
          builder: (context) {
            return AppUpgradeSheet(
              dismissCallback: () {
                SmartDialog.dismiss();
              },
            );
          },
        );
      }
    });
    ref.listen(aboutPageStateNotifierProvider.select((value) => value.uiEvent),
        (previous, next) {
      if (next != null) {
        responseFor(next);
      }
    });
  }

  Future<void> _showAppInfo() async {
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    if (-_clickTime < 500) {
      _clickTime = nowTime;
      _clickCount++;
      if (_clickCount == 10) {
        _clickCount = 0;
        _clickTime = 0;
        String appinfo = await ref
            .read(aboutPageStateNotifierProvider.notifier)
            .getAppInfo();
        // ignore: use_build_context_synchronously
        await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('App信息'),
                  content: Text(
                    appinfo,
                    style: const TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('确定',
                            style: TextStyle(color: Colors.black))),
                  ],
                ));
        return;
      }
    } else {
      _clickCount = 1;
    }
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      color: style.bgGray,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showAppInfo(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          resource.getResource('ic_app_logo'),
                          width: 72,
                          height: 72,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'MOVAhome',
                    style: TextStyle(
                        fontSize: 20,
                        color: style.textMain,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 36),
                      child: Text(
                          ref.watch(aboutPageStateNotifierProvider).appVersion,
                          style: style.secondStyle(fontSize: 16))),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(style.circular8))),
                    child: Semantics(
                      explicitChildNodes:  true,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        DmSettingItem(
                          leadingTitle: 'version_update_text'.tr(),
                          leadingTextStyle: TextStyle(
                              fontSize: style.largeText,
                              fontWeight: FontWeight.bold,
                              color: style.textMain),
                          showRedDot: ref.watch(aboutPageStateNotifierProvider
                              .select((value) => value.hasNewVersion)),
                          trailingText: ref
                              .watch(aboutPageStateNotifierProvider)
                              .newVersionName,
                          leadingTitleWidth: 200,
                          trailingWidth: 150,
                          onTap: (p0) => ref
                              .read(aboutPageStateNotifierProvider.notifier)
                              .checkUpdate(showToast: true, forceShow: true),
                        ),
                        DmSettingItem(
                          leadingTitle: 'user_privacy'.tr(),
                          leadingTextStyle: TextStyle(
                              fontSize: style.largeText,
                              fontWeight: FontWeight.bold,
                              color: style.textMain),
                          onTap: (_) {
                            GoRouter.of(context).push(WebPage.routePath,
                                extra: WebViewRequest(
                                    uri: WebUri(ref
                                        .read(aboutPageStateNotifierProvider)
                                        .privacyUrl),
                                    defaultTitle: 'user_privacy_pri_index'.tr()));
                          },
                        ),
                        DmSettingItem(
                          leadingTitle: 'user_agreement'.tr(),
                          leadingTextStyle: TextStyle(
                              fontSize: style.largeText,
                              fontWeight: FontWeight.bold,
                              color: style.textMain),
                          onTap: (_) {
                            GoRouter.of(context).push(WebPage.routePath,
                                extra: WebViewRequest(
                                    uri: WebUri(ref
                                        .read(aboutPageStateNotifierProvider)
                                        .agreementUrl),
                                    defaultTitle:
                                        'user_agreement_pri_index'.tr()));
                          },
                        ),
                        if (ref.watch(aboutPageStateNotifierProvider
                            .select((value) => value.permissionUrl.isNotEmpty)))
                          DmSettingItem(
                            leadingTitle: 'privacy_permission_request'.tr(),
                            leadingTextStyle: TextStyle(
                                fontSize: style.largeText,
                                fontWeight: FontWeight.bold,
                                color: style.textMain),
                            onTap: (_) {
                              GoRouter.of(context).push(WebPage.routePath,
                                  extra: WebViewRequest(
                                      uri: WebUri(ref
                                          .read(aboutPageStateNotifierProvider)
                                          .permissionUrl),
                                      defaultTitle:
                                          'privacy_permission_request'.tr()));
                            },
                          ),
                        if (ref.watch(aboutPageStateNotifierProvider
                            .select((value) => value.shareListUrl.isNotEmpty)))
                          DmSettingItem(
                            leadingTitle:
                                'privacy_third_platform_share_list'.tr(),
                            leadingTextStyle: TextStyle(
                                fontSize: style.largeText,
                                fontWeight: FontWeight.bold,
                                color: style.textMain),
                            onTap: (_) {
                              GoRouter.of(context).push(WebPage.routePath,
                                  extra: WebViewRequest(
                                      uri: WebUri(ref
                                          .read(aboutPageStateNotifierProvider)
                                          .shareListUrl),
                                      defaultTitle:
                                          'privacy_third_platform_share_list'
                                              .tr()));
                            },
                          ),
                        DmSettingItem(
                          leadingTitle: 'text_user_experience_plan'.tr(),
                          leadingTextStyle: TextStyle(
                              fontSize: style.largeText,
                              fontWeight: FontWeight.bold,
                              color: style.textMain),
                          onTap: (_) {
                            GoRouter.of(context).push(UserConfigPage.routePath,
                                extra: UserConfigType.uxPlan);
                          },
                        ),
                        DmSettingItem(
                          leadingTitle: 'personalized_ads_management'.tr(),
                          leadingTextStyle: TextStyle(
                              fontSize: style.largeText,
                              fontWeight: FontWeight.bold,
                              color: style.textMain),
                          onTap: (_) {
                            GoRouter.of(context).push(UserConfigPage.routePath,
                                extra: UserConfigType.adManage);
                          },
                        ),
                        Visibility(
                          visible: false,
                          child: DmSettingItem(
                            leadingTitle: 'app_res_change'.tr(),
                            leadingTextStyle: TextStyle(
                                fontSize: style.largeText,
                                fontWeight: FontWeight.bold,
                                color: style.textMain),
                            onTap: (_) {
                              GoRouter.of(context).push(UserConfigPage.routePath,
                                  extra: UserConfigType.appRes);
                            },
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible:
                ref.watch(appConfigProvider).value?.regionItem?.countryCode ==
                    'CN',
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 37),
                child: Text(
                  '苏ICP备2024122567号-4A',
                  style: TextStyle(
                      fontSize: style.smallText,
                      decoration: TextDecoration.underline,
                      decorationColor: style.click,
                      color: style.click),
                ),
              ).onClick(() {
                launchUrl(Uri.parse('https://beian.miit.gov.cn/'));
              }),
            ),
          ),
        ],
      ),
    );
  }
}
