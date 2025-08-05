extension QuotedSSIDExtensions on String {
  /// SSID
  String createQuotedSSID() {
    String ssid = this;
    return '"${ssid}"';
  }

  /// SSID
  String decodeQuotedSSID() {
    String ssid = this;
    if (ssid.startsWith('\"') && ssid.endsWith('\"')) {
      int index = ssid.indexOf('\"');
      int lastIndexOf = ssid.lastIndexOf('\"');
      return substring(index + '\"'.length, lastIndexOf);
    }
    return ssid;
  }

  String decodeQuotedAndUnknownSSID() {
    var ssid = decodeQuotedSSID();
    ssid = decodeUnKnownSSID(ssid);
    return ssid;
  }

  /// 是否是有效的SSID
  bool isValidSSID() {
    String ssid = this;
    return ssid.isNotEmpty &&
        ssid != '<unknown ssid>' &&
        ssid != 'unknown ssid' &&
        ssid != '<unknow>' &&
        ssid != '< unknow >';
  }

  /// 将SSID 去掉 未知 SSID的情况
  String decodeUnKnownSSID(String ssid) {
    if (!isValidSSID()) {
      if (ssid.isEmpty) return ssid;
      if (ssid == '<unknown ssid>') return '';
      if (ssid == 'unknown ssid') return '';
      if (ssid == '<unknow>') return '';
      if (ssid == '< unknow >') return '';
    }
    return ssid;
  }
}
