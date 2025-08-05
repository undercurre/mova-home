import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_controller.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_cell.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/region_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:group_list_view/group_list_view.dart';

class RegionPickerPage extends BasePage {
  static const String routePath = '/region_picker_page';

  static Map<String, dynamic> createExtra(
    RegionItem item, {
    showChangeDialog = false,
  }) {
    return {'item': item, 'showChangeDialog': showChangeDialog};
  }

  const RegionPickerPage({super.key});

  @override
  RegionPickerPageState createState() => RegionPickerPageState();
}

typedef VoidAsyncFunction = Future<void> Function();

class RegionPickerPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  // late RegionItem extra;
  late RegionPickerController controller =
      ref.read(regionPickerControllerProvider.notifier);

  @override
  void initData() {
    super.initData();
    var paramMap = GoRouterState.of(context).extra as Map<String, dynamic>;
    var selectItem = paramMap['item'] as RegionItem;
    var showChangeDialog = paramMap['showChangeDialog'] as bool?;
    controller.initData(selectItem, showChangeDialog == true);
    controller.onLoad();
  }

  void saveItem() async {
    RegionItem? item = ref.read(regionPickerControllerProvider).selectRegion;
    if (item != null) {
      /// 需要重新登录等操作
      RegionItem currentItem = await LocalModule().getCurrentCountry();
      if (item.countryCode == currentItem.countryCode) {
        AppRoutes().pop();
        return;
      }

      ///登录注册进来，不显示切换弹框
      if (ref.read(regionPickerControllerProvider).showChangeDialog != true) {
        await ref.watch(privacyPolicyProvider.notifier).reset(item.countryCode);
        AppRoutes().pop(item);
        return;
      }
      // 中国切海外 或者海外切中国
      if (RegionUtils.isCn(currentItem.countryCode) ||
          RegionUtils.isCn(item.countryCode)) {
        showAlertDialog(
          content: 'change_region_tips'.tr(),
          cancelContent: 'cancel'.tr(),
          confirmContent: 'confirm'.tr(),
          confirmCallback: () async {
            SmartDialog.showLoading();
            await LifeCycleManager()
                .logOut(logoutFuture: logOutAccount, resetStack: false);
            await RegionStore().updateRegion(item);
            MessageChannel().changeCountry(item.countryCode);
            SmartDialog.dismiss(status: SmartStatus.loading);
          },
        );
      } else {
        /// 不需要登出
        await RegionStore().updateRegion(item);
        MqttConnector().disconnect();
        MessageChannel().changeCountry(item.countryCode);
        responseFor(ToastEvent(text: 'setting_success'.tr()));
      }
    }
  }

  /// 退出登录，忽略接口返回，都返回true
  Future<bool> logOutAccount() async {
    LogUtils.i('-------logOutAccount-------');
    try {
      await ref.read(accountSettingRepositoryProvider).logoutUser();
    } catch (error) {
      LogUtils.e(error);
    }
    return true;
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    bool rtl = (Directionality.of(context).toString() == 'TextDirection.rtl');
    // controller.selectTheShort(selectItem, context);
    var data = ref.watch(regionPickerControllerProvider);
    return Container(
      color: style.bgGray,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Column()
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(20, 12, 20, 12).withRTL(context),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: CupertinoSearchTextField(
                        placeholder: 'search'.tr(),
                        suffixMode: OverlayVisibilityMode.never,
                        backgroundColor: style.bgWhite,
                        placeholderStyle: style.secondStyle(),
                        itemSize: 20,
                        // itemColor: style.textSecondGray,
                        prefixIcon: Image.asset(resource.getResource('search')),
                        prefixInsets: const EdgeInsets.only(
                                left: 10, right: 7, top: 10, bottom: 10)
                            .withRTL(context),
                        borderRadius: BorderRadius.all(
                            Radius.circular(style.textFieldBorder)),
                        onChanged: (text) {
                          controller.searchFor(text);
                        },
                        style: TextStyle(
                          fontSize: 16,
                          color: style.textMainBlack,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    SearchListGroupView(
                      boxs: data.boxs,
                      selectRegion: data.selectRegion,
                      selectRegionTap: (short) {
                        controller.selectTheShort(short);
                      },
                      scrollerController: controller.scrollerController,
                      isChinese: data.isChinese,
                    ),
                    Align(
                      alignment:
                          rtl ? Alignment.centerLeft : Alignment.centerRight,
                      child: SizedBox(
                        // height: 800,
                        // color: Colors.red,
                        // margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: GestureDetector(
                          onTapDown: (details) {
                            controller.tapForOffset(details.localPosition.dy);
                          },
                          onPanUpdate: (details) {
                            controller.panForOffset(details.localPosition.dy);
                          },
                          onPanStart: (details) {
                            controller.panForStart();
                          },
                          child: SizedBox(
                            width: 50,
                            height: (20 * data.boxs.length).toDouble(),
                            // color: Colors.black,
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              // mainAxisSize: MainAxisSize.min,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < data.boxs.length; i++)
                                  Container(
                                    // color: Colors.red,
                                    padding: const EdgeInsets.only(left: 27)
                                        .withRTL(context),
                                    width: 50,
                                    height: 20,
                                    alignment: Alignment.center,
                                    child: Text(
                                      data.boxs[i].letter,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: style.brandGoldColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: 'country_and_region'.tr(),
      bgColor: style.bgGray,
      rightWidget: TextButton(
        onPressed: () {
          saveItem();
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

class SearchListGroupView extends StatelessWidget {
  const SearchListGroupView({
    super.key,
    required this.boxs,
    this.selectRegion,
    required this.selectRegionTap,
    required this.scrollerController,
    required this.isChinese,
  });

  final List<RegionBoxItem> boxs;
  final RegionItem? selectRegion;
  final void Function(RegionItem region) selectRegionTap;
  final ScrollController scrollerController;
  final bool isChinese;

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return GroupListView(
        itemBuilder: (context, index) {
          return RegionSelectCell(
            item: boxs[index.section].items[index.index],
            isSelect: selectRegion?.countryCode ==
                boxs[index.section].items[index.index].countryCode,
            onTap: () {
              selectRegionTap(boxs[index.section].items[index.index]);
            },
            isChinese: isChinese,
            isGroupLast: boxs[index.section].items.length - index.index == 1,
          );
        },
        sectionsCount: boxs.length,
        groupHeaderBuilder: (context, section) {
          return Container(
            height: 46,
            padding: const EdgeInsets.only(left: 24).withRTL(context),
            color: style.bgGray,
            child: Row(
              children: [
                Text(
                  boxs[section].letter,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: style.textMainBlack,
                  ),
                ),
              ],
            ),
          );
        },
        countOfItemInSection: (section) {
          return boxs[section].items.length;
        },
        controller: scrollerController,
      );
    });
  }
}

class RegionBoxItem {
  List<RegionItem> items = [];
  late String letter;
  late double headerPosition;

  static List<RegionBoxItem> getFromItems(List<RegionItem> items, bool byPy) {
    Map<String, List<RegionItem>> letterMap = {};
    for (var item in items) {
      String lett = byPy
          ? item.pinyin.substring(0, 1).toUpperCase()
          : item.en.substring(0, 1).toUpperCase();
      List<RegionItem> regionItems = letterMap[lett] ?? [];
      regionItems.add(item);
      letterMap[lett] = regionItems;
    }
    List<RegionBoxItem> boxs = [];
    letterMap.forEach((key, value) {
      RegionBoxItem box = RegionBoxItem();
      box.letter = key;
      box.items = value;
      boxs.add(box);
    });
    boxs.sort((a, b) => a.letter.compareTo(b.letter));
    double currentPosition = 0;
    for (var element in boxs) {
      element.headerPosition = currentPosition;
      currentPosition += 46 + element.items.length * 52;
    }
    return boxs;
  }
}

mixin regionPickerEnbale on BasePageState {
  Future<RegionItem?> pushToPicker(RegionItem currentItem) async {
    var result = await GoRouter.of(context).push(RegionPickerPage.routePath,
        extra: RegionPickerPage.createExtra(currentItem)) as RegionItem?;
    return Future.value(result);
  }
}
