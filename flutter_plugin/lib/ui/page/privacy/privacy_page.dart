import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/feature_module.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/configure/app_config_prodiver.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'privacy_policy_mixin.dart';

/// 隐私页
class PrivacyPage extends BasePage {
  static const String routePath = '/privacy_page';

  const PrivacyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PrivacyPageState();
  }
}

class _PrivacyPageState extends BasePageState with PrivacyPolicyMixin {
  /// 退出
  Future<void> onClickQuit() async {
    LogModule().eventReport(0, 2);
    // finish
    exit(0);
  }

  /// 同意并继续
  Future<void> onClickAgree() async {
    LogModule().eventReport(0, 3);
    await AccountModule().agreeProtocol();

    /// 重新刷新一下页面
    await ref.watch(appConfigProvider.notifier).refresh();

    /// 同意隐私，初始化SDK
    await FeatureModule().initSomeSdkAfterAgreePrivacy();
    if (await InfoModule().isRooted()) {
      SmartDialog.showToast('text_device_rooted'.tr());
    }

    /// 重置栈
    await AppRoutes.resetStacks();
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return null;
  }

  List<InlineSpan> stringParser1(StyleModel style, ResourceModel resource) {
    final List<TextSpan> spans = <TextSpan>[];
    var privacyPolicyTitleSecond = 'privacy_policy_title_second'.tr();
    var userAgreement2 = 'user_agreement_pri_index'.tr();
    var userPrivacy2 = 'user_privacy_pri_index'.tr();

    var indexAgreement = privacyPolicyTitleSecond.indexOf(userAgreement2);
    var indexPrivacy = privacyPolicyTitleSecond.indexOf(userPrivacy2);
    if (indexAgreement != -1) {
      spans.add(TextSpan(
          text: privacyPolicyTitleSecond.substring(0, indexAgreement),
          style: style.secondStyle()));
      spans.add(TextSpan(
          text: privacyPolicyTitleSecond.substring(
              indexAgreement, indexAgreement + userAgreement2.length),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              // 用户协议
              await viewUserAgreement();
            },
          style: TextStyle(
            fontSize: 14,
            color: style.click,
          )));
    }
    if (indexAgreement != -1 && indexPrivacy != -1) {
      spans.add(TextSpan(
          text: privacyPolicyTitleSecond.substring(
              indexAgreement + userAgreement2.length, indexPrivacy),
          style: style.secondStyle()));
    }
    if (indexPrivacy != -1) {
      spans.add(TextSpan(
          text: privacyPolicyTitleSecond.substring(
              indexPrivacy, indexPrivacy + userPrivacy2.length),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              // 隐私政策
              await viewUserPrivacy();
            },
          style: TextStyle(
            fontSize: 14,
            color: style.click,
          )));
    }
    return spans;
  }

  List<InlineSpan> stringParser2(StyleModel style, ResourceModel resource) {
    final List<TextSpan> spans = <TextSpan>[];
    var privacyPolicyTitleSecond = 'privacy_policy_title_second'.tr();
    var userPrivacy2 = 'user_privacy_pri_index'.tr();
    var indexPrivacy = privacyPolicyTitleSecond.indexOf(userPrivacy2);
    spans.add(TextSpan(
        text: privacyPolicyTitleSecond
            .substring(indexPrivacy + userPrivacy2.length),
        style: style.secondStyle(),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
          },
        semanticsLabel: privacyPolicyTitleSecond
            .substring(indexPrivacy + userPrivacy2.length),
        spellOut: true));
    return spans;
  }

  Widget _buildContent(StyleModel style, ResourceModel resource) {
    final statusHeight = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32, top: statusHeight + 32)
          .withRTL(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Image.asset(
              resource.getResource('splash_logo'),
              width: 85,
              height: 20,
            ),
          ),
          const SizedBox(height: 35),
          Text(
            'privacy_policy_title_first'.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: style.textMain,
              fontSize: 20,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(children: stringParser1(style, resource)),
          ),
          Semantics(
            label: 'privacy_policy_title_second'.tr(),
            excludeSemantics:  true,
            child: Text.rich(
              TextSpan(children: stringParser2(style, resource)),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'privacy_policy_title_third'.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: style.textSecond,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButon(StyleModel style, ResourceModel resource) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 34)
          .withRTL(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: [
          Expanded(
            child: DMButton(
              onClickCallback: (_) {
                onClickQuit();
              },
              text: 'privacy_policy_quit'.tr(),
              backgroundGradient: style.cancelBtnGradient,
              textColor: style.cancelBtnTextColor,
              borderRadius: style.buttonBorder,
              borderColor: style.lightBlack1,
              fontsize: 16,
              fontWidget: FontWeight.w500,
              width: double.infinity,
              height: 48,
              autoSizeTextEnable: true,
              maxLines: 2,
              minFontSize: 6,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: DMButton(
              onClickCallback: (_) {
                onClickAgree();
              },
              text: 'privacy_policy_agree'.tr(),
              textColor: style.enableBtnTextColor,
              backgroundGradient: style.confirmBtnGradient,
              borderRadius: style.buttonBorder,
              borderColor: style.lightBlack2,
              fontsize: 16,
              borderWidth: 0,
              fontWidget: FontWeight.w500,
              width: double.infinity,
              height: 48,
              autoSizeTextEnable: true,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    ref.watch(privacyPolicyProvider);
    return Container(
      color: style.bgWhite,
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: _buildContent(style, resource),
              )),
          _buildButon(style, resource)
        ],
      ),
    );
  }
}
