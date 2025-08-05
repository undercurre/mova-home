import 'package:easy_localization/easy_localization.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/theme/app_theme_manager.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_ble_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_bt_wifi_state_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_device_cache_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_device_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_permission_request_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_step_list.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_wifi_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/product_list/product_list_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/non_iot_util.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/qr_scan_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/qr_scan_ui_state.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/pair/qr_scanner_overlay_shape.dart';
import 'package:flutter_plugin/ui/widget/pair/scanned_device_item.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:go_router/go_router.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/theme/app_theme_notifier.dart';

class QrScanPage extends BasePage {
  static const String routePath = '/qr_scan';

  const QrScanPage({super.key});

  @override
  QrScanPageState createState() {
    return QrScanPageState();
  }
}

class QrScanPageState extends BasePageState
    with
        ResponseForeUiEvent,
        IotScanPermissionRequestMixin,
        IotScanDeviceCacheMixin,
        IotBtWifiStateMixin,
        IotBleScannerMixin,
        IotWiFiScannerMixin,
        IotScanDeviceMixin {
  late MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    returnImage: true,
    autoStart: false,
    facing: CameraFacing.back,
    formats: [BarcodeFormat.qrCode],
    cameraResolution: const Size(720, 1280),
    useNewCameraSelector: true,
  );

  /// 是否支持补光灯
  bool? isSupportTorchFeature = null;

  List<Barcode> validBarcodes = [];
  BarcodeCapture? capture;
  MobileScannerArguments? arguments;
  var isFinish = false;
  var isInVisible = false;

  @override
  CommonStepChain initStepChain() {
    return IotScanStepList.initQrCodeScanStepChain();
  }

  @override
  void onAppResumeAndActive() {}

  Future<void> onDetect(BarcodeCapture captureItem) async {
    LogUtils.d(
        'sunzhibin zzb - onDetect ${captureItem.barcodes.map((e) => e.rawValue)}');
    if (isFinish) {
      return;
    }
    isFinish = true;
    setState(() {
      capture = captureItem;
    });
    if (!ref
        .read(qrScanStateNotifierProvider.notifier)
        .isDreamePairQrCode(captureItem.barcodes)) {
      return;
    }
    // 识别到有效二维码
    if (ref.read(qrScanStateNotifierProvider).dreameBarcode.length == 1) {
      try {
        await controller.stop();
      } catch (e) {
        LogUtils.e('sunzhibin -- onDetect stop error: $e');
      }
      Barcode barcode = ref.read(qrScanStateNotifierProvider).dreameBarcode[0];
      await toPairingWithBarcode(barcode.rawValue);
    }
  }

  @override
  void addObserver() {
    ref.listen(qrScanStateNotifierProvider.select((value) => value.loading),
        (previous, next) {
      next ? showLoading() : dismissLoading();
    });
    ref.listen(
        qrScanStateNotifierProvider.select(
          (value) => value.event,
        ), (previous, next) {
      if (previous != next) {
        responseFor(next);
        Future.delayed(const Duration(milliseconds: 1500), () {
          setState(() => capture = null);
          isFinish = false;
          if (!isInVisible) {
            controller.start();
          }
        });
      }
    });
  }

  @override
  String get centerTitle => 'scan_add'.tr();

  @override
  Color get navBackgroundColor => Colors.transparent;

  @override
  ThemeStyle get navBarTheme => ThemeStyle.dark;

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: centerTitle,
      backHidden: false,
      theme: ThemeStyle.dark,
      bgColor: Colors.transparent,
      titleColor: style.lightDartWhite,
      leftBackResource: resource.getResource('ic_nav_back_white'),
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          onTitleLeftClick();
        }
      },
    );
  }

  @override
  void initData() {
    super.initData();
    isSupportTorch();
    LogUtils.e('zzb --  > initData ');
    ref.read(qrScanStateNotifierProvider.notifier).initData();
    stepChainCheckPermission();
    ref.read(qrScanStateNotifierProvider.notifier).reportPushToPage();
  }

  /// 判断是否支持补光灯
  void isSupportTorch() async {
    // isSupportTorchFeature = await controller.isSupportTorch();
  }

  @override
  void updateScanDeviceList(List<IotDevice> allScanDeviceProducts) {
    if (mounted) {
      ref
          .read(qrScanStateNotifierProvider.notifier)
          .updataScanDeviceList(allScanDeviceProducts);
    }
  }

  @override
  void onPermissionSuccess(StepEvent event) async {
    super.onPermissionSuccess(event);
    final isGranted = await Permission.camera.isGranted;
    if (isGranted) {
      final args = await controller.start();
      if (args != null) {
        arguments = args;
      }
    }
  }

  @override
  void onPermissionFail(StepId stepId) async {
    super.onPermissionFail(stepId);
    final isGranted = await Permission.camera.isGranted;
    if (isGranted) {
      final args = await controller.start();
      if (args != null) {
        arguments = args;
      }
    }
  }

  @override
  Future<void> onLifecycleEvent(LifecycleEvent event) async {
    super.onLifecycleEvent(event);
    final isGranted = await Permission.camera.isGranted;
    if (event == LifecycleEvent.active) {
      AppThemeManager().updateAppThemeMode(ThemeMode.dark);
      if (isGranted) {
        final args = await controller.start();
        if (args != null) {
          arguments = args;
        }
        if (capture != null) {
          setState(() {
            capture = null;
          });
          isFinish = false;
        }
      }
      await startScanDevice();
    } else if (event == LifecycleEvent.inactive) {
      if (ref.context.mounted) {
        final themeMode =
            await ref.read(appThemeStateNotifierProvider.notifier).loadTheme();
        AppThemeManager().updateAppThemeMode(themeMode);
      }
    } else if (event == LifecycleEvent.invisible) {
      if (isGranted) {
        try {
          LogUtils.d('sunzhibin -- stop onLifecycleEvent');
          await controller.stop();
        } catch (e) {
          LogUtils.e('sunzhibin -- onDetect stop error: $e');
        }
      }
      await stopScanDevice();
      // 如果是亮色主题,则设置
    } else if (event == LifecycleEvent.visible) {
      isInVisible = false;
    }
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    final iotDevice = ref.watch(qrScanStateNotifierProvider
        .select((value) => value.scannedDevice.firstOrNull));

    final viewHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    const navBarHeight = 52;

    /// 包含按钮和 扫描到的设备
    final bottomHeight = 172;
    final textMaxHeight = 100;

    var scanWH = MediaQuery.of(context).size.width - 40;
    var mustBeHeight =
        bottomHeight + textMaxHeight + navBarHeight + statusBarHeight + 30;
    if (viewHeight > mustBeHeight + scanWH) {
      // 不变
    } else {
      scanWH = viewHeight - mustBeHeight;
    }
    var txtOffset = 10.toDouble();
    final top = viewHeight / 2 - scanWH / 2;
    var d = top - 100 - 10;

    if (d > 150) {
      txtOffset = 150;
    } else if (d < statusBarHeight + navBarHeight + 10) {
      txtOffset = statusBarHeight + navBarHeight + 5;
    } else {
      if (d - 13 < statusBarHeight + navBarHeight + 10) {
        txtOffset = d;
      } else {
        txtOffset = d - 13;
      }
    }
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: scanWH,
      height: scanWH,
    );

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            scanWindow: scanWindow,
            controller: controller,
            onScannerStarted: (arguments) {
              setState(() {
                this.arguments = arguments;
              });
            },
            onDetect: onDetect,
          ),
          Column(
            children: [
              Expanded(
                child: capture?.image != null
                    ? Image(
                        gaplessPlayback: true,
                        image: MemoryImage(capture!.image!),
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
            ],
          ),
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                  borderColor: Colors.white,
                  borderRadius: 8,
                  borderLength: 0,
                  borderWidth: 0,
                  cutOutSize: scanWH),
            ),
          ),
          Visibility(
            visible:
                ref.watch(qrScanStateNotifierProvider).dreameBarcode.length > 1,
            child: Column(
              children: [
                Expanded(child: LayoutBuilder(builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  double height = constraints.maxHeight;
                  return Stack(
                      children: drawBarcodeIndicator(
                          context, resource, width, height));
                })),
              ],
            ),
          ),
          // 文字
          Container(
            margin: EdgeInsets.only(top: txtOffset, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ref.watch(qrScanStateNotifierProvider
                          .select((value) => value.isOverSea))
                      ? 'scan_device_qr_code'.tr()
                      : 'scan_device_to_connect'.tr(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                GestureDetector(
                  onTap: () async {
                    isInVisible = true;
                    var lang = await LocalModule().getLangTag();
                    var webHost = await InfoModule().getWebUriHost();
                    final tenantId = await AccountModule().getTenantId();
                    await AppRoutes().push(
                      WebPage.routePath,
                      extra: WebViewRequest(
                          uri: WebUri(
                              '$webHost/ercode.html?lang=$lang&tenantId=$tenantId'),
                          defaultTitle: 'position_of_qr'.tr()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${'check_where_qr'.tr()}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: style.textBrand,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '>',
                          style: TextStyle(
                              color: style.textBrand,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isSupportTorchFeature != false,
            child: Positioned(
              left: (MediaQuery.of(context).size.width - 48) / 2,
              bottom: MediaQuery.of(context).size.height / 844 * 275,
              child: DMButton(
                onClickCallback: (context) {
                  controller.toggleTorch();
                },
                prefixWidget: ValueListenableBuilder<TorchState>(
                  valueListenable: controller.torchState,
                  builder: (context, state, child) {
                    return Image.asset(
                      resource.getResource(state == TorchState.on
                          ? 'ic_scan_torch_on'
                          : 'ic_scan_torch_off'),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 100,
            left: 0,
            right: 0,
            child: Visibility(
              visible: iotDevice != null,
              child: Center(
                child: iotDevice != null
                    ? ScannedDeviceItem(
                        iotDevice: iotDevice,
                        position: ItemPosition.qrScan,
                        onSelect: () {
                          ref
                              .watch(qrScanStateNotifierProvider.notifier)
                              .gotoNextPage(iotDevice, null,
                                  iotDevice.product ?? Product());
                        },
                      )
                    : Container(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DMButton(
                    onClickCallback: (context) {},
                    horizontal: false,
                    prefixWidget: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Image.asset(
                        resource.getResource('ic_scan_qrcode'),
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                    text: 'scan_add'.tr(),
                    textColor: style.textBrand,
                    fontsize: 12,
                    backgroundColor: Colors.transparent,
                  ),
                  DMButton(
                    onClickCallback: (context) {
                      var index = Navigator.of(context).widget.pages.indexWhere(
                          (element) =>
                              element.name == ProductListPage.routePath);
                      if (index == -1) {
                        GoRouter.of(context).push(ProductListPage.routePath);
                      } else {
                        GoRouter.of(context).pop();
                      }
                    },
                    horizontal: false,
                    prefixWidget: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Image.asset(
                        resource.getResource('ic_scan_manual'),
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                    text: 'qr_text_add_manually'.tr(),
                    textColor: Colors.white,
                    fontsize: 12,
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> toPairingWithBarcode(String? barcode) async {
    if (ref.read(
            qrScanStateNotifierProvider.select((value) => value.isOverSea)) &&
        NonIotUtil().hasH5Sign(barcode)) {
      LogUtils.i('zzb--- goToH5Page - $barcode');
      final themeMode = ref.read(appThemeStateNotifierProvider);
      await NonIotUtil().goToH5Page(barcode!, themeMode);
      return;
    }

    var product = await ref
        .read(qrScanStateNotifierProvider.notifier)
        .getIoTDeviceInfo(barcode);
    if (product != null) {
      LogUtils.i('zzb--- $product - $barcode');
      QrCodeContent content =
          ref.read(qrScanStateNotifierProvider.notifier).parseQrCode(barcode);
      var iotDevice = IotDevice.from2(null, content.ap, product);
      IotPairNetworkInfo().deviceSsid = content.ap ?? '';
      await ref
          .watch(qrScanStateNotifierProvider.notifier)
          .gotoNextPage(iotDevice, content.ap, product);
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    ref.read(qrScanStateNotifierProvider.notifier).reportPopToPage();
    try {
      LogUtils.d('sunzhibin -- stop deactivate');
      controller.stop();
    } catch (e) {
      LogUtils.e('sunzhibin -- deactivate error: $e');
    }
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    try {
      controller.dispose();
    } catch (e) {
      LogUtils.e('sunzhibin -- dispose error: $e');
    }
  }

  List<Widget> drawBarcodeIndicator(BuildContext context,
      ResourceModel resource, double width, double height) {
    if (capture == null || arguments == null) {
      return [];
    }
    var barcodes = ref.read(qrScanStateNotifierProvider).dreameBarcode;
    var argumentSize = arguments?.size ?? Size.zero;
    final size = MediaQuery.of(context).size;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    LogUtils.d(
        'sunzhibin - drawBarcodeIndicator size:$size ,devicePixelRatio:$devicePixelRatio');
    // source: 961.3, 1920.0 destination: 411.4, 821.7
    final adjustedSize = applyBoxFit(BoxFit.cover, argumentSize, size);
    // 这是目标大小 和 屏幕实际大小 offset
    var adjustedWidth = adjustedSize.destination.width;
    var adjustedheight = adjustedSize.destination.height;
    adjustedWidth = width;
    adjustedheight = height;
    double verticalPadding = size.height - adjustedheight;
    double horizontalPadding = size.width - adjustedWidth;
    var imageWidth = arguments?.size.width ?? 0;
    var imageHeight = arguments?.size.height ?? 0;

    ///缩放比例
    final viewAspectRatio = adjustedWidth / adjustedheight;
    final imageAspectRatio = imageWidth / imageHeight;
    var scaleFactor = 0.0;
    var postScaleHeightOffset = 0.0;
    var postScaleWidthOffset = 0.0;
    // viewAspectRatio ～ 0.75 imageAspectRatio ～ 0.5
    if (viewAspectRatio > imageAspectRatio) {
      // The image needs to be vertically cropped to be displayed in this view.
      scaleFactor = adjustedWidth.toDouble() / imageWidth.toDouble();
      postScaleHeightOffset =
          (imageHeight.toDouble() * scaleFactor - adjustedheight) / 2;
    } else {
      // 缩放比例 ～ 0.42796875
      // The image needs to be horizontally cropped to be displayed in this view.
      scaleFactor = adjustedheight.toDouble() / imageHeight.toDouble();
      postScaleWidthOffset =
          (adjustedheight.toDouble() * imageAspectRatio - adjustedWidth) / 2;
    }
    List<Offset> spriteOffsets = [];
    for (Barcode item in barcodes) {
      List<Offset> adjustedCorners = [];
      for (var offset in item.corners) {
        final x =
            offset.dx * scaleFactor - postScaleWidthOffset + horizontalPadding;
        final y =
            offset.dy * scaleFactor - postScaleHeightOffset + verticalPadding;
        adjustedCorners.add(Offset(x, y));
      }
      var centerX = adjustedCorners[0].dx +
          (adjustedCorners[2].dx - adjustedCorners[0].dx) / 2;
      var centerY = adjustedCorners[0].dy +
          (adjustedCorners[2].dy - adjustedCorners[0].dy) / 2;
      var tOffset = Offset(centerX, centerY);
      spriteOffsets.add(tOffset);
    }
    return spriteOffsets.asMap().entries.map((entry) {
      int index = entry.key;
      Offset e = entry.value;
      return Positioned(
        top: e.dy - 20,
        left: e.dx - 20,
        child: DMButton(
          onClickCallback: (context) async {
            var barString = barcodes[index]?.rawValue;
            await toPairingWithBarcode(barString);
          },
          prefixWidget: Image.asset(
            resource.getResource('ic_qr_scan_indicator'),
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
          backgroundColor: Colors.transparent,
        ),
      );
    }).toList();
  }
}
