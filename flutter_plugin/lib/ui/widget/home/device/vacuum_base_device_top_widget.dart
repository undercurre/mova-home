import 'package:auto_size_text/auto_size_text.dart';
// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_special_button.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VacuumBaseDeviceTopWidget extends ConsumerStatefulWidget {
  final Pair<ActionBtnResourceModel, ActionBtnResourceModel> btnRes;
  final Pair<ButtonState, ButtonState> btnState;
  final String fastCmdTitle;
  final Function onFastCmdClick;
  final Function onCleanClick;
  final Function onCleanTopClick;
  final VacuumDeviceModel device;
  final StyleModel style;
  final ResourceModel resource;
  final Function(String) messgaeToast;
  final VoidCallback monitorClick;
  final bool rtl;
  final int topFlex;
  final int bottomFlex;
  final int middleFlex;
  final int totalFlex;
  final double constraintsWidth;
  final double constraintsHeight;
  final double topPadding;
  final VoidCallback enterPluginClick;
  final GlobalKey keyClean;
  final GlobalKey keyCharge;

  const VacuumBaseDeviceTopWidget({
    required this.btnRes,
    required this.btnState,
    required this.fastCmdTitle,
    required this.onFastCmdClick,
    required this.onCleanClick,
    required this.onCleanTopClick,
    required this.device,
    required this.style,
    required this.resource,
    required this.messgaeToast,
    required this.monitorClick,
    required this.enterPluginClick,
    required this.rtl,
    required this.topFlex,
    required this.middleFlex,
    required this.bottomFlex,
    required this.totalFlex,
    required this.constraintsWidth,
    required this.constraintsHeight,
    required this.topPadding,
    required this.keyClean,
    required this.keyCharge,
    super.key,
  });

  @override
  ConsumerState<VacuumBaseDeviceTopWidget> createState() =>
      _VacuumBaseDeviceTopWidgetState();
}

