import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth.dart';
import 'package:flutter_plugin/utils/logutils.dart';

typedef WechatAuthListener = void Function(dynamic event);

class WechatAuth {
  static const MethodChannel _wechatMethod =
      MethodChannel('com.dreame.flutter/wechatChannel');
  static const EventChannel _wechatEvent =
      EventChannel('com.dreame.flutter/wechatEvent');

  static WechatAuth? _instance;

  // 私有的命名构造函数
  WechatAuth._internal();

  static WechatAuth get instance {
    if (_instance == null) {
      _registerResponseListener();
      _instance = WechatAuth._internal();
    }

    return _instance!;
  }

  static late final WeakReference<void Function(dynamic event)>
      responseListener;
  static final List<WechatAuthListener> _responseListeners = [];
  static final List<CallbackListener> _callbackListener = [];

  static void _registerResponseListener() {
    responseListener = WeakReference((event) {
      for (var listener in _responseListeners) {
        listener(event);
      }
    });
    final target = responseListener.target;
    if (target != null) {
      _wechatEvent.receiveBroadcastStream().listen(target);
    }
  }

  Future<bool> initWechat() {
    _wechatMethod.invokeMethod('initWechat');
    return Future.value(true);
  }

  void registerSubscriber(CallbackListener listener) {
    clearSubscribers();
    _callbackListener.add(listener);

    addSubscriber((event) {
      _handleEvent(event);
    });
    LogUtils.d(
        '-----------registerSubscriber--------- ${_callbackListener.length}  ${_responseListeners.length}');
  }

  Future<void> auth() async {
    LogUtils.d('----------- auth---------');
    await _wechatMethod.invokeMethod('authWechat');
  }

  void dispose() {
    _wechatMethod.invokeMethod('dipose');
  }

  void _handleEvent(event) {
    LogUtils.d('-----------_handleEvent---------$event ');
    if (event is Map) {
      var eventMap = event;
      int code = eventMap['errorCode'] as int;
      String msg = eventMap['authCode'] as String;
      switch (code) {
        case CODE_AUTH_SUCCESS:
          for (var listener in _callbackListener) {
            listener.call(CODE_AUTH_SUCCESS, msg);
          }
          break;
        case CODE_CANCEL:
          for (var listener in _callbackListener) {
            listener.call(CODE_CANCEL, 'operate_failed'.tr());
          }
          break;
        case CODE_ERROR:
          for (var listener in _callbackListener) {
            listener.call(CODE_ERROR, 'operate_failed'.tr());
          }
          break;
        case CODE_UNINSTALLED:
          for (var listener in _callbackListener) {
            listener.call(
                CODE_UNINSTALLED, 'Toast_3rdPartyBundle_NoWeChat_Tip'.tr());
          }
          break;
        case CODE_OTHER:
          for (var listener in _callbackListener) {
            listener.call(CODE_OTHER, 'operate_failed'.tr());
          }
          break;
        default:
          for (var listener in _callbackListener) {
            listener.call(CODE_OTHER, 'operate_failed'.tr());
          }
          break;
      }
    } else {
      for (var listener in _callbackListener) {
        listener.call(CODE_OTHER, 'operate_failed'.tr());
      }
    }
    clearSubscribers();
  }

  /// Add a subscriber to subscribe responses from WeChat
  void addSubscriber(WechatAuthListener listener) {
    _responseListeners.add(listener);
  }

  /// remove your subscriber from WeChat
  void removeSubscriber(WechatAuthListener listener) {
    _responseListeners.remove(listener);
  }

  void removeCallbackListener(CallbackListener listener) {
    _callbackListener.remove(listener);
  }

  /// remove all existing
  void clearSubscribers() {
    _responseListeners.clear();
    _callbackListener.clear();
  }
}
