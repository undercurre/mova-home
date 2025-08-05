import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/ui/page/home/feature/network_diagnostics/ping/network_ping_utils.dart';
import 'package:flutter_plugin/ui/page/home/home_repository.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'network_diagnostics_uistate.dart';
import 'ping/dns/src/dns_over_https.dart';
import 'ping/generate_204/generate_204_test.dart';
import 'ping/ping_result.dart';

part 'network_diagnostics_state_notifier.g.dart';

@riverpod
class NetworkDiagnosticsStateNotifier
    extends _$NetworkDiagnosticsStateNotifier {
  CancelableOperation? _cancelableOperation;
  NetworkPingUtils pingUtils = NetworkPingUtils();
  final int AVG_LATENCY = 800;
  final int ARRIVAL_RATE = 80;
  final host1 = 'time.apple.com';
  final host2 = 'www.baidu.com';
  final host3 = 'www.google.com';

  @override
  NetworkDiagnosticsUiState build() {
    ref.onDispose(() {
      LogUtils.i('sunzhibin -- networkDiagnostics onDispose --------------');
      deactivate();
    });
    LogUtils.i('sunzhibin -- networkDiagnostics build --------------');
    return const NetworkDiagnosticsUiState();
  }

  void initData() {
    var bindDomain =
        ref.read(homeStateNotifierProvider).currentDevice?.bindDomain;
    state = state.copyWith(bindDomain: bindDomain);
  }

  /// 1、检测wifi是否连接，Android检测是不是2.4G
  /// 2、检测wifi是否有网
  /// 3、解析http的域名，ping ip
  /// 4、解析mqtt域名，ping ip
  /// 5、检测获取到的wifi强度
  Future<void> networkDiagnostics() async {
    _cancelableOperation =
        CancelableOperation.fromFuture(_realNetworkDiagnostics());
  }

  Future<void> _realNetworkDiagnostics() async {
    try {
      // Wi-Fi 是否有网
      var checkInternetRet = await checkInternet();
      if (checkInternetRet.dnsError == true ||
          checkInternetRet.netError == true ||
          checkInternetRet.arrivalRate == 0) {
        LogModule().eventReport(100, 11,
            int1: 2,
            str1: checkInternetRet.arrivalRate.toString(),
            str2: checkInternetRet.latency.toString());
        handleResponse();
        return;
      }
      // 网络变更
      var isCheckNetChange = await checkNetChange();
      if (isCheckNetChange == false) {
        return;
      }
      // http 域名解析
      var httpDomainRet = await checkHttpDomain();
      // mqtt 域名解析
      var mqttDomainRet = await checkMqttDomain();
      // Wi-Fi 信号强度
      var checkWifiQualityRet = await checkWifiQuality();

      LogModule().eventReport(100, 11,
          int1: 1,
          int2: checkInternetRet.arrivalRate >= ARRIVAL_RATE ? 1 : 2,
          int3: httpDomainRet.dnsError == false ? 1 : 2,
          int4: mqttDomainRet.dnsError == false ? 1 : 2,
          str1: checkInternetRet.arrivalRate.toString(),
          str2: checkInternetRet.latency.toString(),
          str3: mqttDomainRet.ip);
      handleResponse();
    } catch (e) {
      LogUtils.e('sunzhibin -- networkDiagnostics error $e');
      state = state.copyWith(
          status: 1,
          result: 1,
          resultText: 'network_diagnostics_change_complete'.tr(),
          resultText2: 'network_diagnostics_change_complete_desc'.tr());
    }
  }

  void handleResponse() {
    LogUtils.i('sunzhibin -- networkDiagnostics $state');
    if (state.networkQuality == 0 ||
        state.networkValid == false ||
        !state.networkDns) {
      state = state.copyWith(
          status: 1,
          result: 0,
          resultText: 'network_diagnostics_error_title'.tr(),
          resultText2: 'network_diagnostics_error_desc'.tr());
      return;
    }

    if (!state.httpDomainDns) {
      state = state.copyWith(
          status: 1,
          result: 0,
          resultText: 'network_diagnostics_dns_title'.tr(),
          resultText2: 'network_diagnostics_dns_desc'.tr());
      return;
    }
    if (state.httpDomainQuality < ARRIVAL_RATE ||
        state.httpDomainLatency > AVG_LATENCY) {
      state = state.copyWith(
          status: 1,
          result: 0,
          resultText: 'network_diagnostics_quality_title'.tr(),
          resultText2: 'network_diagnostics_quality_desc'.tr());
      return;
    }

    if (!state.mqttDomainDns) {
      state = state.copyWith(
          status: 1,
          result: 0,
          resultText: 'network_diagnostics_dns_title'.tr(),
          resultText2: 'network_diagnostics_dns_desc'.tr());
      return;
    }
    if (state.mqttDomainQuality < ARRIVAL_RATE ||
        state.mqttDomainLatency > AVG_LATENCY) {
      state = state.copyWith(
          status: 1,
          result: 0,
          resultText: 'network_diagnostics_quality_title'.tr(),
          resultText2: 'network_diagnostics_quality_desc'.tr());
      return;
    }
    if (state.rssiQuality < ARRIVAL_RATE) {
      state = state.copyWith(
          status: 1,
          result: 0,
          resultText: 'network_diagnostics_quality_title'.tr(),
          resultText2: 'network_diagnostics_quality_desc'.tr());
      return;
    }
    state = state.copyWith(
        status: 1,
        result: 1,
        resultText: 'network_diagnostics_change_complete'.tr(),
        resultText2: 'network_diagnostics_change_complete_desc'.tr());
  }

  Future<PingResult> checkInternet() async {
    /// 简单一个get请求
    final isNetConnect = await Generate204Test().generate204Test();
    final ips = await dnsLookup(host1);
    final gatewayIp = await NetworkInfo().getWifiGatewayIP() ?? '';
    LogUtils.i(
        'sunzhibin -- networkDiagnostics checkHttpDomain gatewayIp:$gatewayIp ,ips: $ips  ');
    if (!isNetConnect && ips.isEmpty) {
      // 网络不通
      return PingResult(
          domain: '',
          ip: '',
          arrivalRate: 0,
          latency: 0,
          dnsError: true,
          netError: true,
          pingDatas: []);
    } else {
      final gatewayIp = await NetworkInfo().getWifiGatewayIP() ?? '';
      final pingResult = await pingUtils.checkPing(host1, gatewayIp, count: 10);
      state = state.copyWith(
          networkQuality: pingResult.arrivalRate,
          networkLatency: pingResult.latency,
          networkDns: pingResult.dnsError == false,
          networkValid: pingResult.netError != true);
      LogUtils.i('sunzhibin -- networkDiagnostics checkPing host1 $state');
      if (pingResult.arrivalRate > 0 || pingResult.dnsError == false) {
        return pingResult;
      }
      final isCN = 'cn' == await LocalModule().serverSite();
      final pingResult2 =
          await pingUtils.checkPing(isCN ? host2 : host3, gatewayIp, count: 10);
      if (pingResult2.arrivalRate > 0 || pingResult.dnsError == false) {
        state = state.copyWith(
            networkQuality: pingResult2.arrivalRate,
            networkLatency: pingResult2.latency,
            networkDns: pingResult2.dnsError == false,
            networkValid: pingResult.netError != true);
        LogUtils.i('sunzhibin -- networkDiagnostics checkPing host2 $state');
        return pingResult2;
      }
      final pingResult3 =
          await pingUtils.checkPing(isCN ? host3 : host2, gatewayIp, count: 10);
      if (pingResult3.arrivalRate > 0 || pingResult.dnsError == false) {
        state = state.copyWith(
            networkQuality: pingResult3.arrivalRate,
            networkLatency: pingResult3.latency,
            networkDns: pingResult3.dnsError == false,
            networkValid: pingResult.netError != true);
        LogUtils.i('sunzhibin -- networkDiagnostics checkPing host3 $state');
        return pingResult3;
      }
      return pingResult;
    }
  }

  Future<PingResult> checkHttpDomain() async {
    String uriHost = await InfoModule().getUriHost();
    String host = Uri.parse(uriHost).host;
    final isNetConnect = await Generate204Test().generate204Test();
    final ips = await dnsLookup(host);
    final gatewayIp = await NetworkInfo().getWifiGatewayIP() ?? '';
    LogUtils.i(
        'sunzhibin -- networkDiagnostics checkHttpDomain gatewayIp:$gatewayIp ,ips: $ips  ');
    if (!isNetConnect && ips.isEmpty) {
      state = state.copyWith(
          httpDomainQuality: 0,
          httpDomainLatency: 0,
          httpDomainDns: false,
          networkValid: false);
      return PingResult.from();
    }
    final pingResult = await pingUtils.checkPing(host, gatewayIp);
    state = state.copyWith(
        httpDomainQuality: pingResult.arrivalRate,
        httpDomainLatency: pingResult.latency,
        httpDomainDns: pingResult.dnsError == false,
        networkValid: pingResult.netError != true);
    LogUtils.i('sunzhibin -- networkDiagnostics checkHttpDomain $state');
    return pingResult;
  }

  Future<PingResult> checkMqttDomain() async {
    ///  20000.mt.cn.iot.mova-tech.com:19974
    final serverUri = await MqttConnector().getServerUri();
    String host = serverUri.first;
    final bindDomain = state.bindDomain ??
        ref.read(homeStateNotifierProvider).currentDevice?.bindDomain ??
        host;
    int index = bindDomain.indexOf(':');
    host = bindDomain.substring(0, index);

    final isNetConnect = await Generate204Test().generate204Test();
    final ips = await dnsLookup(host);
    final gatewayIp = await NetworkInfo().getWifiGatewayIP() ?? '';
    LogUtils.i(
        'sunzhibin -- networkDiagnostics checkMqttDomain gatewayIp:$gatewayIp ,host: $host ,ips: $ips  ');
    if (!isNetConnect && ips.isEmpty) {
      state = state.copyWith(
          httpDomainQuality: 0,
          httpDomainLatency: 0,
          httpDomainDns: false,
          networkValid: false);
      return PingResult.from();
    }
    final pingResult = await pingUtils.checkPing(host, gatewayIp);
    state = state.copyWith(
        mqttDomainQuality: pingResult.arrivalRate,
        mqttDomainLatency: pingResult.latency,
        mqttDomainDns: pingResult.dnsError == false,
        networkValid: pingResult.netError != true);
    LogUtils.i('sunzhibin -- networkDiagnostics checkMqttDomain $state');
    return pingResult;
  }

  Future<int> checkWifiQuality() async {
    int quality = 100;
    // Wi-Fi 信号强度
    final rssi = Platform.isAndroid
        ? await WiFiForIoTPlugin.getCurrentSignalStrength() ?? 0
        : 0;

    /// [https://android.googlesource.com/platform/packages/modules/Wifi/+/refs/heads/main/service/ServiceWifiResources/res/values/config.xml]
    if (rssi <= -88) {
      quality = 0;
    } else if (rssi <= -77 && rssi >= -88) {
      quality = 60;
    } else if (rssi <= -66 && rssi >= -77) {
      quality = 80;
    } else if (rssi <= -55 && rssi >= -66) {
      quality = 90;
    } else {
      quality = 100;
    }
    if (quality <= 80) {
      state = state.copyWith(rssiQuality: quality);
      return quality;
    }
    state = state.copyWith(rssiQuality: quality);
    return quality;
  }

  /// 判断是否是机器连接的Wi-Fi
  Future<bool> checkIsSameWifi() async {
    // 2.4G网络连接
    final ssid = await WiFiForIoTPlugin.getSSID() ?? '';
    try {
      final device = ref.read(homeStateNotifierProvider).currentDevice;
      final octInfoRes = await ref
          .read(homeRepositoryProvider)
          .octInfo(device?.did ?? '', device?.model ?? '');
      final deviceSiid = octInfoRes.otcInfo?.params?.ap?.siid;
      if (deviceSiid == null) {
        return true;
      }
      LogUtils.e('sunzhibin -- octInfo $deviceSiid $ssid');
      if (ssid.isNotEmpty &&
          ssid != '<unknown ssid>' &&
          ssid != 'unknown ssid' &&
          ssid != '<unknow>' &&
          ssid != '< unknow >') {
        return deviceSiid == ssid;
      }
    } catch (e) {
      LogUtils.e('sunzhibin -- octInfo error $e');
    }
    return true;
  }

  void updateProgress(int progress) {
    if (progress == 100) {
      progress = 99;
    }
    state = state.copyWith(progress: progress <= 0 ? 0 : progress);
  }

  void deactivate() {
    pingUtils.cancelPing();
    if (_cancelableOperation != null) {
      if (_cancelableOperation?.isCanceled == true ||
          _cancelableOperation?.isCompleted == true) {
      } else {
        _cancelableOperation?.cancel();
      }
    }
  }

  Future<bool> checkNetChange() async {
    final isWifi = await checkIsSameWifi();
    if (!isWifi) {
      state = state.copyWith(
          status: 1,
          result: 0,
          resultText: 'network_diagnostics_change_title'.tr(),
          resultText2: 'network_diagnostics_change_desc'.tr());
      return false;
    }
    return true;
  }

  Future<List<InternetAddress>> dnsLookup(String host) async {
    var ips = await DnsOverHttps.cloudflare().lookup(host);
    if (ips.isEmpty) {
      final country = await LocalModule().getCountryCode();
      if (country.toLowerCase() == 'cn') {
        ips = await DnsOverHttps.aliCloud(timeout: const Duration(seconds: 5))
            .lookup(host);
      } else {
        ips = await DnsOverHttps.google(timeout: const Duration(seconds: 5))
            .lookup(host);
      }
    }
    LogUtils.i('sunzhibin -- dnsLookup $ips');
    return ips;
  }
}
