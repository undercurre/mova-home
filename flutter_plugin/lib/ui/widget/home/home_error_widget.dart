import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class HomeErrorWidget extends StatelessWidget {
  final VoidCallback? retryCallback;
  const HomeErrorWidget({super.key, this.retryCallback});

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return Expanded(
          flex: 1,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  width: 264,
                  height: 264,
                  image: AssetImage(resource.getResource('ic_home_error_new')),
                ).withDynamic(),
                Padding(
                  padding: const EdgeInsets.only(top: 0).withRTL(context),
                  child: Text(
                    'UserManualPage_Status_loadingException'.tr(),
                    style: TextStyle(fontSize: 14, color: style.textSecond),
                  ),
                ),
                DMButton(
                  backgroundColor: Colors.transparent,
                  margin: const EdgeInsets.only(top: 50).withRTL(context),
                  text: 'UserManualPage_Status_loadingbutton'.tr(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 44, vertical: 10),
                  backgroundGradient: style.cancelBtnGradient,
                  textColor: style.lightDartBlack,
                  borderRadius: style.buttonBorder,
                  onClickCallback: (_) => retryCallback?.call(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
