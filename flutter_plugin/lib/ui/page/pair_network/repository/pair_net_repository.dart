import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_network_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class PairNetRepository {
  var repository = PairNetworkRepository(ApiClient());

  /// 是否绑定过uid
  ///  0:未绑定过
  ///  1:绑定的是别人
  ///  2:绑定的是自己
  Future<bool?> checkDeviceBindOther(String did) async {
    try {
      var bind = await repository.checkDeviceBind(did);
      LogUtils.i('PairNetRepository checkDeviceBind result: $bind');
      return bind == 1;
    } catch (e) {
      LogUtils.e('PairNetRepository checkDeviceBind error: $e');
    }
    return null;
  }

  Future<bool> getDevicePair(String did) async {
    try {
      var result = await repository.getDevicePair(did);
      LogUtils.i('PairNetRepository checkDeviceBind result: $result');
      return result;
    } catch (e) {
      LogUtils.e('PairNetRepository checkDeviceBind error: $e');
    }
    return false;
  }

  /// 牙刷配网接口
  Future<bool> postDevicePairByNonce(Map<String, dynamic> map) async {
    try {
      final did = map['did'] ?? '';
      final mac = map['mac'] ?? '';
      final ver = map['ver'] ?? '';
      final nonce = map['nonce'] ?? '';
      final encryptUid = map['encryptContent'] ?? '';
      final model = IotPairNetworkInfo().selectIotDevice?.product?.model ??
          IotPairNetworkInfo().product?.model ??
          '';
      final property = map;
      final region = await LocalModule().serverSite();
      var bindDomain = await repository.getMqttDomainV2(region, false);
      final req = PairNonceRequest(
          did: did,
          model: model,
          nonce: nonce,
          bindDomain: bindDomain.regionUrl,
          mac: mac,
          ver: ver,
          encryptUid: encryptUid,
          property: property);
      var result = await repository.postDevicePairByNonce(req);
      LogUtils.i(
          'PairNetRepository postDevicePairByNonce result: $result ,req:$req');
      return result;
    } catch (e) {
      LogUtils.e('PairNetRepository postDevicePairByNonce error: $e');
    }
    return false;
  }

  /// postDevicePair4Ble
  Future<int> postDevicePair4Ble(Map<String, dynamic> map) async {
    try {
      final propertyMap = {};
      propertyMap.addAll(map);
      final did = map.remove('did') ?? '';
      final mac = map.remove('mac') ?? '';
      final ver = map.remove('ver') ?? '';
      final secret = map.remove('secret') ?? '';
      final model = IotPairNetworkInfo().selectIotDevice?.product?.model ??
          IotPairNetworkInfo().product?.model ??
          '';
      final property = propertyMap;
      final region = await LocalModule().serverSite();
      var bindDomain = await repository.getMqttDomainV2(region, false);
      final req = <String, dynamic>{
        'did': did,
        'mac': mac,
        'ver': ver,
        'secret': secret,
        'model': model,
        'property': property,
        'bindDomain': bindDomain.regionUrl,
      };
      var ret = await repository.postDevicePair4Ble(req);
      LogUtils.i(
          'PairNetRepository postDevicePairByNonce result: $ret ,req:$req');
      return ret == true ? 0 : -1;
    } catch (e) {
      LogUtils.e('PairNetRepository pairNet error: $e');
      if (e is DreameException) {
        return e.code;
      }
    }
    return -1;
  }
}
