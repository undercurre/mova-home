import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_permission_request_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_camera_permission_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/qrscan/qr_scan_bussiness_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/pair/qr_scanner_overlay_shape.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

/// 扫码业务组件
/// 目前用到产品注册，目的是区分配网扫码页面复杂业务
class QRScanBusinessPage extends BasePage {
  static const String routePath = '/qr_scan_business';

  const QRScanBusinessPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _QRScanBusinessPage();
  }
}

class _QRScanBusinessPage extends BasePageState
    with ResponseForeUiEvent, IotScanPermissionRequestMixin {
  late MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    returnImage: true,
    autoStart: false,
    facing: CameraFacing.back,
    formats: [BarcodeFormat.code128],
    cameraResolution: const Size(720, 1280),
    useNewCameraSelector: true,
  );

  /// 是否支持补光灯
  bool? isSupportTorchFeature = null;

  BarcodeCapture? capture;
  MobileScannerArguments? arguments;
  var isFinish = false;

  @override
  CommonStepChain initStepChain() {
    return CommonStepChain()
      ..configureStepChain([StepCameraPermissionRequestDialog()]);
  }

  Future<void> onDetect(BarcodeCapture captureItem) async {
    LogUtils.i(
        'sunzhibin - onDetect ${captureItem.barcodes.map((e) => e.rawValue)}');
    if (isFinish) {
      return;
    }
    isFinish = true;
    setState(() {
      capture = captureItem;
    });
  }

  @override
  void addObserver() {
    ref.listen(
        qrScanBussinessStateNotifierProvider.select((value) => value.loading),
        (previous, next) {
      next ? showLoading() : dismissLoading();
    });
    ref.listen(
        qrScanBussinessStateNotifierProvider.select(
          (value) => value.event,
        ), (previous, next) {
      if (previous != next) {
        responseFor(next);
        Future.delayed(const Duration(milliseconds: 1500), () {
          setState(() => capture = null);
          isFinish = false;
          controller.start();
        });
      }
    });
  }

  @override
  String get centerTitle => 'scan_sn_code'.tr();

  @override
  Color get navBackgroundColor => Colors.transparent;

  @override
  ThemeStyle get navBarTheme => ThemeStyle.light;

  @override
  void initData() {
    super.initData();
    isSupportTorch();
    ref.read(qrScanBussinessStateNotifierProvider.notifier).initData();
    stepChainCheckPermission();
  }

  /// 判断是否支持补光灯
  void isSupportTorch() async {
    isSupportTorchFeature = await controller.isSupportTorch();
  }

  @override
  Future<void> onLifecycleEvent(LifecycleEvent event) async {
    super.onLifecycleEvent(event);
    final isGranted = await Permission.camera.isGranted;
    if (event == LifecycleEvent.active) {
      if (isGranted) {
        arguments = await controller.start();
        if (capture != null) {
          setState(() {
            capture = null;
          });
          isFinish = false;
        }
      }
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else if (event == LifecycleEvent.invisible) {
      if (isGranted) {
        try {
          await controller.stop();
        } catch (e) {
          LogUtils.e('sunzhibin -- onDetect stop error: $e');
        }
      }
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      ref.read(qrScanBussinessStateNotifierProvider.notifier).reportPopToPage();
    } else if (event == LifecycleEvent.visible) {
      ref
          .read(qrScanBussinessStateNotifierProvider.notifier)
          .reportPushToPage();
    }
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    final viewHeight = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final navBarHeight = 52;

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
                  borderRadius: style.circular8,
                  borderLength: 0,
                  borderWidth: 0,
                  cutOutSize: scanWH),
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
        ],
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    try {
      controller.stop();
    } catch (e) {
      LogUtils.e('sunzhibin -- deactivate error: $e');
    }
  }

  @override
  Future<void> dispose() async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
    try {
      controller.dispose();
    } catch (e) {
      LogUtils.e('sunzhibin -- dispose error: $e');
    }
  }
}
