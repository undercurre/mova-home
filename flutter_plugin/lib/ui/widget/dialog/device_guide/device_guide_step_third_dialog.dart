import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/home/home_guide_manager.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/device_guide_step_second_dialog.dart';

class DeviceGuideStepThirdDialog extends DeviceGuideStepSecondDialog {
  DeviceGuideStepThirdDialog(
      {required super.offset,
      required super.size,
      required super.provideTitleDescOrders,
      required super.provideImageRes,
      required super.lastStep,
      required super.rtl,
      required super.headerControlBtnImgRes,
      super.skipCallback,
      super.finishCallback,
      super.nextStepCallback});

  @override
  Widget buildPositionContent(Posi posi, view_direction.BuildContext context,
      {required StyleModel style, required ResourceModel resource}) {
    return posi == Posi.left
        ? Positioned(
            right: 24,
            top: offset.dy + 21,
            child: buildContent(context, style: style, resource: resource),
          )
        : Positioned(
            left: 36,
            top: offset.dy + 21,
            child: buildContent(context, style: style, resource: resource),
          );
  }
}
