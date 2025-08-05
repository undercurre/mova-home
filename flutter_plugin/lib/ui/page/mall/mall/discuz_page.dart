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

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/model/event/account_info_event.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/event/email_record_event.dart';
import 'package:flutter_plugin/model/mall_debug_model.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/js_action/js_message.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/home/home_page_theme_mixin.dart';
import 'package:flutter_plugin/ui/page/mall/event_action/navigate_sheet_show.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/mall_content_page_minxin.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/mall_request.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/map_naviagte_minxin.dart';
import 'package:flutter_plugin/ui/page/mine/mine_repository.dart';
import 'package:flutter_plugin/ui/widget/home/home_error_widget.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class DisCuzPage extends BasePage {
  static const String routePath = '/disCuz_page';
  MallRequest? request;

  DisCuzPage({super.key, this.request});

  static DisCuzPage parse(String path, {Key? key}) {
    MallRequest request = MallRequest.parse(path);
    DisCuzPage page = DisCuzPage(request: request, key: key);
    return page;
  }

  // String? pagePath;

  @override
  DisCuzPageState createState() {
    return DisCuzPageState();
  }
}

class DisCuzPageState extends WebPageState
    with
        MapNavigateMixin,
        MallContentPageMinXin,
        HomePageThemeMixin {
  bool loadError = false;

  @override
  bool get cacheEnabled => false;

  @override
  bool get clearCache => true;

  @override
  bool get resizeToAvoidBottomInset => Platform.isIOS ? false : true;

  @override
  bool get disallowOverScroll => false;

  @override
  CacheMode get cacheMode => CacheMode.LOAD_NO_CACHE;

  @override
  void initData() {
    super.initData();
    EventBusUtil.getInstance().register<EmailRecordDialogResultEvent>(this,
        (event) async {
      if (event.result == EmailRecordDialogResult.cancel) {
        _sendEmail(isCancel: true);
        return;
      }
      UserInfoModel? userInfo = await AccountModule().getUserInfo();
      _sendEmail(email: userInfo?.email);
    });
    loadPage();
  }

  @override
  void didUpdateWidget(covariant ConsumerStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      loadPage();
    }
  }


  Future<void> loadPage() async {
    if (widget is DisCuzPage) {
      DisCuzPage page = widget as DisCuzPage;

      MallDebugModel debug =
          await MallDebugModel.getMallDebugInfo('discuz_debug_info');
      Uri uri;
      if (debug.enable == true && debug.host.isNotEmpty) {
        if (debug.host.startsWith('https://') ||
            debug.host.startsWith('http://')) {
          uri = Uri.parse(debug.host);
        } else {
          uri = Uri(path: debug.host, scheme: 'http');
        }
        MallRequest request = MallRequest.parse(uri.toString());
        page.request = request;
      }
      await loadFromPage(page.request);
    }
  }

  @override
  bool changeToDarkIfNeeded() {
    return true;
  }

  void didAppearForSelect() {
    if (Platform.isAndroid) {
      callMethodToWeb('mountedOnshow', null);
    }
  }

  @override
  Future<void> actionToWebMesage(JSMessage? message) async {
    switch (message) {
      case JSMessageForGetAuthToken _:
        await _getAuthToken();
        break;
      case JSMessageForGetEmail _:
        await _getEmail();
        break;
      case JSMessageForKeyboardUnfocus _:
        unFocusKeyBoard();
        break;
      case JSMessageForshowLoading message:
        showPopLoading(
          message: message.title,
          timeout: message.timeout,
        );
        break;
      case JSMessageForHideLoading _:
        hideLoading();
        break;
      default:
        break;
    }
    return;
  }

  Future<void> _getAuthToken() async {
    try {
      String authCode = await _loadAuthToken();
      Map<String, dynamic> auth = {
        'country_code': 'de',
        'auth_code': authCode,
        'code': 0
      };
      await callMethodToWeb('onAppMessage', auth);
    } catch (e) {
      LogUtils.e('MallContentPageMinXin _getAuthToken error: $e');
    }
  }

  Future<String> _loadAuthToken() async {
    try {

      String? clientId = 'eu_discover_web';
      String? authCode =
          await ref.read(accountRepositoryProvider).getDiscuzAuthCode(clientId);
      if (authCode == null) throw 'authCode is null';
      return authCode;
    } catch (e) {
      LogUtils.e('MallContentPageMinXin _loadAuthToken error: $e');
      rethrow;
    }
  }

  @override
  bool canSpanBack() {
    return true;
  }

  @override
  void dispose() {
    destory();
    super.dispose();
  }

  // @override
  // void onAppResume() {
  //   super.onAppResume();
  //   if (Platform.isAndroid) {
  //     callMethodToWeb('onShow', {});
  //   }
  // }
  @override
  Future<bool> onBackClick() async {
    LogUtils.i('discuz_page --------- onBackClick $this');
    return true;
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    statusHeight = MediaQuery.of(context).padding.top;
    return KeyboardSizeProvider(
        smallSize: 500.0,
        child: provider.Consumer<ScreenHeight>(builder: (context, res, child) {
          if (shouldAddObserverKeyboard) {
            sendKeyBoardHeight(res.keyboardHeight);
          }
          return Padding(
            padding: EdgeInsets.only(top: statusHeight),
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
        'mall page onLoadError code: $code, message: $message ,url: $url');
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
  Future<void> onLoad(WebViewRequest? request) async {
    if (request == null) {
      await super.onLoad(request);
      return;
    }
    UserInfoModel? userInfo = await AccountModule().getUserInfo();
    String authCode = await _loadAuthToken();
    Map<String, String> headers = Map<String, String>.from(request.headers);
    headers['authCode'] = authCode;
    headers['uid'] = userInfo?.uid ?? '';
    headers['userAgent'] = Platform.isAndroid ? 'app_android' : 'app_ios';
    request.headers = headers;
    await super.onLoad(request);
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

  Future<void> _getEmail() async {
    String? email;
    UserInfoModel? userInfo = await AccountModule().getUserInfo();
    if (userInfo == null) {
      //没有个人信息，铁定失败
      _sendEmail(email: null);
      return;
    }
    String discuzEmail = email ?? '';
    String localEmail = userInfo.email ?? '';

    if (discuzEmail.isNotEmpty && discuzEmail == localEmail) {
      //两者相同，并且都有值，直接返回 ，不需要再调用getUserInfo接口
      _sendEmail(email: localEmail);
    } else {
      UserInfoModel fixUserInfo =
          await ref.read(mineRepositoryProvider).getUserInfo();
      localEmail = fixUserInfo.email ?? '';
      if (localEmail.isEmpty) {
        //本地邮箱为空，需要弹窗
        EventBusUtil.getInstance().fire(EmailRecordDialogEvent());
      } else {
        _sendEmail(email: localEmail);
      }
    }
  }

  void _sendEmail({String? email, bool isCancel = false}) {
    Map<String, dynamic> emailMap;
    if (isCancel) {
      emailMap = {
        'msg': 'email bind canceled',
        'code': -2,
      };
    } else {
      if (email == null || email.isEmpty) {
        emailMap = {
          'msg': 'getUserEmail fail',
          'code': -1,
        };
      } else {
        emailMap = {
          'email': email,
          'code': 0,
        };
      }
    }

    callMethodToWeb('onEmailUpdate', emailMap);
  }

  void unFocusKeyBoard() {
    FocusScope.of(context).requestFocus();
  }

  void showPopLoading({
    String? message,
    int timeout = 3000,
  }) {
    SmartDialog.showLoading(
      msg: message ?? '',
      displayTime: Duration(milliseconds: timeout),
    );
  }

  void hideLoading() {
    SmartDialog.dismiss(tag: 'loading_dialog');
  }

  @override
  Future<void> onLoadStop(
      InAppWebViewController controller, WebUri? url) async {
    //   await controller.evaluateJavascript(source: """
    //   document.querySelectorAll('textarea').forEach(input => {
    //           input.addEventListener('focus', function () {
    //               var rect = getInput();
    //               console.log(rect);
    //               // window.flutter_inappwebview.callHandler('inputFocus', { x: input.getBoundingClientRect().left, y: input.getBoundingClientRect().top,width: input.getBoundingClientRect().width,height: input.getBoundingClientRect().height });
    //           });
    //           input.addEventListener('blur', function () {
    //               // window.flutter_inappwebview.callHandler('inputBlur');
    //           });
    //       });
    //       function getInput() {
    //           var input = document.activeElement; // 获取当前获取焦点的元素
    //           if (input && input.tagName.toLowerCase() === 'textarea') {
    //               var rect = input.getBoundingClientRect(); // 获取元素的位置和大小
    //               return {
    //                   x: rect.left, // X坐标
    //                   y: rect.top // Y坐标
    //                   width: rect.width, // 宽度
    //                   height: rect.height // 高度
    //               };
    //           }
    //           return nil; // 如果没有找到输入框或者焦点不在输入框上，返回错误信息
    //       };
    // """);
  }
}
