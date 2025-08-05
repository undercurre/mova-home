import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/manual/product_manual_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/manual_viewer/product_manual_viewer_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../utils/LogUtils.dart';

// ignore: must_be_immutable
class ProductManualViewerPage extends BasePage {
  static const String routePath = '/product_manual_viewer_page';
  HelpCenterProduct product;
  ProductManualViewerPage({super.key, required this.product});

  // 'Toast_3rdPartyBundle_Unbundle'.tr(args: [platform])

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductManualViewerPage();
  }
}

class _ProductManualViewerPage extends BasePageState<ProductManualViewerPage> {
  @override
  String get centerTitle =>
      'UserManualPage_page_title'.tr(args: [widget.product.displayName ?? '']);

  GlobalKey _qrCodeGlobalKey = GlobalKey(debugLabel: 'qrCodeGlobalKey');

  @override
  Widget get rightItemWidget => Visibility(
      visible: ref
              .watch(productManualViewerStateNotifierProvider
                  .select((value) => (value.pdfUrl ?? '')))
              .isNotEmpty &&
          ref.watch(productManualViewerStateNotifierProvider
                  .select((value) => (value.requestFaild))) ==
              false,
      child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Image.asset(
                  width: 20,
                  height: 20,
                  ref
                      .read(resourceModelProvider)
                      .getResource('share_user_manual')))
          .onClick(() async {
        // 下载说明书
        Widget contentWidget = Center(
          child: RepaintBoundary(
            key: _qrCodeGlobalKey,
            child: QrImageView(
              backgroundColor: Colors.white,
              data: ref.watch(productManualStateNotifierProvider
                  .select((value) => value.pdfUrl)),
              version: QrVersions.auto,
            ),
          ),
        );
        showCustomCommonDialog(
            topWidget: contentWidget,
            tag: 'qrCode',
            title: 'e_introduce_qr_share_code'.tr(),
            cancelContent: 'cancel'.tr(),
            confirmContent: 'save_image'.tr(),
            confirmPreDismissCallback: (dismiss) async {
              final image = await _getQrCodeImage();
              dismiss();
              await _saveQrCode(image);
            },
            confirmCallback: () {});
      }));

  @override
  void initData() {
    ref
        .read(productManualViewerStateNotifierProvider.notifier)
        .loadData(widget.product);
  }

  Future<ui.Image> _getQrCodeImage() async {
    // 加载图片
    RenderRepaintBoundary boundary = _qrCodeGlobalKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    return image;
  }

  Future<void> _saveQrCode(ui.Image image) async {
    try {
      // 请求存储权限
      var isGranted = await _requestPermission();
      if (isGranted) {
        // 保存图片到相册
        ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();
        final result = await ImageGallerySaver.saveImage(pngBytes);
        if (result['isSuccess']) {
          ref
              .read(productManualStateNotifierProvider.notifier)
              .showToast('operate_success'.tr());
        } else {
          ref
              .read(productManualStateNotifierProvider.notifier)
              .showToast('operate_failed'.tr());
        }
      } else {
        LogUtils.d('Permission denied');
      }
    } catch (e) {
      LogUtils.e('Error saving QR code: $e');
    }
  }

  Future<bool> _requestPermission() async {
    var status = await Permission.storage.status;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 28) {
        // Android 10以下需要权限
        status = await Permission.storage.request();
      } else {
        status = PermissionStatus.granted;
      }
    } else {
      status = await Permission.storage.request();
    }
    return status.isGranted;
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
                      backgroundColor: style.textMainBlack,
                      valueColor: AlwaysStoppedAnimation(style.normal),
                    ),
                  if (!isProcessing)
                    Image(
                      image: AssetImage(
                        resource.getResource('ic_pdf_down_error'),
                      ),
                      color: style.textMainBlack,
                      width: 60,
                      height: 60,
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                        isProcessing
                            ? 'UserManualPage_Status_loading'.tr()
                            : 'UserManualPage_Status_loadingException'.tr(),
                        style: TextStyle(
                          color: style.textMainBlack,
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
                textColor: style.enableBtnTextColor,
                backgroundGradient: style.confirmBtnGradient,
                disableBackgroundGradient: style.disableBtnGradient,
                disableTextColor: style.disableBtnTextColor,
                borderRadius: style.buttonBorder,
                text: 'UserManualPage_Status_loadingbutton'.tr(),
                height: 42,
                onClickCallback: () async {
                  await ref
                      .read(productManualViewerStateNotifierProvider.notifier)
                      .retry();
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
    return ref.watch(productManualViewerStateNotifierProvider
            .select((value) => (value.requestFaild)))
        ? buildLoadingView(-1)
        : ref
                .watch(productManualViewerStateNotifierProvider
                    .select((value) => (value.pdfUrl ?? '')))
                .isEmpty
            ? buildLoadingView(0)
            : PDF(
                autoSpacing: Platform.isIOS /*Android 用 false ios 用true*/,
                fitPolicy: FitPolicy.BOTH,
                fitEachPage: false,
                pageFling: false,
              ).cachedFromUrl(
                ref.watch(productManualViewerStateNotifierProvider
                    .select((value) => value.pdfUrl ?? '')),
                placeholder: (progress) => buildLoadingView(progress),
                errorWidget: (error) => buildLoadingView(-1),
              );
  }
}
