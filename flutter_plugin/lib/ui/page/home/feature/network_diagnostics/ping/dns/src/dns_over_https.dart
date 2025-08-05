import 'dart:convert';
import 'dart:io';

import 'package:flutter_plugin/ui/page/home/feature/network_diagnostics/ping/dns/src/dns_resolve.dart';

import 'dns_client.dart';
import 'dns_record.dart';

class DnsOverHttps extends DnsClient {
  final _client = HttpClient();

  /// URL of the service (without query).
  final String url;
  final Uri _uri;

  /// Whether to hide client IP address from the authoritative server.
  final bool maximalPrivacy;

  /// Default timeout for operations.
  final Duration? timeout;

  DnsOverHttps(this.url, {this.timeout, this.maximalPrivacy = false})
      : _uri = Uri.parse(url) {
    _client.connectionTimeout = timeout ?? const Duration(milliseconds: 5000);
  }

  /// Shuts down the HTTP client.
  ///
  /// If [force] is `false` (the default) the [HttpClient] will be kept alive
  /// until all active connections are done. If [force] is `true` any active
  /// connections will be closed to immediately release all resources. These
  /// closed connections will receive an error event to indicate that the client
  /// was shut down. In both cases trying to establish a new connection after
  /// calling [close] will throw an exception.
  void close({bool force = false}) {
    _client.close(force: force);
  }

  factory DnsOverHttps.google({Duration? timeout}) {
    return DnsOverHttps(DnsResolve.google, timeout: timeout);
  }

  factory DnsOverHttps.cloudflare({Duration? timeout}) {
    return DnsOverHttps(DnsResolve.cloudflare, timeout: timeout);
  }

  factory DnsOverHttps.aliCloud({Duration? timeout}) {
    return DnsOverHttps(DnsResolve.alicloud, timeout: timeout);
  }

  @override
  Future<List<InternetAddress>> lookup(String hostname) {
    return lookupHttps(hostname).catchError((err) {
      return DnsRecord.from();
    }).then((record) {
      return record.answer
              ?.where((answer) => answer.type == 1)
              .map((answer) => InternetAddress(answer.data))
              .toList() ??
          [];
    });
  }

  Future<DnsRecord> lookupHttps(String hostname,
      {InternetAddressType type = InternetAddressType.any}) async {
    // Build URL
    var query = {'name': hostname};
    // Add: IPv4 or IPv6?
    if (type == InternetAddressType.any || type == InternetAddressType.IPv4) {
      query['type'] = 'A';
    } else {
      query['type'] = 'AAAA';
    }

    // Hide my IP?
    if (maximalPrivacy) {
      query['edns_client_subnet'] = '0.0.0.0/0';
    }
    final request =
        await _client.getUrl(Uri.https(_uri.authority, _uri.path, query));
    request.headers.set('accept', 'application/dns-json');
    final response = await request.close();
    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    final record = DnsRecord.fromJson(jsonDecode(contents.toString()));
    return record;
  }
}
