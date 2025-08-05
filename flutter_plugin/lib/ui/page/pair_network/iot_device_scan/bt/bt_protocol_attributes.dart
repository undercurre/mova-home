import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BtProtocolAttributes {
  BtProtocolAttributes._internal();

  factory BtProtocolAttributes() => _instance;
  static final BtProtocolAttributes _instance =
      BtProtocolAttributes._internal();

  static final bleServiceUuid = Guid('0000fe98-0000-1000-8000-00805f9b34fb');
  static final bleReadCharUuid = Guid('00002a02-0000-1000-8000-00805f9b34fb');
  static final bleWriteCharUuid = Guid('00002a03-0000-1000-8000-00805f9b34fb');
}
