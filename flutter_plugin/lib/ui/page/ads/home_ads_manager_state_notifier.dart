import 'dart:convert';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';

// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/ui/page/ads/home_ads_model.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/main/main_repository.dart';
import 'package:flutter_plugin/ui/page/settings/settings_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_ads_manager_state_notifier.g.dart';

@riverpod
class HomeAdsManager extends _$HomeAdsManager {
  @override
  List<ADModel> build() {
    return [];
  }

  Future<void> showPersonalizedAd() async {
    OAuthModel? account = await AccountModule().getAuthBean();
    String? countryCode = await LocalModule().getCountryCode();
    final String storageKey = '${account.uid}_$countryCode';
    const String fileName = 'personalized_ad';
    final aduserswitch =
        await ref.read(settingsRepositoryProvider).getAduserswitch();
    final isAgree = aduserswitch == 1;
    // 0/null 未操作， 1：允许， 2：不允许
    int? curPersonalizedAdState =
        await LocalStorage().getInt(storageKey, fileName: fileName);
    final isCn = countryCode.toLowerCase() == 'cn';

    // 没有打开个性化广告开关 并且本地没有保存过， 则弹出弹窗
    if (!isAgree && curPersonalizedAdState == 0 && !isCn) {
      ref.watch(dialogJobManagerProvider.notifier).sendJobMessage(DialogJob(
            DialogType.personalizedAd,
            bundle: {
              'state': curPersonalizedAdState,
              'storageKey': storageKey,
              'fileName': fileName,
            },
          ));
    } else {
      // 开关打开/点击过个性化广告的状态，允许或拒绝
      await LocalStorage()
          .putInt(storageKey, isAgree ? 1 : 2, fileName: fileName);
      await queryHomeAd();
    }
  }

  /// 查询广告
  Future<void> loadHomeAd() async {
    LogUtils.i('loadHomeAd  ------- home query -----');
    await showPersonalizedAd();
  }

  Future<void> queryHomeAd() async {
    LogUtils.i('loadHomeAd  ------- home query -----');
    try {
      List<ADModel> adModels =
          await ref.watch(mainRepositoryProvider).getADList();
      if (adModels.isNotEmpty) {
        var oAuthBean = await AccountModule().getAuthBean();
        var countryCode = await LocalModule().getCountryCode();
        var adsInfoMap = await ref
            .watch(mainRepositoryProvider)
            .getAdInfo(account: oAuthBean, countryCode: countryCode);
        var showList = await _adsFilterShow(adModels, adsInfoMap);
        LogUtils.i(
            'loadHomeAd show ------- queryList:  $adModels    +++++++++   showList:  $showList');
        if (showList.isNotEmpty) {
          ref
              .watch(dialogJobManagerProvider.notifier)
              .sendJobMessage(DialogJob(DialogType.ad, bundle: showList));
        }
        if (adModels.isNotEmpty) {
          // 广告弹出，保存弹出的广告时间
          await ref
              .watch(homeAdsManagerProvider.notifier)
              .updateAdShow(adsInfoMap, adModels, oAuthBean, countryCode);
        }
      } else {
        LogUtils.i('loadHomeAd isEmpty');
      }
    } catch (error) {
      LogUtils.e('loadHomeAd error: $error');
    }
  }

  Future<void> loadSplashAdInfo() async {
    try {
      List<ADModel> adModels = await ref
          .watch(mainRepositoryProvider)
          .getADList(adType: AdType.splash);
      if (adModels.isNotEmpty) {
        LogUtils.i(
            'HomeAdsManager---for----HomeAdsManager.loadSplashAdInfo $adModels');
        final adModel = adModels[0]; // 始终取第0个
        await updateSplashAdInfo(adModel);
      } else {
        LogUtils.d('HomeAdsManager loadSplashAdInfo isEmpty');
        // 清理资源
        await clearSplashAdInfo();
      }
    } catch (error) {
      LogUtils.e('HomeAdsManager loadSplashAdInfo error: $error');
    }
  }

