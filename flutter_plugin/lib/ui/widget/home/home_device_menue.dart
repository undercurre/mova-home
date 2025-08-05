import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class HomeDeviceMenu extends StatelessWidget {
  final DeviceModel? currentDevice;
  final Function(DeviceModel? currentDevice)? clickAdd;
  final Function(DeviceModel? currentDevice)? clickShare;
  final Function(DeviceModel? currentDevice)? clickRename;
  final Function(DeviceModel? currentDevice)? clickDelete;

  const HomeDeviceMenu(
      {super.key,
      required this.currentDevice,
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
      Function(DeviceModel? currentDevice)? clickCallback,
      {bool showDivider = true}) {
    return Container(
        padding: const EdgeInsets.all(12).withRTL(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10).withRTL(context),
              child: Image(
                image: AssetImage(
                  resource.getResource(image),
                ),
                width: 24,
                height: 24,
              ).withDynamic().flipWithRTL(context),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
                child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: fontColor, fontSize: 14, fontWeight: FontWeight.bold),
            ))
          ],
        )).onClick(() => clickCallback?.call(currentDevice));
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      bool rtl =
          (Directionality.of(context) == view_direction.TextDirection.rtl);
      return Container(
        // padding: const EdgeInsets.only(top: 8, right: 12).withRTL(context),
        child: CustomPaint(
          painter: BubblePainter(color: const Color(0xFF6A6A6A), radius: 8.0),
          child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  currentDevice == null
                      ? const SizedBox()
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: currentDevice!.master
                              ? [
                                  buildItem(
                                      context,
                                      style,
                                      resource,
                                      'ic_home_rename',
                                      'rename'.tr(),
                                      style.textWhite,
                                      clickRename),
                                  buildItem(
                                      context,
                                      style,
                                      resource,
                                      'ic_home_share',
                                      'text_home_popup_share'.tr(),
                                      style.textWhite,
                                      clickShare),
                                  buildItem(
                                      context,
                                      style,
                                      resource,
                                      'ic_home_delete',
                                      'cancel_receive'.tr(),
                                      style.red1,
                                      clickDelete,
                                      showDivider: false)
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
              )),
        ),
      );
    });
  }
}

class HomePopupMenueAnmiation extends StatefulWidget {
  const HomePopupMenueAnmiation({
    super.key,
    required this.child,
    required this.animationParam,
  });

  final Widget child;

  final AnimationParam animationParam;

  @override
  State<HomePopupMenueAnmiation> createState() => _CustomAnimationState();
}

class _CustomAnimationState extends State<HomePopupMenueAnmiation>
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

class BubblePainter extends CustomPainter {
  final double radius;
  final Color color; // 圆角大小

  BubblePainter(
      {this.radius = 10.0, this.color = Colors.transparent}); // 默认圆角大小为10

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    // 绘制尖角
    path.moveTo(size.width / 2 - 10, 10); // 尖角的左侧点
    path.lineTo(size.width / 2, 0); // 尖角的顶点
    path.lineTo(size.width / 2 + 10, 10); // 尖角的右侧点

    // 使用RRect绘制带圆角的矩形
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 10, size.width, size.height - 10),
        Radius.circular(radius)));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
