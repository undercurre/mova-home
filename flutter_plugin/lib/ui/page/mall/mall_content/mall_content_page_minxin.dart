import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    hide LocalStorage;
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/configure/app_config_prodiver.dart';
import 'package:flutter_plugin/common/configure/user_info_store.dart';
import 'package:flutter_plugin/common/network/http/mall_auth_manager.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/js_action/js_map_navigation.dart';
import 'package:flutter_plugin/ui/common/js_action/js_message.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_page.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/home/home_page.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_model.dart';
import 'package:flutter_plugin/ui/page/main/main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';
import 'package:flutter_plugin/ui/page/mall/event_action/navigate_sheet_show.dart';
import 'package:flutter_plugin/ui/page/mall/mall/mall_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/mall_plugin_state_notifier.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/mall_request.dart';
import 'package:flutter_plugin/ui/page/mall/wechat/wechat_page.dart';
import 'package:flutter_plugin/ui/page/message/message_main_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/device_share_page.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/settings_page.dart';
import 'package:flutter_plugin/ui/page/voice/voice_control_page.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:pay_kit/option/wechat_option.dart';
import 'package:pay_kit/pay_kit.dart';
import 'package:pay_kit/pay_request/pay_request.dart';
import 'package:pay_kit/pay_request/pay_response.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

