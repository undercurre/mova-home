import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/common/js_action/js_message.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/home/home_repository.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';
import 'package:flutter_plugin/ui/page/mine/warranty_cards/warranty_cards_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/product_list/product_list_page.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';

class WarrantyCardsPage extends BasePage {
  static const String routePath = '/warranty_cards_page';

  const WarrantyCardsPage({super.key});

  static Map<String, dynamic> createParams({
    required String url,
    required String title,
  }) {
    return {
      'url': url,
      'title': title,
    };
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _WarrantyCardsPageState();
  }
}

class _WarrantyCardsPageState extends BasePageState with ResponseForeUiEvent {
  InAppWebViewController? currentController;
  bool _showTitle = false;
  double progress = 0;

  @override
  void addObserver() {
    super.addObserver();

    ref.listen(
      warrantyCardsStateNotifierProvider.select(
        (value) => value.event,
      ),
      (previous, next) {
        responseFor(next);
      },
    );
  }

  @override
  Future<void> onLifecycleEvent(LifecycleEvent event) async {
    super.onLifecycleEvent(event);
    if (event == LifecycleEvent.visible) {
      LogUtils.d('----  WarrantyCardsPage visible ----');
      await _checkDeviceListIfNeeded();
    }
  }

  Future<void> _checkDeviceListIfNeeded() async {
    final result = await ref.read(homeRepositoryProvider).getDeviceList();
    if (result.page.records.isEmpty) {
      ref
          .watch(warrantyCardsStateNotifierProvider.notifier)
          .updateChecked(true);
    }
    _showTitle = result.page.records.isNotEmpty;
  }

