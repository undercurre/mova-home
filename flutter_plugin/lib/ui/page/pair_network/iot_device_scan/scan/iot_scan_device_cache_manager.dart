import 'dart:async';
import 'dart:collection';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_js/quickjs/ffi.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_network_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:wifi_scan/wifi_scan.dart';

/// 缓存请求到的Iot设备，
class IotScanDeviceCacheManager {
  IotScanDeviceCacheManager._internal();

  factory IotScanDeviceCacheManager() => _instance;
  static final IotScanDeviceCacheManager _instance =
      IotScanDeviceCacheManager._internal();

  final StreamController<List<IotDevice>> _streamController =
      StreamController<List<IotDevice>>.broadcast();

  final repository = PairNetworkRepository(ApiClient());

  /// 查询队列，只查询最后一次的内容
  final ListQueue<int> _listQueue = ListQueue(1);

  /// 扫描到的所有的已更新过信息的设备
  final List<IotDevice> allScanDeviceProducts = [];

  /// 扫描到的所有的已更新过信息的设备
  final List<Product> prodctList = [];

  /// 扫描到的未查询到信息的设备，一般为没有白名单，设备未分类，未上线
  final Set<IotDevice> _nothingDevices = LinkedHashSet();

  /// 正在查询的WIFI设备列表
  final Set<IotDevice> _waitingWifiDevices = LinkedHashSet();

  /// 正在查询的蓝牙设备列表
  final Set<IotDevice> _waitingBleDevices = LinkedHashSet();

  int _count = 0;

  Stream<List<IotDevice>> get streamController {
    return _streamController.stream;
  }

  void updateScanDeviceList(List<IotDevice> allScanDeviceProducts) {
    LogUtils.i(
        'onScannedIotDevices updateScanDeviceList: $_streamController $_count ${allScanDeviceProducts.length}');
    _streamController.add(allScanDeviceProducts);
  }

  Future<void> addQueryProductInfoByPids(List<ScanResult> results) async {
    var iotDeviceList = results
        .map((e) => IotDevice.from(e, null, null))
        .where((element) => element.isIotDevice())
        .where((element) => !_nothingDevices.contains(element))
        .where((element) => !_waitingBleDevices.contains(element))
        .where((element) {
      var index = allScanDeviceProducts.indexOf(element);
      if (index >= 0) {
        allScanDeviceProducts[index].updateIotDeviceInfo(element);
        updateScanDeviceList(allScanDeviceProducts);
      }
      return index == -1;
    }).toList();
    if (iotDeviceList.isNotEmpty) {
      _waitingBleDevices.addAll(iotDeviceList);
      _listQueue.add(1);
      await queryProductInfo();
    }
  }

  Future<void> addQueryDeviceInfoByModels(List<WiFiAccessPoint> results) async {
    var iotDeviceList = results
        .map((e) => IotDevice.from(null, e, null))
        .where((element) => element.isIotDevice())
        .where((element) => !_nothingDevices.contains(element))
        .where((element) => !_waitingWifiDevices.contains(element))
        .where((element) {
      var index = allScanDeviceProducts.indexOf(element);
      if (index >= 0) {
        allScanDeviceProducts[index].updateIotDeviceInfo(element);
        updateScanDeviceList(allScanDeviceProducts);
      }
      return index == -1;
    }).toSet();
    if (iotDeviceList.isNotEmpty) {
      _waitingWifiDevices.addAll(iotDeviceList);
      _listQueue.add(1);
      await queryProductInfo();
    }
  }

  Future<void> queryProductInfo() async {
    while (_listQueue.isNotEmpty) {
      _listQueue.removeFirst();
      var iotWifiDeviceList = [..._waitingWifiDevices];
      var iotBleDeviceList = [..._waitingBleDevices];

      var models = iotWifiDeviceList
          .map((e) => e.wifiScanModel)
          .where((element) => element != null)
          .join(',');
      var pids = iotBleDeviceList
          .map((e) => e.btScanPid)
          .where((element) => element != null)
          .join(',');

      Future<List<Product>> _wifiFuture;
      Future<List<Product>> _bleFuture;
      try {
        _wifiFuture = models.isNotEmpty
            ? repository.getProductInfoByModels(models)
            : Future(() => []);
        _bleFuture = pids.isNotEmpty
            ? repository.getProductInfoByPids(pids)
            : Future(() => []);
        List<List<Product>> list = await Future.wait([_wifiFuture, _bleFuture]);
        var products = list[0] + list[1];

        _handleProductResult(iotWifiDeviceList, iotBleDeviceList, products);

        /// 如果还有查询则，循环查询
      } catch (e) {
        LogUtils.e('-------getProductInfoByModels----- $e');
      }
    }

    /// 延迟查询，
    await Future.delayed(const Duration(seconds: 2));
  }

  void _handleProductResult(List<IotDevice> iotWifiDeviceList,
      List<IotDevice> iotBleDeviceList, List<Product> products) {
    var iotDeviceList = iotWifiDeviceList + iotBleDeviceList;
    for (var element in iotDeviceList) {
      if (products.isEmpty) {
        _nothingDevices.add(element);
        continue;
      }
      var product = products.firstWhereOrNull((p0) =>
          p0.productId == element.btScanPid ||
          p0.model == element.wifiScanModel ||
          p0.quickConnects.keys.contains(element.btScanPid) ||
          p0.quickConnects.values.contains(element.wifiScanModel));
      if (product == null) {
        /// 添加到nothing list
        _nothingDevices.add(element);
        continue;
      }
      element.product = product;
      element.updateIotDeviceProductInfo(product);
      var index = allScanDeviceProducts.indexOf(element);
      if (index < 0) {
        allScanDeviceProducts.add(element);
      }
    }

    /// 清理waiting list
    _waitingWifiDevices.removeAll(iotWifiDeviceList);
    _waitingBleDevices.removeAll(iotBleDeviceList);

    /// 更新设备列表
    updateScanDeviceList(allScanDeviceProducts);
  }
}
