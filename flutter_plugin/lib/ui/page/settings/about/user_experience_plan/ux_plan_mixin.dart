import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_type.dart';
import 'package:flutter_plugin/ui/widget/dialog/ux_plan_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

mixin UxPlanMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void showUxPlanDialog() {
    _updateUxPlanSp();
    SmartDialog.show(
        tag: 'ux_plan_dialog',
        clickMaskDismiss: false,
        backDismiss: false,
        animationType: SmartAnimationType.fade,
        builder: (_) {
          return UxPlanDialog(
            clickClose: () {
              dismissUxPlanDialog();
            },
            clickPrivacy: () async {
              var privacyInfo = await ref
                  .read(userConfigPageStateNotifierProvider
                      .call(UserConfigType.uxPlan)
                      .notifier)
                  .getPrivacyInfo();
              unawaited(GoRouter.of(context).push(WebPage.routePath,
                  extra: WebViewRequest(
                      uri: WebUri(privacyInfo?.privacyUrl ?? ''),
                      defaultTitle: 'user_privacy_pri_index'.tr())));
            },
            clickConfirm: () async {
              bool result = await ref
                  .read(userConfigPageStateNotifierProvider
                      .call(UserConfigType.uxPlan)
                      .notifier)
                  .setUXPlanAuthState(true);
              if (result) {
                dismissUxPlanDialog();
              }
            },
          );
        });
  }

  void dismissUxPlanDialog() {
    SmartDialog.dismiss(tag: 'ux_plan_dialog');
    ref.read(dialogJobManagerProvider.notifier).nextJob();
  }

  void _updateUxPlanSp() {
    ref
        .read((userConfigPageStateNotifierProvider
            .call(UserConfigType.uxPlan)
            .notifier))
        .updateUxSp();
  }
}
