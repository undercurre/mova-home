import 'dart:io';

import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/help_center/help_question_search/help_question_search_page.dart';
import 'package:flutter_plugin/ui/page/help_center/manual/product_manual_ui_state.dart';
import 'package:flutter_plugin/ui/page/help_center/manual_viewer/product_manual_viewer_page.dart';
import 'package:flutter_plugin/ui/page/help_center/model/app_faq.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:async/async.dart';

part 'product_manual_state_notifier.g.dart';

@riverpod
class ProductManualStateNotifier extends _$ProductManualStateNotifier {
  late List<AppFaq> _faqs;
  late HelpCenterProduct _product;
  bool _isDisposed = false;
  CancelableOperation? _cancelOp;

  List<String> adpatModels = [
    'dreame.vacuum.r2228',
    'dreame.vacuum.r2316',
    'dreame.vacuum.r2313'
  ];

  @override
  ProductManualUiState build() {
    ref.onDispose(() {
      _cancelOp?.cancel();
      _isDisposed = true;
    });
    return const ProductManualUiState();
  }

  void loadData(HelpCenterProduct product) {
    if (Platform.isIOS) {
      if (adpatModels.contains(product.model)) {
        state = state.copyWith(showAR: true);
      }
    }
    _product = product;
    ref
        .read(helpCenterRepositoryProvider)
        .getfaqs(product: _product.productId ?? '')
        .then((value) {
      _faqs = value;
      bool showFaq = value.isNotEmpty;
      bool showMore = value.length > 5;
      List<AppFaq> faqs = showMore ? value.sublist(0, 5) : value;
      if (!_isDisposed) {
        state = state.copyWith(
          faqs: faqs,
          showFaq: showFaq,
          showMore: showMore,
        );
      }
    }).catchError((e) {
      LogUtils.e('[ProductManualStateNotifier] loadData getfaqs error: $e');
    });
    ref.read(helpCenterRepositoryProvider).getContactInfo().then((value) {
      if (!_isDisposed) {
        state = state.copyWith(
          saleContacts: value,
        );
      }
    }).catchError((e) {
      LogUtils.e(
          '[ProductManualStateNotifier] loadData getContactInfo error: $e');
    });
    ref
        .read(helpCenterRepositoryProvider)
        .submitSuggestHistory(model: product.model ?? '')
        .then((value) {
      if (!_isDisposed) {
        state = state.copyWith(video: value);
      }
    }).catchError((e) {
      LogUtils.e(
          '[ProductManualStateNotifier] loadData submitSuggestHistory error: $e');
    });
    ref
        .read(helpCenterRepositoryProvider)
        .getProductMediaList(productID: product.productId ?? '')
        .then((value) {
      if (!_isDisposed) {
        state = state.copyWith(
            displayMediaList: value?.displayMediaList ?? [],
            productIntroduce: value?.productDesc ?? '');
      }
    }).catchError((e) {
      LogUtils.e(
          '[ProductManualStateNotifier] loadData getProductMediaList error: $e');
    });

    ref
        .read(helpCenterRepositoryProvider)
        .getPDF(_product.model ?? '')
        .then((pdfUrl) {
      if (!_isDisposed) {
        state = state.copyWith(pdfUrl: pdfUrl);
      }
    }).catchError((e) {
      LogUtils.e('[ProductManualStateNotifier] loadData getfaqs error: $e');
    });
  }

  void expandedProductIntroduce() {
    state = state.copyWith(isExpand: !state.isExpand);
  }

  void toShowVideo() {
    state = state.copyWith(showVideo: true);
  }

  void showToast(String text) {
    state = state.copyWith(event: ToastEvent(text: text));
  }

  void pushToSearchFaq() {
    List<AppFaq> transfaqs = [];
    for (int i = 0; i < _faqs.length; i++) {
      AppFaq faq = _faqs[i];
      if (i < 5) {
        faq.isExpand = false;
      }
      transfaqs.add(faq);
    }

    state = state.copyWith(
        event: PushEvent(
      path: HelpQuestionSearchPage.routePath,
      extra: transfaqs,
    ));
  }

  void pushToManualViewer() {
    state = state.copyWith(
        event: PushEvent(
      path: ProductManualViewerPage.routePath,
      extra: _product,
    ));
  }

  void pushToAR() {
    UIModule().pushToArManual(_product.model ?? '');
  }

  void changeExpanded(int index) {
    List<AppFaq> faqs = state.faqs;
    faqs[index].isExpand = !faqs[index].isExpand;
    state = state.copyWith(faqs: faqs);
  }
}
