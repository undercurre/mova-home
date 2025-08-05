import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/utils/logutils.dart';

/// Wi-Fi 和 BT 状态监听
mixin IotBtWifiStateMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<BluetoothAdapterState>? _isBleAdapterStateSubscription;
  StreamSubscription<List<ConnectivityResult>>?
      onConnectivityChangedSubscription;

  @override
  void initState() {
    super.initState();
    subscribeBtWifiOpenState();
  }

  @override
  void dispose() {
    super.dispose();
    _isBleAdapterStateSubscription?.cancel();
    onConnectivityChangedSubscription?.cancel();
  }

  void subscribeBtWifiOpenState() {
    _subscribeBtOpenState();
    _subscribeWifiOpenState();
  }

  Future<bool> isBtOpen() async {
    return await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;
  }

  Future<bool> isWifiOpen() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    return result.last == ConnectivityResult.wifi;
  }

  void btStateChanged(bool isOpen, BluetoothAdapterState state) {}

  void wifiStateChanged(bool isOpen, ConnectivityResult state) {}

  void _subscribeBtOpenState() {
    if (Platform.isIOS) {
      FlutterBluePlus.setOptions(showPowerAlert: false);
    }
    _isBleAdapterStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      LogUtils.i('IotBtWifiStateMixin adapterState -$state');
      if (state == BluetoothAdapterState.on) {
        // TODO：蓝牙打开了，判断stepChain 是否已经完成了，完成了就判断是否有权限，扫描附近设备
        btStateChanged(true, state);
      } else {
        btStateChanged(false, state);
      }
    });
  }

  Future<void> _subscribeWifiOpenState() async {
    onConnectivityChangedSubscription =
        Connectivity().onConnectivityChanged.listen((event) {
      LogUtils.i('onConnectivityChanged: $event');
      if (event.last == ConnectivityResult.wifi) {
        // TODO： Wi-Fi打开了，判断stepChain 是否已经完成了，完成了就判断是否有权限，扫描附近设备
        wifiStateChanged(true, event.last);
      } else {
        wifiStateChanged(false, event.last);
      }
    });
    final event = await Connectivity().checkConnectivity();
    wifiStateChanged(event.last == ConnectivityResult.wifi, event.last);
  }
}