// JS交互相关文档：[https://dreametech.feishu.cn/wiki/WGkzw0tVdiRw1Kk1ag1cd8j9nXf?from=from_copylink]
mixin MallContentPageMinXin on WebPageState {
  double statusHeight = 0;
  String pagePath = '';
  bool fullScreen = true;
  bool shouldAddObserverKeyboard = false;
  final String mallStorageKey = 'dreame.mall.storage';
  late final PayKit _payKitPlugin = PayKit();

  //用于商城阻止app返回并触发商城自身业务逻辑
  Function? backBlockEvent;

  /// 商城加载的资源版本信息
  PluginLocalModel? mPluginLocalModel = null;

  Future<void> loadFromPage(MallRequest? pagePath) async {
    initConfig();
    if (!mounted) return;
    if (pagePath == null) return;

    if (!pagePath.path.startsWith('http')) {
      final mallModelInfo = await ref
          .read(mallPluginNotifierProvider.notifier)
          .getMallModelInfo(forceCheck: true);
      mPluginLocalModel = mallModelInfo;

      final filePath = await mallModelInfo.getUri();
      LogUtils.i('[MallContentPageMinXin] loadFromPage filePath:${filePath}');
      await updateUrl(filePath, pagePath);
    } else {
      await updateOnLineUrl(pagePath);
    }
  }

  Future<void> reloadLocalPage(MallRequest? pagePath) async {
    setState(() {
      webViewKeyValue++;
    });
    if (!mounted) return;
    final mallModelInfo = await ref
        .read(mallPluginNotifierProvider.notifier)
        .getMallModelInfo(forceCheck: true);
    mPluginLocalModel = mallModelInfo;
    LogUtils.i(
        '[MallContentPageMinXin] reloadLocalPage mallModelInfo:${mallModelInfo.toString()}');
    final filePath = await mallModelInfo.getUri();
    await updateUrl(filePath, pagePath, reload: true);
  }

  Future<void> loadUrl(String? url) async {
    initConfig();
    if (!mounted) return;
    if (url == null || url.isEmpty) return;
    try {
      WebUri uri = WebUri(url.trim());
      updateNav(uri);
      WebViewRequest request =
          WebViewRequest(uri: uri, useHybridComposition: true);
      await onLoad(request);
    } catch (e) {
      LogUtils.e('loadUrl error: $e');
    }
  }

  void updateNav(Uri path) {
    Map<String, String> queryParameters = path.queryParameters;
    String? isNavBar = queryParameters['isNavBar'];
    bool hasNavBar = isNavBar == '1';
    bool shouldFullScreen = hasNavBar == false;
    if (shouldFullScreen != fullScreen) {
      setState(() {
        fullScreen = shouldFullScreen;
      });
    }
  }

  @override
  void updateUrlFromOverride({required Uri? url}) {
    if (url == null) return;
    updateNav(url);
  }

  Future<void> updateOnLineUrl(MallRequest pagePath) async {
    if (!mounted) return;
    MallLoginRes? req = await ref.read(userInfoStoreProvider).getMallInfo();
    Map<String, String> queryParameters =
        Map<String, String>.from(pagePath.queryParameters ?? {});
    queryParameters['accessToken'] = req?.accessToken ?? '';
    queryParameters['user_id'] = req?.user_id ?? '';
    queryParameters['statusBarHeight'] = '${statusHeight.toInt()}';
    queryParameters['mallVersion'] = Constant.mallCheckVersion;
    Uri temp = Uri.parse(pagePath.path);
    Uri ur = Uri(
      path: temp.path,
      scheme: temp.scheme,
      host: temp.host,
      port: temp.port,
      queryParameters: queryParameters,
      fragment: temp.fragment,
    );
    updateNav(ur);
    WebViewRequest request = WebViewRequest(
        uri: WebUri.uri(ur), useHybridComposition: useHybridComposition);
    await onLoad(request);
  }

  Future<void> updateUrl(Uri path, MallRequest? pagePath,
      {bool reload = false}) async {
    if (!mounted) return;
    MallLoginRes? req = await ref.read(userInfoStoreProvider).getMallInfo();
    Map<String, String> queryParameters =
        Map<String, String>.from(pagePath?.queryParameters ?? {});
    queryParameters['accessToken'] = req?.accessToken ?? '';
    queryParameters['user_id'] = req?.user_id ?? '';
    queryParameters['statusBarHeight'] = '${statusHeight.toInt()}';
    queryParameters['mallVersion'] = Constant.mallCheckVersion;
    queryParameters['isReload'] = '$reload';
    Uri ur = Uri(
      path: path.path,
      scheme: path.scheme,
      host: path.host,
      port: path.port,
      queryParameters: queryParameters,
      fragment: pagePath?.path,
    );
    updateNav(WebUri.uri(ur));
    WebViewRequest request = WebViewRequest(
        uri: WebUri.uri(ur), useHybridComposition: useHybridComposition);
    await onLoad(request);
  }

  Future<void> _responseForMessageAction(String messageString) async {
    Map<String, dynamic> messageMap = jsonDecode(messageString);
    JSMessage? message = JSMessage.registerFromMap(messageMap);
    switch (message) {
      case JSMessageForOpenWebview action:
        await pushOpenWebView(action.path);
        break;
      case JSMessageForCloseWebView _:
        closeMallWebView();
        break;
      case JSMessageForRefreshSession _:
        await _refreshSession();
        break;
      case JSMessageForRefreshIotToken _:
        await _refreshToken();
        break;
      case JSMessageForOpenWechatPage page:
        await openWeChat(page.path);
      case JSMessageForOpenOuterPage page:
        pushOutPage(page.path);
      case JSMessageForNavigation nav:
        navigationTo(nav.path);
      case JSMessageForShare _:
        shareWith(messageString);
      case JSMessageThirdShare _:
        thirdPlatformShareWith(messageMap);
      case JSMessageForMapNavigation mapNav:
        mapNavigation(mapNav.navigation);
      case JSMessageForGetLocation _:
        await getLocation();
      case JSMessageForSaveImage saveImage:
        await saveImageFor(saveImage.type, saveImage.content);
      case JSMessageForPopState _:
        await popState();
      case JSMessageForOpenMiniProgram param:
        openMiniProgram(param.id, param.path);
      case JSMessageForWechatPay pay:
        await payFor(pay);
      case JSMessageForAliPay pay:
        await payFor(pay);
      case JSMessageForJianHangPay pay:
        await payFor(pay);
      case JSMessageForJDPay pay:
        await payFor(pay);
      case JSMessageForReloadWebView _:
        await reloadWebView();
      case JSSharedStorageSet set:
        await sharedStorageFor(set);
      case JSSharedStorageGet get:
        await sharedStorageFor(get);
      case JSSharedStorageRemove remove:
        await sharedStorageFor(remove);
      case JSKeyBoardObserver obser:
        obser.isAdd ? addKeyboardObserver() : removeKeyboardObserver();
        break;
      case JSMessageForRequestPermission permission:
        await requestPermission(permission.permissions);
        break;
      case JSMessageForBackBlock back:
        initBackBlock(back.isClear);
      case JSMessageForAR message:
        await onARChannel(message);
        break;
      default:
        break;
    }
    actionToWebMesage(message);
  }

  void actionToWebMesage(JSMessage? message) {}

  Future<void> popState() async {
    // bool canPop = false;
    // var controller = currentController;
    // if (controller != null) {
    //   canPop = await controller.canGoBack();
    // }
    // print('objectcan go Back ${canPop}');
    // updateCanPan(Platform.isIOS && canPop == false);
    await super.upateCanGoBack();
  }

  @override
  void onWebViewControllerCreated(InAppWebViewController controller) {
    super.onWebViewControllerCreated(controller);
    controller.addJavaScriptHandler(
      handlerName: 'messageChannel',
      callback: (arguments) {
        String messageString = arguments[0];
        if (messageString.isEmpty) return;
        _responseForMessageAction(messageString);
      },
    );
  }

  void destory() {
    currentController?.removeJavaScriptHandler(handlerName: 'messageChannel');
  }

  void initConfig() {
    // controller.addJavaScriptChannel(
    //   'messageChannel',
    //   onMessageReceived: (p0) {
    // String messageString = p0.message;
    // if (messageString.isEmpty) return;
    // responseForMessageAction(messageString);
    //   },
    // );
    // if (controller.platform is WebKitWebViewController) {
    //   (controller.platform as WebKitWebViewController)
    //       .setAllowsBackForwardNavigationGestures(true);
    // }
  }

  void updateEvent(CommonUIEvent event) {
    responseFor(event);
  }

  void addKeyboardObserver() {
    if (shouldAddObserverKeyboard) {
      return;
    }
    shouldAddObserverKeyboard = true;
  }

  void removeKeyboardObserver() {
    if (!shouldAddObserverKeyboard) {
      return;
    }
    shouldAddObserverKeyboard = false;
  }
}

