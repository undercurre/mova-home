import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/mall/mall/mall_page.dart';
import 'package:flutter_plugin/ui/page/mine/mine_repository.dart';
import 'package:flutter_plugin/ui/page/mine/warranty_cards/warranty_cards_uistate.dart';
import 'package:flutter_plugin/ui/page/mine/warranty_cards/warranty_handler_utils.dart';
import 'package:flutter_plugin/ui/page/webview/webview_page.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'warranty_cards_state_notifier.g.dart';

@riverpod
class WarrantyCardsStateNotifier extends _$WarrantyCardsStateNotifier {
  @override
  WarrantyCardsUiState build() {
    return WarrantyCardsUiState(
      title: '',
      url: '',
      userInfo: null,
      deviceListChecked: false,
      event: const EmptyEvent(),
    );
  }

  Future<String> init(Map<String, dynamic> extra) async {
    String url = extra['url'] ?? '';
    var title = extra['title'] ?? '';

    state = state.copyWith(
      url: url,
      title: title,
    );
    return url;
  }

  Future<void> pushToCNMallWeb(String path) async {
    PushEvent event = PushEvent(
      path: MallPage.routePath,
      extra: 'pages/order/order',
    );
    state = state.copyWith(event: event);
  }

  Future<void> pushToShopify(
      String email, String countryCode, String path) async {
    final url = await ref.read(mineRepositoryProvider).getShopifyOrderUrl(
          email,
          countryCode,
          path,
        );

    await AppRoutes().push(
      WebviewPage.routePath,
      extra: WebviewPage.createParams(
        url: url,
        title: 'text_view_related_service'.tr(),
      ),
    );
  }

  Future<void> navigateToShopifyOrderPage(String path) async {
    final userInfo = await AccountModule().getUserInfo();
    final email = userInfo?.email ?? '';

    final countryCode = await WarrantyHandlerUtils.getCountryCode();
    final userCNShopifyLink = await WarrantyHandlerUtils.useCNShopifyIfNeeded();
    if (userCNShopifyLink) {
      LogUtils.d(
          '------ navigateToShopifyOrderPage userCNShopifyLink ------ $path');
      await pushToCNMallWeb(path);
    } else {
      LogUtils.d(
          '------ navigateToShopifyOrderPage pushToShopify ------ $path');
      await pushToShopify(email, countryCode, path);
    }
  }

  void onLoadStart(String url) {
    LogUtils.d('onLoadStart: $url');
  }

  void updateChecked(bool checked) {
    state = state.copyWith(deviceListChecked: checked);
  }
}
