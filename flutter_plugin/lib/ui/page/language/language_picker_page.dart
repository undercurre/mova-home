import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/language/language_picker_cell.dart';
import 'package:flutter_plugin/ui/page/language/language_picker_page_controller.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:go_router/go_router.dart';

class LanguagePickerPage extends BasePage {
  static const String routePath = '/language_picker_page';

  const LanguagePickerPage({super.key});

  @override
  LanguagePickerPageState<LanguagePickerPage> createState() {
    return LanguagePickerPageState<LanguagePickerPage>();
  }
}

class LanguagePickerPageState<LanguagePickerPage> extends BasePageState {
  late LanguagePickerPageController controller =
      ref.read(languagePickerPageControllerProvider.notifier);

  Future<void> changeLanguage() async {
    Locale? local = ref.read(languagePickerPageControllerProvider
        .select((value) => value.selectLanguage?.toLanguageLocal()));
    if (local != null) {
      //
      await controller.saveItem();
      // ignore: use_build_context_synchronously
      await context.setLocale(local);
      await AppRoutes.resetStacks();
    }
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    List<LanguageModel>? languages = ref.watch(
        languagePickerPageControllerProvider
            .select((value) => value.languages));
    return Container(
      color: style.bgGray,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20).withRTL(context),
        child: ListView.builder(
            itemCount: languages?.length ?? 0,
            itemBuilder: (context, index) {
              if (languages == null) return null;
              LanguageModel item = languages[index];
              BorderRadiusGeometry borderRadius = BorderRadius.zero;
              if (index == 0) {
                borderRadius = BorderRadius.only(
                  topLeft: Radius.circular(style.circular8),
                  topRight: Radius.circular(style.circular8),
                );
              } else if (languages.length - index == 1) {
                borderRadius = BorderRadius.only(
                  bottomLeft: Radius.circular(style.circular8),
                  bottomRight: Radius.circular(style.circular8),
                );
              }
              return LanguagePickerCell(
                language: item,
                borderRadius: borderRadius,
                isSelect: item.displayLang ==
                    ref.watch(
                      languagePickerPageControllerProvider
                          .select((value) => value.selectLanguage?.displayLang),
                    ),
                onTap: () {
                  controller.selectItem(item);
                },
                isGroupLast: languages.length - index == 1,
              );
            }),
      ),
    );
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: 'mine_language_more'.tr(),
      bgColor: style.bgGray,
      rightWidget: TextButton(
        onPressed: () async {
          // saveItem();
          // changeLanguage();
          Locale? local = ref.read(languagePickerPageControllerProvider
              .select((value) => value.selectLanguage?.toLanguageLocal()));
          if (local != null) {
            //
            await controller.saveItem();
            // await context.setLocale(local);
            // Navigator.of(context, rootNavigator: true)
            //     .popUntil((route) => route.isFirst);
          }
        },
        child: Text(
          'save'.tr(),
          style: style.mainStyle(fontWeight: FontWeight.w400),
        ),
      ),
      itemAction: (tag) {
        if (tag == BarButtonTag.left) GoRouter.of(context).pop();
      },
    );
  }
}
