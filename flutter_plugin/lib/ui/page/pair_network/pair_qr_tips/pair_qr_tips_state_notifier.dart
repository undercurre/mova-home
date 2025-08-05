import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'pair_qr_tips_uistate.dart';

part 'pair_qr_tips_state_notifier.g.dart';

@riverpod
class PairQrTipsStateNotifier extends _$PairQrTipsStateNotifier {
  @override
  PairQrTipsUiState build() {
    return const PairQrTipsUiState();
  }

  Future<void> initData() async {
    state = state.copyWith(
        currentStep: IotPairNetworkInfo().currentStep,
        totalSteps: IotPairNetworkInfo().totalStep);
    try {
      await animPath();
    } catch (e) {
      LogUtils.e('Exception error: $e');
    }
  }

  Future<void> animPath() async {
    final isZh = await LocalModule().getLangTag() == 'zh';
    var isOppo = false;
    var manualAnimPath = '';
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      isOppo = androidInfo.manufacturer.toUpperCase() == 'oppo'.toUpperCase() ||
          androidInfo.fingerprint.toUpperCase() == 'oppo'.toUpperCase();
      manualAnimPath = isZh
          ? ref
              .watch(resourceModelProvider)
              .getResource('anim_qr_connect_tips_android_zh', suffix: '.json')
          : ref
              .watch(resourceModelProvider)
              .getResource('anim_qr_connect_tips_android_en', suffix: '.json');
      if (isOppo) {
        manualAnimPath = isZh
            ? ref.watch(resourceModelProvider).getResource(
                'anim_qr_connect_tips_android_zh_oppo',
                suffix: '.json')
            : ref.watch(resourceModelProvider).getResource(
                'anim_qr_connect_tips_android_en_oppo',
                suffix: '.json');
      }
    } else if (Platform.isIOS) {
      manualAnimPath = isZh
          ? ref
              .watch(resourceModelProvider)
              .getResource('anim_qr_connect_tips_ios_zh', suffix: '.json')
          : ref
              .watch(resourceModelProvider)
              .getResource('anim_qr_connect_tips_ios_en', suffix: '.json');
    }
    state = state.copyWith(manualAnimPath: manualAnimPath);
  }

  /// 旧协议
  /// "Uy024060#cn#10000#19973#Asia\/Shanghai#qkey#zh-cn"
  /// 新协议
  ///"Uy024060#cn#10000#19973#Asia\/Shanghai#qkey#zh-cn#10000.mt.cn.iot.dreame.tech"
  Future<String> generatePairQRValue(PairDomainModel domainRes) async {
    var user = await AccountModule().getUserInfo();
    var region = IotPairNetworkInfo().region!;
    var timezone = await FlutterTimezone.getLocalTimezone();
    var lang = await LocalModule().getLangTag();
    var domainPrefix = '';
    var port = '';
    if (domainRes.regionUrl != null) {
      domainPrefix = domainRes.regionUrl!.split('.').first;
      port = domainRes.regionUrl!.split(':').last;
    }
    int index = domainRes.regionUrl?.indexOf(port) ?? -1;
    final domain1 = index != -1
        ? domainRes.regionUrl?.substring(0, index - 1)
        : domainRes.regionUrl;
    var content =
        '${user?.uid}#$region#$domainPrefix#$port#$timezone#${domainRes.pairQRKey}#$lang#${domain1}';
    var pairQrJson = {
      's': IotPairNetworkInfo().routerWifiName,
      'p': IotPairNetworkInfo().routerWifiPwd,
      'd': content
    };
    return Future.value(jsonEncode(pairQrJson));
  }

  void toggleEnableBtn() {
    state = state.copyWith(enableBtn: !state.enableBtn);
  }
}
