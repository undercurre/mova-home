import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/webview/webview_constants.dart';
import 'package:flutter_plugin/ui/page/webview/webview_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// webview page
class WebviewPage extends BasePage {
  static const String routePath = '/webview_page';

  const WebviewPage({super.key});

  static Map<String, dynamic> createParams({
    required String url,
    required String title,
    String type = '',
    bool hideTitle = false,
  }) {
    return {
      WebviewConstants.KEY_WEB_URL: url,
      WebviewConstants.KEY_WEB_TITLE: title,
      WebviewConstants.KEY_WEB_TYPE: type,
      WebviewConstants.KEY_WEB_HIDE_TITLE: hideTitle
    };
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _WebviewPageState();
  }
}

class _WebviewPageState extends BasePageState {
  InAppWebViewController? currentController;

  Future<void> updateController(InAppWebViewController controller) async {
    currentController = controller;
    // 获取当前的 URL
    var originalUrl = ref.watch(webviewStateNotifierProvider).url;
    // 获取主题模式
    final themeMode = ref.read(appThemeStateNotifierProvider);
    String themePath = themeMode == ThemeMode.dark ? 'dark' : 'light';

    // 拼接参数
    var uri = Uri.parse(originalUrl);
    var queryParameters = Map<String, String>.from(uri.queryParameters);
    queryParameters['themeMode'] = themePath;
    var newUri = uri.replace(queryParameters: queryParameters);

    await currentController?.loadUrl(
      urlRequest: URLRequest(
        url: WebUri(newUri.toString()),
      ),
    );
  }

  @override
  void initData() async {
    super.initData();
    var extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    String url =
        await ref.read(webviewStateNotifierProvider.notifier).init(extra);
    LogUtils.d('----- initData ------ $url');
    // await currentController?.loadUrl(
    //     urlRequest: URLRequest(url: Uri.parse(url)));
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen<ThemeMode>(appThemeStateNotifierProvider, (previous, next) {
      try {
        // 当 ThemeMode 发生变化时触发
        LogUtils.i(
            '[mall_page] themeProvider changed from ${previous?.name} to ${next.name}');
        // 在这里处理 ThemeMode 变化的逻辑
        LogUtils.i('[mall_page] System mode activated');
        final params = {'theme': next.name}; // 构造参数
        LogUtils.i('[mall_page]callMethodToWeb params: $params');
        // 获取 WebPageState 的实例
        callMethodToWeb('themeChange', params); // 调用方法
      } catch (e) {
        LogUtils.e('[mall_page] addObserver themeProvider Error: $e');
      }
    });
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
      LogUtils.e('mall 错误-----$e');
    }

    // currentController?.runJavaScript(jsFunction);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    var uistate = ref.watch(webviewStateNotifierProvider);
    return NavBar(
      title: uistate.title,
      isHiddenTitle: uistate.isHideTitle,
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
    return Container(
        color: style.bgWhite,
        child: InAppWebView(
          key: ValueKey('webview_page_${style.bgColor}'), 
          onWebViewCreated: (controller) {
            updateController(controller);
          },
          initialSettings: InAppWebViewSettings(
            underPageBackgroundColor: style.bgColor,
          ),
          initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
              )),
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;
            if (![
              'http',
              'https',
              'file',
              'chrome',
              'data',
              'javascript',
              'about'
            ].contains(uri.scheme)) {
              if (await canLaunchUrl(uri)) {
                // Launch the App
                await launchUrl(
                  uri,
                );
                // and cancel the request
                return NavigationActionPolicy.CANCEL;
              }
            }

            return NavigationActionPolicy.ALLOW;
          },
        ));
  }
}