  Future<void> updateSplashAdInfo(ADModel adModel) async {
    try {
      final localAdInfoMap = await getAdInfo(adType: AdType.splash);

      if (localAdInfoMap.isEmpty) {
        String picPath = await _downloadSplashPicByAdModel(adModel);
        await saveSplashAdInfo(adModel, picFilePath: picPath);
        return;
      }

      final localAdModelMap = localAdInfoMap['adModel'];
      final localAdModel = ADModel.fromJson(localAdModelMap);

      if (adModel.id != localAdModel.id) {
        // 先删除旧的资源
        await clearSplashAdInfo();
        String picPath = await _downloadSplashPicByAdModel(adModel);
        await saveSplashAdInfo(adModel, picFilePath: picPath);
      } else {
        // 需要merge本地和远程的，比如远程nextShowDay会变化
        Directory appDocumentsDir = await getApplicationDocumentsDirectory();
        String oldPicPath = localAdModel.picFilePath ?? '';
        String picPath = oldPicPath;
        if (oldPicPath.isEmpty ||
            !File('${appDocumentsDir.path}/$oldPicPath').existsSync()) {
          picPath = await _downloadSplashPicByAdModel(adModel);
        }
        await saveSplashAdInfo(
          adModel,
          popShowTime: localAdInfoMap['popShowTime'] ?? 0,
          picFilePath: picPath,
          isClicked: localAdInfoMap['isClicked'] ?? false,
        );
      }
    } catch (error) {
      LogUtils.e('HomeAdsManager updateSplashAdInfo error: $error');
    }
  }

