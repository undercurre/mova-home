import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/model/after_sale_item.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/help_center_product_cell.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/help_center_setting_cell.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/non_iot_util.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'help_center_repository.dart';

class HelpCenterPage extends BasePage {
  static const String routePath = '/help_center';

  const HelpCenterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HelpCenterState();
  }
}

class _HelpCenterState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  void initData() {
    ref.watch(helpCenterStateNotifierProvider.notifier).loadData();
  }

  @override
  Widget? get rightItemWidget => ThemeWidget(
        builder: (_, style, resource) {
          return GestureDetector(
            onTap: () {
              ref
                  .read(helpCenterStateNotifierProvider.notifier)
                  .pushToQuestionSearch();
            },
            child: Container(
              padding: const EdgeInsets.only(right: 16).withRTL(context),
              child: Image(
                image: AssetImage(
                  resource.getResource('help_center_icon_more'),
                ),
                width: 24,
                height: 24,
              ),
            ),
          );
        },
      );

  @override
  Color? get backgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  String get centerTitle => 'text_help_and_feedback'.tr();

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(helpCenterStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  Widget buildSectionHeader(
      {required String title,
      required StyleModel style,
      required ResourceModel resource}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: style.textSecond,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
        ]);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        child: CustomScrollView(
          slivers: <Widget>[
            if (ref.watch(helpCenterStateNotifierProvider).isShowTop)
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: buildSectionHeader(
                                title: 'user_help'.tr(),
                                style: style,
                                resource: resource)),
                        Visibility(
                          visible: ref.watch(helpCenterStateNotifierProvider.select((value) => value.isOverSea)),
                          child: Expanded(
                              flex: 1,
                              child: InkWell(
                                  onTap: () {
                                    goToH5ListPage();
                                  },
                                  splashColor: Colors.transparent, // 去掉波纹
                                  highlightColor: Colors.transparent, // 去掉高亮
                                  child: Row(children: [
                                    const Expanded(flex: 1, child: SizedBox()),
                                    Icon(Icons.star_border,
                                        color: style.textBrand),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        child: Text(
                                          'collected_device'.tr(),
                                          style:
                                              TextStyle(color: style.textBrand),
                                        ))
                                  ]))),
                        )
                      ],
                    )
                  ],
                ),
              ),
            if (ref.watch(helpCenterStateNotifierProvider).isShowTop)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 18),
                  decoration: BoxDecoration(
                    color: style.bgWhite,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(style.circular8)),
                  ),
                  height:
                      ref.watch(helpCenterStateNotifierProvider).topNumber * 90,
                  child: ListView.builder(
                    itemCount:
                        ref.watch(helpCenterStateNotifierProvider).topNumber,
                    itemBuilder: (context, index) {
                      HelpCenterProduct product = ref
                          .read(helpCenterStateNotifierProvider)
                          .topList[index];
                      return HelpCenterProductCell(
                          product: product,
                          onTap: () {
                            ref
                                .read(helpCenterStateNotifierProvider.notifier)
                                .pushToProductManual(product);
                          });
                    },
                  ),
                ),
              ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(helpCenterStateNotifierProvider.notifier)
                          .pushToProductList();
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: style.bgWhite,
                        borderRadius:
                            ref.watch(helpCenterStateNotifierProvider).isShowTop
                                ? BorderRadius.vertical(
                                    bottom: Radius.circular(style.circular8))
                                : BorderRadius.circular(style.circular8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'text_view_more_product'.tr(),
                            style:
                                style.disableStyle(fontSize: style.largeText),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  buildSectionHeader(
                      title: 'text_consultation_and_feedback'.tr(),
                      style: style,
                      resource: resource),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(style.circular8),
                child: Container(
                  color: style.bgWhite,
                  child: Column(children: [
                    /// 在线客服，热线电话，访问官网，服务邮箱
                    if (ref
                        .watch(helpCenterStateNotifierProvider)
                        .expandContact)
                      for (var item in ref
                          .watch(helpCenterStateNotifierProvider)
                          .saleContacts)
                        HelpCenterSettingCell(
                          style: style,
                          resource: resource,
                          image: item.image,
                          desc: item.desc,
                          title: item.title,
                          onTap: () async {
                            if (item.contact == AfterSaleContact.onlineServer) {
                              try {
                                showLoading();
                                List<BaseDeviceModel> deviceList = [];
                                if (ref.exists(homeStateNotifierProvider)) {
                                  deviceList = ref.read(
                                      homeStateNotifierProvider
                                          .select((value) => value.deviceList));
                                }
                                await ref
                                    .read(helpCenterRepositoryProvider)
                                    .pushToChat(
                                        context: context,
                                        info: item.onlineServiceInfo,
                                        deviceList: deviceList);
                              } finally {
                                dismissLoading();
                              }
                            } else {
                              item.onTap?.call(item.valueList?.first);
                            }
                          },
                        ),
                    // 产品建议
                    HelpCenterSettingCell(
                      image: 'ic_feedback_suggest',
                      title: 'text_product_suggestion'.tr(),
                      desc: null,
                      style: style,
                      resource: resource,
                      onTap: () {
                        ref
                            .read(helpCenterStateNotifierProvider.notifier)
                            .pushToSuggestion();
                      },
                    ),
                    // 问题日志上报 官网
                    HelpCenterSettingCell(
                      image: 'ic_feedback_quest',
                      title: 'text_bug_report'.tr(),
                      desc: null,
                      style: style,
                      resource: resource,
                      onTap: () {
                        ref
                            .read(helpCenterStateNotifierProvider.notifier)
                            .pushToReport();
                      },
                    ),
                  ]),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Container(
              height: MediaQuery.of(context).padding.bottom,
            ))
          ],
        ));
  }

  void goToH5ListPage() {
    final themeMode = ref.read(appThemeStateNotifierProvider);
    try {
      NonIotUtil().goToH5Page(NonIotUtil().getCollectedListUrl(), themeMode);
    } catch (e) {
      LogUtils.e('[HelpCenterPage] goToH5ListPage error:$e');
    }
  }
}
