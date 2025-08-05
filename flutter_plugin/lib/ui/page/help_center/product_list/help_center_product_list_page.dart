import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/ui/page/help_center/product_list/help_center_product_list_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/help_center_product_cell.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpCenterProductListPage extends BasePage {
  static const String routePath = '/help_center_product_list_page';

  const HelpCenterProductListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HelpCenterProductListPage();
  }
}

class _HelpCenterProductListPage
    extends BasePageState<HelpCenterProductListPage>
    with CommonDialog, ResponseForeUiEvent {
  @override
  Color? get backgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  String get centerTitle => 'help_AfterSale_more_device'.tr();
  final tabScrollController = ScrollController();
  final bodyScrollController = ScrollController();
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void initData() {
    final extra = AppRoutes()
        .getGoRouterStateExtra<List<HelpCenterKindOfProduct>>(context);
    ref
        .read(helpCenterProductListStateNotifierProvider.notifier)
        .loadData(extra);
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        helpCenterProductListStateNotifierProvider
            .select((value) => value.event), (previous, next) {
      responseFor(next);
    });
  }

  Future<void> _onTabSelect(int index, item) async {
    ref
        .read(helpCenterProductListStateNotifierProvider.notifier)
        .onTabSelect(index, item);
    await pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    await tabScrollController.animateTo(index.toDouble() * 80,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    final state = ref.watch(helpCenterProductListStateNotifierProvider);
    final products = state.products;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          width: double.infinity,
          height: 30,
          child: ListView.builder(
              key: const ValueKey('section'),
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              cacheExtent: 80,
              controller: tabScrollController,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final tabItem = products[index];
                return ValueListenableBuilder<bool>(
                  valueListenable: ValueNotifier<bool>(tabItem.isSelected),
                  builder: (context, isSelected, child) {
                    return Container(
                      // width: 80,
                      // height: 30,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? style.moreProductTabSelectedColor
                            : style.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Center(
                            child: Text(
                          tabItem.name,
                          style: isSelected
                              ? TextStyle(
                                  color: style.moreProductTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)
                              : style.normalStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                        )),
                      ),
                    ).onClick(() {
                      _onTabSelect(index, tabItem);
                    });
                  },
                );
              }),
        ),
        Expanded(
          child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              controller: pageController,
              itemBuilder: (context, index) {
                final childrenList = products[index].childrenList;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: bodyScrollController,
                      itemCount: childrenList.length,
                      itemBuilder: (ctx, index) {
                        final product = childrenList[index];
                        return Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: style.bgWhite,
                            borderRadius: index == 0
                                ? BorderRadius.vertical(
                                    top: Radius.circular(style.circular8))
                                : index == childrenList.length - 1
                                    ? BorderRadius.vertical(
                                        bottom:
                                            Radius.circular(style.circular8))
                                    : BorderRadius.zero,
                          ),
                          child: HelpCenterProductCell(
                              product: product,
                              onTap: () {
                                ref
                                    .read(
                                        helpCenterProductListStateNotifierProvider
                                            .notifier)
                                    .pushToProductManual(product);
                              }),
                        );
                      }),
                );
              }),
        )
      ],
    );
  }
}