  Future<String> _downloadSplashPicByAdModel(ADModel adModel) async {
    String urlPath = adModel.picture;
    if (urlPath.isEmpty) {
      return Future.value('');
    }

    final picSplit = Uri.parse(urlPath).path.split('.');
    String extension = picSplit.isNotEmpty ? '.${picSplit.last}' : '';
    Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    final account = await AccountModule().getAuthBean();
    final countryCode = await LocalModule().getCountryCode();

    // 文件夹名称开始的路径
    String filePath =
        '${AdType.splash.typeFileName}/${account.uid}-$countryCode/${adModel.id}$extension';
    return await DMHttpManager()
        .create(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20),
            interceptorTypes: [InterceptorType.none])
        .download(urlPath, '${appDocumentsDir.path}/$filePath')
        .then((value) {
          LogUtils.d(
              'HomeAdsManager downloadSplashPicByAdModel success: $filePath');
          return Future.value(filePath);
        })
        .catchError((e) {
          LogUtils.e('HomeAdsManager downloadSplashPicByAdModel error: $e');
          return Future.value('');
        });
  }

  Future<void> clearSplashAdInfo() async {
    final account = await AccountModule().getAuthBean();
    final countryCode = await LocalModule().getCountryCode();

    try {
      Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      String saveDirPath =
          '${appDocumentsDir.path}/${AdType.splash.typeFileName}/${account.uid}-$countryCode/';
      final saveDir = Directory(saveDirPath);
      if (saveDir.existsSync()) {
        saveDir.deleteSync(recursive: true);
      }

      await _saveAdInfo(null, adType: AdType.splash);
    } catch (error) {
      LogUtils.e('HomeAdsManager clearSplashAdInfo error: $error');
    }
  }

  Future<bool> _saveAdInfo(Map<String, dynamic>? models,
      {OAuthModel? account,
      String? countryCode,
      AdType adType = AdType.homePage}) async {
    LogUtils.i('HomeAdsManager---for----MainRepository.saveAdInfo');
    account ??= await AccountModule().getAuthBean();
    countryCode ??= await LocalModule().getCountryCode();
    if (models == null) {
      LogUtils.d(
          'HomeAdsManager saveAdInfo ------  $countryCode ${account.uid}  ++++++ null');
      return await LocalStorage().putString(
          fileName: adType.typeFileName,
          '${account.uid}-$countryCode-${adType.typeKey}',
          '');
    } else {
      var value = jsonEncode(models);
      LogUtils.d(
          'HomeAdsManager saveAdInfo ------ $countryCode ${account.uid}  ++++++ $value');
      return await LocalStorage().putString(
          fileName: adType.typeFileName,
          '${account.uid}-$countryCode-${adType.typeKey}',
          value);
    }
  }

  /// 获取本地保存的广告展示信息
  /// key:id  value:下次需要展示时间
  Future<Map<String, dynamic>> getAdInfo(
      {OAuthModel? account,
      String? countryCode,
      AdType adType = AdType.homePage}) async {
    LogUtils.i('HomeAdsManager---for----MainRepository.getAdInfo');
    account ??= await AccountModule().getAuthBean();
    countryCode ??= await LocalModule().getCountryCode();
    var value = await LocalStorage().getString(
        fileName: adType.typeFileName,
        '${account.uid}-$countryCode-${adType.typeKey}');
    if (value == null || value == '' || value == '{}') {
      return <String, dynamic>{};
    }
    var map = jsonDecode(value);
    LogUtils.d(
        'HomeAdsManager getAdInfo ------ $countryCode ${account.uid} ++++++ $value');
    return map;
  }

  Future<bool> saveSplashAdInfo(ADModel adModel,
      {int popShowTime = 0,
      String? picFilePath,
      bool isClicked = false}) async {
    var saveAdModel = adModel;
    if (picFilePath?.isNotEmpty ?? false) {
      saveAdModel = adModel.copyWith(picFilePath: picFilePath);
    }

    final adInfoMap = <String, dynamic>{'adModel': saveAdModel};
    adInfoMap['popShowTime'] = popShowTime;
    adInfoMap['isClicked'] = isClicked;

    return _saveAdInfo(adInfoMap, adType: AdType.splash);
  }

  /// 过滤广告展示
  /// 当天弹过广告弹框一次，不再弹
  /// 下次不再展示的广告 showAgain = 0，不点击的话，根据弹出弹框的频率弹，点击了以后就以后不再弹出
  /// 下次需要展示的广告 showAgain = 1，根据弹出弹框的频率弹
  Future<List<ADModel>> _adsFilterShow(
      List<ADModel> adModels, Map<String, dynamic> adsInfoMap) async {
    List<ADModel> adShowModels = [];

    // 针对每个用户 地区， 广告弹框只能一天一次；
    var popShowTime = adsInfoMap['popShowTime'] ?? 0;
    var dateTime = DateTime.now();
    if (dateTime.millisecondsSinceEpoch <= popShowTime) {
      LogUtils.i('loadHomeAd show ------- popShowTime skip');
      return adShowModels;
    }

    for (ADModel element in adModels) {
      /// 过滤不需要展示的广告
      /// int type, // 0: 普通广告 1: 个性化广告
      /// int nextShowDay, // 下次弹框时间
      /// int showAgain, // 是否再次弹框 0:不弹 1:弹
      if (element.showAgain == 1) {
        /// 过滤弹框
        if (adsInfoMap.containsKey(element.id)) {
          var time = adsInfoMap[element.id] ?? 0;
          if (dateTime.millisecondsSinceEpoch >= time) {
            adShowModels.add(element);
          }
        } else {
          adShowModels.add(element);
        }
      } else {
        /// 过滤已经点击过的广告
        var time = adsInfoMap[element.id] ?? 0;
        if (time >= 0) {
          var time = adsInfoMap[element.id] ?? 0;
          if (dateTime.millisecondsSinceEpoch >= time) {
            adShowModels.add(element);
          }
        } else {
          // 点击过的广告，不再展示
        }
      }
    }
    return adShowModels;
  }

  /// 当今天弹过广告弹框，没有弹出来过的广告默认今天已弹出，一起计算下次弹框时间
  Future<void> updateAdShow(Map<String, dynamic> adsInfoMap,
      List<ADModel> adModels, OAuthModel oAuthBean, String countryCode) async {
    var adsInfoNewMap = <String, int>{};
    var dateTime = DateTime.now();
    var popShowTime = adsInfoMap['popShowTime'] ?? 0;
    if (popShowTime < dateTime.millisecondsSinceEpoch) {
      return;
    }
    var newSaveMap = <String, int>{};
    for (ADModel element in adModels) {
      var nextShowDay = element.nextShowDay == 0
          ? dateTime.millisecondsSinceEpoch
          : element.nextShowDay;
      // 今天要展示的广告，更新成今天的时间。 不展示的不更新，还记录上次的时间，上次时间没有，则记录今天（可能是今天展示过广告了，新增的广告不再展示）
      if (adsInfoMap.containsKey(element.id)) {
        adsInfoNewMap[element.id] = adsInfoMap[element.id] ?? nextShowDay;
      } else {
        newSaveMap[element.id] = nextShowDay;
        adsInfoNewMap[element.id] = nextShowDay;
      }
    }
    if (newSaveMap.isNotEmpty) {
      await ref.watch(mainRepositoryProvider).saveAdInfo(adsInfoNewMap,
          account: oAuthBean, countryCode: countryCode);
    }
  }

  Future<void> updateAdShowInfo(List<ADModel> adShowList) async {
    var oAuthBean = await AccountModule().getAuthBean();
    var countryCode = await LocalModule().getCountryCode();
    var adsInfoMap = await ref
        .watch(mainRepositoryProvider)
        .getAdInfo(account: oAuthBean, countryCode: countryCode);

    var dateTime = DateTime.now();
    var dataDay = DateTime(
        dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999, 999);

    for (ADModel element in adShowList) {
      var nextShowDay = element.nextShowDay == 0
          ? dateTime.millisecondsSinceEpoch
          : element.nextShowDay;
      // 今天要展示的广告，更新成今天的时间。 不展示的不更新，还记录上次的时间，上次时间没有，则记录今天（可能是今天展示过广告了，新增的广告不再展示）
      adsInfoMap[element.id] = nextShowDay;
    }
    if (adShowList.isNotEmpty) {
      adsInfoMap['popShowTime'] = dataDay.millisecondsSinceEpoch;
    }
    await ref
        .watch(mainRepositoryProvider)
        .saveAdInfo(adsInfoMap, account: oAuthBean, countryCode: countryCode);
  }
}