extension MallContentAble on MallContentPageMinXin {
  Future<void> pushOpenWebView(String path) async {
    PushEvent event = PushEvent(
      path: MallPage.routePath,
      extra: path,
      pushCallback: (value) {
        goBackFromOther();
      },
    );
    updateEvent(event);
  }

  void goBackFromOther() {
    if (Platform.isAndroid) {
      callMethodToWeb('mountedOnshow', null);
    }
  }

  void pushOutPage(String path) {
    CommonUIEvent event = PushEvent(
      path: WebPage.routePath,
      extra: WebViewRequest(uri: WebUri(path), useHybridComposition: true),
    );
    updateEvent(event);
  }

  void closeMallWebView() {
    CommonUIEvent event = PushEvent(
      func: RouterFunc.pop,
    );
    updateEvent(event);
  }

  Future<void> _refreshSession() async {
    String? accessToken = (await AccountModule().getAuthBean()).accessToken;
    if (accessToken == null) return;

    try {
      LogUtils.i(
          '[MallContentPageMinXin] _refreshSession accessToken:${accessToken}');
      MallLoginRes? res =
          await ref.read(mallAuthManagerProvider.notifier).getMallAuthInfo();
      if (res == null) return;
      Map<String, dynamic> auth = {
        'type': '1',
        'data': {
          'accessToken': res.accessToken,
          'user_id': res.user_id,
        },
        'code': 0
      };
      LogUtils.i('[MallContentPageMinXin] _refreshSession auth:${auth}');
      await callMethodToWeb('onAppMessage', auth);
    } catch (e) {
      Map<String, dynamic> auth = {
        'msg': 'getAuthTCode fail',
        'code': -1,
      };
      LogUtils.i('[MallContentPageMinXin] _refreshSession error:$e');
      await callMethodToWeb('onAppMessage', auth);
      LogUtils.e('MallContentPageMinXin _refreshSession error: $e');
    }
  }