class _VacuumBaseDeviceTopWidgetState
    extends ConsumerState<VacuumBaseDeviceTopWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static const int textHideTime = 1; // 1 毫秒隐藏文字
  static const int sizeTime = 150; // 150 毫秒缩小
  static const int moveTime = 400; // 400 毫秒移动
  static const int textOpacityAnimationTime = 20;

  // 主动画控制器
  AnimationController? _mainController;

  // 新增：用于控制原来大小内容显示的动画
  AnimationController? _originalShowController;

  late Animation<double> _originalShowAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Size> _sizeAnimation;
  late Animation<double> _verticalMoveAnimation;
  late Animation<double> _imageOpacityAnimation;

  double _originalY = 0.0;
  double _verticalMoveY = 0.0;
  double _sizeHeight = 0.0;
  bool _isAnimationCompleted = false;

  double _cleanWidth = 0.0;
  double _cleanHeight = 0.0;
  double _rightPadding = 0.0;
  double _monotorY = 0.0;

  void _initAnimations() {
    if (_mainController == null || _originalShowController == null) return;

    // 计算总时间
    const totalTime = textHideTime + sizeTime + moveTime;

    double animationEndDy = _monotorY + 15;
    if (widget.device.isShowVideoFeature()) {
      animationEndDy = _monotorY + 42 + 15;
    }

    // 文字透明度动画，先隐藏文字
    _textOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: textHideTime / totalTime,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.0),
        weight: (totalTime - textHideTime) / totalTime,
      ),
    ]).animate(_mainController!);

    // 大小动画，在文字隐藏后开始缩小
    _sizeAnimation = TweenSequence<Size>([
      TweenSequenceItem(
        tween: ConstantTween<Size>(Size(_cleanWidth, _sizeHeight)),
        weight: textHideTime / totalTime,
      ),
      TweenSequenceItem(
        tween: Tween<Size>(
          begin: Size(_cleanWidth, 300),
          end: const Size(42, 42),
        ),
        weight: sizeTime / totalTime,
      ),
      TweenSequenceItem(
        tween: ConstantTween<Size>(const Size(42, 42)),
        weight: moveTime / totalTime,
      ),
    ]).animate(_mainController!);

    // 垂直移动动画
    _verticalMoveAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(_verticalMoveY),
        weight: textHideTime / totalTime,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(_verticalMoveY),
        weight: sizeTime / totalTime,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: _originalY,
          end: animationEndDy,
        ),
        weight: moveTime / totalTime,
      ),
    ]).animate(_mainController!);

    // 初始化图片透明度动画
    _imageOpacityAnimation = _createTweenSequence<double>(
      [
        _createTweenSequenceItem(
          ConstantTween<double>(1.0),
          textOpacityAnimationTime,
          totalTime,
        ),
        _createTweenSequenceItem(
          Tween<double>(
            begin: 1.0,
            end: 0.0,
          ),
          textOpacityAnimationTime,
          totalTime,
        ),
        _createTweenSequenceItem(
          ConstantTween<double>(0.0),
          totalTime - 2 * textOpacityAnimationTime,
          totalTime,
        ),
      ],
      _mainController!,
    );

    // 新增：初始化原来大小内容显示的动画
    _originalShowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _originalShowController!,
        curve: const Interval(0.0, 1.0),
      ),
    );

    // 监听主动画控制器的状态，50%进度时开始原来大小内容的动画
    _mainController?.addListener(() {
      try {
        if (_mainController!.value >= 0.5) {
          _originalShowController?.forward();
        } else {
          _originalShowController?.reverse();
        }
      } catch (e) {
        _originalShowController?.value = 1.0; // 设置动画到结束状态
        LogUtils.e('_originalShowController Error in animation listener: $e');
      }
    });

    _mainController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimationCompleted = true;
      } else {
        _isAnimationCompleted = false;
      }
    });
  }

  // 创建 TweenSequence 的辅助方法
  Animation<T> _createTweenSequence<T>(
    List<TweenSequenceItem<T>> items,
    AnimationController controller,
  ) {
    return TweenSequence<T>(items).animate(controller);
  }

  // 创建 TweenSequenceItem 的辅助方法
  TweenSequenceItem<T> _createTweenSequenceItem<T>(
    Tween<T> tween,
    int duration,
    int totalDuration,
  ) {
    return TweenSequenceItem(
      tween: tween,
      weight: duration / totalDuration,
    );
  }

  @override
  void initState() {
    super.initState();

    LogUtils.i(
        '[VacuumBaseDeviceTopWidget] initState constraintsWidth = ${widget.constraintsWidth}, constraintsHeight = ${widget.constraintsHeight}');

    // 计算尺寸
    _recalculateSizes();

    try {
      _mainController = AnimationController(
        vsync: this,
        duration:
            const Duration(milliseconds: textHideTime + sizeTime + moveTime),
      );

      _originalShowController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: moveTime),
      );

      _initAnimations();
    } catch (e) {
      _originalShowController?.value = 1.0; // 设置动画到结束状态
      LogUtils.e('Error initState animations: $e');
    }
  }

  void _toggleAnimation() {
    bool online = widget.device.isOnline();
    if (!online) {
      return;
    }

    // 如果已经是小快捷指令，则不执行动画
    if (_isSmallFastCmdShow()) {
      return;
    }

    // 如果动画还在进行中，则不执行动画
    if (_mainController?.status == AnimationStatus.forward ||
        _mainController?.status == AnimationStatus.completed) {
      return;
    }

    if (_isAnimationCompleted) {
      return;
    }

    // 如果能点击，先重置动画
    _mainController?.reset();
    _mainController?.forward();
  }

  @override
  void didUpdateWidget(covariant VacuumBaseDeviceTopWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 检查宽度或高度是否发生变化
    if (oldWidget.constraintsWidth != widget.constraintsWidth ||
        oldWidget.constraintsHeight != widget.constraintsHeight) {
      LogUtils.i('[VacuumBaseDeviceTopWidget] Size changed: '
          'width: ${oldWidget.constraintsWidth} -> ${widget.constraintsWidth}, '
          'height: ${oldWidget.constraintsHeight} -> ${widget.constraintsHeight}');

      // 重新计算尺寸相关的变量
      _recalculateSizes();

      // 重新初始化动画（如果需要的话）
      _initAnimations();

      LogUtils.i('[VacuumBaseDeviceTopWidget] Size changed: '
          'width: ${_sizeAnimation.value.width} , '
          'height: ${_sizeAnimation.value.height} ');
    }
  }

  void _recalculateSizes() {
    double flexWidthValue = 390;
    double containerW = widget.constraintsWidth * 350 / flexWidthValue;
    _cleanWidth = containerW * 176 / 350;
    _cleanHeight =
        widget.constraintsHeight * widget.bottomFlex / widget.totalFlex;

    double dy = widget.constraintsHeight *
        (widget.topFlex + widget.middleFlex) /
        widget.totalFlex;
    _originalY = dy;

    _rightPadding = (widget.constraintsWidth - containerW) / 2;
    _monotorY = widget.topPadding + 50;

    // 194是因为312行的Container的Column的154+40
    double contentH = _cleanHeight * (154 / widget.bottomFlex);
    _sizeHeight = contentH * (69 / 154);

    double midPadding = contentH * (16 / 154);
    _verticalMoveY = dy + _sizeHeight + midPadding;

    LogUtils.i('[VacuumBaseDeviceTopWidget] Recalculated sizes: '
        'contentH: $contentH, _cleanHeight: $_cleanHeight, dy : $dy, _sizeHeight : $_sizeHeight, midPadding: $midPadding,');
  }

  @override
  void dispose() {
    _mainController?.dispose();
    _originalShowController?.dispose();
    _mainController = null;
    _originalShowController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ThemeWidget(builder: (context, style, resource) {
      return Stack(
        children: [
          PositionedDirectional(
            end: _rightPadding,
            top: _monotorY,
            child: _buildMenuWidget(style, resource),
          ),
          Column(
            children: [
              Expanded(
                flex: widget.topFlex,
                child: Container(
                    // color: Colors.red,
                    ),
              ),
              Expanded(
                flex: widget.middleFlex,
                child: Container(
                    // color: Colors.green,
                    ),
              ),
              Expanded(
                flex: widget.bottomFlex,
                child: Container(
                  // color: Colors.blue,
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 20,
                        child: SizedBox.shrink(),
                      ),
                      Expanded(
                          flex: 350,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 154,
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 154,
                                      child: Container(
                                        child:
                                            _buildEnterWidget(style, resource),
                                      ),
                                    ),
                                    Expanded(
                                      flex: widget.bottomFlex - 154,
                                      child: const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                flex: 20,
                                child: SizedBox.shrink(),
                              ),
                              Expanded(
                                flex: 176,
                                // 这里需要占位控件。因为keyCharge涉及到其他使用
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 154,
                                      key: widget.keyCharge,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 69,
                                            child: Container(
                                              // color: Colors.green,
                                              child: _buildCleanListWidget(
                                                  resource, context, style),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 16,
                                            child: Container(
                                                // color: Colors.red,
                                                ),
                                          ),
                                          Expanded(
                                            flex: 69,
                                            child: Visibility(
                                              visible: _isSmallFastCmdShow(),
                                              child: GestureDetector(
                                                onTap: () {
                                                  widget.onCleanClick();
                                                },
                                                child: _buildCleanWidget(
                                                    resource, context, style),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: widget.bottomFlex - 154,
                                      child: const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      const Expanded(
                        flex: 20,
                        child: SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomWidget(resource, context, style),
        ],
      );
    });
  }

  Widget _buildBottomWidget(
      ResourceModel resource, BuildContext context, StyleModel style) {
    // 如果不支持快捷指令，直接返回
    bool supportFastCommand = widget.device.isSupportFastCommand();
    if (!supportFastCommand) {
      return PositionedDirectional(
        end: _rightPadding,
        top: _verticalMoveY,
        child: GestureDetector(
          onTap: () {
            widget.onCleanClick();
          },
          child: SizedBox(
            width: _cleanWidth,
            height: _sizeHeight,
            child: _buildCleanWidget(resource, context, style),
          ),
        ),
      );
    }
    // 正在工作中 && _isAnimationCompleted
    if (_isWorking() && _isAnimationCompleted) {
      // 点击“全屋清洁”按钮后，这里需要重置动画，是因为状态变成非工作中(显示大快捷指令UI)，需要能再次启动动画。
      _mainController?.reset();
    }

    if (_isSmallFastCmdShow()) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_mainController, _originalShowAnimation]),
      builder: (context, child) {
        return Stack(
          children: [
            PositionedDirectional(
              end: _rightPadding,
              top: _verticalMoveY,
              child: Container(
                child: _buildAnimationWidget(resource, context, style),
              ),
            ),
            PositionedDirectional(
              end: _rightPadding,
              top: _verticalMoveAnimation.value,
              child: GestureDetector(
                onTap: () {
                  if (_isBigFastCmdShow()) {
                    widget.onFastCmdClick();
                    return;
                  }
                  widget.onCleanClick();
                },
                child: SizedBox(
                  width: _sizeAnimation.value.width,
                  height: _sizeAnimation.value.height,
                  child: _buildFastCmdWidget(
                    resource,
                    context,
                    style,
                    _sizeAnimation.value.width,
                    _sizeAnimation.value.height,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimationWidget(
      ResourceModel resource, BuildContext context, StyleModel style) {
    return Opacity(
      opacity: _originalShowAnimation.value,
      child: GestureDetector(
        onTap: () {
          widget.onCleanClick();
        },
        child: SizedBox(
          width: _cleanWidth,
          height: _sizeHeight,
          child: _buildCleanWidget(resource, context, style),
        ),
      ),
    );
  }

  Widget _buildEnterWidget(StyleModel style, ResourceModel resource) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF955E30).withOpacity(0.16), // 阴影颜色
            blurRadius: 12, // 阴影模糊半径
            offset: const Offset(6, 6), // 阴影偏移量，x方向为6，y方向为6
          ),
        ],
      ),
      child: Container(
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(resource.getResource('ic_new_vacuum_enter_bg')),
              fit: BoxFit.fill, // 这里不能用BoxFit.contain，折叠屏手机会有问题
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              resource.getResource('ic_new_vaccum_logo'),
              width: 42,
              height: 42,
              color: style.textMainWhite,
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: AutoSizeText(
                    'text_enter_plugin'.tr(),
                    minFontSize: 14,
                    maxFontSize: 24,
                    stepGranularity: 1,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: style.textMainWhite),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 8.0,
                  ),
                  child: Image.asset(
                    resource.getResource('ic_arrow_right_small'),
                    width: 11,
                    height: 18,
                    color: style.textMainWhite,
                  ).flipWithRTL(context),
                )
              ],
            )
          ],
        ).flipWithRTL(context),
      ).flipWithRTL(context).onClick(() {
        widget.enterPluginClick();
      }),
    );
  }

  // 是否正在工作中
  bool _isWorking() {
    return widget.device.latestStatus == 12 || // 正在清洁
        widget.device.latestStatus == 1 || // 正在清扫
        widget.device.latestStatus == 5 || // 正在回充
        widget.device.latestStatus == 7 || // 正在拖地
        widget.device.latestStatus == 97 || // 快捷指令任务中
        widget.device.latestStatus == 27; // 局部清洁
  }

  Widget _buildFastCmdWidget(ResourceModel resource, BuildContext context,
      StyleModel style, double width, double height) {
    return Stack(
      children: [
        Opacity(
          opacity: _imageOpacityAnimation.value,
          child: Image(
            width: width,
            height: height,
            image: AssetImage(
              resource.getResource('ic_new_vacuum_cmd_bg'),
            ),
            fit: BoxFit.fill,
          ).flipWithRTL(context),
        ),
        PositionedDirectional(
          top: 12,
          start: 16,
          end: (40 + 16),
          child: Opacity(
            opacity: _textOpacityAnimation.value,
            child: AutoSizeText(
              widget.fastCmdTitle,
              maxFontSize: 14,
              minFontSize: 12,
              maxLines: 2,
              style: TextStyle(
                fontSize: 14,
                decoration: TextDecoration.none,
                color: _textColor(context, style, resource),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        _buildFastCmdIconWidget(resource, context, style),
      ],
    );
  }

  Widget _buildFastCmdIconWidget(
      ResourceModel resource, BuildContext context, StyleModel style) {
    bool isMinimized =
        _sizeAnimation.value.width == 42 && _sizeAnimation.value.height == 42;
    if (isMinimized) {
      return Align(
        alignment: Alignment.center,
        child: _iconCmdWidget(
            widget.btnState.second == ButtonState.disable, style, resource),
      );
    }

    return PositionedDirectional(
      bottom: 0,
      end: 0,
      child: SizedBox(
        width: 42,
        height: 42,
        child: GestureDetector(
          onTap: () {
            widget.onFastCmdClick();
          },
          child: Semantics(
            label: widget.btnState.second == ButtonState.disable
                ? 'text_add_fast_list'.tr() + 'device_offline'.tr()
                : 'text_add_fast_list'.tr(),
            child: Image.asset(
              resource.getResource(widget.btnState.second == ButtonState.disable
                  ? 'ic_home_new_btn_cmd_disable'
                  : 'ic_home_new_btn_cmd'),
            ).flipWithRTL(context),
          ),
        ),
      ),
    );
  }

  // 向上动画需要结束后，显示清洁
  Widget _buildCleanWidget(
      ResourceModel resource, BuildContext context, StyleModel style) {
    return Stack(
      children: [
        Image(
          image: AssetImage(
            resource.getResource('ic_new_vacuum_charge_bg'),
          ),
          fit: BoxFit.fill,
          width: _cleanWidth,
          height: _sizeHeight,
        ),
        PositionedDirectional(
          top: 12,
          start: 16,
          end: (40 + 16),
          child: AutoSizeText(_buttonText(context, style, resource),
              maxFontSize: 14,
              minFontSize: 12,
              maxLines: 2,
              style: TextStyle(
                fontSize: 14,
                decoration: TextDecoration.none,
                color: _textColor(context, style, resource),
                fontWeight: FontWeight.w600,
              )),
        ),
        PositionedDirectional(
            bottom: 2,
            end: 2,
            child: SizedBox(
              width: 42,
              height: 42,
              child: _rightIconWidget(context, resource),
            )),
      ],
    );
  }

  String _buttonText(
      BuildContext context, StyleModel style, ResourceModel resource) {
    String buttontText = '';
    ActionBtnResourceModel btnRes = widget.btnRes.second;
    if (widget.btnState.second == ButtonState.active) {
      buttontText = btnRes.activeText ?? '';
    } else if (widget.btnState.second == ButtonState.disable) {
      buttontText = btnRes.disableText ?? '';
    } else if (widget.btnState.second == ButtonState.none) {
      buttontText = btnRes.normalText ?? '';
    }
    return buttontText;
  }

  Color _textColor(
      BuildContext context, StyleModel style, ResourceModel resource) {
    if (widget.btnState.second == ButtonState.disable) {
      return style.homeCleanTextDisableColor;
    } else {
      return style.homeCleanTextColor;
    }
  }

  // 是否显示小快捷指令
  bool _isSmallFastCmdShow() {
    bool supportFastCommand = widget.device.isSupportFastCommand();
    // 小快捷指令
    bool isShowFastCmd = _showFastcommdBtnParse().second;
    return supportFastCommand && isShowFastCmd;
  }

  // 是否显示大快捷指令
  bool _isBigFastCmdShow() {
    bool supportFastCommand = widget.device.isSupportFastCommand();
    // 大快捷指令
    bool isShowFastCmd = _showFastcommdBtnParse().first;
    return supportFastCommand && isShowFastCmd;
  }

  Widget _rightIconWidget(BuildContext context, ResourceModel resource) {
    ActionBtnResourceModel btnRes = widget.btnRes.second;
    var imageName = btnRes.normalImage;
    imageName = 'ic_new_vacuum_cmd';
    String? currentLable = '';
    if (widget.btnState.second == ButtonState.active) {
      imageName = btnRes.activeImage;
      currentLable = btnRes.activeText;
    } else if (widget.btnState.second == ButtonState.disable) {
      imageName = btnRes.disableImage;
      currentLable = btnRes.disableText;
    } else {
      imageName = btnRes.normalImage;
      currentLable = btnRes.normalText;
    }
    return Semantics(
      label: currentLable,
      child: Image.asset(
        resource.getResource(imageName),
        width: 40,
        height: 40,
      ).flipWithRTL(context),
    );
  }

  Widget _iconCmdWidget(
      bool disable, StyleModel style, ResourceModel resource) {
    return GestureDetector(
        onTap: () {
          widget.onFastCmdClick();
        },
        child: Container(
          decoration: BoxDecoration(
            color: style.homeRightMenuBgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: style.homeRightMenuBorderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF252B52).withOpacity(0.05), // 阴影颜色
                blurRadius: 8, // 阴影模糊半径
                offset: const Offset(2, 4), // 阴影偏移量，x方向为2，y方向为4
              ),
            ],
          ),
          width: 42,
          height: 42,
          child: Semantics(
            label: widget.btnState.second == ButtonState.disable
                ? 'text_add_fast_list'.tr() + 'device_offline'.tr()
                : 'text_add_fast_list'.tr(),
            child: Image.asset(
              resource.getResource(widget.btnState.second == ButtonState.disable
                  ? 'ic_home_new_btn_cmd_disable'
                  : 'ic_home_new_btn_cmd'),
            ).flipWithRTL(context),
          ),
        ));
  }

  Widget _buildMenuWidget(StyleModel style, ResourceModel resource) {
    return Column(
      children: [
        _buildMonitor(),
        const SizedBox(
          height: 15,
        ),
        _buildFastCmdMenuWidget(style, resource),
      ],
    );
  }

  // 视频入口
  Widget _buildMonitor() {
    if (widget.device.isShowVideoFeature() || widget.device.isShowVideo()) {
      bool online = widget.device.isOnline();
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: widget.style.homeRightMenuBgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.style.homeRightMenuBorderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF252B52).withOpacity(0.05), // 阴影颜色
              blurRadius: 8, // 阴影模糊半径
              offset: const Offset(2, 4), // 阴影偏移量，x方向为2，y方向为4
            ),
          ],
        ),
        child: Semantics(
          label: online &&
                  (widget.device.master || widget.device.getVideoPermission())
              ? 'view_live_video'.tr()
              : 'view_live_video'.tr() + 'device_offline'.tr(),
          child: Image.asset(
            width: 30,
            height: 24,
            online &&
                    (widget.device.master || widget.device.getVideoPermission())
                ? widget.resource.getResource('ic_home_monitor')
                : widget.resource.getResource('ic_home_monitor_offline'),
          ).withDynamic().onClick(() {
            widget.monitorClick();
          }).flipWithRTL(context),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // 快捷指令菜单入口
  Widget _buildFastCmdMenuWidget(StyleModel style, ResourceModel resource) {
    if (!widget.device.isSupportFastCommand()) {
      return const SizedBox.shrink();
    }
    return Visibility(
      visible: _isSmallFastCmdShow(),
      child: Align(
        alignment: Alignment.center,
        child: _iconCmdWidget(
            widget.btnState.second == ButtonState.disable, style, resource),
      ),
    );
  }

  Widget _buildCleanListWidget(
      ResourceModel resource, BuildContext context, StyleModel style) {
    return /* 清洁按钮*/
        Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF252B52).withOpacity(0.05), // 阴影颜色
            blurRadius: 10, // 阴影模糊半径
            offset: const Offset(6, 6), // 阴影偏移量，x方向为6，y方向为6
          ),
        ],
      ),
      child: _buildCleanButton(
        style,
        resource,
      ),
    );
  }

  Widget _buildCleanButton(StyleModel style, ResourceModel resource) {
    return DMSpecialButton.third(
        backgroundImage:
            AssetImage(resource.getResource('ic_new_vacuum_start_bg')),
        actionBtnRes: widget.btnRes.first,
        state: widget.btnState.first,
        textColor: style.homeCleanTextColor,
        disableTextColor: style.homeCleanTextDisableColor,
        borderRadius: 8,
        fontsize: 14,
        maxLines: 2,
        fontWidget: FontWeight.w600,
        padding: const EdgeInsets.all(2),
        onClickCallback: (buttonState) async {
          await widget.onCleanTopClick();
          _toggleAnimation();
        });
  }

  @override
  bool get wantKeepAlive => true;

  /* 展示大快捷指令按钮 和小快捷指令按钮 <大快捷指令,小快捷指令>*/
  Pair<bool, bool> _showFastcommdBtnParse() {
    bool online = widget.device.isOnline();
    bool support = widget.device.isSupportFastCommand();
    if (!support) {
      //不支持快捷指令
      return Pair(false, false);
    }
    if (online) {
      if (widget.device.isCanStopFastCMD()) {
        //清洁任务中
        return Pair(false, true);
      } else if (widget.device.latestStatus == 2 /* 待机 */) {
        return Pair(false, true);
      } else if (widget.device.latestStatus == 105 ||
          widget.device.latestStatus == 106) {
        // 105: 拖布更换中， 106: 拖布更换暂停
        return Pair(false, true);
      } else {
        return Pair(true, false);
      }
    } else {
      //离线
      return Pair(false, true);
    }
  }
}
