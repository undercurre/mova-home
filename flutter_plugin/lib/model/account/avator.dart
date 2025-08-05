import 'dart:typed_data';
import 'package:flutter/foundation.dart';


class AvatorReq {
  AvatorReq({
    required this.name,
    required this.forKey,
    required this.type,
    required this.data,
  });
  String name;
  String forKey;
  String type;
  Uint8List data;
}