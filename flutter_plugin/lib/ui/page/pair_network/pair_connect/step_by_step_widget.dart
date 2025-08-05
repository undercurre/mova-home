import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/animated_rotation_box.dart';
import 'package:flutter_plugin/ui/widget/gradient_circular_progress_indicator.dart';

class StepByStepWidget extends StatelessWidget {
  /// 0: loading, 1: success, 2: failed
  final int status;
  final String text;

  StepByStepWidget({super.key, required this.text, required this.status});

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          status != 0
              ? Image.asset(
                  status == 1
                      ? resource.getResource('icon_step_success')
                      : resource.getResource('icon_step_failed'),
                  width: 20,
                  height: 20,
                )
              : AnimatedRotationBox(
                  child: Image.asset(
                  resource.getResource('icon_step_loading'),
                  width: 20,
                  height: 20,
                )),
          const SizedBox(
            width: 9,
          ),
          Flexible(
            child: Text(text,
                style: status == 0
                    ? style.disableStyle()
                    : status == 1
                        ? style.secondStyle()
                        : style.errorStyle()),
          )
        ],
      );
    });
  }
}
