import 'dart:async';

import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import 'dns/src/dns_over_https.dart';
import 'ping_result.dart';

class NetworkPingUtils {
  StreamSubscription? _pingSubscription;
  bool _isRunning = true;

  Future<bool> dnsLookup(String host, {int timeout = 1 * 1000}) async {
    try {
      var internetAddressList = await DnsOverHttps.cloudflare(
              timeout: Duration(milliseconds: timeout))
          .lookup(host);

      if (internetAddressList.isNotEmpty) {
        return true;
      }
    } catch (e) {
      LogUtils.e('sunzhibin -- dnsLookup error $e');
    }
    try {
      var dnsRecord = await DnsOverHttps.cloudflare(
              timeout: Duration(milliseconds: timeout))
          .lookupHttps(host);
      if (dnsRecord.isSuccess && dnsRecord.answer?.isNotEmpty == true) {
        return true;
      }
    } catch (e) {
      LogUtils.e('sunzhibin -- dnsLookup error $e');
    }
    try {
      final internetAddressList =
          await DnsOverHttps.aliCloud(timeout: Duration(milliseconds: timeout))
              .lookup(host);
      if (internetAddressList.isNotEmpty) {
        return true;
      }
    } catch (e) {
      LogUtils.e('sunzhibin -- dnsLookup error $e');
    }
    try {
      final dnsRecord =
          await DnsOverHttps.aliCloud(timeout: Duration(milliseconds: timeout))
              .lookupHttps(host);
      if (dnsRecord.isSuccess && dnsRecord.answer?.isNotEmpty == true) {
        return true;
      }
    } catch (e) {
      LogUtils.e('sunzhibin -- dnsLookup error $e');
    }
    return false;
  }

  Future<PingResult> checkPing(String host, String gatewayIp,
      {int count = 10,
      double timeout = 1,
      double interval = 1,
      bool ipv6 = false,
      int ttl = 40}) async {
    final pingDatas = await _pingTest(host,
        count: count,
        timeout: timeout,
        interval: interval,
        ipv6: ipv6,
        ttl: ttl);

    int arrivalRate = 0;
    int avgLatency = 0;
    int latency = 0;
    int index = 0;
    String ip = '';
    bool? isDNSError = null;
    bool? isNetError = null;
    for (var e in pingDatas) {
      if (e.response != null && e.response?.ip != null) {
        ip = e.response?.ip ?? '';
        // 回复的是网关Ip
        if (ip.isNotEmpty && gatewayIp.isNotEmpty && ip == gatewayIp) {
          isNetError = true;
        } else {
          isDNSError ??= false;
          isNetError = null;
        }
      }
      if (e.summary != null) {
        final transmitted = e.summary?.transmitted ?? 0;
        final received = e.summary?.received ?? 0;
        arrivalRate = received * 100 ~/ (transmitted == 0 ? 1 : transmitted);
      } else if (e.response != null && e.response?.time != null) {
        index++;
        latency += e.response?.time?.inMilliseconds ?? 0;
      } else if (e.error != null) {
        if (e.error == PingError.requestTimedOut) {
          /// 丢包不管
        } else if (e.error == PingError.unknownHost ||
            e.error == PingError.unreachable) {
          // HTTP 网不通 DNS 异常
          isDNSError ??= true;
        } else {
          // 未知不管
        }
      }
    }
    avgLatency = latency ~/ (index == 0 ? 1 : index);
    PingResult result = PingResult(
        domain: host,
        ip: ip,
        dnsError: isDNSError,
        netError: isNetError,
        arrivalRate: arrivalRate,
        latency: avgLatency,
        pingDatas: pingDatas);
    LogUtils.i('sunzhibin -- checkHttpDomain $result');
    return result;
  }

  void cancelPing() {
    _isRunning = false;
    if (_pingSubscription != null) {
      _pingSubscription?.cancel();
      _pingSubscription = null;
    }
  }

  /// ping测试
  Future<List<PingData>> _pingTest(String domain,
      {int count = 10,
      double timeout = 1,
      double interval = 1,
      bool ipv6 = false,
      int ttl = 40}) async {
    final completer = Completer<List<PingData>>();
    List<PingData> pingDatas = [];
    try {
      final ping = Ping(
        domain,
        count: count,
        timeout: timeout,
        interval: interval,
        ipv6: ipv6,
        ttl: ttl,
      );
      _pingSubscription = ping.stream.listen((event) {
        LogUtils.i('sunzhibin -- pingTest $domain ,event: $event');
        pingDatas.add(event);
        if (!_isRunning) {
          _pingSubscription?.cancel();
          ping.stop();
        }
        if (event.summary != null) {
          // 正常的情况
          _pingSubscription?.cancel();
          ping.stop();
          if (!completer.isCompleted) {
            completer.complete(pingDatas);
          }
        } else if (event.error != null) {
          if (event.error == PingError.unknownHost ||
              event.error == PingError.unreachable) {
            // 网络不通
            _pingSubscription?.cancel();
            ping.stop();
            if (!completer.isCompleted) {
              completer.complete(pingDatas);
            }
          } else if (event.error == PingError.requestTimedOut) {
            /// 发送超时
          } else {
            //出错了
            _pingSubscription?.cancel();
            ping.stop();
            if (!completer.isCompleted) {
              completer.complete([]);
            }
          }
        }
      });
    } catch (e) {
      LogUtils.e('sunzhibin -- pingTest error $e');
      if (!completer.isCompleted) {
        _pingSubscription?.cancel();
        completer.complete(pingDatas);
      }
    }
    return completer.future;
  }
}
