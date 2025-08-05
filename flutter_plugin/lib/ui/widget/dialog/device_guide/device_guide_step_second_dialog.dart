import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/home/home_guide_manager.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class DeviceGuideStepSecondDialog extends BaseDeviceGuideDialog {
  Offset offset;
  Size size;
  String headerControlBtnImgRes;

  DeviceGuideStepSecondDialog(
      {required this.offset,
      required this.size,
      required super.provideTitleDescOrders,
      required super.provideImageRes,
      required super.lastStep,
      required super.rtl,
      required this.headerControlBtnImgRes,
      super.skipCallback,
      super.finishCallback,
      super.nextStepCallback});

  @override
  ThemeWidget buildBody() {
    double arrowLeft = offset.dx + size.width / 2 - 15;
    return ThemeWidget(builder: (context, style, resource) {
      Posi posi = rtl! ? Posi.right : Posi.left;
      return Stack(
        children: [
          Positioned(
            left: offset.dx,
            top: offset.dy - size.height,
            child: buildHeader(),
          ),
          Positioned(
            left: arrowLeft,
            top: offset.dy + 20,
            child: Image.asset(
              resource.getResource('ic_home_step_arrow'),
              width: 30,
              height: 21,
              color: style.bgWhite,
            ).withDynamic(),
          ),
          buildPositionContent(posi, context, style: style, resource: resource),
        ],
      );
    });
  }

  Widget buildHeader() {
    return ThemeWidget(builder: (context, style, resource) {
      return Image.asset(resource.getResource(headerControlBtnImgRes),
              width: 64, height: 64)
          .withDynamic();
    });
  }

  Widget buildPositionContent(Posi posi, BuildContext context,
      {required StyleModel style, required ResourceModel resource}) {
    return posi == Posi.left
        ? Positioned(
            left: 36,
            top: offset.dy + 21,
            child: buildContent(context, style: style, resource: resource),
          )
        : Positioned(
            right: 24,
            top: offset.dy + 21,
            child: buildContent(context, style: style, resource: resource),
          );
  }
}
