import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/help_center/manual_viewer/product_manual_viewer_ui_state.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'product_manual_viewer_state_notifier.g.dart';

@riverpod
class ProductManualViewerStateNotifier
    extends _$ProductManualViewerStateNotifier {
  late HelpCenterProduct _product;
  @override
  ProductManualViewerUIState build() {
    return const ProductManualViewerUIState();
  }

  Future<void> loadData(HelpCenterProduct product) async {
    _product = product;
    try {
      String url = await ref
          .read(helpCenterRepositoryProvider)
          .getPDF(_product.model ?? '');
      state = state.copyWith(pdfUrl: url);
    } catch (e) {
      state = state.copyWith(requestFaild: true);
    }
  }

  Future<void> retry() async {
    state = state.copyWith(requestFaild: false);
    await loadData(_product);
  }
}
