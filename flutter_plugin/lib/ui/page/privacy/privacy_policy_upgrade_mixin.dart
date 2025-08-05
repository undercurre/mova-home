import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/account/privacy_res.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_type.dart';
import 'package:flutter_plugin/ui/widget/dialog/privacy_policy_upgrade_sheet.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'privacy_policy_state_notifier.dart';

/// 首页隐私更新
mixin PrivacyPolicyUpgradeMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  @override
  void dispose() {
    super.dispose();
    SmartDialog.dismiss(tag: 'tag_privacy_dialog');
  }

  /// show 隐私更新dialog
  void showPrivacyPolicyUpgradeDialog(PrivacyInfoBean bean) {
    if (!context.mounted) {
      return;
    }
    LogUtils.i(
        '-------- showPrivacyPolicyUpgradeDialog ---------  ${bean.toJson()} ');
    String content = bean.privacyChangelog ?? '';
    SmartDialog.show(
        tag: 'tag_privacy_dialog',
        alignment: Alignment.bottomCenter,
        backDismiss: false,
        clickMaskDismiss: false,
        builder: (_) {
          LogUtils.d(
              '---------- showPrivacyPolicyUpgradeDialog showModalBottomSheet ----------- $context');
          return PrivacyPolicyUpgradeSheet(
            privacyUrl: bean.privacyUrl,
            agreementUrl: bean.agreementUrl,
            content: content,
            agreeClick: () {
              SmartDialog.dismiss(tag: 'tag_privacy_dialog');
              // 保存 feedback
              ref.watch(privacyPolicyProvider.notifier).feedback(bean);
              ref.read(dialogJobManagerProvider.notifier).nextJob();
              ref.read(userConfigPageStateNotifierProvider.call(UserConfigType.uxPlan).notifier).agreeUXPlan();
            },
            rejectClick: () {
              exit(0);
            },
          );
        });
  }
}
