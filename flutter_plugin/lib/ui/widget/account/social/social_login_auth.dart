import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_plugin/ui/widget/account/social/model/social_userinfo_model.dart';
import 'package:flutter_plugin/ui/widget/account/social/sign_in_with_apple_auth.dart';
import 'package:flutter_plugin/ui/widget/account/social/wechat_auth.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';

const String GOOGLE_AUTH = "GOOGLE_APP";
const String FACEBOOK_AUTH = "FACEBOOK_APP";
const String WECHAT_AUTH = "WECHAT_OPEN";
const String APPLE_AUTH = "APPLE";

const int CODE_AUTH_SUCCESS = 0;
const int CODE_CANCEL = 1;
const int CODE_ERROR = 2;
const int CODE_UNINSTALLED = 3;
const int CODE_OTHER = 4;

typedef CallbackListener = void Function(int code, String? msg);
mixin SocialLoginAuth<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final WechatAuth _wechatAuth = WechatAuth.instance;
  final SignInWithAppleAuth? _appleSignInAuth =
      Platform.isIOS ? SignInWithAppleAuth.instance : null;

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  void initSDK() {
    LogUtils.i('--------- initSDK ------- ');
    _initGoogle();
    _initFacebook();
    _initWechat();
    _initAppleSignIn();
  }

  void _initGoogle() {}

  void _initFacebook() {}

  void _initWechat() async {
    LogUtils.i('--------- _initWechat ------- ');
    await _wechatAuth.initWechat();
  }

  void _initAppleSignIn() {
    LogUtils.i('--------- _signInWithApple init --------');
    _appleSignInAuth?.initSignIn();
  }

  /// 谷歌登录
  Future<Pair<bool, String?>> googleLogin() async {
    String clientId = Platform.isAndroid
        ? Constant.googleAndroidClientId
        : Constant.googleiOSClientId;
    GoogleSignIn? googleSignIn =
        GoogleSignIn(clientId: clientId, serverClientId: clientId);
    var isSignedIn = await googleSignIn.isSignedIn();
    if (isSignedIn == true) {
      await googleSignIn.signOut();
    }
    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      var googleSignInAuthentication = await account?.authentication;
      var idToken = googleSignInAuthentication?.idToken ?? '';
      LogUtils.d('---------------------- $account ');

      LogUtils.d('skkk---------------------- ${account?.email} ');
      bool isAuthorized = account != null;
      if (isAuthorized) {
        var token = idToken;
        LogUtils.d('---------------------- $token ');
        return Pair(true, token);
      }
    } catch (e) {
      LogUtils.d('---------------------- $e ');
    }
    unawaited(SmartDialog.showToast('operate_failed'.tr()));
    return Pair(false, null);
  }

  /// facebook 登录
  Future<Pair<bool, SocialTruck?>> facebookLogin() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      LogUtils.d('------------ facebookLogin logOut ---------- $e ');
    }
    try {
      bool shoulLitmited = false;

      if (Platform.isIOS) {
        String osVersion = Platform.operatingSystemVersion;
        RegExp regExp = RegExp(r'(\d+)\.(\d+)(?:\.(\d+))?');
        Match? match = regExp.firstMatch(osVersion);

        if (match == null) {
          shoulLitmited = true;
        } else {
          int majorVersion = int.parse(match.group(1)!);
          int minorVersion = int.parse(match.group(2)!);
          if (majorVersion > 14 || (majorVersion == 14 && minorVersion >= 5)) {
            TrackingStatus status =
                await AppTrackingTransparency.trackingAuthorizationStatus;
            if (status == TrackingStatus.restricted ||
                status == TrackingStatus.denied ||
                status == TrackingStatus.notDetermined) {
              if (majorVersion >= 17) {
                shoulLitmited = true;
              }
            }
          }
        }
      }
      LoginResult result = await FacebookAuth.instance.login(
        loginTracking:
            shoulLitmited ? LoginTracking.limited : LoginTracking.enabled,
        loginBehavior: LoginBehavior.nativeWithFallback,
        permissions: [
          'email',
          'public_profile',
        ],
      );
      LogUtils.d('------------ facebookLogin ---------- 1 ');
      if (shoulLitmited) {
        if (result.status == LoginStatus.success) {
          LogUtils.d('------------ facebookLogin ---------- 2 ');
          final userData = await FacebookAuth.instance.getUserData();
          SocialUserInfoModel userInfo = SocialUserInfoModel.fromJson(userData);
          SocialTruck socialTruck = SocialTruck(
            type: SocialType.facebook,
            userInfo: userInfo,
            token: result.accessToken?.tokenString ?? '',
          );
          return Pair(true, socialTruck);
        }
      } else {
        if (result.status == LoginStatus.success) {
          LogUtils.d('------------ facebookLogin ---------- 3 ');
          SocialTruck socialTruck = SocialTruck(
            type: SocialType.facebook,
            token: result.accessToken?.tokenString ?? '',
          );
          LogUtils.d('------------ facebookLogin ---------- 4 ');
          return Pair(true, socialTruck);
        }
      }
    } catch (e) {
      LogUtils.d('------------ facebookLogin ---------- $e ');
    }
    unawaited(SmartDialog.showToast('operate_failed'.tr()));
    return Pair(false, null);
  }

  /// apple登录
  /// https://github.com/firebase/flutterfire/blob/master/packages/firebase_ui_oauth_apple/README.md
  Future<void> appleLogin(CallbackListener listener) async {
    LogUtils.d('----------AppleLogin registerSubscriber--------');
    _appleSignInAuth?.registerSubscriber(listener);
    LogUtils.d('----------AppleLogin auth--------');
    await _appleSignInAuth?.auth();
    LogUtils.d('----------AppleLogin auth end --------');
  }

  /// 微信登录
  Future<void> wechatLogin(CallbackListener listener) async {
    LogUtils.d(
        '----------wechatLogin registerSubscriber--------${listener.hashCode} ');
    _wechatAuth.registerSubscriber(listener);
    LogUtils.d('----------wechatLogin auth--------');
    await _wechatAuth.auth();
    LogUtils.d('----------wechatLogin auth end --------');
  }
}
