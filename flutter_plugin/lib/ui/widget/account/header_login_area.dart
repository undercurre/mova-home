import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef AreaChangeCallback = void Function(int areaCode, String areaName);

class HeaderLoginArea extends ConsumerWidget implements PreferredSizeWidget {
  final String areaName;
  final int areaCode;
  final AreaChangeCallback callback;
  final double height;
  final Widget? leading;

  const HeaderLoginArea({
    super.key,
    required this.height,
    required this.areaCode,
    required this.areaName,
    required this.callback,
    this.leading = null,
  });

  void onPress() {
    LogUtils.d('-------- onPress -------');
    callback.call(this.areaCode, this.areaName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ThemeWidget(builder: (_, style, resource) {
      return SizedBox(
        height: 48,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              resource.getResource('icon_back_black'),
              width: 18,
              height: 18,
            ),
            const Spacer(
              flex: 1,
            ),
            GestureDetector(
              onTap: onPress,
              child: Row(
                children: [
                  Text(
                    areaName,
                    style: TextStyle(
                        color: style.btnText,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500),
                  ),
                  Image.asset(
                    resource.getResource('icon_arrow_right2'),
                    width: 7,
                    height: 13,
                  ).flipWithRTL(context)
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
