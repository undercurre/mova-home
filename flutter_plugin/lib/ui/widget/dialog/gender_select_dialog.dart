import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';

typedef SelectValueCallback<T, E> = void Function(T title, E value);

/// 内容，取消按钮，登录按钮
class GenderSelectDialog extends Dialog {
  final String cancelContent;
  final String confirmContent;
  final List<String> itemArray;
  final List<dynamic> valueArray;
  final VoidCallback? cancelCallback;
  final SelectValueCallback confirmCallback;
  final BuildContext _cancelContext;
  final int? defaultIndex;

  const GenderSelectDialog(
    this._cancelContext, {
    super.key,
    required this.cancelContent,
    required this.confirmContent,
    required this.confirmCallback,
    required this.itemArray,
    required this.valueArray,
    this.cancelCallback,
    this.defaultIndex,
  });

  void dismiss() {
    Navigator.of(_cancelContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    late int selectIndex = defaultIndex ?? 0;
    List<String> genderList = itemArray;
    return ThemeWidget(builder: (_, style, resource) {
      return Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(style.circular20),
                color: style.bgWhite),
            margin: const EdgeInsets.symmetric(horizontal: 35),
            padding:
                const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 20)
                    .withRTL(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    height: 132,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                                color: style.bgGray,
                                borderRadius:
                                    BorderRadius.circular(style.cellBorder)),
                          ),
                        ),
                        SizedBox(
                          height: 132,
                          child: ListWheelScrollView.useDelegate(
                            physics: const FixedExtentScrollPhysics(),
                            magnification: 1.5,
                            overAndUnderCenterOpacity: 0.4,
                            childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  return Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${genderList[index]}",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: style.textMainBlack),
                                    ),
                                  );
                                },
                                childCount: genderList.length),
                            itemExtent: 44.0,
                            onSelectedItemChanged: (int index) =>
                                {selectIndex = index},
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 24).withRTL(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: DMButton(
                            height: 48,
                            borderRadius: style.buttonBorder,
                            width: double.infinity,
                            textColor: style.lightDartBlack,
                            backgroundGradient: style.cancelBtnGradient,
                            text: cancelContent,
                            onClickCallback: (_) {
                              dismiss();
                              cancelCallback?.call();
                            }),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: DMButton(
                            height: 48,
                            borderRadius: style.buttonBorder,
                            textColor: style.btnText,
                            backgroundGradient: style.confirmBtnGradient,
                            text: confirmContent,
                            width: double.infinity,
                            onClickCallback: (_) {
                              dismiss();
                              confirmCallback.call(itemArray[selectIndex],
                                  valueArray[selectIndex]);
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
