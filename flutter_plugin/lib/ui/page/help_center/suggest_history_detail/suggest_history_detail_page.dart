import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_history_box.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest_history_detail/suggest_history_detail_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/question_suggest_tag.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/suggest_history_media_cell.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:media_viewer/model/media_item.dart';
import 'package:media_viewer/widget/media_previewer.dart';

class SuggestHistoryDetailPage extends BasePage {
  final SuggestHistoryItem history;
  static const String routePath = '/suggest_history_detail_page';

  const SuggestHistoryDetailPage({super.key, required this.history});

  @override
  BasePageState<SuggestHistoryDetailPage> createState() {
    return _SuggestHistoryDetailPage();
  }
}

class _SuggestHistoryDetailPage extends BasePageState<SuggestHistoryDetailPage>
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
  String get centerTitle => 'text_product_suggestion'.tr();

  @override
  void initData() {
    super.initData();
    ref
        .read(suggestHistoryDetailStateNotifierProvider.notifier)
        .loadData(widget.history);
  }

  void showDetail(int index) {
    List<String> mediaPaths = ref
        .read(suggestHistoryDetailStateNotifierProvider.notifier)
        .getMediaPaths();
    List<MediaItem> medias =
        mediaPaths.map((e) => MediaItem.builder(uri: e)).toList();
    MediaPreviewer.pushToViewer(context, previews: medias, selectIndex: index);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    SuggestHistoryItem? history =
        ref.watch(suggestHistoryDetailStateNotifierProvider).history;
    if (history == null) {
      return Container();
    }
    return Column(children: [
      Expanded(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: style.bgWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(style.circular8),
                      topRight: Radius.circular(style.circular8)),
                ),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16)
                    .withRTL(context),
                margin: const EdgeInsets.only(left: 16, right: 16, top: 12)
                    .withRTL(context),
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
                                    resource
                                        .getResource('ic_placeholder_robot'),
                                    width: 60,
                                    height: 60,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: history.deviceIconUrl,
                                    errorWidget: (context, string, _) {
                                      return Image.asset(
                                        resource.getResource(
                                            'ic_placeholder_robot'),
                                        width: 60,
                                        height: 60,
                                      );
                                    },
                                    width: 60,
                                    height: 60,
                                  ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 4)
                                  .withRTL(context),
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
                        ],
                      ),
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
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: style.bgWhite,
                ),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16)
                    .withRTL(context),
                margin:
                    const EdgeInsets.only(left: 16, right: 16).withRTL(context),
                child: Text(
                  history.content,
                  style: style.textNormalStyle(fontSize: 14),
                  softWrap: true,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: style.bgWhite,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(style.circular8),
                      bottomRight: Radius.circular(style.circular8)),
                ),
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20)
                    .withRTL(context),
                margin:
                    const EdgeInsets.only(left: 16, right: 16).withRTL(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            onTap: () {
                              showDetail(index);
                            },
                          );
                        },
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 32, right: 32, bottom: 50)
            .withRTL(context),
        padding: const EdgeInsets.only(top: 50),
        child: Text(
          'text_suggestion_submit_success_content'.tr(),
          style: style.disableStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }
}
