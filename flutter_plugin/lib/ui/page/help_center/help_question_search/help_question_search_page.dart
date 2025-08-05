import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/help_question_search/help_question_search_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/model/app_faq.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/faq_cell.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class HelpQuestionSearchPage extends BasePage {
  static const String routePath = '/help_question_search_page';
  List<AppFaq>? faqs;
  HelpQuestionSearchPage({super.key, this.faqs});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HelpQuestionSearchPage();
  }
}

class _HelpQuestionSearchPage extends BasePageState<HelpQuestionSearchPage> {
  @override
  void initData() {
    ref
        .watch(helpQuestionSearchStateNotifierProvider.notifier)
        .loadData(widget.faqs);
  }

  @override
  Color? get backgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  Color? get navBackgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          GoRouter.of(context).pop();
        }
      },
      bgColor: style.bgGray,
      titleWidget: ClipRRect(
        borderRadius: BorderRadius.circular(style.circular8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 12, right: 12).withRTL(context),
          height: 34,
          decoration: BoxDecoration(
              color: style.bgWhite,
              borderRadius: BorderRadius.circular(style.circular8)),
          alignment: Alignment.center,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                    resource.getResource('search'),
                  ),
                  width: 20,
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    // color: StyleModel().bgWhite,
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 6).withRTL(context),
                    child: TextField(
                      style: style.thirdStyle(),
                      cursorColor: style.click,
                      decoration: InputDecoration(
                        hintText: 'faq_hint_search_header'.tr(),
                        hintStyle: style.secondStyle(),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      onChanged: (text) {
                        ref
                            .read(helpQuestionSearchStateNotifierProvider
                                .notifier)
                            .search(text);
                      },
                    ),
                  ),
                )
              ]),
        ),
      ),
      rightWidget: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.only(right: 15, left: 25).withRTL(context),
          child: Text(
            'search'.tr(),
            style: style.mainStyle(),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: ref.watch(helpQuestionSearchStateNotifierProvider
          .select((value) => value.faqs?.length ?? 0)),
      itemBuilder: (context, index) {
        List<AppFaq> faqs =
            ref.watch(helpQuestionSearchStateNotifierProvider).faqs!;
        AppFaq faq = faqs[index];
        BorderRadius borderRadius = BorderRadius.zero;
        if (faqs.length == 1) {
          borderRadius = BorderRadius.circular(style.circular8);
        } else {
          if (index == 0) {
            borderRadius = BorderRadius.only(
                topLeft: Radius.circular(style.circular8),
                topRight: Radius.circular(style.circular8));
          }
          if (index == faqs.length - 1) {
            borderRadius = BorderRadius.only(
                bottomLeft: Radius.circular(style.circular8),
                bottomRight: Radius.circular(style.circular8));
          }
        }
        return ClipRRect(
          borderRadius: borderRadius,
          child: FaqCell(
            faq: faq,
            searchText:
                ref.watch(helpQuestionSearchStateNotifierProvider).searchText,
            onExpand: () {
              ref
                  .read(helpQuestionSearchStateNotifierProvider.notifier)
                  .expandFaq(index);
            },
          ),
        );
      },
    );
  }
}
