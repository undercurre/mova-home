/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-21 19:57:46
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-09-07 11:25:15
 * @FilePath: /flutter_plugin/lib/ui/page/mall/wechat/wechat_page_minxin.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inappwebview/src/in_app_webview/in_app_webview_controller.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:url_launcher/url_launcher.dart';

mixin WeChatPageMinXin on WebPageState {
  @override
  Future<void> onLoad(WebViewRequest? request) {
    initConfig();
    return super.onLoad(request);
  }

  void initConfig() {
    // controller.setNavigationDelegate(NavigationDelegate(
    //   onUrlChange: (change) async {
    //     String? url = change.url;
    //     if (url == null) return;
    //     Uri uri = Uri.parse(url);
    //     LogUtils.d('${uri.toString()} @------@ ${uri.scheme}');
    //     if (uri.scheme == 'weixin') {
    //       await launchUrl(uri);
    //       dismiss();
    //     }
    //   },
    // ));
  }

  @override
  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
      InAppWebViewController controller,
      NavigationAction navigationAction) async {
    Uri? uri = navigationAction.request.url;
    if (uri == null) {
      return NavigationActionPolicy.CANCEL;
    }
    if (uri.scheme == 'weixin') {
      await launchUrl(uri);

      if (Platform.isAndroid) {
        dismiss();
      }
      return NavigationActionPolicy.CANCEL;
    }
    return super.shouldOverrideUrlLoading(controller, navigationAction);
  }

  void dismiss() {
    PushEvent event = PushEvent(func: RouterFunc.pop);
    responseFor(event);
  }
}
