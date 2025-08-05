import 'dart:convert';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_network_repository.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_code/pair_qr_code_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pair_qr_code_state_notifier.g.dart';

@riverpod
class PairQrCodeStateNotifier extends _$PairQrCodeStateNotifier {
  @override
  PairQrCodeUiState build() {
    return const PairQrCodeUiState();
  }

  Future<void> initData() async {
    state = state.copyWith(
        currentStep: IotPairNetworkInfo().currentStep,
        totalSteps: IotPairNetworkInfo().totalStep);
    await queryQRCodeKey();
  }

  Future<void> queryQRCodeKey() async {
    try {
      state = state.copyWith(showLoading: true);
      PairDomainModel result = await ref
          .read(pairNetworkRepositoryProvider)
          .getMqttDomainV2(IotPairNetworkInfo().region!, true);
      IotPairNetworkInfo().pairQRKey = result.pairQRKey;
      var pairQrValue = await generatePairQRValue(result);
      state = state.copyWith(showLoading: false);
      state = state.copyWith(pairQRValue: pairQrValue);
    } on DreameAuthException catch (e) {
      state = state.copyWith(showLoading: false);
      LogUtils.d('DreameAuthException error: ${e.code}');
    } catch (e) {
      state = state.copyWith(showLoading: false);
      LogUtils.d('Exception error: $e');
    }
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
