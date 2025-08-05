class SchemeType {
  static const device = SchemeType('DEVICE');
  static const web = SchemeType('WEB');
  static const webExternal = SchemeType('WEB_EXTERNAL');
  static const mall = SchemeType('MALL');
  static const vip = SchemeType('VIP');
  static const member = SchemeType('MEMBER');
  static const wxApplet = SchemeType('WX_APPLET');
  static const app = SchemeType('APP');
  static const homeTab = SchemeType('HOME_TAB');
  static const appLogin = SchemeType('APP_LOGIN');
  static const alexaAuth = SchemeType('ALEXA_AUTH');
  static const splashAd = SchemeType('SPLASH_AD');
  static const community = SchemeType('COMMUNITY');
  static const nfc = SchemeType('NFC');
  static const overseasMall = SchemeType('OVERSEA_MALL');
  static const channel = SchemeType('channel');


  final String name;
  const SchemeType(this.name);

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    return other is SchemeType && other.name == name;
  }

  bool isDeviceEvent() {
    return this == device || this == nfc;
  }
}
