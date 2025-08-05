import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/manual_viewer/pdf/pdf_state.dart';
import 'package:flutter_plugin/ui/page/help_center/manual_viewer/pdf/pdf_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/manual_viewer/product_manual_viewer_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class PdfViewerPage extends BasePage {
  static const String routePath = '/pdf_viewer_page';
  String title;
  String url;

  PdfViewerPage({super.key, required this.title, required this.url});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PdfViewerPage();
  }
}

class _PdfViewerPage extends BasePageState<PdfViewerPage> {
  @override
  String get centerTitle => widget.title;

  @override
  void initData() {
  }

  Widget buildLoadingView(double processing) {
    bool isProcessing = processing >= 0;
    return ThemeWidget(builder: (_, style, resource) {
      return Container(
        padding: const EdgeInsets.only(left: 24, right: 24),
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isProcessing)
                    LinearProgressIndicator(
                      value: processing,
                      minHeight: 4,
                      backgroundColor: const Color(0xffEDEDED),
                      valueColor: AlwaysStoppedAnimation(style.normal),
                    ),
                  if (!isProcessing)
                    Image(
                      image: AssetImage(
                        resource.getResource('ic_pdf_down_error'),
                      ),
                      width: 60,
                      height: 60,
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                        isProcessing
                            ? 'UserManualPage_Status_loading'.tr()
                            : 'UserManualPage_Status_loadingException'.tr(),
                        style: const TextStyle(
                          color: Color(0x73000000),
                          fontSize: 16,
                        )),
                  ),
                ],
              ),
            ),
            if (!isProcessing)
              DMCommonClickButton(
                margin: const EdgeInsets.only(bottom: 54),
                enable: true,
                backgroundGradient: style.confirmBtnGradient,
                disableBackgroundGradient: style.disableBtnGradient,
                textColor: style.confirmBtnTextColor,
                disableTextColor: style.disableBtnTextColor,
                borderRadius: style.buttonBorder,
                text: 'UserManualPage_Status_loadingbutton'.tr(),
                height: 42,
                onClickCallback: () async {
                  await ref.read(pdfStateNotifierProvider.notifier).retry();
                },
              )
          ],
        ),
      );
    });
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    int count = ref
        .watch(pdfStateNotifierProvider.select((value) => value.refreshCount));
    return KeyedSubtree(
        key: ValueKey(count),
        child: PDF(
          autoSpacing: Platform.isIOS /*Android 用 false ios 用true*/,
          fitPolicy: FitPolicy.BOTH,
          fitEachPage: false,
          pageFling: false,
        ).cachedFromUrl(
          widget.url,
          placeholder: (progress) => buildLoadingView(progress),
          errorWidget: (error) => buildLoadingView(-1),
        ));
  }
}
