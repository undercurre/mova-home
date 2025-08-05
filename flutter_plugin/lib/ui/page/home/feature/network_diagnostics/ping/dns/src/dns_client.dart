import 'dart:io';

/// https://github.com/dietfriends/dns_client
/// https://pub.dev/packages/dns_client
///
abstract class DnsClient {
  Future<List<InternetAddress>> lookup(String hostname);
}
