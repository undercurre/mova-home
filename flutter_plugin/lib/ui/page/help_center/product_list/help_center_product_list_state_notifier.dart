import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/manual/product_manual_page.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/ui/page/help_center/product_list/help_center_product_list_ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'help_center_product_list_state_notifier.g.dart';

@riverpod
class HelpCenterProductListStateNotifier
    extends _$HelpCenterProductListStateNotifier {
  @override
  HelpCenterProductListUiState build() {
    return const HelpCenterProductListUiState();
  }

  void loadData(List<HelpCenterKindOfProduct>? products) {
    updateTopData(products ?? []);
  }

  void updateTopData(List<HelpCenterKindOfProduct> list) {
    final allProducts = list
        .where((element) => element.childrenList.isNotEmpty)
        .expand((element) => element.childrenList)
        .toList();
    final ownList = allProducts.where((element) => element.tag != 0).toList();
    List<HelpCenterKindOfProduct> newList = [];
    if (allProducts.isNotEmpty) {
      newList.add(HelpCenterKindOfProduct(
          categoryId: 'all',
          categoryOrder: 0,
          name: 'text_product_all'.tr(),
          isSelected: true,
          childrenList: allProducts));
    }
    if (ownList.isNotEmpty) {
      newList.add(HelpCenterKindOfProduct(
          categoryId: 'mine',
          categoryOrder: 1,
          name: 'text_product_mine'.tr(),
          childrenList: ownList));
    }
    newList.addAll(list);
    state = state.copyWith(
      products: newList,
    );
  }

  void pushToProductManual(HelpCenterProduct product) {
    state = state.copyWith(
        event: PushEvent(
      path: ProductManualPage.routePath,
      extra: product,
    ));
  }

  void onTabSelect(index, item) {
    final products = state.products.map((e) {
      if (e == item) {
        return e.copyWith(isSelected: true);
      } else if (e.isSelected) {
        return e.copyWith(isSelected: false);
      } else
        return e;
    }).toList();
    state = state.copyWith(
      products: products,
      kindofIndex: index,
    );
  }
}