  Future<void> _refreshToken() async {
    try {
      String? accessToken = (await AccountModule().getAuthBean()).accessToken;
      LogUtils.i(
          '[MallContentPageMinXin] _refreshToken accessToken:$accessToken');
      if (accessToken == null) throw 'accessToken is null';
      MallLoginRes? res =
          await ref.read(mallAuthManagerProvider.notifier).getMallAuthInfo();
      if (res == null) throw 'loginMall error';
      await ref.read(userInfoStoreProvider).saveMallInfo(res);
      UserInfoModel? userInfo = await AccountModule().getUserInfo();
      var authBean = await AccountModule().getAuthBean();
      Map<String, dynamic> auth = {
        'data': {
          'accessToken': authBean.accessToken ?? '',
          'uid': userInfo?.uid ?? '',
        },
        'code': 0
      };
      await callMethodToWeb('onAppMessage', auth);
    } catch (e) {
      Map<String, dynamic> auth = {
        'msg': 'refresh fail',
        'code': -1,
      };
      await callMethodToWeb('onAppMessage', auth);
      LogUtils.e('MallContentPageMinXin _refreshSession error: $e');
    }
  }

  Future<void> openWeChat(String path) async {
    bool isInstall = await InfoModule().isAppInstalled('wechat');
    if (isInstall == false) {
      SmartDialog.showToast('text_wechat_uninstall_operate_failed'.tr());
      return;
    }
    WebUri fixUri = WebUri(path);
    debugPrint(fixUri.toString());
    CommonUIEvent event = PushEvent(
      path: WeChatPage.routePath,
      extra: WebViewRequest(
        uri: fixUri,
        useHybridComposition: useHybridComposition,
        headers: {
          'Referer': 'https://app-d.dreame.tech',
        },
      ),
    );
    updateEvent(event);
  }

  void navigationTo(String path) {
    switch (path) {
      case 'home/h5':
        //跳转到商城
        ref.read(appConfigProvider.notifier).resetApp();
        ref
            .read(mainStateNotifierProvider.notifier)
            .selectThemeType(TabItemType.mall);
        break;
      case 'home/device':
        //跳转到首页
        ref.read(appConfigProvider.notifier).resetApp();
        ref
            .read(mainStateNotifierProvider.notifier)
            .selectThemeType(TabItemType.device);
        break;
      case 'home/mine':
        //跳转到我的
        ref.read(appConfigProvider.notifier).resetApp();
        ref
            .read(mainStateNotifierProvider.notifier)
            .selectThemeType(TabItemType.mine);
        break;
      case 'mine/accountSetting':
        //跳转到个人信息页
        pushToAccountSetting();
        break;
      case 'mine/deviceShare':
        //跳转设备共享
        pushToDeviceShare();
        break;
      case 'mine/voiceControl':
        //跳转到语音控制
        pushToVoiceControl();
        break;
      case 'mine/widgetIntroduce':
        //跳转到小组件介绍
        pushToWidgetIntroduce();
        break;
      case 'mine/helpFeedback':
        //跳转到帮助与反馈
        pushToHelpCenter();
        break;
      case 'mine/appSetting':
        //跳转到设置
        pushToAppSetting();
        break;
      case 'device/addDevice':
        //跳转到添加设备页
        pushToAddDevice();
        break;
      case 'device/barcodeScan':
        //跳转到二维码
        pushToQr();
        break;
      case 'deivce/messageCenter':
        //跳转到消息中心
        pushMessageCenter();
        break;
      case 'deivce/homePage':
        //跳转到设备页
        pushToDeviceHome();
        break;
      case 'mine/chat':
        pushChat();
        break;
      default:
        break;
    }
  }

