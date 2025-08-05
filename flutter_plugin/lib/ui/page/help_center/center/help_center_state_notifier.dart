import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_ui_state.dart';
import 'package:flutter_plugin/ui/page/help_center/help_question_search/help_question_search_page.dart';
import 'package:flutter_plugin/ui/page/help_center/manual/product_manual_page.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/ui/page/help_center/product_list/help_center_product_list_page.dart';
import 'package:flutter_plugin/ui/page/help_center/question_report/question_report_page.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest/product_suggest_page.dart';
import 'package:flutter_plugin/ui/page/home/home_repository.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_network_repository.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_plugin/utils/region_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'help_center_state_notifier.g.dart';

@riverpod
class HelpCenterStateNotifier extends _$HelpCenterStateNotifier {
  @override
  HelpCenterUiState build() {
    return const HelpCenterUiState();
  }

  Future<void> loadData() async {
    final isRegionCn = await RegionUtils.isRegionCn();
    state = state.copyWith(isOverSea: !isRegionCn);

    List<DeviceModel> list =
        (await ref.read(homeRepositoryProvider).getDeviceList()).page.records;
    List<String> models = [];
    for (var item in list) {
      if (!models.contains(item.model)) {
        models.add(item.model);
      }
    }

    List<HelpCenterKindOfProduct> kindOfProductList = [];
    List<HelpCenterProduct> productList = [];

    List<KindOfProduct> categories =
        await ref.read(pairNetworkRepositoryProvider).getProductCategory();

    for (KindOfProduct kindOfProduct in categories) {
      final hcKindOfProduct = HelpCenterKindOfProduct(
        categoryId: kindOfProduct.categoryId,
        categoryOrder: kindOfProduct.categoryOrder,
        name: kindOfProduct.name,
        childrenList: [],
      );
      List<HelpCenterProduct> childrenList = [];
      for (SeriesOfProduct serie in kindOfProduct.childrenList) {
        for (Product produc in serie.productList) {
          HelpCenterProduct product = HelpCenterProduct.fromProduct(produc);
          productList.add(product);
          childrenList.add(product);
        }
      }
      final helpCenterKindOfProduct =
          hcKindOfProduct.copyWith(childrenList: childrenList);
      kindOfProductList.add(helpCenterKindOfProduct);
    }
    List<HelpCenterProduct> topList = productList.toList();
    var tag = 1;
    while (models.isNotEmpty) {
      String model = models.last;
      for (int i = 0; i < topList.length; i++) {
        HelpCenterProduct product = topList[i];
        if (product.model == model ||
            product.quickConnects.values.contains(model)) {
          product.tag = tag;
          topList.insert(0, topList.removeAt(i));
          tag++;
          break;
        }
      }
      models.removeLast();
    }

    state = state.copyWith(
      topList: topList,
      products: productList,
      kindOfProducts: kindOfProductList,
      isShowTop: topList.isNotEmpty,
      topNumber: topList.length >= 2 ? 2 : topList.length,
    );

    ref.read(helpCenterRepositoryProvider).getContactInfo().then((value) {
      state = state.copyWith(
        saleContacts: value,
      );
    }).catchError((e) {
      LogUtils.e('getContactInfo catchError: $e');
    });
  }

  void contactusClick() {
    state = state.copyWith(
      expandContact: !state.expandContact,
    );
  }

  void pushToProductList() {
    state = state.copyWith(
      event: PushEvent(
        path: HelpCenterProductListPage.routePath,
        extra: state.kindOfProducts,
      ),
    );
  }

  void pushToQuestionSearch() {
    state = state.copyWith(
      event: PushEvent(
        path: HelpQuestionSearchPage.routePath,
      ),
    );
  }

  void updateTopData(List<HelpCenterProduct> list) {
    state = state.copyWith(
      products: list,
      isShowTop: list.isNotEmpty,
      topNumber: list.length >= 2 ? 2 : list.length,
    );
  }

  void pushToProductManual(HelpCenterProduct product) {
    state = state.copyWith(
        event: PushEvent(
      path: ProductManualPage.routePath,
      extra: product,
    ));
  }

  void pushToReport() {
    state = state.copyWith(
        event: PushEvent(
      path: QuestionReportPage.routePath,
    ));
  }

  void pushToSuggestion() {
    state = state.copyWith(
        event: PushEvent(
      path: ProductSuggestPage.routePath,
    ));
  }
}
