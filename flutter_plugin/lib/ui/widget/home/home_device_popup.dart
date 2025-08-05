import 'package:auto_size_text/auto_size_text.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class HomeDevicePopup extends StatelessWidget {
  final BaseDeviceModel? currentDevice;
  final VoidCallback? clickAdd;
  final VoidCallback? clickShare;
  final VoidCallback? clickRename;
  final VoidCallback? clickDelete;
  final bool isHideDeleteButton;

  const HomeDevicePopup(
      {super.key,
      required this.currentDevice,
      this.isHideDeleteButton = false,
      this.clickAdd,
      this.clickShare,
      this.clickRename,
      this.clickDelete});

  Widget buildItem(
      BuildContext context,
      StyleModel style,
      ResourceModel resource,
      String image,
      String text,
      Color fontColor,
      VoidCallback? clickCallback,
      {bool showDivider = true}) {
    return Container(
        constraints: const BoxConstraints(minWidth: 140, maxWidth: 200),
        padding: const EdgeInsets.all(12).withRTL(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage(
                    resource.getResource(image),
                  ),
                  width: 24,
                  height: 24,
                ).withDynamic().flipWithRTL(context),
                const SizedBox(width: 6),
                Flexible(
                    child: AutoSizeText(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  maxFontSize: 14,
                  minFontSize: 8,
                  stepGranularity: 1,
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ))
              ],
            ),
          ],
        )).onClick(() => clickCallback?.call());
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      bool showShare = currentDevice?.supportShare ?? false;

      return Padding(
        padding: const EdgeInsets.only(top: 8, right: 12).withRTL(context),
        child: Card(
          elevation: 0,
          color: style.bgWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(style.circular4)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              currentDevice == null
                  ? const SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: currentDevice!.master
                          ? [
                              showShare
                                  ? buildItem(
                                      context,
                                      style,
                                      resource,
                                      'ic_home_share',
                                      'text_home_popup_share'.tr(),
                                      style.textMain,
                                      clickShare)
                                  : const SizedBox.shrink(),
                              buildItem(
                                  context,
                                  style,
                                  resource,
                                  'ic_home_rename',
                                  'rename'.tr(),
                                  style.textMain,
                                  clickRename),
                              isHideDeleteButton
                                  ? const SizedBox.shrink()
                                  : buildItem(
                                      context,
                                      style,
                                      resource,
                                      'ic_home_delete',
                                      'cancel_receive'.tr(),
                                      style.red1,
                                      clickDelete,
                                      showDivider: false),
                            ]
                          : [
                              buildItem(
                                  context,
                                  style,
                                  resource,
                                  'ic_home_delete',
                                  'cancel_receive'.tr(),
                                  style.red1,
                                  clickDelete,
                                  showDivider: false)
                            ])
            ],
          ),
        ),
      );
    });
  }
}

class HomePopupAnmiation extends StatefulWidget {
  const HomePopupAnmiation({
    super.key,
    required this.child,
    required this.animationParam,
  });

  final Widget child;

  final AnimationParam animationParam;

  @override
  State<HomePopupAnmiation> createState() => _CustomAnimationState();
}

class _CustomAnimationState extends State<HomePopupAnmiation>
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
            alignment: rtl ? Alignment.topRight : Alignment.topLeft,
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
