import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/model/rn_debug_packages.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/developer/developer_mode_page_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class DeveloperModePage extends BasePage {
  static const String routePath = '/mine/developer';

  const DeveloperModePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DeveloperModePageState();
  }
}

class DeveloperModePageState extends BasePageState {
  final TextEditingController _ipController = TextEditingController();

  @override
  void initData() {
    ref.read(developerModePageStateNotifierProvider.notifier).initData();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(developerModePageStateNotifierProvider, (previous, next) {
      next.when(
          data: (data) {
            if (data.rnDebugPackages != null) {
              _ipController.text = data.rnDebugPackages?.ip ?? '';
              ref
                  .read(developerModePageStateNotifierProvider.notifier)
                  .saveModels();
            }
          },
          error: (error, stackTrace) {},
          loading: () {});
    });
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: '开发者选项',
      bgColor: style.bgGray,
      rightWidget: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 16).withRTL(context),
              child: GestureDetector(
                  onTap: () async {
                    Map<String, dynamic>? qrcodeInfo =
                        await UIModule().pushToQRScanRN();
                    if (qrcodeInfo != null &&
                        qrcodeInfo.isNotEmpty &&
                        qrcodeInfo['code'] == 0) {
                      Map<String, dynamic> result =
                          jsonDecode(qrcodeInfo['result']);
                      String ip = result['ip'] ?? '';
                      List projects = result['projects'];
                      ref
                          .read(developerModePageStateNotifierProvider.notifier)
                          .updateDeveloperInfoFromQRCode(projects, ip);
                    }
                  },
                  child: Image.asset(
                    resource.getResource('btn_developer_scan'),
                    width: 24,
                    height: 24,
                  ).flipWithRTL(context))),
          Padding(
              padding: const EdgeInsets.only(right: 16).withRTL(context),
              child: GestureDetector(
                  onTap: () {
                    ref
                        .read(developerModePageStateNotifierProvider.notifier)
                        .updateProjects(Projects(
                            packageName: '', model: '', selected: false));
                  },
                  child: Image.asset(
                    resource.getResource('ic_home_add'),
                    width: 24,
                    height: 24,
                    color: style.textMainBlack,
                  ).flipWithRTL(context)))
        ],
      ),
      itemAction: (tag) async {
        if (tag == BarButtonTag.left) {
          ref
              .read(developerModePageStateNotifierProvider.notifier)
              .saveModels();
          GoRouter.of(context).pop();
        }
      },
    );
  }

  @override
  Future<bool> onBackClick() {
    ref.read(developerModePageStateNotifierProvider.notifier).saveModels();
    return super.onBackClick();
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return ref.watch(developerModePageStateNotifierProvider).when(
        data: (data) {
          double keyHeight = 0.0;
          if (MediaQuery.of(context).viewInsets.bottom != 0.0) {
            keyHeight = MediaQuery.of(context).viewInsets.bottom;
          }
          bool isDebug = data.rnDebugPackages!.enable;
          List<Projects> models = data.rnDebugPackages!.projects ?? [];
          return Container(
            color: style.bgGray,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return _buildItem(
                            context, style, resource, models[index], index);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 10,
                          color: Colors.transparent,
                        );
                      },
                      itemCount: models.length),
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 0)
                        .withRTL(context),
                    child: Row(
                      children: [
                        Text(
                          'IP:PORT',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: style.textMainBlack),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _ipController,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: style.textMainBlack),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: style.click), // 自定义下划线颜色
                              ),
                            ),
                            onChanged: (value) {
                              LogUtils.d('onChanged:$value');
                              ref
                                  .read(developerModePageStateNotifierProvider
                                      .notifier)
                                  .saveModels(ip: value);
                            },
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  child: DMButton(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(10),
                      onClickCallback: (_) {
                        ref
                            .read(
                                developerModePageStateNotifierProvider.notifier)
                            .updateEnable();
                      },
                      prefixWidget: Icon(
                        Icons.lightbulb_circle,
                        color: isDebug ? Colors.lightGreen : style.carbonBlack,
                        size: 60,
                      )),
                ),
                Padding(
                        padding: EdgeInsets.only(
                            bottom: (MediaQuery.of(context).padding.bottom) +
                                10 +
                                keyHeight))
                    .flipWithRTL(context)
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Text('Error: $error');
        },
        loading: () => Container(
              color: style.white,
            ));
  }

  Widget _buildItem(BuildContext context, StyleModel style,
      ResourceModel resource, Projects models, int index) {
    return Container(
      color: style.bgGray,
      width: double.infinity,
      child: Slidable(
          key: ValueKey(models.id),
          groupTag: '0',
          endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const ScrollMotion(),
              children: [
                Center(
                    child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.asset(
                          resource.getResource('icon_message_item_delete'),
                          width: 40,
                          height: 40)
                      .onClick(() {
                    ref
                        .read(developerModePageStateNotifierProvider.notifier)
                        .deleteModel(index);
                  }),
                ))
              ]),
          child: GestureDetector(
            // onTap: () {},
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0).withRTL(context),
              decoration: BoxDecoration(
                color: style.bgWhite,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      AnimatedInputText(
                        initialValue: models.packageName,
                        onTextChanged: (str) {
                          ref
                              .read(developerModePageStateNotifierProvider
                                  .notifier)
                              .updateProjects(
                                  Projects(
                                      id: index,
                                      packageName: str,
                                      model: models.model,
                                      selected: models.selected),
                                  index: index);
                        },
                        showCountryCode: false,
                        showGetDynamicCode: false,
                        underLineHeight: 0,
                        animateLineHeight: 0,
                        prefixChild: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              child: Text(
                                'package:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: style.textMainBlack),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 10))
                          ],
                        ),
                      ),
                      AnimatedInputText(
                        initialValue: models.model,
                        onTextChanged: (str) {
                          ref
                              .read(developerModePageStateNotifierProvider
                                  .notifier)
                              .updateProjects(
                                  Projects(
                                      id: index,
                                      packageName: models.packageName,
                                      model: str,
                                      selected: models.selected),
                                  index: index);
                        },
                        showCountryCode: false,
                        showGetDynamicCode: false,
                        underLineHeight: 0,
                        animateLineHeight: 0,
                        prefixChild: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              child: Text(
                                'model:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: style.textMainBlack),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 10))
                          ],
                        ),
                      ),
                    ],
                  )),
                  DMButton(
                    padding: const EdgeInsets.only(left: 30),
                    backgroundColor: Colors.transparent,
                    onClickCallback: (ctx) {
                      models.selected = !models.selected!;
                      ref
                          .read(developerModePageStateNotifierProvider.notifier)
                          .updateProjects(models,
                              index: index, enableChanged: true);
                    },
                    prefixWidget: Icon(
                      Icons.check_circle_outline,
                      color: models.selected! ? style.click : style.carbonBlack,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
