import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/pair_connect_method.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import 'generate_session_id.dart';

/// 配网来源
enum IotPairEntrance {
  productList(1),
  nearby(2),
  qr(3);

  final int code;

  const IotPairEntrance(this.code);
}

enum IotScanType {
  WIFI('WIFI'),
  WIFI_BLE('WIFI_BLE'),
  BLE('BLE'),
  ;

  final String scanType;

  const IotScanType(this.scanType);
}

enum IotDeviceFeature {
  FORCE_BIND_WIFI('forceBindWifi') /*强制绑定Wi-Fi*/,
  VIDEO('video') /*声网视频*/,
  VIDEO_ALI('video_ali') /*阿里视频*/,
  VIDEO_TX('video_tx') /*腾讯视频*/,
  FAST_COMMAND('fastCommand') /*快捷指令*/,
  HOLD_SELFCLEAN_DRY('hold_selfClean_dry') /*洗地机-首页-自清洁-烘干*/,
  HOLD_SELFCLEAN_SELFCLEANDEEP(
      'hold_selfClean_selfCleanDeep') /*洗地机-首页-自清洁-深度自清洁*/,
  HIDE_DELETE('hideDelete') /*首页隐藏设备删除按钮*/,
  ;

  final String feature;

  const IotDeviceFeature(this.feature);
}

enum IotDeviceBindType {
  STRONG('strong'),
  WEAK('weak'),
  ;

  final String bindType;

  const IotDeviceBindType(this.bindType);
}

///
enum IotDeviceExtendScType {
  ENABLE_BC_PAIR('ENABLE_BC_PAIR') /*蓝牙重新配*/,
  DEVICE_SCAN_WIFI('DEVICE_SCAN_WIFI') /*机器扫Wi-Fi*/,
  QR_CODE('QR_CODE'),
  QR_CODE_V2('QR_CODE_V2'),
  PINCODE('PINCODE') /*二进制*/,
  NON_FORCE_WIFI('NON_FORCE_WIFI') /*二进制*/,
  BLOB('BLOB') /*二进制*/,
  GPS_LOCK('GPS_LOCK') /*二进制*/,

  ;

  final String extendSctype;

  const IotDeviceExtendScType(this.extendSctype);
}

/// 配网过程参数，管理类
class IotPairNetworkInfo {
  IotPairNetworkInfo._internal();

  factory IotPairNetworkInfo() => _instance;
  static final IotPairNetworkInfo _instance = IotPairNetworkInfo._internal();

  IotPairEntrance pairEntrance = IotPairEntrance.productList;

  Product? product;
  String? deviceSsid;
  bool? isAfterSale;

  /// 默认等于iotDevice，只有当用户手动选择设备时才会赋值
  IotDevice? selectIotDevice;

  String? routerWifiName;
  String? routerWifiPwd;

  String? regionUrl;
  String? pairQRKey;

  int totalStep = 0;
  int currentStep = 0;
  String? sessionID;

  String? uid;
  String? region;
  String? language;
  List<PairGuideModel> guideSteps = [];

  String? finalPairType;
  PairConnectMethod pairConnectMethod = PairConnectMethod.WIFI;

  Future<IotPairNetworkInfo> enterPairNet() async {
    _clearInfo();
    GenerateSessionID().generateSessionID();
    sessionID = GenerateSessionID().currentSessionID();
    uid = await AccountModule().getAuthBean().then((value) => value.uid ?? '');
    region = await LocalModule().serverSite();
    language = await LanguageModel().langTag ?? 'zh';
    return this;
  }

  void increaseStep() {
    if (currentStep == totalStep) {
      return;
    }
    currentStep = currentStep + 1;
  }

  void decreaseStep() {
    if (currentStep == 0) {
      return;
    }
    currentStep = currentStep - 1;
  }

  /// 计算针对于牙菌斑设备 - 配网引导的总步骤
  void calculateTotalStepForConnectMethod(PairConnectMethod pairConnectMethod) {
    if (pairConnectMethod == PairConnectMethod.WIFI){
      // wifi配网需要总步骤数是5步
      if(Platform.isIOS){
        totalStep = 5;
      }else {
        totalStep = 5;
      }
    }else {
      // hotspot配网需要总步骤数是6步
      totalStep = 6;
    }
  }

  void calculateTotalStep(List<PairGuideModel> guideSteps) {
    this.guideSteps = guideSteps;
    if (product == null) throw 'product is null';
    totalStep = 0;

    // 1. 配网方式 需要有Wi-Fi，则添加输入路由器Wi-Fi密码步骤
    if (product?.extendScType.contains(IotDeviceExtendScType.NON_FORCE_WIFI) ==
        true) {
      /// 跳过输入Wi-Fi设置，不加Wi-Fi的页面步骤
    } else {
      totalStep = totalStep + 1;
    }

    // 2、配网引导
    totalStep = totalStep + guideSteps.length;

    //3、 附近设备扫描页 或 二维码配网页, 配网码和配网方式都是同一步骤
    if (Platform.isIOS) {
      if (product?.scType == IotScanType.BLE.scanType ||
          product?.scType == IotScanType.WIFI_BLE.scanType) {
        /// 扫附近设备扫描页
        totalStep = totalStep + 1;
      } else if (product?.extendScType
              .contains(IotDeviceExtendScType.QR_CODE_V2.extendSctype) ==
          true) {
        /// 配网码配网
        totalStep = totalStep + 1;
      } else if (pairEntrance == IotPairEntrance.qr && 
       deviceSsid?.isNotEmpty == true) {
        // 如果是扫码,则需要加一个扫码引导步骤
        totalStep = totalStep + 1;
      }
    } else if (Platform.isAndroid) {
      totalStep = totalStep + 1;
    }

    /// 配网页
    totalStep = totalStep + 1;
  }

  /// 清理
  void exitPairNet() {
    GenerateSessionID().resetSessionID();
    _clearInfo();
  }

  Future<String?> getMqttDomainV2() async {
    try {
      final region = await LocalModule().serverSite();
      final domainRes =
          await processApiResponse(ApiClient().getMqttDomainV2(region, false));
      IotPairNetworkInfo().regionUrl = domainRes.regionUrl ?? '';
      return IotPairNetworkInfo().regionUrl;
    } catch (e) {
      LogUtils.e('getMqttDomainV2 error: $e');
    }
    return null;
  }

  void _clearInfo() {
    this.pairEntrance = IotPairEntrance.productList;
    this.deviceSsid = null;
    this.product = null;

    /// 默认等于iotDevice，只有当用户手动选择设备时才会赋值
    this.selectIotDevice = null;
    this.routerWifiName = null;
    this.routerWifiPwd = null;

    this.regionUrl = null;
    this.pairQRKey = null;

    this.sessionID = null;
    this.uid = null;
    this.region = null;
    this.language = null;
    this.currentStep = 0;
    this.totalStep = 0;
    this.isAfterSale = null;
  }
}
