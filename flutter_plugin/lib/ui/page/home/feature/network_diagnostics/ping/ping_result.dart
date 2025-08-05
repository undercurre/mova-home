import 'package:flutter_icmp_ping/flutter_icmp_ping.dart';

class PingResult {
  PingResult({
    required this.domain,
    required this.ip,
    required this.arrivalRate,
    required this.latency,
    required this.dnsError,
    required this.netError,
    required this.pingDatas,
  });

  final String domain;
  final bool? dnsError;
  final bool? netError;
  final int latency;
  final String ip;

  // 到达率
  final int arrivalRate;
  final List<PingData> pingDatas;

  factory PingResult.from() => PingResult(
      domain: '',
      ip: '',
      arrivalRate: 0,
      latency: 0,
      dnsError: true,
      netError: true,
      pingDatas: []);

  @override
  String toString() {
    return 'PingResult{domain: $domain, ip: $ip ,arrivalRate: $arrivalRate, latency: $latency, dnsError: $dnsError}';
  }
}
