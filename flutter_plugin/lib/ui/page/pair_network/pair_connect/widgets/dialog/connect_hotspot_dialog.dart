import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';

import 'package:lottie/lottie.dart';

class ConnectHotspotDialog extends StatelessWidget {
  final String? ssid;
  final String animPath;

  const ConnectHotspotDialog({this.ssid, required this.animPath, super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 35 * 2;
    final lottieKey = ValueKey(MediaQuery.of(context).platformBrightness);
    return ThemeWidget(builder: (context, style, resource) {
    return Container(
        width: width,
        height: width / 320 * 372,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: style.bgWhite,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'text_connect_robot_hotspot'.tr(args: [ssid ?? '']),
                style: TextStyle(
                  fontSize: 16,
                  color: style.textMain,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(style.cellBorder),
                child: Lottie.asset(
                  key: lottieKey,
                  animPath,
                  fit: BoxFit.cover,
                  width: width - 48,
                  height: width / 272 * 186,
                  onLoaded: (composition) {},
                ),
              ),
              DMButton(
                onClickCallback: (context) {
                  SmartDialog.dismiss();
                },
                textColor: style.enableBtnTextColor,
                backgroundGradient: style.confirmBtnGradient,
                borderRadius: style.buttonBorder,
                width: width - 48,
                height: 48,
                text: 'know'.tr(),
                fontWidget: FontWeight.w700,
              ),
            ],
          ),
        ),
      );
    });
  }
}
