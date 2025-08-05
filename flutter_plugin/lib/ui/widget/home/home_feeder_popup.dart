import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/message/share/popup/device_share_popup_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeFeederPopup extends ConsumerStatefulWidget {
  final int defaultIndex; //默认选中index
  final int defaultWeight; //默认克重
  final VoidCallback dismissCallback;
  final Function(int index, dynamic value)? confirmCallback;

  const HomeFeederPopup(
      {required this.defaultIndex,
      required this.defaultWeight,
      required this.dismissCallback,
      required this.confirmCallback,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeFeederPopupState();
}

class _HomeFeederPopupState extends ConsumerState<HomeFeederPopup>
    with CommonDialog {
  final List<int> _values = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20
  ];
  int _selectedEatIndex = 0;
  @override
  void initState() {
    super.initState();
    _selectedEatIndex = widget.defaultIndex;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
        deviceSharePopupNotifierProvider.select((value) => value.uiEvent),
        ((previous, next) {
      if (next is ToastEvent) {
        if (next.text.isNotEmpty) {
          showToast(next.text);
        }
        widget.dismissCallback.call();
      }
    }));
    return ThemeWidget(
      builder: (_, style, resource) {
        return Column(
          children: [
            const Spacer(),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90).withRTL(context),
                  child: Container(
                    height: 360,
                    decoration: BoxDecoration(
                        color: style.bgWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(style.circular20),
                            topRight: Radius.circular(style.circular20))),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10)
                                  .withRTL(context),
                              child: Text(
                                'feeder_immediately'.tr(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: style.mainStyle(fontSize: 16),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                      left: 32, right: 32, top: 16, bottom: 16)
                                  .withRTL(context),
                              child: SizedBox(
                                height: 60,
                                width: double.infinity,
                                child: _buildMeddleContentView(style),
                              ),
                            ),
                            Container(child: _buildHorizonScrollWhile(style)),
                            Padding(
                              padding: const EdgeInsets.only(
                                      left: 32, right: 32, top: 16, bottom: 16)
                                  .withRTL(context),
                              child: _buildBottomBtn(style),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildMeddleContentView(StyleModel style) {
    int count = _values[_selectedEatIndex];
    int remindweight = count * widget.defaultWeight;
    return Row(
      children: [
        Text(
          'feeder_total'.tr(),
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: style.textMain),
        ),
        const Spacer(),
        Text(
          'feeder_segment_format'.tr(args: ['$count', '${remindweight}g']),
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFDC6E)),
        )
      ],
    );
  }

  Widget _buildHorizonScrollWhile(StyleModel style) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: HorizonListView(
              height: 100,
              dataSource: _values,
              selectIndex: _selectedEatIndex,
              selectChanged: (index) {
                setState(() {
                  _selectedEatIndex = index;
                });
              }),
        )
      ],
    );
  }

  Widget _buildBottomBtn(StyleModel style) {
    return SizedBox(
        height: 60,
        child: Row(
          children: [
            Expanded(
                child: DMButton(
                    height: 48,
                    width: double.infinity,
                    onClickCallback: (_) {
                      widget.dismissCallback.call();
                    },
                    text: 'cancel'.tr(),
                    textColor: style.textMain,
                    fontsize: 14,
                    fontWidget: FontWeight.w500,
                    backgroundColor: style.bgGray,
                    borderRadius: style.buttonBorder,
                    padding: const EdgeInsets.symmetric(vertical: 14))),
            const Visibility(
                visible: true,
                child: SizedBox(
                  width: 32,
                )),
            Expanded(
                child: DMButton(
                    height: 48,
                    width: double.infinity,
                    onClickCallback: (_) {
                      widget.confirmCallback
                          ?.call(_selectedEatIndex, _values[_selectedEatIndex]);
                    },
                    text: 'confirm'.tr(),
                    textColor: style.enableBtnTextColor,
                    fontsize: 14,
                    fontWidget: FontWeight.w500,
                    backgroundGradient: style.confirmBtnGradient,
                    borderRadius: style.buttonBorder,
                    padding: const EdgeInsets.symmetric(vertical: 14)))
          ],
        ));
  }
}

class HorizonListView extends StatefulWidget {
  double? height;
  List<dynamic> dataSource;
  int? selectIndex;
  ValueChanged<int> selectChanged;
  Widget? rightWidget;

  HorizonListView({
    super.key,
    this.height,
    required this.dataSource,
    required this.selectIndex,
    required this.selectChanged,
  });

  @override
  State<HorizonListView> createState() => _HorizonListViewState();
}

class _HorizonListViewState extends State<HorizonListView> {
  @override
  Widget build(BuildContext context) {
    if ((widget.selectIndex ?? 0) > (widget.dataSource.length - 1)) {
      widget.selectChanged(widget.dataSource.length - 1);
    }

    return ThemeWidget(builder: (context, style, resource) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 1,
                child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: widget.height,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.dataSource.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              widget.selectChanged(index);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: widget.selectIndex == index
                                    ? BoxDecoration(
                                        color: const Color(0xFFFFDC6E),
                                        borderRadius: BorderRadius.circular(52),
                                      )
                                    : null,
                                width: 60,
                                height: 100,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${widget.dataSource[index]}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: style.normal)),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text('feeder_count_segment'.tr(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: style.normal))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })))
          ]);
    });
  }
}
