import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class DeviceGuideStepFourDialog extends BaseDeviceGuideDialog {
  Offset offset;

  DeviceGuideStepFourDialog(
      {required this.offset,
      required super.provideTitleDescOrders,
      required super.provideImageRes,
      required super.lastStep,
      required super.rtl,
      super.finishCallback});

  @override
  ThemeWidget buildBody() {
    return ThemeWidget(builder: (context, style, resource) {
      return Stack(
          children: rtl!
              ? [
                  Positioned(
                      top: offset.dy - 44,
                      left: 0,
                      child: Container(
                        height: 44,
                        width: 64,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: rtl!
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12))
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12))),
                        child: Center(
                          child: Image.asset(
                                  width: 30,
                                  height: 24,
                                  resource.getResource('ic_home_fast_cmd'))
                              .withDynamic(),
                        ),
                      )),
                  Positioned(
                    left: 64,
                    top: offset.dy - 30,
                    child: Image.asset(
                            resource.getResource('ic_home_step_arrow_right'),
                            width: 30,
                            height: 21,
                            color: style.bgWhite)
                        .withDynamic()
                        .flipWithRTL(context),
                  ),
                  Positioned(
                      left: 80,
                      top: offset.dy - 100,
                      child: _buildContent(context,
                          style: style, resource: resource))
                ]
              : [
                  Positioned(
                      top: offset.dy - 44,
                      right: 0,
                      child: Container(
                        height: 44,
                        width: 64,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: rtl!
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12))
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12))),
                        child: Center(
                          child: Image.asset(
                                  width: 30,
                                  height: 24,
                                  resource.getResource('ic_home_fast_cmd'))
                              .withDynamic(),
                        ),
                      )),
                  Positioned(
                    right: 64,
                    top: offset.dy - 30,
                    child: Image.asset(
                      resource.getResource('ic_home_step_arrow_right'),
                      width: 30,
                      height: 21,
                      color: style.bgWhite,
                    ).withDynamic(),
                  ),
                  Positioned(
                      right: 80,
                      top: offset.dy - 100,
                      child: _buildContent(context,
                          style: style, resource: resource))
                ]);
    });
  }

  Widget _buildContent(BuildContext context,
      {required StyleModel style, required ResourceModel resource}) {
    double maxWidth = MediaQuery.of(context).size.width - 100;
    if (maxWidth > 270) {
      maxWidth = 270;
    }
    return super.buildContent(context,
        style: style, resource: resource, maxWidth: maxWidth);
  }
}
