import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/search/pair_search_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/widgets/pair_type_selection_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';

/// 牙菌斑配网-类型选择页面
class PairTypeSelectionPage extends BasePage {
  static const routePath = '/pair_type_selection';

  const PairTypeSelectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PairTypeSelectionPageState();
  }
}

class _PairTypeSelectionPageState extends BasePageState {
  List<PairGuideModel> guides = [];

  @override
  void initData() {
    super.initData();

    final arguments =
        AppRoutes().getGoRouterStateExtra<Map<String, dynamic>>(context);
    if (arguments != null) {
      ref
          .read(pairSearchStateNotifierProvider.notifier)
          .updateDisplayName(arguments['displayName']);
      ref
          .read(pairSearchStateNotifierProvider.notifier)
          .updateProductId(arguments['productId']);
      guides = arguments['guides'];
    }
    //ref.read(pairSearchStateNotifierProvider.notifier).initData();
  }

  @override
  PreferredSizeWidget buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: ref.watch(pairSearchStateNotifierProvider).navTitle.tr(),
      bgColor: style.bgGray,
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          onTitleLeftClick();
        }
      },
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return PairTypeSelectionWidget(
        ref.watch(pairSearchStateNotifierProvider
            .select((value) => value.displayName)),
        guides);
  }
}
