import 'package:flutter/material.dart';

bool isValidPhone(String phone) {
  return isValidPhoneFor(phone, true);
}

bool isValidPhonenumber(String phone, String phoneCode) {
  return isValidPhoneFor(
      phone,
      phoneCode == '86' ||
          phoneCode.toUpperCase() == 'CN' ||
          phoneCode.toUpperCase() == '86');
}

bool isValidPhoneFor(String phone, bool isCn) {
  return isCn ? isValidPhoneForCN(phone) : isValidPhoneForOverseas(phone);
}

bool isValidPhoneForCN(String phone) {
  RegExp regExpStr = RegExp(r'^1+(\d{10})$');
  bool isContainer = regExpStr.hasMatch(phone);
  return isContainer;
}

bool isValidPhoneForOverseas(String phone) {
  RegExp regExpStr = RegExp(r'^\d{6,15}$');
  bool isContainer = regExpStr.hasMatch(phone);
  return isContainer;
}

bool isVaildPassword(String password) {
  RegExp regExpStr = RegExp(
      r'^(?![A-Z]*$)(?![a-z]*$)(?![0-9]*$)(?![^A-Za-z0-9]*$)((?![\s])[\x00-\x7F]){8,16}$');
  bool isContainer = regExpStr.hasMatch(password);
  return isContainer;
}

bool isVaildEmail(String email) {
  // RegExp regExpStr = RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$');
  // bool isContainer = regExpStr.hasMatch(email);
  // return isContainer;
  var index = email.indexOf('@');
  return index > 0;
}

/// 是否是中国地区
bool isCnRegion(String region) {
  return '86' == region || 'CN' == region.toUpperCase();
}

bool isLTR(BuildContext context) {
  return Directionality.of(context) == TextDirection.ltr;
}