  Future<void> updateController(InAppWebViewController controller) async {
    final String url = ref.watch(warrantyCardsStateNotifierProvider).url;

    try {
      final Uri uri = Uri.parse(url);
      final String encodedUrl = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: uri.path,
        queryParameters: uri.queryParameters.map(
            (key, value) => MapEntry(key, Uri.encodeQueryComponent(value))),
      ).toString();

      LogUtils.d('----------InAppWebview load url: $encodedUrl ----------');

      await controller
          .loadUrl(
        urlRequest: URLRequest(url: WebUri(encodedUrl)),
      )
          .timeout(Duration(seconds: 30), onTimeout: () {
        LogUtils.e('加载URL超时');
      });

      controller.addJavaScriptHandler(
        handlerName: 'messageChannel',
        callback: ((arguments) {
          try {
            LogUtils.d(
                '----------InAppWebview messageChannel: $arguments ----------');
            String messageString = arguments.first;
            if (messageString.isEmpty) {
              return;
            }
            responseForMessageAction(messageString);
          } catch (e) {
            LogUtils.e('处理JavaScript消息时出错: $e');
          }
        }),
      );
      currentController = controller;
    } catch (e) {
      LogUtils.e('URL解析错误: $e');
    }
  }

  Future<void> responseForMessageAction(String messageString) async {
    Map<String, dynamic> messageMap = jsonDecode(messageString);
    JSMessage? message = JSMessage.registerFromMap(messageMap);
    LogUtils.d('------ js bridge object--------$messageMap');
    switch (message) {
      case JSMessageForNavigation nav:
        await navigationTo(nav.pathType, nav.path);
      case JSMessageForRefreshAccessToken _:
        LogUtils.d('------ JSMessageForRefreshAccessToken ------');
        await _refreshTokenForWarranty();
        break;
      default:
    }
  }

  Future<void> navigationTo(String type, String path) async {
    switch (type) {
      case 'openShopifyOrderPage':
        LogUtils.d('------ openShopifyOrderPage ------');
        await ref
            .read(warrantyCardsStateNotifierProvider.notifier)
            .navigateToShopifyOrderPage(path);
        break;
      case 'openAddDevicePage':
        LogUtils.d('------ openAddDevicePage ------');
        unawaited(navigateToProductListPage());
        break;
      case 'openOnlineServicePage':
        LogUtils.d('------ openOnlineServicePage ------');
        List<BaseDeviceModel> deviceList = [];
        if (ref.exists(homeStateNotifierProvider)) {
          deviceList = ref.read(
              homeStateNotifierProvider.select((value) => value.deviceList));
        }
        unawaited(ref
            .read(helpCenterRepositoryProvider)
            .pushToChat(context: context, deviceList: deviceList));
        break;
      case 'HTML5':
        await navigationToPath(path);
        LogUtils.d('------ openOverseaPage ------');
        break;
      case 'MailTo':
        await handleForMail();
        LogUtils.d('------ Email to -------');
        break;
      default:
    }
  }

  Future<void> navigationToPath(String path) async {
    switch (path) {
      case 'home/h5':
        GoRouter.of(context).pop();
        await ref
            .read(mainStateNotifierProvider.notifier)
            .selectThemeType(TabItemType.overseasMall);
      default:
    }
  }

  Future<void> handleForMail() async {
    Uri mailtoUri = Uri.parse('mailto:aftersales@mova-tech.com');

    if (await canLaunchUrl(mailtoUri)) {
      // Launch the App
      await launchUrl(
        mailtoUri,
      );
    }
  }

  Future<void> navigateToProductListPage() async {
    await UIModule().generatePairNetEngine(ProductListPage.routePath);
  }

  Future<void> _refreshTokenForWarranty() async {
    // 调用网络请求刷新 token, 不主动去刷新 token
    await ref.watch(accountSettingRepositoryProvider).getUserInfo();

    try {
      var authBean = await AccountModule().getAuthBean();
      final accessToken = authBean.accessToken ?? '';
      // 发送类型 3 的消息给 web, 通知 web 刷新 access token
      Map<String, dynamic> auth = {
        'type': '3',
        'data': {
          'accessToken': accessToken,
        },
        'code': 0
      };
      await callMethodToWeb('onAppMessage', auth);
    } catch (e) {
      LogUtils.e('-------- onAppMessage -----$e');
    }
  }

  Future<void> callMethodToWeb(
      String method, Map<String, dynamic>? params) async {
    try {
      if (!context.mounted) return;
      if (currentController == null) return;
      bool isLoading = await currentController!.isLoading();
      if (isLoading == true) return;
      String paramsString = '';
      if (params != null) {
        paramsString = json.encode(params);
      }
      String jsFunction = '$method($paramsString)';
      unawaited(currentController?.evaluateJavascript(source: jsFunction));
    } catch (e) {
      LogUtils.e('call method to web error: -----$e');
    }
  }

  @override
  void initData() async {
    super.initData();
    var extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    String url =
        await ref.read(warrantyCardsStateNotifierProvider.notifier).init(extra);
    LogUtils.d('----- initData ------ $url');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    var uiState = ref.watch(warrantyCardsStateNotifierProvider);
    return NavBar(
      title: uiState.title,
      bgColor: _showTitle ? style.bgGray : style.bgWhite,
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          GoRouter.of(context).pop();
        }
      },
    );
  }

  @override
  void dispose() {
    try {
      currentController?.stopLoading();
    } catch (e) {
      LogUtils.e('[web_page] dispose stopLoading error: $e');
    }
    currentController = null;
    super.dispose();
  }

  // 是否开启返回键拦截
  @override
  Future<bool> onBackClick() async {
    if (currentController != null) {
      if (await currentController!.canGoBack()) {
        await currentController!.goBack();
        return false;
      }
    }
    return true;
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        children: [
          InAppWebView(
            key: ValueKey('warranty_page_${style.bgColor}'),
            onWebViewCreated: (controller) {
              updateController(controller);
            },
            onLoadStart: (controller, url) {
              LogUtils.d('Page started loading: $url');
              setState(() {
                progress = 0;
              });
            },
            onLoadStop: (controller, url) async {
              LogUtils.d('Page finished loading: $url');
              setState(() {
                progress = 1;
              });
              if (isRtl) {
                await controller.evaluateJavascript(source: '''
                document.body.dir = 'rtl';
                document.body.style.textAlign = 'right';
                ''');
              }
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            initialSettings: InAppWebViewSettings(
              underPageBackgroundColor: style.bgColor,
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              useHybridComposition: true,
              allowsInlineMediaPlayback: true,
            ),
            onPermissionRequest: (controller, permissionRequest) async {
              return PermissionResponse(
                  resources: permissionRequest.resources,
                  action: PermissionResponseAction.GRANT);
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED);
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (progress < 1)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: style.bgWhite,
              valueColor: AlwaysStoppedAnimation<Color>(style.normal),
            ),
        ],
      ),
    );
  }
}
