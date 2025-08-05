import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/mixin/pair_net_back_helper.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_solution/pair_solution_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';

class PairSolutionPage extends BasePage {
  static const String routePath = '/pair_solution';

  const PairSolutionPage({super.key});

  @override
  _PairSolutionPageState createState() {
    return _PairSolutionPageState();
  }
}

class _PairSolutionPageState extends BasePageState with PairNetBackHelper {
  @override
  String get centerTitle => 'text_solution'.tr();

  @override
  void initData() {
    super.initData();
    ref.read(pairSolutionStateNotifierProvider.notifier).initData();
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resourceModel) {
    var solutions = ref.watch(pairSolutionStateNotifierProvider).solutions;
    return Container(
      color: style.bgGray,
      child: Column(children: [
        Expanded(
          flex: 4,
          child: GroupListView(
            itemBuilder: (context, idxPath) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: style.bgWhite,
                    borderRadius: BorderRadius.circular(style.circular8)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    solutions[idxPath.section].solution[idxPath.index],
                    style: TextStyle(
                        color: style.textMain,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              );
            },
            sectionsCount: solutions.length,
            groupHeaderBuilder: (context, section) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 26, horizontal: 32),
                child: Text(
                  solutions[section].title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: style.textSecond),
                ),
              );
            },
            countOfItemInSection: (section) {
              return solutions[section].solution.length;
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DMFormatRichText(
                  type: 2,
                  normalTextStyle:
                      const TextStyle(fontSize: 14, color: Color(0xFF8D8D8D)),
                  clickTextStyle:
                      TextStyle(fontSize: 14, color: style.textBrand),
                  content: 'searching_no_devices_contact_customer_service'.tr(),
                  indexs: ['text_contact_cs'.tr()],
                  richCallback: (index, key, content) {
                    List<BaseDeviceModel> deviceList = [];
                    if (ref.exists(homeStateNotifierProvider)) {
                      deviceList = ref.read(homeStateNotifierProvider
                          .select((value) => value.deviceList));
                    }
                    ref
                        .read(helpCenterRepositoryProvider)
                        .pushToChat(context: context, deviceList: deviceList);
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                DMButton(
                  width: double.infinity,
                  height: 48,
                  borderRadius: style.circular8,
                  textColor: style.enableBtnTextColor,
                  backgroundGradient: style.confirmBtnGradient,
                  text: 'retry'.tr(),
                  onClickCallback: (context) {
                    gotoPairNetBackToFirst();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
