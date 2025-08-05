import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth.dart';
import 'package:flutter_plugin/utils/logutils.dart';

typedef AppleSignInAuthListener = void Function(dynamic event);

class SignInWithAppleAuth {
  static const MethodChannel _appleSignInMethod =
      MethodChannel('com.dreame.flutter/appleSignInChannel');
  static const EventChannel _appleSignInEvent =
      EventChannel('com.dreame.flutter/appleSignInEvent');

  static SignInWithAppleAuth? _instance;

  SignInWithAppleAuth._internal();

  static SignInWithAppleAuth get instance {
    if (_instance == null) {
      _registerResponseListener();
      _instance = SignInWithAppleAuth._internal();
    }
    return _instance!;
  }

  static late final WeakReference<void Function(dynamic event)>
      responseListener;
  static final List<AppleSignInAuthListener> _responseListeners = [];
  static final List<CallbackListener> _callbackListener = [];

  static void _registerResponseListener() {
    responseListener = WeakReference((event) {
      for (var listener in _responseListeners) {
        listener(event);
      }
    });
    final target = responseListener.target;
    if (target != null) {
      _appleSignInEvent.receiveBroadcastStream().listen(target);
    }
  }

  Future<bool> initSignIn() {
    _appleSignInMethod.invokeMethod('initSignIn');
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
    await _appleSignInMethod.invokeMethod('signIn');
  }

  void _handleEvent(event) {
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
  }

  void dispose() {
    _appleSignInMethod.invokeMethod('dispose');
  }

  /// Add a subscriber to subscribe responses from Apple Sign In
  void addSubscriber(AppleSignInAuthListener listener) {
    _responseListeners.add(listener);
  }

  /// remove your subscriber from Apple Sign In
  void removeSubscriber(AppleSignInAuthListener listener) {
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
