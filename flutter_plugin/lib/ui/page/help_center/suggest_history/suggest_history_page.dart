import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_history_box.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest_history/suggest_history_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/question_suggest_tag.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/suggest_history_media_cell.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class SuggestHistoryPage extends BasePage {
  static const String routePath = '/suggest_history_page';

  const SuggestHistoryPage({super.key});

  @override
  BasePageState<SuggestHistoryPage> createState() {
    return _SuggestHistoryPage();
  }
}

class _SuggestHistoryPage extends BasePageState<SuggestHistoryPage>
    with ResponseForeUiEvent {
  @override
  Color? get backgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  Color? get navBackgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgColor;
  }

  @override
  String get centerTitle => 'text_history'.tr();

  @override
  void initData() {
    super.initData();
    ref.read(suggestHistoryStateNotifierProvider.notifier).loadData();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        suggestHistoryStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  Widget buildDeviceCell(SuggestHistoryItem history) {
    return ThemeWidget(builder: (_, style, resource) {
      return Row(
        children: [
          history.deviceIconUrl.isEmpty == true
              ? Image.asset(
                  resource.getResource('ic_placeholder_robot'),
                  width: 60,
                  height: 60,
                )
              : CachedNetworkImage(
                  imageUrl: history.deviceIconUrl,
                  errorWidget: (context, string, _) {
                    return Image.asset(
                      resource.getResource('ic_placeholder_robot'),
                      width: 60,
                      height: 60,
                    );
                  },
                  width: 60,
                  height: 60,
                ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 4).withRTL(context),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 20),
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        history.name,
                        style: style.mainStyle(fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Text(
                      history.time,
                      style: style.secondStyle(fontSize: 12),
                      textAlign: TextAlign.start,
                    ),
                  ]),
            ),
          ),
          Image.asset(
            resource.getResource('ic_help_arrow'),
            width: 16,
            height: 16,
          ).flipWithRTL(context),
        ],
      );
    });
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return ListView.builder(
        itemCount:
            ref.watch(suggestHistoryStateNotifierProvider).records?.length ?? 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemBuilder: (context, index) {
          SuggestHistoryItem history =
              ref.read(suggestHistoryStateNotifierProvider).records![index];
          return GestureDetector(
            onTap: () {
              ref
                  .read(suggestHistoryStateNotifierProvider.notifier)
                  .pushToIndex(index);
            },
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: style.bgWhite,
                borderRadius: BorderRadius.circular(style.circular8),
              ),
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                            left: 4, top: 12, right: 0, bottom: 12)
                        .withRTL(context),
                    child: Row(
                      children: [
                        if (history.type == 1)
                          history.deviceIconUrl.isEmpty == true
                              ? Image.asset(
                                  resource.getResource('ic_placeholder_robot'),
                                  width: 60,
                                  height: 60,
                                )
                              : CachedNetworkImage(
                                  imageUrl: history.deviceIconUrl,
                                  errorWidget: (context, string, _) {
                                    return Image.asset(
                                      resource
                                          .getResource('ic_placeholder_robot'),
                                      width: 60,
                                      height: 60,
                                    );
                                  },
                                  width: 60,
                                  height: 60,
                                ),
                        Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 4).withRTL(context),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints:
                                        const BoxConstraints(minHeight: 20),
                                    margin: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      history.type == 1
                                          ? history.name
                                          : 'app_feedback'.tr(),
                                      style: style.mainStyle(fontSize: 14),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Text(
                                    history.time,
                                    style: style.secondStyle(fontSize: 12),
                                    textAlign: TextAlign.start,
                                  ),
                                ]),
                          ),
                        ),
                        Image.asset(
                          resource.getResource('ic_help_arrow'),
                          width: 16,
                          height: 16,
                        ).flipWithRTL(context),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    indent: 4,
                    endIndent: 4,
                    color: style.lightBlack1,
                  ),
                  const SizedBox(
                    height: 11.5,
                  ),
                  if (history.tags != null && history.tags!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Wrap(
                        runSpacing: 12,
                        spacing: 12,
                        children: [
                          for (String tag in history.tags!)
                            QuestionSuggestionTag(
                              title: tag,
                              isSelect: true,
                            )
                        ],
                      ),
                    ),
                  Text(
                    history.content,
                    style: style.textNormalStyle(fontSize: 14),
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((history.medias?.length ?? 0) +
                          (history.medias?.length ?? 0) >
                      0)
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 12),
                      itemCount: history.medias?.length ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return SuggestHistoryMediaCell(
                          item: history.medias![index],
                        );
                      },
                    )
                ],
              ),
            ),
          );
        });
  }
}
