import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/help_center/model/app_faq.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'video_player_page.dart';

// ignore: must_be_immutable
class FaqCell extends StatefulWidget {
  AppFaq faq;
  String? searchText = '';
  void Function() onExpand;

  FaqCell({
    super.key,
    required this.faq,
    this.searchText,
    required this.onExpand,
  });

  @override
  State<FaqCell> createState() => _FaqCellState();
}

class _FaqCellState extends State<FaqCell> {
  bool isExpand = false;

  @override
  void initState() {
    super.initState();
    isExpand = widget.faq.isExpand;
  }

  @override
  void didUpdateWidget(FaqCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    isExpand = widget.faq.isExpand;
  }

  void touchClick() {
    setState(() {
      isExpand = !isExpand;
    });
    widget.onExpand();
  }

  Widget buildProductIntroduce(BuildContext context, StyleModel style,
      AppFaq faq, List<String>? search) {
    var url = faq.localizationDisplayMedia.filePath;
    if (isExpand) {
      if (url?.isNotEmpty == true) {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0, bottom: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      AppRoutes().push(VideoPlayerPage.routePath, extra: url!);
                    },
                    child: Text('click_here_to_view_video_details'.tr(),
                        style: TextStyle(
                            color: style.click,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                  )),
              buildRichText(style, faq, search),
            ]));
      } else {
        return buildRichText(style, faq, search);
      }
    } else {
      return Container();
    }
  }

  Widget buildRichText(StyleModel style, AppFaq faq, List<String>? search) {
    return DMFormatRichText(
      type: 2,
      content: faq.bodyItems.first.content,
      normalTextStyle: TextStyle(
        color: style.textSecond,
        fontSize: 14,
      ),
      clickTextStyle: TextStyle(
        color: style.click,
        fontSize: 14,
      ),
      indexs: search,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      AppFaq faq = widget.faq;
      List<String>? search =
          widget.searchText != null ? [widget.searchText!] : null;
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 12).withRTL(context),
        color: style.bgWhite,
        child: Column(children: [
          GestureDetector(
            onTap: () {
              touchClick();
            },
            child: Container(
                constraints: const BoxConstraints(minHeight: 60),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 19, bottom: 19),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DMFormatRichText(
                              type: 2,
                              content: faq.title,
                              normalTextStyle: style.normalStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                              clickTextStyle: style.clickStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                              indexs: search,
                            ),
                          ),
                          Transform.rotate(
                            angle: isExpand
                                ? (Directionality.of(context) ==
                                view_direction.TextDirection.rtl
                                    ? -math.pi / 2
                                    : math.pi / 2)
                                : 0,
                            child: Image(
                              image: AssetImage(
                                resource.getResource('ic_help_arrow'),
                              ),
                              width: 20,
                              height: 20,
                            ).flipWithRTL(context),
                          )
                        ]),
                  ),
                  Divider(
                    height: 1.0,
                    indent: 14.0,
                    color: isExpand ? style.lightBlack1 : style.bgWhite,
                  ),
                  const SizedBox(height: 16),
                ])),
          ),
          buildProductIntroduce(context, style, faq, search),
        ]),
      );
    });
  }
}
