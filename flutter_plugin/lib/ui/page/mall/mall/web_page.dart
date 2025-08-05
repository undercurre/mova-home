import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/network/http/network_util.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/manual_viewer/pdf/pdf_viewer_page.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/url/common_url_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class WebPage extends BasePage {
  static const String routePath = '/web_page';

  const WebPage({super.key, this.request});

  final WebViewRequest? request;

  @override
  WebPageState createState() {
    return WebPageState();
  }
}

enum MallUrlType {
  online,
  local,
}

class WebPageState extends BasePageState with ResponseForeUiEvent {
  static const String KEEP_ONLY_STATUS_BAR = 'keepOnlyStatusBar=1';

  ///  是否重定向
  bool isRedirect = false;

  ///  是否需要缓存
  bool cacheEnabled = true;

  ///  是否需要清除缓存
  bool clearCache = false;

  /// 是否开启混合渲染模式
  bool useHybridComposition = false;

  ///  是否能返回上一页
  bool canGoBack = false;

  ///  是否缓存模式
  CacheMode cacheMode = CacheMode.LOAD_DEFAULT;

  /// 当前控制器
  InAppWebViewController? currentController;

  /// 当前请求
  WebViewRequest? webViewRequest;

  /// 当前是否支持键盘弹出
  @override
  bool resizeToAvoidBottomInset = Platform.isIOS ? false : true;

  bool disallowOverScroll = false;

