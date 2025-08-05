class Constant {
  // 单例
  static Constant instance = Constant();
  static String appVersion = '151';
  static String mallVersionLocal = '153'; //asset下商城zip包的版本
  static String mallSdkVersion = '5';
  static String mallCheckVersion = mallSdkVersion; // 这个参数是给商城来做兼容，以后只改这个
  static String appSourceVersion = '1'; // App皮肤版本号
  static String appAnimVersion = '1'; // App动画资源版本号
  static String tenantId = '000002';

  /// google验证
  static String googleRecaptchaAndroid =
      '6LfURtYpAAAAAClKAhn_0oSQa7eDoOhu-o-Z7RO8';
  static String googleRecaptchaIos = '6LdnH9YpAAAAADFd-5hScyhSg-xLdMatiZ0A-erD';

  /// Google 验证登录
  static String googleAndroidClientId =
      '354210209092-uisjjlcrdvvsg4p2ievi2lu54bfrp1sa.apps.googleusercontent.com';
  static String googleiOSClientId =
      '354210209092-tbsc5ti626dbvt7cb18cd9cqr16v0foo.apps.googleusercontent.com';

  /// facebook 验证登录

  ///
  /// AuthInfo key
  static String kDreameAuth = 'Dreame-Auth';
  static String kTenantId = 'Tenant-Id';
  static String kAuthorizationCode = 'Authorization';
  static String kDreameRLC = 'Dreame-RLC';
  static String kDreameMeta = 'Dreame-Meta';
  static String kLangTag = 'Lang';
  static String kOverseaMallSupported = 'isOverseasMallSupported';
  static String kOnlineServiceSupported = 'isOnlineServiceSupported';

  /// Authorization used in iot
  static String kAuthorizationInIotValue =
      'Basic ZHJlYW1lX2FwcHYxOkFQXmR2QHpAU1FZVnhOODg=';

  /// UserDefaults
  static String sharedMallLoginResKey = 'mallLoginRes';
  static String sharedGrowthGiftPopedKey = 'growthGiftPoped';
  // 动态资源文件名
  static String dynamicConfigKey = 'app_anim_config';
  static String appAnimFileKey = 'AppAnimFile';

  static String mallUrl = 'mall_url';
  static String mallType = 'mall_type';

  //定位链接地址
  static String mallExploreTab3 = 'pages/contents/contents?tabsIndex=2';
}
