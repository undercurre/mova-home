/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-26 15:18:40
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-08-23 10:50:03
 * @FilePath: /flutter_plugin/lib/ui/page/language/language_picker_cell.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class LanguagePickerCell extends ConsumerStatefulWidget {
  LanguagePickerCell({
    super.key,
    required this.language,
    this.borderRadius = BorderRadius.zero,
    this.isSelect = false,
    this.onTap,
    required this.isGroupLast,
  });
  LanguageModel language;
  BorderRadiusGeometry borderRadius = BorderRadius.zero;
  bool isSelect = false;
  bool isGroupLast = false;
  final void Function()? onTap;
  @override
  LanguagePickerCellState createState() {
    return LanguagePickerCellState();
  }
}

class LanguagePickerCellState extends ConsumerState<LanguagePickerCell> {
  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
            ),
            // color: style.bgWhite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  // color: Colors.white,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16)
                        .withRTL(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.language.displayLang,
                          style: style.mainStyle(fontSize: 16),
                        ),
                        Visibility(
                          visible: widget.isSelect,
                          child: ThemeWidget(
                            builder: (context, styleModel, resource) {
                              return Image.asset(
                                resource.getResource('search_right'),
                                width: 24,
                                height: 24,
                                color: styleModel.textMainBlack,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16)
                        .withRTL(context),
                    child: Container(
                      height: 0.5,
                      color: widget.isGroupLast ? null : style.lightBlack1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
