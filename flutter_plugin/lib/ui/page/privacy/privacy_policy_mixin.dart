import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'privacy_policy_state_notifier.dart';

/// 隐私
mixin PrivacyPolicyMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// 查看用户协议
  Future<void> viewUserAgreement() async {
    var info = await ref
        .watch(privacyPolicyProvider.notifier)
        .viewPrivacyInfo(showLoading: true);
    var url = await composeNewUrl(info.agreementUrl);
    LogUtils.i('-------- viewUserAgreement ---------- $url');
    await GoRouter.of(context).push(
      WebPage.routePath,
      extra: WebViewRequest(
          uri: WebUri(url), defaultTitle: 'user_agreement_pri_index'.tr()),
    );
  }

  /// 查看隐私政策
  Future<void> viewUserPrivacy() async {
    var info = await ref
        .watch(privacyPolicyProvider.notifier)
        .viewPrivacyInfo(showLoading: true);
    var url = await composeNewUrl(info.privacyUrl);
    LogUtils.i('-------- viewUserPrivacy ---------- $url');
    await GoRouter.of(context).push(
      WebPage.routePath,
      extra: WebViewRequest(
          uri: WebUri(url), defaultTitle: 'user_privacy_pri_index'.tr()),
    );
  }

  Future<String> composeNewUrl(String url) async {
    final lang = await LocalModule().getLangTag();
    final region = await LocalModule().serverSite();
    final tenantId = await AccountModule().getTenantId();
    return '$url&curLang=$lang&curRegion=$region&tenantId=$tenantId';
  }
}
