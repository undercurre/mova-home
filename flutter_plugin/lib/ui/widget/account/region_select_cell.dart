// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';

class RegionSelectCell extends StatelessWidget {
  RegionSelectCell({
    super.key,
    required this.item,
    required this.isSelect,
    required this.onTap,
    required this.isChinese,
    required this.isGroupLast,
  });

  final RegionItem item;
  final bool isSelect;
  final bool isChinese;
  bool isGroupLast = false;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, res) {
        return GestureDetector(
          onTapUp: (_) {
            onTap();
          },
          child: Container(
              padding: const EdgeInsets.only(left: 24).withRTL(context),
              height: 52,
              color: style.bgWhite,
              child: Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text(
                        isChinese ? item.name : item.en,
                        style: style.mainStyle(),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10).withRTL(context),
                        child: Text(
                          item.code,
                          style: style.mainStyle(),
                        ),
                      ),
                      const Expanded(
                        child: Text(''),
                      ),
                      Visibility(
                        visible: isSelect,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 24).withRTL(context),
                          child: ThemeWidget(
                            builder: (context, styleModel, resource) {
                              return Image.asset(
                                resource.getResource('search_right'),
                                width: 24,
                                height: 24,
                                color: style.textMainBlack,
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  )),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        // margin: const EdgeInsets.only(left: 24),
                        height: 0.5,
                        // width: 100,
                        color: isGroupLast ? null : style.lightBlack,
                        // child: const Text(''),
                      ))
                    ],
                  )
                ],
              )),
        );
      },
    );
  }
}
