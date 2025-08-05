import 'package:dio/io.dart';

class CertVerifyAdapter extends IOHttpClientAdapter {
  @override
  ValidateCertificate? get validateCertificate => (certificate, host, port) {
        if (host.contains('mova-tech.com')) {
          var subject = certificate?.subject ?? '';
          final index = subject.lastIndexOf('CN=');
          final subjectCN = subject.substring(index).replaceAll('CN=', '');
          return _verifyHostname(host, subjectCN);
        } else {
          return true;
        }
      };

  /// 证书校验域名,参考[android.dreame.module.net.DreameHostVerify]
  bool _verifyHostname(String? hostname, String? pattern) {
    if (hostname == null ||
        hostname.isEmpty ||
        hostname.startsWith('.') ||
        hostname.endsWith('..')) {
      return false;
    }
    if (pattern == null ||
        pattern.isEmpty ||
        pattern.startsWith('.') ||
        pattern.endsWith('..')) {
      return false;
    }
    if (!hostname.endsWith('.')) {
      hostname += '.';
    }
    if (!pattern.endsWith('.')) {
      pattern += '.';
    }
    pattern = pattern.toLowerCase();
    if (!pattern.contains('*')) {
      return hostname == pattern;
    }
    if (!pattern.startsWith('*.') || pattern.indexOf('*', 1) != -1) {
      return false;
    }
    if (hostname.length < pattern.length) {
      return false;
    }
    if ('*.' == pattern) {
      return false;
    }
    final suffix = pattern.substring(1);
    if (!hostname.endsWith(suffix)) {
      return false;
    }
    final suffixStartIndexInHostname = hostname.length - suffix.length;
    if (suffixStartIndexInHostname > 0 &&
        hostname.lastIndexOf('.', suffixStartIndexInHostname - 1) != -1) {
      return false;
    }
    return true;
  }
}
