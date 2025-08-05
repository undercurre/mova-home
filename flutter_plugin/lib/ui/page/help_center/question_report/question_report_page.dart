import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/model/question_report_item.dart';
import 'package:flutter_plugin/ui/page/help_center/question_report/question_report_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionReportPage extends BasePage {
  static const String routePath = '/qyestion_report_page';

  const QuestionReportPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _QuestionReportPage();
  }
}

class _QuestionReportPage extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  Color? get backgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  String get centerTitle => 'text_bug_report'.tr();

  @override
  void initData() {
    ref.watch(questionReportStateNotifierProvider.notifier).loadData();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        questionReportStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  Widget buildHeader(String title) {
    final style = ref.watch(styleModelProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Text(
        title,
        style: style.secondStyle(fontSize: 16),
      ),
    );
  }

  Widget buildCell(
      {required String title,
      bool showShareTag = true,
      bool showCheck = false,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ThemeWidget(builder: (_, style, resource) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(style.cellBorder),
              color: style.bgWhite,
            ),
            constraints: const BoxConstraints(minHeight: 54),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.only(
              left: 12,
              right: 16,
              top: 17,
              bottom: 17,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(children: [
                    if (showShareTag == true)
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: style.blueShare,
                        ),
                        constraints: const BoxConstraints(minHeight: 18),
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 7),
                        child: Text('message_setting_share'.tr(),
                            style: TextStyle(
                                fontSize: 12, color: style.textWhite)),
                      ),
                    Expanded(
                      child: Text(
                        title,
                        style: style.mainStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                ),
                Image(
                  image: AssetImage(
                    resource.getResource(
                        showCheck ? 'ic_report_checked' : 'ic_report_uncheck'),
                  ),
                  width: 20,
                  height: 20,
                )
              ],
            ));
      }),
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 14),
      child: Column(children: [
        Expanded(
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: buildHeader('app_feedback'.tr()),
            ),
            SliverList.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return buildCell(
                  title: 'text_app_bug_report'.tr(),
                  showShareTag: false,
                  showCheck: ref.watch(questionReportStateNotifierProvider
                      .select((value) => value.appFeedbackIsCheck)),
                  onTap: () {
                    ref
                        .read(questionReportStateNotifierProvider.notifier)
                        .onCheckAppreport();
                  },
                );
              },
            ),
            if (ref.watch(questionReportStateNotifierProvider
                    .select((value) => value.reports.length)) >
                0)
              SliverToBoxAdapter(
                child: buildHeader('my_feedback_device'.tr()),
              ),
            SliverList.builder(
              itemCount: ref.watch(questionReportStateNotifierProvider
                  .select((value) => value.reports.length)),
              itemBuilder: (context, index) {
                QuestionReportItem device = ref.watch(
                    questionReportStateNotifierProvider
                        .select((value) => value.reports[index]));
                return buildCell(
                  title: device.title,
                  showShareTag: device.showShareTag,
                  showCheck: device.isCheck,
                  onTap: () {
                    ref
                        .read(questionReportStateNotifierProvider.notifier)
                        .onCheckItem(index);
                  },
                );
              },
            ),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(children: [
            DMCommonClickButton(
              borderRadius: style.buttonBorder,
              enable: ref.watch(questionReportStateNotifierProvider
                  .select((value) => value.submitEnable)),
              text: 'text_bug_report'.tr(),
              disableBackgroundGradient: style.disableBtnGradient,
              disableTextColor: style.disableBtnTextColor,
              textColor: style.enableBtnTextColor,
              backgroundGradient: style.confirmBtnGradient,
              height: 44,
              onClickCallback: () {
                ref
                    .read(questionReportStateNotifierProvider.notifier)
                    .updateLog();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'text_bug_report_tip'.tr(),
              style: style.disableStyle(fontSize: 12),
            ),
          ]),
        )
      ]),
    );
  }
}
