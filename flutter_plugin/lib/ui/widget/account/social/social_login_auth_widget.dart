import 'dart:async';
import 'dart:io';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth.dart';
import 'package:flutter_plugin/ui/widget/account/social/model/social_userinfo_model.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

typedef SocailAuthCallback = Function(bool, String, dynamic?);
typedef SocailOtherCallback = Function();

/// 三方登录按钮
///
class SocialLoginAuthWidget extends ConsumerStatefulWidget {
  final bool isPrivacyChecked;
  final double height;
  final bool isCnDomain;
  final String btnImage;
  final String text;
  final Color? textColor;
  final double textSize;
  final SocailOtherCallback otherCallback;
  final SocailAuthCallback authCallback;
  final void Function(bool calling)? onCallingCallback;

  /// 三方登录组件
  const SocialLoginAuthWidget({
    super.key,
    required this.isCnDomain,
    required this.text,
    required this.btnImage,
    this.isPrivacyChecked = false,
    this.textColor,
    this.textSize = 14,
    this.height = 80,
    required this.otherCallback,
    required this.authCallback,
    this.onCallingCallback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SocialLoginAuthState();
  }
}

class _SocialLoginAuthState extends ConsumerState<SocialLoginAuthWidget>
    with SocialLoginAuth {
  bool showWeChat = true;
  bool? isGpFavor = null;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      updateStatus();
    }
    isGpVersion();
  }

  Future<void> updateStatus() async {
    bool weChatInstall = await InfoModule().isAppInstalled('wechat');
    setState(() {
      showWeChat = weChatInstall;
    });
  }

  Future<void> isGpVersion() async {
    if (Platform.isAndroid) {
      bool isGpVersion = await InfoModule().isGpVersion();
      setState(() {
        isGpFavor = isGpVersion;
      });
    }
  }

  Future<void> onPasswordPressed() async {
    widget.otherCallback();
  }

  Future<void> onWechatPressed() async {
    LogUtils.d('------- onWechatPressed ------ ');
    if (!widget.isPrivacyChecked) {
      unawaited(SmartDialog.showToast('terms_uncheck'.tr()));
      return;
    }
    widget.onCallingCallback?.call(true);
    await wechatLogin((code, msg) {
      widget.onCallingCallback?.call(false);
      if (context.mounted) {
        if (code != CODE_AUTH_SUCCESS) {
          unawaited(SmartDialog.showToast(msg ?? 'operate_failed'.tr()));
        }
        widget.authCallback.call(code == CODE_AUTH_SUCCESS, WECHAT_AUTH, msg);
      }
    });
  }

  Future<void> onGooglePressed() async {
    if (!widget.isPrivacyChecked) {
      unawaited(SmartDialog.showToast('terms_uncheck'.tr()));
      return;
    }
    widget.onCallingCallback?.call(true);
    Pair<bool, String?> pair = await googleLogin();
    widget.onCallingCallback?.call(false);
    widget.authCallback.call(pair.first, GOOGLE_AUTH, pair.second);
  }

  Future<void> onApplePressed() async {
    if (!widget.isPrivacyChecked) {
      unawaited(SmartDialog.showToast('terms_uncheck'.tr()));
      return;
    }
    widget.onCallingCallback?.call(true);
    await appleLogin((code, msg) {
      widget.onCallingCallback?.call(false);
      if (code != CODE_AUTH_SUCCESS) {
        unawaited(SmartDialog.showToast(msg ?? 'operate_failed'.tr()));
      }
      widget.authCallback.call(code == CODE_AUTH_SUCCESS, APPLE_AUTH, msg);
    });
  }

  Future<void> onFacebookPressed() async {
    if (!widget.isPrivacyChecked) {
      unawaited(SmartDialog.showToast('terms_uncheck'.tr()));
      return;
    }
    widget.onCallingCallback?.call(true);
    Pair<bool, SocialTruck?> pair = await facebookLogin();
    widget.onCallingCallback?.call(false);
    widget.authCallback.call(pair.first, FACEBOOK_AUTH, pair.second);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return Container(
        // height: widget.height,
        width: double.infinity,
        padding: EdgeInsets.zero,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              widget.text,
              style: TextStyle(
                  color: widget.textColor ?? style.textSecond,
                  fontWeight: FontWeight.w500,
                  fontSize: widget.textSize),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _buildSocialWidget(style, resource)
        ]),
      );
    });
  }

  Widget _buildSocialWidget(StyleModel style, ResourceModel resource) {
    if (Platform.isAndroid) {
      if (isGpFavor == null) {
        return _buildDefault(style, resource);
      }
      return isGpFavor == true
          ? _buildOther(style, resource)
          : _buildCn(style, resource);
    } else {
      return widget.isCnDomain
          ? _buildCn(style, resource)
          : _buildOther(style, resource);
    }
  }

  String getSemanticLabel(String btnImage) {
    final Map<String, String> loginButtonTitles = {
      'social_mobile':'sigh_up_with_phone_verification_code'.tr(),
      'social_password': 'sign_up_with_username_and_password'.tr(),
    };
    if (btnImage.isEmpty) {
      return '';
    }
    return loginButtonTitles[btnImage] ?? '';
  }

  Widget _buildDefault(StyleModel style, ResourceModel resource) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Semantics(
            label: getSemanticLabel(widget.btnImage),
            child: GestureDetector(
                onTap: onPasswordPressed,
                child: Image.asset(
                  resource.getResource(widget.btnImage),
                  width: 40,
                  height: 40,
                )),
          ),
        ),
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(width: 40, height: 40),
        ),
      ],
    );
  }

  Widget _buildCn(StyleModel style, ResourceModel resource) {
    var isIOS = Platform.isIOS;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Semantics(
            label: getSemanticLabel(widget.btnImage),
            child: GestureDetector(
                onTap: onPasswordPressed,
                child: Image.asset(
                  resource.getResource(widget.btnImage),
                  width: 40,
                  height: 40,
                )),
          ),
        ),
        if (showWeChat)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Semantics(
              label: 'share_weixin'.tr(),
              child: GestureDetector(
                  onTap: onWechatPressed,
                  child: Image.asset(
                    resource.getResource('social_wechat'),
                    width: 40,
                    height: 40,
                  )),
            ),
          ),
        if (isIOS && isIOSVersionGreaterThan13())
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Semantics(
              label: 'sign_up_with_apple'.tr(),
              child: GestureDetector(
                  onTap: onApplePressed,
                  child: Image.asset(
                    resource.getResource('social_apple'),
                    width: 40,
                    height: 40,
                  )),
            ),
          ),
      ],
    );
  }

  Widget _buildOther(StyleModel style, ResourceModel resource) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Semantics(
            label: getSemanticLabel(widget.btnImage),
            child: GestureDetector(
                onTap: onPasswordPressed,
                child: Image.asset(
                  resource.getResource(widget.btnImage),
                  width: 40,
                  height: 40,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Semantics(
            label: 'sigh_up_with_facebook'.tr(),
            child: GestureDetector(
                onTap: onFacebookPressed,
                child: Image.asset(
                  resource.getResource('social_facebook'),
                  width: 40,
                  height: 40,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Semantics(
            label: 'sign_up_with_google'.tr(),
            child: GestureDetector(
                onTap: onGooglePressed,
                child: Image.asset(
                  resource.getResource('social_google'),
                  width: 40,
                  height: 40,
                )),
          ),
        ),
        ...addAppleWidget(resource)
      ],
    );
  }

  List<Widget> addAppleWidget(resource) {
    return Platform.isIOS && isIOSVersionGreaterThan13()
        ? [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Semantics(
                label: 'sign_up_with_apple'.tr(),
                child: GestureDetector(
                  onTap: onApplePressed,
                  child: Image.asset(
                    resource.getResource('social_apple'),
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            )
          ]
        : [];
  }

  bool isIOSVersionGreaterThan13() {
    if (Platform.isIOS) {
      final iosVersion = Platform.operatingSystemVersion;
      final versionComponents = iosVersion.split('.');
      final versionComponent = versionComponents.firstOrNull;
      if (versionComponent == null) {
        return false;
      }
      final realVersionComponents = versionComponent.split(' ');
      final realVersionComponent = realVersionComponents.lastOrNull;
      if (realVersionComponent == null) {
        return false;
      }
      final majorVersion = int.tryParse(realVersionComponent);
      return majorVersion != null && majorVersion > 13;
    }

    return false;
  }
}
