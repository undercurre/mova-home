import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/help_center/model/after_sale_info.dart';
import 'package:flutter_plugin/ui/widget/common/dash_divider.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class HelpCenterContactCell extends StatelessWidget {
  final String title;
  final List<AfterSaleItemValue>? items;
  final bool isShowEnter;

  final void Function(AfterSaleItemValue?)? onTap;

  const HelpCenterContactCell(
      {super.key,
        required this.title,
        this.items,
        this.isShowEnter = true,
        this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(null);
        }
      },
      child: ThemeWidget(builder: (_, style, resource) {
        return Column(children: [
          Container(
            constraints: const BoxConstraints(minHeight: 60),
            width: double.infinity,
            color: style.bgWhite,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: style.mainStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                      if (items != null && items!.isNotEmpty)
                        for (var item in items!)
                          GestureDetector(
                            onTap: () {
                              if (onTap != null) {
                                onTap!(item);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 5),
                              width: double.infinity,
                              child: Text(
                                item.channelContent ?? '',
                                style: style.secondStyle(fontSize: 14),
                                maxLines: 100,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                if (isShowEnter)
                  Image(
                    image: AssetImage(
                      resource.getResource('ic_help_arrow'),
                    ),
                    width: 20,
                    height: 20,
                  ).flipWithRTL(context),
              ],
            ),
          ),
          DashedDivider(
            color: style.lightBlack1,
            strokeWidth: 1,
            dashLength: 5,
            spaceLength: 5,
            indent: 48,
          )
        ]);
      }),
    );
  }
}