  Future<void>? reloadWebView() {
    return currentController?.reload();
  }

  void pushToDeviceHome() {
    if (ref
        .read(mainStateNotifierProvider.notifier)
        .haveTargetTab(TabItemType.device)) {
      // 存在Device TAB,切到Device TAB
      ref
          .read(mainStateNotifierProvider.notifier)
          .changeTab(TabItemType.device);
    } else {
      GoRouter.of(context).push(HomePage.routePath, extra: {'from': 'mall'});
    }
  }

  void pushToMineSetting() {}

  Future<void> pushChat() async {
    List<BaseDeviceModel> deviceList = [];
    if (ref.exists(homeStateNotifierProvider)) {
      deviceList = ref
          .read(homeStateNotifierProvider.select((value) => value.deviceList));
    }
    await ref
        .read(helpCenterRepositoryProvider)
        .pushToChat(context: context, deviceList: deviceList);
  }

  Future<void> pushToQr() async {
    var params = await UIModule().pushQRScanInfo();
    callMethodToWeb('onBarCodeScan', params);
  }

  void shareWith(String messageString) {
    if (messageString.isEmpty) return;
    UIModule().shareContent(messageString);
  }

  void thirdPlatformShareWith(Map<String, dynamic> messageMap) {
    if (messageMap.isEmpty) return;
    Map<String, dynamic> sharMessageData = messageMap['data'] ?? {};
    if (sharMessageData.isEmpty) return;
    UIModule().thirdShareContent(sharMessageData);
  }

  void mapNavigation(JSMapNavigation nav) {
    if (nav.title == null ||
        nav.location == null ||
        nav.location?.lat == null ||
        nav.location?.lon == null) return;
    NaivgateSheetShow navShow = NaivgateSheetShow(navigation: nav);
    updateEvent(ActionEvent(action: navShow));
  }

  Future<void> getLocation() async {
    var result = await UIModule().getLocation();
    callMethodToWeb('onAppMessage', result);
  }

  void openMiniProgram(String? appleId, String? path) {
    if (appleId == null || path == null) return;
    UIModule().openMiniProgram(appleId, path: path);
  }

