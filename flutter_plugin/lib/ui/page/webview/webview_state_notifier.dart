import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/ui/page/webview/webview_constants.dart';
import 'package:flutter_plugin/ui/page/webview/webview_uistate.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'webview_state_notifier.g.dart';

@riverpod
class WebviewStateNotifier extends _$WebviewStateNotifier {
  @override
  WebviewUistate build() {
    return const WebviewUistate(title: '', url: '', isHideTitle: false);
  }

  Future<String> init(Map<String, dynamic> extra) async {
    String url = extra[WebviewConstants.KEY_WEB_URL] ?? '';
    var title = extra[WebviewConstants.KEY_WEB_TITLE] ?? '';
    var type = extra[WebviewConstants.KEY_WEB_TYPE] ?? '';
    if (type == WebviewConstants.TYPE_WEB_PRIVACY) {
      try {
        url = await composeNewUrl(url);
      } catch (e) {
        LogUtils.e(e);
      }
    }
    if (title.startsWith('《') && title.endsWith('》')) {
      title = title.substring(1, title.length - 1);
    }
    var isHideTitle = extra[WebviewConstants.KEY_WEB_HIDE_TITLE] ?? false;

    state = state.copyWith(url: url, title: title, isHideTitle: isHideTitle);
    return url;
  }

  Future<String> composeNewUrl(String url) async {
    final lang = await LocalModule().getLangTag();
    final region = await LocalModule().serverSite();
    final tenantId = await AccountModule().getTenantId();
    return '$url&curLang=$lang&curRegion=$region&tenantId=$tenantId';
  }
}
