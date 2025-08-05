import 'dart:convert';
import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/home/command_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_special_button.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class HomeFastCommandPop extends ConsumerStatefulWidget {
  final BaseDeviceModel? currentDevice;
  final VoidCallback? addCommandCallback;
  final Function(bool)? closeCallback;
  final Function(int)? editCommandCallback;
  final Function(String)? toastCallback;

  const HomeFastCommandPop(
      {super.key,
      required this.currentDevice,
      this.addCommandCallback,
      this.closeCallback,
      this.editCommandCallback,
      this.toastCallback});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeFastCommandPopState();
  }
}

class _HomeFastCommandPopState extends ConsumerState<HomeFastCommandPop> {
  @override
  Widget build(BuildContext context) {
    VacuumDeviceModel currentDeivce = (ref
        .watch(homeStateNotifierProvider)
        .currentDevice as VacuumDeviceModel);
    List<FastCommandModel> fastCommandList =
        currentDeivce.fastCommandList ?? [];
    List<Widget> column1 = [];
    List<Widget> column2 = [];

    for (int i = 0; i < fastCommandList.length; i++) {
      if (i % 2 == 0) {
        column1.add(_buildItem(fastCommandList[i], _clickFastCommandButton));
      } else {
        column2.add(_buildItem(fastCommandList[i], _clickFastCommandButton));
      }
    }

    return ThemeWidget(builder: (context, style, resource) {
      return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20), // 只裁剪左下角
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF252B52).withOpacity(0.05),
              blurRadius: 12, // 阴影模糊半径
              offset: const Offset(6, 6), // 阴影偏移量，x方向为6，y方向为6
            ),
          ],
        ),
        child: ClipRRect(
          // 圆角裁剪需要用ClipRRect。不能用ClipRRect
          borderRadius: const BorderRadiusDirectional.only(
            bottomStart: Radius.circular(20),
          ),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: style.fastCmdPopBgColor,
                      border: Border.all(color: style.white, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SingleChildScrollView(
                          child: Row(
                            // 这里一定要CrossAxisAlignment.start，如果是单数个。右边的会居中显示。
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                flex: 20,
                                child: SizedBox.shrink(),
                              ),
                              Expanded(
                                flex: 165,
                                child: Column(
                                  children: column1,
                                ),
                              ),
                              const Expanded(
                                flex: 20,
                                child: SizedBox.shrink(),
                              ),
                              Expanded(
                                flex: 165,
                                child: Column(
                                  children: column2,
                                ),
                              ),
                              const Expanded(
                                flex: 20,
                                child: SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 20,
                              child: SizedBox.shrink(),
                            ),
                            Expanded(
                              flex: 350,
                                child: MergeSemantics(
                                  child: Container(
                                    
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight:
                                          Radius.circular(20), // 只裁剪左下角
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF252B52)
                                            .withOpacity(0.05), // 阴影颜色
                                        blurRadius: 12, // 阴影模糊半径
                                        offset: const Offset(
                                            6, 6), // 阴影偏移量，x方向为6，y方向为6
                                      ),
                                    ]),
                                    child: Semantics(
                                      label: 'text_clean_sheet_command_create'
                                          .tr(),
                                      button: true,
                                      child: DMButton(
                                    width: double.infinity,
                                    height: 52,
                                    backgroundColor: style.fastCmdPopBtnBgColor,
                                    borderRadius: 12,
                                    textColor: style.textMainBlack,
                                    borderColor: style.fastCmdPopBorderColor,
                                    borderWidth: 1,
                                    fontWidget: FontWeight.w600,
                                    text:
                                        'text_clean_sheet_command_create'.tr(),
                                    onClickCallback: (context) {
                                      widget.addCommandCallback?.call();
                                          }),
                                    ),
                                  ),
                                )
                            ),
                            const Expanded(
                              flex: 20,
                              child: SizedBox.shrink(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 0,
                    end: 0,
                    child: Image.asset(
                            resource.getResource('ic_new_vacuum_cmd_bg_arrow'))
                        .flipWithRTL(context),
                  )
                ],
              )),
        ),
      );
    });
  }

  Widget _buildItem(
      FastCommandModel command, Function(FastCommandModel)? clickCallback) {
    bool isPin = false;
    if (command.property != null) {
      isPin = command.property!.contains('pin');
    }

    return ThemeWidget(builder: (context, style, resource) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Semantics(
                button: true,
                label: utf8.decode(base64.decode(command.name ?? '')),
                child: DMSpecialButton.primary(
              backgroundColor: style.white,
              borderColor: style.fastCmdPopBorderColor,
              borderWidth: 1,
              textColor: style.textMainBlack,
              height: 70,
              rightIconWidget: Semantics(
                label: command.state == '1'
                    ? 'pause'.tr()
                    : 'text_device_start'.tr(),
                child: Image.asset(
                  resource.getResource(command.state == '1'
                      ? 'ic_home_new_btn_clean_pause'
                      : 'ic_home_new_btn_clean'),
                  width: 40,
                  height: 40,
                ),
              ),
              text: utf8.decode(base64.decode(command.name ?? '')),
              maxLines: 2,
              boxShadow: BoxShadow(
                color: const Color(0xFF252B52).withOpacity(0.05), // 阴影颜色
                blurRadius: 12, // 阴影模糊半径
                offset: const Offset(6, 6), // 阴影偏移量，x方向为6，y方向为6
              ),
              borderRadius: 16,
              fontWidget: FontWeight.w600,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              onClickCallback: (context) async {
                clickCallback?.call(command);
              },
                )),
            PositionedDirectional(
                top: -5,
                start: -5,
                child: Visibility(
                  visible: isPin,
                  child: Image.asset(
                    resource.getResource('ic_home_fast_btn_pin'),
                    width: 20,
                    height: 20,
                  ).flipWithRTL(context),
                ))
          ],
        ),
      );
    });
  }

  Future<void> _clickFastCommandButton(FastCommandModel command) async {
    bool value = await ref
        .read(fastCommandStateNotifierProvider.notifier)
        .onFastCommandClick(command);
    widget.closeCallback?.call(value);
  }
}

class HomeFastPopupAnmiation extends StatefulWidget {
  const HomeFastPopupAnmiation({
    super.key,
    required this.child,
    required this.animationParam,
  });

  final Widget child;

  final AnimationParam animationParam;

  @override
  State<HomeFastPopupAnmiation> createState() => _CustomAnimationState();
}

class _CustomAnimationState extends State<HomeFastPopupAnmiation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationParam.animationTime,
    );
    widget.animationParam.onForward = () {
      _controller.value = 0;
      _controller.forward();
    };
    widget.animationParam.onDismiss = () {
      _controller.reverse();
    };

    // 创建缩放动画
    _scaleAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1.0, curve: Curves.easeInOut),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          bool rtl =
              (Directionality.of(context) == view_direction.TextDirection.rtl);
          return Transform.scale(
            alignment: Alignment.bottomCenter,
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _controller.value,
              child: child,
            ),
          );
        },
        child: widget.child);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
