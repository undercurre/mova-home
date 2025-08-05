import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dreame_flutter_base_event_tracker/data/event_tracker_options.dart';
import 'package:dreame_flutter_base_event_tracker/event_tracker.dart';
import 'package:dreame_flutter_base_event_tracker/logger/event_tracker_logger.dart';
// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BurialPointUtil {
  BurialPointUtil._internal();

  factory BurialPointUtil() => _instance;
  static final BurialPointUtil _instance = BurialPointUtil._internal();

  Future<void> init() async {
    var uploadOptions = UploadOptions(20, const Duration(seconds: 10));
    var persistenceOptions = PersistenceOptions();

    var lang = LanguageStore().getCurrentLanguage().langTag;
    var country = RegionStore().currentRegion;
    var regin = country.domain.substring(0, country.domain.indexOf('.'));
    var countryCode = country.countryCode;
    var metadata = EventMetadata(
        region: regin,
        lang: lang,
        country: countryCode,
        platform: Platform.operatingSystem,
        appSource: 1);
    EventTracker()
        .setPersistenceOptions(persistenceOptions)
        .setUploadOptions(uploadOptions)
        .setMetadata(metadata)
        .setLogger(Logger())
        .initialize();
  }

  Future<void> updateConfig({bool agreePrivacy = false}) async {
    var lang = LanguageStore().getCurrentLanguage().langTag;
    var country = RegionStore().currentRegion;
    var regin = country.domain.substring(0, country.domain.indexOf('.'));
    var countryCode = country.countryCode;
    var appVer = '';
    var brand = '';
    var platformVer = '';
    if (agreePrivacy) {
      PackageInfo info = await PackageInfo.fromPlatform();
      var deviceInfo = await _getDeviceInfo();
      platformVer = deviceInfo?.second ?? '';
      brand = deviceInfo?.first ?? '';
      if (Platform.isIOS) {
        appVer = '${info.version}_${info.buildNumber}';
      } else {
        appVer = info.version;
      }
      EventTracker().updateMetadataInfo(
          region: regin,
          lang: lang,
          country: countryCode,
          platform: Platform.operatingSystem,
          platformVer: platformVer,
          brand: brand,
          appVer: appVer,
          appSource: 1);
    }
    String uid = (await AccountModule().getUserInfo())?.uid ?? '';
    EventTracker().updateUid(uid);
    if (uid.isNotEmpty) {
      EventTracker().enableUpload();
    } else {
      EventTracker().disableUpload();
    }
  }

  void clearUid() {
    EventTracker().updateUid('');
    EventTracker().disableUpload();
  }

  void updateUid(String? uid) {
    EventTracker().updateUid(uid);
  }

  Future<void> forceUpload() async {
    EventTracker().forceUpload();
  }

  Future<void> enableUpload() async {
    EventTracker().enableUpload();
  }

  Future<void> disableUpload() async {
    EventTracker().disableUpload();
  }

  void destroy() {
    EventTracker().destroy();
  }
}

class Logger extends EventTrackerLogger {
  @override
  void d(String message, {String? tag}) {
    LogUtils.d('$tag: $message');
  }

  @override
  void e(String message, {String? tag, Error? error}) {
    LogUtils.e('$tag: $message');
  }

  @override
  void i(String message, {String? tag}) {
    LogUtils.i('$tag: $message');
  }

  @override
  void w(String message, {String? tag}) {
    LogUtils.w('$tag: $message');
  }

  @override
  void wtf(String message,
      {String? tag, Error? error, StackTrace? stackTrace}) {
    LogUtils.wtf('$tag: $message');
  }
}

Future<Pair<String, String>?> _getDeviceInfo() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return Future.value(Pair('${androidInfo.brand} ${androidInfo.model}',
        androidInfo.version.sdkInt.toString()));
  } else if (Platform.isIOS) {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    return Future.value(Pair(iosInfo.utsname.machine, iosInfo.systemVersion));
  }
  return null;
}
