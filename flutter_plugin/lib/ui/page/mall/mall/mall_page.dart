/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-17 14:23:54
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-09-01 14:12:35
 * @FilePath: /flutter_plugin/lib/ui/page/mall/mall/mall_page.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_plugin/common/configure/user_info_store.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:flutter_plugin/model/event/app_lifecycle_event.dart';
import 'package:flutter_plugin/model/event/account_info_event.dart';
import 'package:flutter_plugin/model/event/email_record_event.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';
import 'package:flutter_plugin/ui/page/mall/event_action/navigate_sheet_show.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/mall_content_page_minxin.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/mall_plugin_state_notifier.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/mall_request.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/map_naviagte_minxin.dart';
import 'package:flutter_plugin/ui/widget/home/home_error_widget.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:provider/provider.dart' as provider;
import 'package:synchronized/synchronized.dart';
class MallPage extends BasePage {
  static const String routePath = '/mall_page';
  final TabItemType? type;
  final MallRequest? request;

  const MallPage({super.key, this.request, this.type});

  static MallPage parse(String path, {Key? key, TabItemType? type}) {
    MallRequest request = MallRequest.parse(path);
    MallPage page = MallPage(request: request, key: key, type: type);
    return page;
  }

  // String? pagePath;

  @override
  MallPageState createState() {
    return MallPageState();
  }
}

