import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/mixin/pair_net_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_network_repository.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/qr_scan_ui_state.dart';
import 'package:flutter_plugin/utils/region_utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'non_iot_util.dart';

part 'qr_scan_state_notifier.g.dart';

@riverpod
class QrScanStateNotifier extends _$QrScanStateNotifier with PairNetMixin {
  late IotPairNetworkInfo pairEntry;

  @override
  QrScanUiState build() {
    return QrScanUiState();
  }

  Future<void> initData() async {
    pairEntry = IotPairNetworkInfo()..enterPairNet();

    final isRegionCn = await RegionUtils.isRegionCn();
    state = state.copyWith(isOverSea: !isRegionCn);
  }

  /// 跳转到下一页，开始配网
  /// iotDevice !=null,表示是附近扫描的设备
  /// ap !=null,表示是扫码的设备
  Future<void> gotoNextPage(
      IotDevice? iotDevice, String? ap, Product product) async {
    pairEntry.product = product;
    pairEntry.pairEntrance =
        ap == null ? IotPairEntrance.nearby : IotPairEntrance.qr;
    pairEntry.selectIotDevice = iotDevice;
    pairEntry.deviceSsid = iotDevice?.wifiSsid ?? ap;
    // 配网来源埋点
    LogModule().eventReport(15, 1, int1: pairEntry.pairEntrance.code - 1);

    await gotoPairNet(product, () {
      updateEvent(const LoadingEvent(isLoading: true));
    }, () {
      updateEvent(const LoadingEvent(isLoading: false));
    });
  }

  Future<Product?> getIoTDeviceInfo(String? qrMessage) async {
    updateEvent(const LoadingEvent(isLoading: true));
    QrCodeContent content = parseQrCode(qrMessage);
    if (content.model.isEmpty) {
      // Toast: 当前二维码无设备信息，请手动添加设备
      updateEvent(const LoadingEvent(isLoading: false));
      updateEvent(ToastEvent(text: 'current_device_nuInfo'.tr()));
      return null;
    }
    try {
      Product product = await ref
          .read(pairNetworkRepositoryProvider)
          .checkModel(content.model);
      return Future.value(product);
    } on DreameAuthException catch (e) {
      var code = e.code;
      updateEvent(const LoadingEvent(isLoading: false));
      switch (code) {
        case 50501:
          // 设备未上线
          updateEvent(ToastEvent(text: 'product_not_online'.tr()));
          break;
        case 50502:
          // 地区不匹配
          updateEvent(ToastEvent(text: 'product_not_support'.tr()));
          break;
        case 50503:
          // 产品未添加至分类
          updateEvent(ToastEvent(text: 'product_not_classified'.tr()));
          break;
        default:
          // 网络异常
          updateEvent(ToastEvent(text: 'no_net_check_state'.tr()));
      }
    }
    return null;
  }

  void updataScanDeviceList(List<IotDevice> scanList) {
    state = state.copyWith(scannedDevice: scanList);
  }

  bool isDreamePairQrCode(List<Barcode>? barcodes) {
    if (barcodes == null || barcodes.isEmpty) {
      return false;
    }
    List<Barcode> dreameBarcodes = [];
    for (var barcode in barcodes) {
      if ((barcode.rawValue?.contains('app.dreame.tech') ?? false) ||
          (barcode.rawValue?.contains('app.mova-tech.com') ?? false) ||
          (state.isOverSea && NonIotUtil().hasH5Sign(barcode.rawValue)) ||
          (barcode.rawValue?.contains('app.trouver-tech') ?? false)) {
        dreameBarcodes.add(barcode);
      }
    }
    if (dreameBarcodes.isEmpty) {
      updateEvent(ToastEvent(text: 'qr_recognize_error'.tr()));
    }
    state = state.copyWith(dreameBarcode: dreameBarcodes);
    return dreameBarcodes.isNotEmpty;
  }

  QrCodeContent parseQrCode(String? qrString) {
    if (qrString == null) {
      return QrCodeContent();
    }
    var trimmedStr = qrString.trim().replaceAll(' ', '');
    Uri uri = Uri.parse(trimmedStr);
    final queryParameters = uri.queryParameters;
    final model = queryParameters['model'];
    var mac = queryParameters['m'] ?? queryParameters['mac'];
    final sn = queryParameters['sn'];

    if (model == null || model.isEmpty) {
      return QrCodeContent();
    }

    var fixModel = model.replaceAll('-', '.');
    var wifiModel = fixModel.replaceAll('.', '-');
    var realMac = mac?.replaceAll(':', '') ?? '';
    if (realMac.length >= 4) {
      realMac = realMac.substring(realMac.length - 4);
    } else {
      realMac = '';
    }
    var ap = realMac.isNotEmpty ? '${wifiModel}_miap$realMac' : '';
    if (fixModel.endsWith('2257')) {
      fixModel = fixModel.replaceAll('2257', '2257o');
    }
    if (mac == null || mac.isEmpty) {
      return QrCodeContent(model: fixModel);
    }
    return QrCodeContent(model: fixModel, ap: ap);
  }

  void updateEvent(CommonUIEvent event) {
    if (event is LoadingEvent) {
      state = state.copyWith(loading: event.isLoading);
    } else {
      state = state.copyWith(event: event);
    }
  }

  void reportPushToPage() {
    LogModule().eventReport(15, 16,
        str1: pairEntry.sessionID ?? '', str2: 'QRScanPage');
  }

  void reportPopToPage() {
    var startTime = int.parse(pairEntry.sessionID ?? '');
    var endTime = DateTime.timestamp().millisecondsSinceEpoch;
    var takeTime = (endTime - startTime) ~/ 1000;
    LogModule().eventReport(15, 17,
        str1: pairEntry.sessionID ?? '', int1: takeTime, str2: 'QRScanPage');
  }
}
