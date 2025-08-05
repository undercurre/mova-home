import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_curve25519/flutter_curve25519.dart';

class Curve25519KeypairGenerator {
  late Curve25519KeyPair _keypair;

  Curve25519KeyPair generateKeyPair() {
    var seed = List.generate(32, (index) => Random().nextInt(256));
    final keypair = Curve25519KeyPair.fromSeed(Uint8List.fromList(seed));
    _keypair = keypair;
    return keypair;
  }

  String getSharedKey(Uint8List publicKey) {
    Uint8List rawKey = Curve25519.sharedKey(_keypair.privateKey, publicKey);
    return base64Encode(rawKey);
  }
}