  // String? defalutTitle;
  @override
  void initState() {
    if (widget is WebPage) {
      WebPage page = widget as WebPage;
      String url = page.request?.uri.toString() ?? '';
      cacheEnabled = page.request?.cacheEnabled ?? true;
      clearCache = page.request?.clearCache ?? false;
      useHybridComposition = page.request?.useHybridComposition ?? false;
      // 是否全屏
      if (url.contains('fullscreen=1')) {
        showTitle = false;
      }

      keepOnlyStatusBar = url.contains(KEEP_ONLY_STATUS_BAR);

      final title = page.request?.defaultTitle ?? '';
      centerTitle = title;
      onLoad(page.request);
    }
    super.initState();
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
        LogUtils.i('[mall_page] addObserver themeProvider Error: $e');
      }
    });
  }

  @override
  void dispose() {
    removeJsHandler();
    try {
      currentController?.stopLoading();
    } catch (e) {
      LogUtils.e('[web_page] dispose stopLoading error: $e');
    }
    currentController?.dispose(); // 确保调用 dispose
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

  int webViewKeyValue = 0;

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        children: [
          Container(
            color: style.bgBlack,
            child: InAppWebView(
              key: ValueKey(webViewKeyValue), 
              onReceivedError: onReceivedError,
              onWebViewCreated: _updateController,
              onTitleChanged: _onTitleChanged,
              initialSettings: InAppWebViewSettings(
                underPageBackgroundColor: style.bgColor,
                regexToCancelSubFramesLoading:
                    '^(?!http|file|chrome|data|about|javascript).*',
                disableInputAccessoryView: false,
                allowsBackForwardNavigationGestures: canSpanBack(),
                allowsInlineMediaPlayback: true,
                useShouldOverrideUrlLoading: true,
                cacheEnabled: cacheEnabled,
                clearCache: clearCache,
                useHybridComposition: useHybridComposition,
                cacheMode: cacheMode,
                allowFileAccessFromFileURLs: true,
                allowUniversalAccessFromFileURLs: true,
                mediaPlaybackRequiresUserGesture: false,
                // userAgent: Platform.isIOS ? 'app_ios' : 'app_android',
                disallowOverScroll: disallowOverScroll,
              ),
              shouldOverrideUrlLoading: shouldOverrideUrlLoading,
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED);
              },
              onWebContentProcessDidTerminate: (controller) {
                currentController?.reload();
              },
              onLoadStop: onLoadStop,
            ),
          ),
        ],
      ),
    );
  }

  // 返回上一页
  Future<void> goBack() async {
    bool canResponseGoback = true;
    if (Platform.isAndroid) {
      canResponseGoback = true;
    } else {
      if (currentController != null) {
        bool? isLoading = await currentController?.isLoading();
        if (isLoading == true) {
          try {
            await currentController?.stopLoading();
          } catch (e) {
            LogUtils.e('[web_page] dispose stopLoading error: $e');
          }
        }
        if (await currentController!.canGoBack()) {
          await currentController!.goBack();
          canResponseGoback = false;
        }
      }
    }
    if (canResponseGoback) {
      AppRoutes().pop();
    }
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return super.showTitle
        ? NavBar(
            backHidden: false,
            itemAction: (tag) {
              if (tag == BarButtonTag.left) {
                goBack();
              }
            },
            title: centerTitle,
            bgColor: navBackgroundColor ?? style.bgColor,
            barHeight: keepOnlyStatusBar ? 0 : NavBar.BAR_HEIGHT,
          )
        : null;
  }

  void onLoadError(
      InAppWebViewController controller, Uri? url, int code, String message) {
    LogUtils.e('[web_page] --onLoadError--$url--$code--$message--');
  }

  Future<bool> shouldOpenNewURL(URLRequest request) async {
    Map<String, String> headers = request.headers ?? {};
    WebUri? uri = request.url;
    if (uri == null) {
      return false;
    }
    WebViewRequest newRequest = WebViewRequest(
        uri: uri, headers: headers, useHybridComposition: useHybridComposition);
    await GoRouter.of(context).push(WebPage.routePath, extra: newRequest);
    return true;
  }

  Future<void> toRedirect(
      InAppWebViewController controller, WebResourceRequest request) async {
    if (!mounted) return;
    final url = request.url;
    final host = url.host;
    final realIp = await NetworkUtil().dnsRequest(host);
    if (realIp.isEmpty) {
      LogUtils.e('ip is empty');
      return;
    }
    final fixUrl = url.replace(host: realIp);
    WebUri fixWebUrl = WebUri.uri(fixUrl);
    if (!mounted) return;
    final hearders = request.headers ?? {};
    await onLoad(WebViewRequest(
        uri: fixWebUrl,
        headers: hearders,
        useHybridComposition: useHybridComposition));
  }

  Future<void> onLoad(WebViewRequest? request) async {
    LogUtils.i('webpagePath------${request?.uri}');
    webViewRequest = request;
    await loadRequest();
  }

  Future<void> loadRequest() async {
    if (currentController == null ||
        webViewRequest == null ||
        webViewRequest?.uri == null) {
      return;
    }

    final themeMode = ref.read(appThemeStateNotifierProvider);
    String themePath = themeMode == ThemeMode.dark ? 'dark' : 'light';
    WebUri? originalUri = webViewRequest?.uri;

    // 创建可变的查询参数副本, uri.replace 方法是encode的，可能会导致访问有问题
    String originalUriPath = originalUri.toString();
    final queryParameters = {'themeMode': themePath};
    final newWebUri =
        CommonUrlUtils().appendRawQueryParam2(originalUriPath, queryParameters);
    webViewRequest = webViewRequest?.copyWith(uri: newWebUri);

    URLRequest req = URLRequest(
        url: webViewRequest?.uri,
        headers: webViewRequest?.headers,
        method: 'GET',
        body: webViewRequest?.body);
    if (!mounted) return;

    try {
      if (Platform.isIOS && req.url?.scheme == 'file') {
        String accessToPath = req.url?.path ?? '';
        accessToPath = accessToPath.substring(0, accessToPath.lastIndexOf('/'));

        await currentController?.loadUrl(
          urlRequest: req,
          allowingReadAccessTo: WebUri('file://$accessToPath'),
        );
      } else {
        // 替换${id}之类的协定变量
        req.url = WebUri(await _replaceSpecialSymbolByUrl(req.url.toString()));

        // 使用 loadData 替代 loadUrl 来避免添加到历史堆栈
        await currentController!.loadUrl(urlRequest: req);
      }
    } catch (e) {
      LogUtils.e(
          '[web_page] loadRequest = ${webViewRequest.toString()}---- error msg = $e-------');
    }
  }

  void updateRequest(URLRequest request) {}

  Future<void> callMethodToWeb(
      String method, Map<String, dynamic>? params) async {
    try {
      if (!context.mounted) {
        LogUtils.i('[WebPageState] callMethodToWeb !context.mounted');
        return;
      }
      if (currentController == null) {
        LogUtils.i('[WebPageState] callMethodToWeb currentController = null');
        return;
      }
      bool isLoading = await currentController!.isLoading();
      if (isLoading == true) {
        LogUtils.i('[WebPageState] callMethodToWeb isLoading = true');
      }
      String paramsString = '';
      if (params != null) {
        paramsString = json.encode(params);
      }
      String jsFunction = '$method($paramsString)';
      unawaited(currentController?.evaluateJavascript(source: jsFunction));
    } catch (e) {
      LogUtils.e('[web_page] callMethodToWeb mall 错误-----$e');
    }

    // currentController?.runJavaScript(jsFunction);
  }

  //用于回调
  void updateUrlFromOverride({required WebUri? url}) {}

  static const JS_HANDLER = 'jsHandler';
  static const POP_PAGE = 'goBack';
  static const TITLE = 'title';
  static const PDF_URL = 'pdfUrl';

  Future<void> upateCanGoBack() async {
    if (currentController == null) return;
    canGoBack = await currentController!.canGoBack();
    updateCanPan(Platform.isIOS && canGoBack == false);
  }

  //监听Title变化
  void _onTitleChanged(InAppWebViewController controller, String? title) {
    if (widget is WebPage) {
      WebPage page = widget as WebPage;
      final defaultTitle = page.request?.defaultTitle ?? '';
      if (defaultTitle.isEmpty) {
        setState(() {
          centerTitle = title ?? '';
        });
      }
    }
  }

  //初始化控制器
  void _updateController(InAppWebViewController? controller) {
    currentController = controller;
    LogUtils.d('[web_page] _updateController controller = $controller');
    removeJsHandler();
    currentController?.addJavaScriptHandler(
        handlerName: JS_HANDLER,
        callback: (args) {
          try {
            handleH5Data(args);
          } catch (e) {
            LogUtils.i(
                '[web_page] _updateController controller = $controller   handleH5DataError = $e');
          }
          return List.empty();
        });
    onWebViewControllerCreated(controller!);
    loadRequest();
  }

  void handleH5Data(List<dynamic> args) {
    LogUtils.i('[web_page] handleH5Data   args = $args');
    if (args.isNotEmpty) {
      Map<String, dynamic> jsonObject = jsonDecode(args[0].toString());
      bool isPopBack = jsonObject[POP_PAGE] ?? false;
      String title = jsonObject[TITLE]?.toString() ?? '';
      String pdfUrl = jsonObject[PDF_URL]?.toString() ?? '';
      if (isPopBack) {
        // LogUtils.e('[web_page] goBack   args = $args');
        goBack();
        removeJsHandler();
      } else if (title.isNotEmpty && pdfUrl.isNotEmpty) {
        goToPdfPage(Pair(title, pdfUrl));
      }
    }
  }

  void removeJsHandler() =>
      currentController?.removeJavaScriptHandler(handlerName: JS_HANDLER);

  Future<void> goToPdfPage(Pair<String, String> p) async {
    await AppRoutes().push(PdfViewerPage.routePath, extra: p);
  }

  //收到webview错误
  void onReceivedError(InAppWebViewController controller,
      WebResourceRequest request, WebResourceError error) {
    if (request.isForMainFrame == false) {
      return;
    }
    if (error.type == WebResourceErrorType.HOST_LOOKUP) {
      toRedirect(controller, request);
    }
    if (error.type == WebResourceErrorType.UNKNOWN &&
        error.description == 'net::ERR_FILE_NOT_FOUND') {
      return;
    }
    onLoadError(controller, request.url, error.type.toNativeValue() ?? -1,
        error.description);
  }

  //shouldOverrideUrlLoading 拦截
  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
      InAppWebViewController controller,
      NavigationAction navigationAction) async {
    var url = navigationAction.request.url;

    if (url != null &&
        ['http', 'https', 'file', 'chrome', 'data', 'javascript', 'about']
            .firstWhere((element) => url.scheme.startsWith(element),
                orElse: () => '')
            .isEmpty) {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);

        return NavigationActionPolicy.CANCEL;
      }
    }

    if (navigationAction.navigationType == NavigationType.LINK_ACTIVATED &&
        (url?.scheme == 'http' || url?.scheme == 'https')) {
      if (navigationAction.request.url?.host !=
          navigationAction.sourceFrame?.securityOrigin?.host) {
        bool shouldOpen = await shouldOpenNewURL(navigationAction.request);
        if (shouldOpen) {
          return NavigationActionPolicy.CANCEL;
        }
      }
    }

    //在隐私政策页面在跳转到官网url的时候，根本没有onLoadStop回到，所以这里做个延时来判断即将允许的页面，是否可以点击返回上个界面
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      // 要延时执行的方法
      upateCanGoBack();
    });
    updateUrlFromOverride(url: url);
    return Future.value(NavigationActionPolicy.ALLOW);
  }

  Future<String> _replaceSpecialSymbolByUrl(String urlStr) async {
    String newUrlStr = Uri.decodeComponent(urlStr);
    String region = await LocalModule().getCountryCode();
    UserInfoModel? info = await AccountModule().getUserInfo();
    String lang = await LocalModule().getLangTag();
    Map<String, String> specialSymbol = {
      '\${uid}': info?.uid ?? '',
      '\${phone}': info?.phone ?? '',
      '\${mail}': info?.email ?? '',
      '\${region}': region,
      '\${language}': lang
    };

    specialSymbol.forEach((key, value) {
      if (newUrlStr.contains(key)) {
        newUrlStr = newUrlStr.replaceAll(key, value);
      }
    });

    return newUrlStr;
  }

  Future<void> onLoadStop(
      InAppWebViewController controller, WebUri? url) async {
    final isRealod = url?.toString().contains('isReload=true');
    if (isRealod == true) {
      if (Platform.isAndroid) {
        await controller.clearHistory();
      }
    }
  }

  // 是否可以返回
  bool canSpanBack() {
    return false;
  }

  //WebView创建成功过后的回调
  void onWebViewControllerCreated(InAppWebViewController controller) {}
}