  Future<void> payFor(JSMessageForPay pay) async {
    if (pay is JSMessageForAliPay) {
      await _payKitPlugin.pay(
        payRequest: AliPayRequest(
            orderInfo: pay.info.orderInfo,
            env:
                pay.info.env == 0 ? PayAlipayEnv.sandbox : PayAlipayEnv.online),
        response: (result) {
          int re = -1;
          if (result == PayStatus.success) {
            re = 1;
          } else if (result == PayStatus.cancel) {
            re = 0;
          } else if (result == PayStatus.failure) {
            re = -1;
          } else if (result == PayStatus.uninstall) {
            re = -101;
          }
          callMethodToWeb('onPayResponse', {'code': re});
        },
      );
    } else if (pay is JSMessageForWechatPay) {
      await _payKitPlugin.register(
        wechatOption: WechatOption(
          appId: 'wx59efb945de8565a0',
          universalLink: 'https://app.mova-tech.com/',
        ),
      );
      await _payKitPlugin.pay(
          payRequest: WeChatPayRequest(
              partnerId: '1684177000',
              prepayId: pay.info.prepayId,
              package: pay.info.package,
              nonceStr: pay.info.nonceStr,
              timeStamp: pay.info.timeStamp,
              sign: pay.info.sign),
          response: (result) {
            int re = -1;
            if (result == PayStatus.success) {
              re = 1;
            } else if (result == PayStatus.cancel) {
              re = 0;
            } else if (result == PayStatus.failure) {
              re = -1;
            } else if (result == PayStatus.uninstall) {
              re = -101;
            }
            callMethodToWeb('onPayResponse', {'code': re});
          });
    } else if (pay is JSMessageForJianHangPay) {
      try {
        final url = Uri.parse(pay.url);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          await _handleJianhangAppNotInstalled();
        }
      } catch (e) {
        ToastEvent alert = ToastEvent(text: 'operate_failed'.tr());
        updateEvent(alert);
      }
    }
  }

  // 处理建行生活未安装的情况
  Future<void> _handleJianhangAppNotInstalled() async {
    if (Platform.isIOS) {
      final jianhangAppStoreUrl = Uri.parse(
          'https://apps.apple.com/cn/app/%E5%BB%BA%E8%A1%8C%E7%94%9F%E6%B4%BB/id1472477795');
      bool isSuccess = await canLaunchUrl(jianhangAppStoreUrl);
      if (!isSuccess) {
        ToastEvent alert = const ToastEvent(text: '下载【建行生活APP】，完成相关支付');
        updateEvent(alert);
        return;
      }
      await launchUrl(jianhangAppStoreUrl);
    } else {
      ToastEvent alert = const ToastEvent(text: '下载【建行生活APP】，完成相关支付');
      updateEvent(alert);
    }
  }

  Future<void> saveImageFor(String type, String content) async {
    try {
      debugPrint(content);

      if (type == 'url') {
        if (content.startsWith('http://') || content.startsWith('https://')) {
          await saveImageFromUri(content);
        } else {
          await callMethodToWeb('onSaveImage', {
            'code': 1,
            'result': 'URL must start with http:// or https://',
          });
          return;
        }
      } else if (type == 'base64') {
        await saveImageFromBase64(content);
      } else {
        await callMethodToWeb('onSaveImage', {
          'code': 1,
          'result': 'type must be url or base64',
        });
        return;
      }

      await callMethodToWeb('onSaveImage', {
        'code': 0,
      });
    } catch (e) {
      final error = e.toString();
      LogUtils.e('MallContentPageMinXin saveImageFor error: $error');

      await callMethodToWeb('onSaveImage', {
        'code': 1,
        'result': error,
      });
      LogUtils.e('MallContentPageMinXin saveImageFor error2: $error');
    }
  }

  Future<void> saveImageFromBase64(String base64Str) async {
    try {
      // 检查 Base64 字符串是否有效
      if (!_isValidBase64(base64Str)) {
        throw '无效的 Base64 字符串';
      }

      // 检查存储权限
      await _checkStoragePermission();

      // 解析 Base64 字符串
      Uint8List bytes;
      try {
        bytes = base64Decode(base64Str);
      } catch (e) {
        throw '无效的 Base64 字符串: ${e.toString()}';
      }

      // 保存图片
      final result = await ImageGallerySaver.saveImage(bytes);
      if (result == null || result == '') throw '图片保存失败';
    } catch (e) {
      debugPrint('saveImageFromBase64 error: ${e.toString()}');
      throw '图片保存失败: ${e.toString()}';
    }
  }

  Future<void> saveImageFromUri(String uri) async {
    try {
      // 检查 URI 是否有效
      if (!_isValidUri(uri)) {
        throw '无效的 URI';
      }

      // 检查存储权限
      await _checkStoragePermission();

      // 下载图片
      var response = await Dio().get(
        uri,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode != 200) {
        throw '下载图片失败: HTTP ${response.statusCode}';
      }

      if (response.data == null || response.data.length == 0) {
        throw '下载的图片数据为空';
      }

      // 保存图片
      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
      if (result == null || result == '') throw '图片保存失败';
    } catch (e) {
      debugPrint('saveImageFromUri error: ${e.toString()}');
      throw '图片保存失败: ${e.toString()}';
    }
  }

  /// 相册权限
  Future<void> _checkStoragePermission() async {
    if (Platform.isIOS) {
      Permission permission = Permission.photos;
      PermissionStatus storageStatus = await permission.status;
      if (storageStatus == PermissionStatus.granted) {
        return;
      }
      if (storageStatus != PermissionStatus.granted &&
          storageStatus != PermissionStatus.limited) {
        storageStatus = await permission.request();
        if (storageStatus != PermissionStatus.granted &&
            storageStatus != PermissionStatus.limited) {
          throw '相册权限受限';
        }
      }
      throw '相册权限未授权';
    } else if (Platform.isAndroid) {
      PermissionStatus permissionStatus = PermissionStatus.granted;
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permissionStatus = await Permission.storage.status;
      } else {
        permissionStatus = await Permission.photos.status;
      }
      if (permissionStatus == PermissionStatus.granted ||
          permissionStatus == PermissionStatus.limited) {
        return;
      } else {
        // 权限被拒绝
        await showCustomAlertView(() async {
          // 如果是永久拒绝，则弹出弹框去设置开启权限
          PermissionStatus permissionStatus = PermissionStatus.granted;
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt <= 32) {
            permissionStatus = await Permission.storage.status;
          } else {
            permissionStatus = await Permission.photos.status;
          }
          if (permissionStatus == PermissionStatus.permanentlyDenied) {
            await showOpenSettingDialog();
            return;
          }
          if (androidInfo.version.sdkInt <= 32) {
            permissionStatus = await Permission.storage.request();
          } else {
            permissionStatus = await Permission.photos.request();
          }
          if (permissionStatus == PermissionStatus.granted ||
              permissionStatus == PermissionStatus.limited) {
            return;
          }
        });
        throw '相册权限未授权';
      }
    }
  }

  Future<void> showCustomAlertView(Function() confirmCallback) async {
    CustomAlertEvent alert = CustomAlertEvent(
      contentAlign: TextAlign.left,
      content: 'Toast_SystemServicePermission_CameraPhoto'.tr(),
      confirmContent: 'next'.tr(),
      cancelContent: 'cancel'.tr(),
      confirmCallback: confirmCallback,
      cancelCallback: () {},
    );
    showCustomCommonDialog(
        topWidget: alert.topWidget ?? const SizedBox.shrink(),
        content: alert.content ?? '',
        contentAlign: alert.contentAlign,
        confirmContent: alert.confirmContent ?? '',
        cancelContent: alert.cancelContent ?? '',
        cancelCallback: () {
          alert.cancelCallback?.call();
        },
        confirmCallback: () {
          alert.confirmCallback?.call();
        });
  }

  Future<void> showOpenSettingDialog() async {
    String permisson =
        '${'common_permission_camera'.tr()} 、 ${'common_permission_storage'.tr()}';
    String content = 'common_permission_fail_3'.tr(args: [permisson]);
    AlertEvent alert = AlertEvent(
        content: content,
        confirmContent: 'common_permission_goto'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmCallback: () {
          AppSettings.openAppSettings(type: AppSettingsType.settings);
        },
        cancelCallback: () {});
    showAlertDialog(
        title: alert.title ?? '',
        content: alert.content ?? '',
        contentAlign: alert.contentAlign,
        cancelContent: alert.cancelContent ?? '',
        cancelCallback: () {
          alert.cancelCallback?.call();
        },
        confirmContent: alert.confirmContent ?? '',
        confirmCallback: () {
          alert.confirmCallback?.call();
        });
  }

  bool _isValidBase64(String base64Str) {
    try {
      base64Decode(base64Str);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _isValidUri(String uri) {
    try {
      final parsedUri = Uri.parse(uri);
      return parsedUri.scheme == 'http' || parsedUri.scheme == 'https';
    } catch (_) {
      return false;
    }
  }

  Future<void> sharedStorageFor(JSSharedStorage storage) async {
    Map<String, dynamic>? result;
    if (storage is JSSharedStorageSet) {
      final ret = await LocalStorage()
          .putString(storage.key, storage.value, fileName: mallStorageKey);
      result = {
        'type': storage.type,
        'value': storage.value,
        'key': storage.key,
        'code': ret ? 0 : -1
      };
    } else if (storage is JSSharedStorageRemove) {
      bool isSuccess = false;
      if (storage.key != null && storage.key!.isNotEmpty) {
        isSuccess =
            await LocalStorage().remove(storage.key!, fileName: mallStorageKey);
      } else {
        isSuccess = await LocalStorage().clear(fileName: mallStorageKey);
      }
      result = {
        'type': storage.type,
        'key': storage.key,
        'code': isSuccess ? 0 : -1
      };
    } else if (storage is JSSharedStorageGet) {
      try {
        final value = await LocalStorage()
            .getString(storage.key, fileName: mallStorageKey);
        result = {
          'type': storage.type,
          'value': value,
          'key': storage.key,
          'code': 0
        };
      } catch (e) {
        result = {
          'type': storage.type,
          'value': '',
          'key': storage.key,
          'code': -1
        };
      }
    }
    await callMethodToWeb('onSharedStorage', result);
  }

  void sendKeyBoardHeight(double height) {
    callMethodToWeb('onKeyboardHeight', {'height': height});
  }

  Future<void> requestPermission(String permissions) async {
    var status = PermissionStatus.denied;
    if (permissions.contains('camera')) {
      status = await Permission.camera.request();
    }
    await callMethodToWeb(
        'requestPermission', {'result': status.isGranted, 'code': 0});
  }

  void initBackBlock(bool clear) {
    if (clear) {
      backBlockEvent = null;
      callMethodToWeb('backBlock', {'result': clear, 'code': 0});
      return;
    }
    backBlockEvent = () {
      callMethodToWeb('backBlock', {'result': clear, 'code': 0});
    };
  }

  Future<void> onARChannel(JSMessageForAR message) async {
    // if (message.type == 'isARSupport') {
    //   String systemVersion = await InfoModule().systemVersion() as String;
    //   bool isSupport = systemVersion.compareTo('13.0') >= 0;
    //   var params = {'type': message.type, 'data': isSupport};
    //   await callMethodToWeb('onARChannel', params);
    // } else if (message.type == 'goodsInfo') {
    //   var data = message.toMap();
    //   MallLoginRes? req = await ref.read(userInfoStoreProvider).getMallInfo();
    //   data['mallInfo'] = req?.toJson();
    //   await UIModule().onARChannel(data);
    // }
  }
}

extension MallContentForNavigate on MallContentPageMinXin {
  void pushToAccountSetting() {
    GoRouter.of(context).push(AccountSettingPage.routePath);
  }

  void pushToDeviceShare() {
    GoRouter.of(context).push(DeviceSharePage.routePath);
  }

  void pushToVoiceControl() {
    GoRouter.of(context).push(VoiceControlPage.routePath);
  }

  void pushToHelpCenter() {
    GoRouter.of(context).push(HelpCenterPage.routePath);
  }

  void pushToAppSetting() {
    GoRouter.of(context).push(SettingsPage.routePath);
  }

  void pushToAddDevice() {
    UIModule().openPage('/connect/device/productQR');
  }

  void pushMessageCenter() {
    GoRouter.of(context).push(MessageMainPage.routePath);
  }

  Future<void> pushToWidgetIntroduce() async {
    String lang = await LocalModule().getLangTag();
    String tenantId = await AccountModule().getTenantId();

    if (Platform.isIOS) {
      var url =
          'https://app-privacy-cn.iot.mova-tech.com/widget/index.html?tenantId=${tenantId}&lang=${lang}';

      final webrequest = WebViewRequest(
        uri: WebUri(url),
        cacheEnabled: true,
        useHybridComposition: true,
      );
      await GoRouter.of(context).push(WebPage.routePath, extra: webrequest);
    } else {
      await UIModule().openPage('/widget/appwidget/select');
    }
  }
}
