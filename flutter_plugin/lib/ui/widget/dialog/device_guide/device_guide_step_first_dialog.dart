import 'package:flutter/cupertino.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class DeviceGuideStepFirstDialog extends BaseDeviceGuideDialog {
  Offset titleOffset;

  DeviceGuideStepFirstDialog(
      {required super.provideImageRes,
      required super.lastStep,
      required super.rtl,
      super.nextStepCallback,
      super.skipCallback,
      super.finishCallback,
      required this.titleOffset,
      required super.provideTitleDescOrders});

  @override
  ThemeWidget buildBody() {
    var titleTop = titleOffset.dy + 25;
    return ThemeWidget(builder: (context, style, resource) {
      return Stack(
        children: rtl!
            ? [
                Positioned(
                  top: titleOffset.dy - 8,
                  left: 12,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: style.bgWhite),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          resource.getResource('ic_home_more'),
                          width: 24,
                          height: 24,
                        ).withDynamic()
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 21,
                  top: titleTop + 20,
                  child: Image.asset(
                    resource.getResource('ic_home_step_arrow'),
                    width: 30,
                    height: 21,
                    color: style.bgWhite,
                  ).withDynamic(),
                ),
                Positioned(
                    left: 20,
                    top: titleTop + 21,
                    child:
                        buildContent(context, style: style, resource: resource))
              ]
            : [
                Positioned(
                  top: titleOffset.dy - 8,
                  right: 12,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: style.bgWhite),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          resource.getResource('ic_home_more'),
                          width: 24,
                          height: 24,
                        ).withDynamic()
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 21,
                  top: titleTop + 20,
                  child: Image.asset(
                    resource.getResource('ic_home_step_arrow'),
                    width: 30,
                    height: 21,
                    color: style.bgWhite,
                  ).withDynamic(),
                ),
                Positioned(
                    right: 20,
                    top: titleTop + 21,
                    child:
                        buildContent(context, style: style, resource: resource))
              ],
      );
    });
  }
}
