/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-21 18:30:47
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-10-25 18:32:58
 * @FilePath: /flutter_plugin/lib/ui/common/js_action/js_message.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

import 'dart:convert';

import 'package:flutter_plugin/ui/common/js_action/js_app_share_info.dart';
import 'package:flutter_plugin/ui/common/js_action/js_map_navigation.dart';

sealed class JSMessage {
  const JSMessage();

  static JSMessage? registerFromMap(Map<String, dynamic>? map) {
    try {
      if (map == null) return null;
      String? type = map['type'];
      if (type == null) return null;
      switch (type) {
        case 'closeWebView':
          return JSMessageForCloseWebView();
        case 'navigation':
          Map<String, dynamic> data = map['data'];
          JSMessageForNavigation navigation = JSMessageForNavigation(
            path: data['path'],
            pathType: data['type'],
          );
          return navigation;
        case 'refreshAccessToken':
          return JSMessageForRefreshAccessToken();
        case 'share':
          String? jsonString = jsonEncode(map);
          Map<String, dynamic> data = map['data'];
          JSMessageForShare share = JSMessageForShare(
              target: data['target'],
              type: data['type'],
              oriString: jsonString,
              content: JsAppShareContent.fromMap(data['content']));
          return share;
        case 'thirdShare':
          Map<String, dynamic> data = map['data'];
          JSMessageThirdShare share = JSMessageThirdShare(
            title: data['title'] ?? 'MOVAhome',
            content: data['content'] ?? '',
            url: data['url'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
          );
          return share;
        case 'openWechatPage':
          String path = map['data'];
          return JSMessageForOpenWechatPage(path: path);
        case 'refreshSession':
          return JSMessageForRefreshSession();
        case 'refreshToken':
          return JSMessageForRefreshIotToken();
        case 'openWebview':
          String path = map['data'];
          return JSMessageForOpenWebview(path: path);
        case 'openOuterPage':
          String path = map['data'];
          return JSMessageForOpenOuterPage(path: path);
        case 'mapNavigation':
          return JSMessageForMapNavigation.createFrom(map['data']);
        case 'getLocation':
          return JSMessageForGetLocation();
        case 'saveImage':
          Map<String, dynamic> data = map['data'];
          return JSMessageForSaveImage(data: data);
        case 'popstate':
          return JSMessageForPopState();
        case 'pushstate':
          return JSMessageForPopState();
        case 'openMiniProgram':
          Map<String, dynamic> data = map['data'];
          return JSMessageForOpenMiniProgram(data: data);
        case 'pay':
          Map<String, dynamic> data = map['data'];
          return JSMessageForPay.createFrom(data);
        case 'reloadWebview':
          return JSMessageForReloadWebView();
        case 'sharedStorage':
          return JSSharedStorage.createFrom(map['data']);
        case 'getAuthCode':
          return JSMessageForGetAuthToken();
        case 'keyboardForObserver':
          dynamic isadd = map['data'];
          return JSKeyBoardObserver.createFrom(isadd);
        case 'getUserEmail':
          // String? email = map['data'];因为临时改不需要email
          return JSMessageForGetEmail(email: null);
        case 'keyboardUnfocus':
          return JSMessageForKeyboardUnfocus();
        case 'showLoading':
          return JSMessageForshowLoading(data: map['data']);
        case 'hideLoading':
          return JSMessageForHideLoading();
        case 'requestPermission':
          return JSMessageForRequestPermission(permissions: map['data']);
        case 'backBlockForObserver':
          return JSMessageForBackBlock(isClear: map['data']);
        case 'onARChannel':
          var channel_data = map['data'];
          var type = channel_data['type'];
          var data = channel_data['data'];
          var message = JSMessageForAR(type: type, data: data);
          return message;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }
}

// ignore: camel_case_types
class JSMessageForCloseWebView extends JSMessage {}

class JSMessageForGetLocation extends JSMessage {}

class JSMessageForPopState extends JSMessage {}

class JSMessageForReloadWebView extends JSMessage {}

class JSMessageForGetAuthToken extends JSMessage {}

class JSMessageForGetEmail extends JSMessage {
  JSMessageForGetEmail({this.email});

  String? email;
}

class JSMessageForshowLoading extends JSMessage {
  int timeout = 3000;
  String? title;

  JSMessageForshowLoading({required Map<String, dynamic> data}) {
    var gettimeout = data['timeout'];
    if (gettimeout != null) {
      if (gettimeout is int) {
        timeout = gettimeout > 0 ? gettimeout : 3000;
      } else if (gettimeout is String) {
        timeout = int.tryParse(gettimeout) ?? 3000;
      }
    }
    title = data['title'];
  }
}

class JSMessageForHideLoading extends JSMessage {}

class JSMessageForKeyboardUnfocus extends JSMessage {}

class JSMessageForInputFocus extends JSMessage {
  JSMessageForInputFocus(
      {required this.y,
      required this.height,
      required this.x,
      required this.width});

  String x;
  String y;
  String width;
  String height;

  static JSMessageForInputFocus? createFrom(Map<String, dynamic>? map) {}
}

class JSMessageForOpenWebview extends JSMessage {
  JSMessageForOpenWebview({required this.path});

  String path;
}

class JSMessageForNavigation extends JSMessage {
  JSMessageForNavigation({required this.path, required this.pathType});

  String path;
  String pathType;
}

class JSMessageForShare extends JSMessage {
  JSMessageForShare(
      {required this.target, required this.type, this.oriString, this.content});

  String target;
  String type;
  JsAppShareContent? content;
  String? oriString;
}

class JSMessageThirdShare extends JSMessage {
  JSMessageThirdShare({
    required this.title,
    required this.url,
    this.content = '',
    this.imageUrl = '',
  });

  String title;
  String url;
  String? content;
  String? imageUrl;
}

class JSMessageForOpenWechatPage extends JSMessage {
  JSMessageForOpenWechatPage({required this.path});

  String path;
}

class JSMessageForRefreshSession extends JSMessage {}

class JSMessageForRefreshIotToken extends JSMessage {}

// 刷新 accesstoken
class JSMessageForRefreshAccessToken extends JSMessage {}

class JSMessageForOpenOuterPage extends JSMessage {
  JSMessageForOpenOuterPage({required this.path});

  String path;
}

class JSMessageForSaveImage extends JSMessage {
  JSMessageForSaveImage({required Map<String, dynamic> data}) {
    type = data['type'];
    content = data['content'];
  }

  late String type;
  late String content;
}

class JSMessageForMapNavigation extends JSMessage {
  JSMessageForMapNavigation({required this.navigation});

  // String title;
  JSMapNavigation navigation;

  static JSMessageForMapNavigation? createFrom(Map<String, dynamic>? map) {
    if (map == null) return null;
    JSMapNavigation navigation = JSMapNavigation.fromJson(map);
    String? title = navigation.title;
    JSMapLocation? location = navigation.location;
    if (title == null || location == null) return null;
    return JSMessageForMapNavigation(navigation: navigation);
  }
}

class JSMessageForOpenMiniProgram extends JSMessage {
  JSMessageForOpenMiniProgram({required Map<String, dynamic> data}) {
    id = data['id'];
    path = data['path'];
  }

  late String id;
  late String path;
}

class JSMessageForPay extends JSMessage {
  JSMessageForPay({required this.type});

  String type;

  static JSMessage? createFrom(Map<String, dynamic>? map) {
    if (map == null) return null;

    String? type = map['type'];
    if (type == null) return null;

    switch (type) {
      case 'alipay':
        Map<String, dynamic> data = map['info'];

        Map<String, dynamic> order = data['orderInfo'];

        int env = int.parse(data['env']);

        String orderInfo = order['prepay_id'];

        return JSMessageForAliPay(
            info: JSMessageForAliPayInfo(orderInfo: orderInfo, env: env),
            type: type);
      case 'wechat_pay':
        Map<String, dynamic> data = map['info'];

        return JSMessageForWechatPay(
            info: JSMessageForWechatPayInfo(
                prepayId: data['prepayId'],
                package: data['package'],
                nonceStr: data['nonceStr'],
                timeStamp: data['timeStamp'].toString(),
                sign: data['sign']),
            type: type);
      case 'jianhangApp':
        Map<String, dynamic>? data = map['info'];
        String? url = data?['url'];
        return JSMessageForJianHangPay(type: type, url: url ?? '');
      case 'jd_pay_h5':
        Map<String, dynamic> data = map['info'];
        Map<String, dynamic> order = data['orderInfo'];
        Map<String, dynamic> prepay = jsonDecode(order['prepay_id']);
        return JSMessageForJDPay(
            info: JSMessageForJDPayInfo(
                orderId: prepay['order_id'],
                appId: prepay['app_id'],
                merchant: prepay['merchant'],
                signData: prepay['response']),
            type: type);
      default:
        return null;
    }
  }
}

class JSMessageForAliPay extends JSMessageForPay {
  JSMessageForAliPay({required this.info, required super.type});
  JSMessageForAliPayInfo info;
}

class JSMessageForAliPayInfo {
  JSMessageForAliPayInfo({required this.orderInfo, required this.env});
  String orderInfo;
  int env;
}

class JSMessageForWechatPay extends JSMessageForPay {
  JSMessageForWechatPay({required this.info, required super.type});
  JSMessageForWechatPayInfo info;
}

class JSMessageForJianHangPay extends JSMessageForPay {
  JSMessageForJianHangPay({required this.url, required super.type});
  String url;
}

class JSMessageForWechatPayInfo {
  JSMessageForWechatPayInfo(
      {required this.prepayId,
      required this.nonceStr,
      required this.package,
      required this.timeStamp,
      required this.sign});

  String? partnerId;
  String prepayId;
  String package;
  String nonceStr;
  String timeStamp;
  String sign;
}

class JSMessageForJDPay extends JSMessageForPay {
  JSMessageForJDPay({required this.info, required super.type});

  JSMessageForJDPayInfo info;
}

class JSMessageForJDPayInfo {
  JSMessageForJDPayInfo(
      {required this.orderId,
      required this.merchant,
      required this.appId,
      required this.signData,
      this.extraInfo = ''});

  String orderId;
  String merchant;
  String appId;
  String signData;
  String extraInfo;
}

class JSSharedStorage extends JSMessage {
  JSSharedStorage({required this.type});
  String type;

  static JSSharedStorage? createFrom(Map<String, dynamic>? map) {
    if (map == null) return null;

    String? type = map['type'];
    if (type == null) return null;

    switch (type) {
      case 'set':
        Map<String, dynamic> data = map['data'];
        String key = data['key'];
        String value = data['value'];
        return JSSharedStorageSet(type: type, key: key, value: value);
      case 'get':
        Map<String, dynamic> data = map['data'];
        String key = data['key'];
        return JSSharedStorageGet(type: type, key: key);
      case 'remove':
        Map<String, dynamic> data = map['data'];
        String key = data['key'];
        return JSSharedStorageRemove(type: type, key: key);
      default:
        return null;
    }
  }
}

class JSKeyBoardObserver extends JSMessage {
  JSKeyBoardObserver({required this.isAdd});
  static JSKeyBoardObserver createFrom(dynamic isAdd) {
    if (isAdd is bool) return JSKeyBoardObserver(isAdd: isAdd);
    if (isAdd is String) {
      return JSKeyBoardObserver(isAdd: isAdd == '1');
    }
    return JSKeyBoardObserver(isAdd: false);
  }

  final bool isAdd;
}

class JSSharedStorageGet extends JSSharedStorage {
  JSSharedStorageGet({required this.key, required super.type});
  String key;
}

class JSSharedStorageSet extends JSSharedStorage {
  JSSharedStorageSet(
      {required this.key, required this.value, required super.type});
  String key;
  String value;
}

class JSSharedStorageRemove extends JSSharedStorage {
  JSSharedStorageRemove({required this.key, required super.type});
  String? key;
}

class JSMessageForRequestPermission extends JSMessage {
  JSMessageForRequestPermission({required this.permissions});

  String permissions;
}

class JSMessageForBackBlock extends JSMessage {
  JSMessageForBackBlock({required this.isClear});

  bool isClear;
}

class JSMessageForAR extends JSMessage {
  JSMessageForAR({required this.type, this.data});

  String type;
  dynamic? data;

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic?> toMap() {
    return {
      'type': type,
      'data': data,
    };
  }
}
