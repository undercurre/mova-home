import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/foldable_screen_utils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class HomeEmptyWidget extends ConsumerWidget {
  final VoidCallback? scanCallback;
  final VoidCallback? addCallback;
  final bool isSecondPage;

  const HomeEmptyWidget({super.key, this.scanCallback, this.addCallback, this.isSecondPage = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return Stack(
          children: [
            _bottomWidget(context, style, resource),
            _topWidget(context, style, resource)
          ],
        );
      },
    );
  }

  Widget _topWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Container(
          color: Colors.transparent,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: DMButton(
            onClickCallback: (_) => scanCallback?.call(),
            borderRadius: style.buttonBorder,
            height: 48,
            width: double.infinity,
            backgroundGradient: style.confirmBtnGradient,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            surffixWidget: Flexible(
              child: Padding(
                  padding: const EdgeInsets.only(left: 5).withRTL(context),
                  child: Text(
                    'scan_qrcode_connect'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: style.btnText,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            prefixWidget: Image(
              width: 20,
              height: 20,
              color: style.btnText,
              image: AssetImage(resource.getResource('ic_home_empty_scan')),
            ).withDynamic(),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: DMButton(
            onClickCallback: (_) => addCallback?.call(),
            borderRadius: style.buttonBorder,
            height: 48,
            width: double.infinity,
            backgroundColor: style.lightDartWhite,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            surffixWidget: Padding(
                padding: const EdgeInsets.only(left: 5).withRTL(context),
                child: Text(
                  'qr_text_add_manually'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      color: style.lightDartBlack,
                      fontWeight: FontWeight.bold),
                )),
            prefixWidget: Image(
              width: 20,
              height: 20,
              color: style.lightDartBlack,
              image: AssetImage(resource.getResource('ic_home_empty_add')),
            ).withDynamic(),
          ),
        ),
        Container(
          height: isSecondPage ? 120 : 40,
        ),
      ],
    );
  }

  Widget _bottomWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    var path = resource.getResource('add_device_bg', suffix: '.json');
    // 390 * 840
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (FoldableScreenUtils().isFoldScreenHorizontalExpansion(context)) {
      width = height * 390 / 804;
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: width),
        child: LayoutBuilder(builder: (context, constraint) {
          return Lottie.asset(
            path,
            repeat: true,
            fit: BoxFit.fitWidth,
            width: constraint.maxWidth,
            height: constraint.maxHeight,
          );
        }),
      ),
    );
  }
}
