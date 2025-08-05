import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:go_router/go_router.dart';

import 'app_theme_model.dart';
import 'app_theme_set_state_notifier.dart';

class AppThemeSetPage extends BasePage {
  static const String routePath = '/app_theme_set_page';

  const AppThemeSetPage({super.key});

  @override
  AppThemeSetPageState<AppThemeSetPage> createState() {
    return AppThemeSetPageState<AppThemeSetPage>();
  }
}

class AppThemeSetPageState<AppThemeSetPage> extends BasePageState {
  @override
  void initData() {
    ref.watch(appThemeSetStateNotifierProvider.notifier).initData();
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    var dataList = ref.watch(
        appThemeSetStateNotifierProvider.select((value) => value.dataList));
    return Container(
      color: style.bgColor,
      child: _buildList(context, style, resource, dataList),
    );
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: 'app_theme_set'.tr(),
      bgColor: style.bgColor,
      itemAction: (tag) {
        if (tag == BarButtonTag.left) GoRouter.of(context).pop();
      },
    );
  }

  Widget _buildList(BuildContext context, StyleModel style,
      ResourceModel resource, List<AppThemeModel> models) {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
      height: models.length * 64 + 12,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: style.white,
      ),
      child: ListView.builder(
        itemCount: models.length,
        itemBuilder: (context, index) {
          String iconName = models[index].selected
              ? models[index].selectedIcon
              : models[index].normalIcon;

          return GestureDetector(
            onTap: () {
              ref
                  .read(appThemeSetStateNotifierProvider.notifier)
                  .updateThemeSelected(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              color: style.bgWhite,
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      models[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: style.textMainBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Image(
                    width: 24,
                    height: 24,
                    image: AssetImage(resource.getResource(
                      iconName,
                    )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
