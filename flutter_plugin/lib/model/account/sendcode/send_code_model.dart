import 'package:flutter_plugin/model/region_item.dart';

class SendCodeModel {
  int interval;
  String phone;
  String codeKey;
  RegionItem currentPhone;
  RegionItem currentRegion;
  SendCodeModel({
    required this.phone,
    required this.codeKey,
    required this.currentPhone,
    required this.currentRegion,
    this.interval = 60,
  });
}

class SocialCodeModel {
  String phone;
  String codeKey;
  RegionItem currentPhone;
  RegionItem currentRegion;
  String oauthSource;
  String uuid;
  int interval = 60;
  SocialCodeModel({
    required this.currentPhone,
    required this.currentRegion,
    required this.oauthSource,
    required this.uuid,
    this.phone = '',
    this.codeKey = '',
    this.interval = 60,
  });
}