class MallPageState extends WebPageState
    with MapNavigateMixin, MallContentPageMinXin {
  bool loadError = false;
  final Lock _lock = new Lock();

  @override
  bool get resizeToAvoidBottomInset => Platform.isIOS ? false : true;

  @override
  bool get disallowOverScroll => false;

  @override
  void initData() {
    loadPage();
  }

  void _registerWebEvent() {
    if (Platform.isAndroid) {
      callMethodToWeb('mountedOnshow', null);
    }
    callMethodToWeb('onAppPageShow', {'code': 0, 'result': 1});
  }

  void _checkMallVersion() {
    if ((widget as MallPage).type == TabItemType.overseasMall) {
        return;
    }
    if ((widget as MallPage).type == TabItemType.mall ||
        (widget as MallPage).type == TabItemType.explore) {
      unawaited(_lock.synchronized(()=>_checkLocalMallUpdateIfNeeded()));
    }
  }

  @override
  void didUpdateWidget(covariant ConsumerStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget &&
        (widget as MallPage).type == TabItemType.overseasMall) {
      loadPage();
    }
  }

  @override
  Future<void> loadRequest() async {
    if (webViewRequest == null ||
        currentController == null ||
        statusHeight == 0) {
      return;
    }
    MallLoginRes? req = await ref.read(userInfoStoreProvider).getMallInfo();
    Map<String, String> queryParameters =
        Map<String, String>.from(webViewRequest?.uri.queryParameters ?? {});
    queryParameters['statusBarHeight'] = '${statusHeight.toInt()}';
    queryParameters['accessToken'] = req?.accessToken ?? '';
    queryParameters['user_id'] = req?.user_id ?? '';
    queryParameters['mallVersion'] = Constant.mallCheckVersion;
    final fixUrl =
        webViewRequest?.uri.replace(queryParameters: queryParameters);
    if (fixUrl != null) {
      WebUri uri = WebUri.uri(fixUrl);
      webViewRequest?.uri = uri;
    }

    return super.loadRequest();
  }

  void updateStatusBar(double height) {
    if (height == 0) return;

    if (statusHeight == height) {
      return;
    }

    statusHeight = height;
    loadRequest();
  }

  @override
  void addObserver() {
    super.addObserver();
    EventBusUtil.getInstance().register<SelectTabEvent>(this, (event) {
      if (event.tabItemType == TabItemType.mall ||
          event.tabItemType == TabItemType.explore) {
        _onTabActive(event.tabItemType);
      }
    });
    EventBusUtil.getInstance().register<ForceUpdateMallEvent>(this, (event) {
      // 判断当前是跟页面，重新加载
      if ((widget as MallPage).type == TabItemType.mall ||
          (widget as MallPage).type == TabItemType.explore) {
        // if ((widget as MallPage).type == null) {
        //   return;
        // }
        unawaited(_lock.synchronized(()=>_checkLocalMallUpdateIfNeeded()));
      }
    });

    EventBusUtil.getInstance().register<RefreshOverseasMalldEvent>(this,
        (event) {
      String url = event.url;
      (widget as MallPage).request?.path = url;
      loadUrl(url);
    });
  }

  void _onTabActive(TabItemType tabItemType) {
    LogUtils.i(
        '[mall_page] onTabActive tabItemType:$tabItemType version:${mPluginLocalModel?.version} path:${mPluginLocalModel?.path}');
    _registerWebEvent();
    _checkMallVersion();
  }

  void loadPage() {
    MallPage page = widget as MallPage;
    if (page.type == TabItemType.overseasMall) {
      loadUrl(page.request?.path);
        return;
      }
    loadFromPage(page.request);
  }

  LifecycleEvent _preEvent = LifecycleEvent.push;

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);

    final type = (widget as MallPage).type;
    if (type != null /*商城/发现*/) {
      if (event == LifecycleEvent.active &&
          _preEvent == LifecycleEvent.inactive) {
        _preEvent = LifecycleEvent.active;
        // 检查更新
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _registerWebEvent();
          _checkMallVersion();
        });
      }
      if (event == LifecycleEvent.inactive) {
        _preEvent = event;
      }
    }
  }

  Future<void> _checkLocalMallUpdateIfNeeded() async {
    final url = (widget as MallPage).request?.path;
    if (url != null && url.isNotEmpty && (!url.startsWith('http'))) {
      
      LogUtils.d(
          '[mall_page] checkMallUpdateIfNeeded page: $url, tabType: ${(widget as MallPage).type}');

      final localCacheModel = await ref
          .read(mallPluginNotifierProvider.notifier)
          .getMallModelInfo(forceCheck: true);
      if (localCacheModel.version != mPluginLocalModel?.version) {
        // 更新
        await reloadLocalPage((widget as MallPage).request);
      }
      await ref
          .read(pluginProvider.notifier)
          .checkMallUpdateIfNeeded(forceCheck: false);
    }
  }

  @override
  bool canSpanBack() {
    return true;
  }

  @override
  void dispose() {
    destory();
    EventBusUtil.getInstance().unRegister(this);
    super.dispose();
  }

  @override
  Future<bool> onBackClick() async {
    if ((widget as MallPage).type == TabItemType.mall ||
        (widget as MallPage).type == TabItemType.explore) {
      if ((widget as MallPage).type != null) {
        return true;
      }
    }
    return super.onBackClick();
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    updateStatusBar(MediaQuery.of(context).padding.top);

    return KeyboardSizeProvider(
        smallSize: 500.0,
        child: provider.Consumer<ScreenHeight>(builder: (context, res, child) {
          if (shouldAddObserverKeyboard) {
            sendKeyBoardHeight(res.keyboardHeight);
          }
          final isOverseasMall =
              (widget as MallPage).type == TabItemType.overseasMall;
          return Padding(
            padding: isOverseasMall
                ? EdgeInsets.only(top: MediaQuery.of(context).padding.top)
                : EdgeInsets.zero,
            child: loadError
                ? Column(
                    children: [
                      HomeErrorWidget(
                        retryCallback: () {
                          setState(() {
                            loadError = false;
                          });
                          loadPage();
                        },
                      ),
                    ],
                  )
                : super.buildBody(context, style, resource),
          );
        }));
  }

  @override
  void updateEvent(CommonUIEvent event) {
    super.updateEvent(event);
    if (event is ActionEvent) {
      CommonEventAction common = event.action;
      if (common is NaivgateSheetShow) {
        showNaviteSheet(nav: common.navigation);
      }
    }
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return fullScreen ? null : super.buildNavBar(context, style, resource);
  }

  @override
  Future<void> onLoadError(InAppWebViewController controller, Uri? url,
      int code, String message) async {
    LogUtils.i(
        '[mall_page] onLoadError code: $code, message: $message ,url: $url');
    if (code == -999 && Platform.isIOS) {
      return;
    }
    if (code == -1007) {
      await controller.reload();
    }
    if (message == 'net::ERR_FILE_NOT_FOUND' ||
        message == 'net::ERR_FAILED' ||
        message == 'net::ERR_UNKNOWN_URL_SCHEME') {
      return;
    }
    setState(() {
      loadError = true;
    });
  }

  @override
  void onReceivedError(InAppWebViewController controller,
      WebResourceRequest request, WebResourceError error) {
    if (error.type == WebResourceErrorType.TOO_MANY_REDIRECTS) {
      URLRequest req = URLRequest(
        url: request.url,
        headers: request.headers,
        method: request.method,
      );

      controller.loadUrl(urlRequest: req);
      return;
    }
    super.onReceivedError(controller, request, error);
  }

  @override
  Future<void> onLoadStop(
      InAppWebViewController controller, WebUri? url) async {
    await super.onLoadStop(controller, url);
  }
}
