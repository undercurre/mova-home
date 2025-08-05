// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'pair_network_repository.g.dart';

class PairNetworkRepository {
  final ApiClient apiClient;

  PairNetworkRepository(this.apiClient);

  Future<List<KindOfProduct>> getProductCategory() async {
    return processApiResponse<List<KindOfProduct>>(apiClient.productCategory());
  }

  Future<List<Product>> getProductInfoByPids(String pids) async {
    var result =
    processApiResponse<List<Product>>(apiClient.getProductInfoByPids(pids));
    return result;
  }

  Future<List<Product>> getProductInfoByModels(String models) async {
    var result = processApiResponse<List<Product>>(
        apiClient.getProductInfoByModels(models));
    return result;
  }

  Future<Product> checkModel(String model) async {
    var result = processApiResponse<Product>(apiClient.checkModel(model));
    return result;
  }

  Future<bool> getDevicePair(String did) async {
    var result =
    processApiResponse<bool>(apiClient.getDevicePair({'did': did}));
    return result;
  }

  Future<PairDomainModel> getMqttDomainV2(
      String region, bool qrCodePair) async {
    var result = processApiResponse<PairDomainModel>(
        apiClient.getMqttDomainV2(region, qrCodePair));
    return result;
  }

  Future<dynamic> postDevicePairByNonce(PairNonceRequest req) async {
    var result =
    processApiResponse<dynamic>(apiClient.postDevicePairByNonce(req));
    return result;
  }

  Future<dynamic> postDevicePair4Ble(Map<String, dynamic> req) async {
    var result = processApiResponse<dynamic>(apiClient.postDevicePair4Ble(req));
    return result;
  }

  Future<dynamic> getDevicePair2(Map<String, dynamic> req) async {
    var result = processApiResponse<dynamic>(apiClient.getDevicePair(req));
    return result;
  }

  Future<List<PairGuideModel>> getPairGuideList(String productId) async {
    var result = await processApiResponse<PairGuideWrapper>(
        apiClient.getPairGuideList(productId));
    return result.content;
  }

  Future<PairQrCheck> getDeviceQRPair(String pairQRKey) async {
    var result = processApiResponse<PairQrCheck>(
        apiClient.getDeviceQRPair({'pairQRKey': pairQRKey}));
    return result;
  }

  Future<int> checkDeviceBind(String did) async {
    var result =
    processApiResponse<int>(apiClient.checkDeviceBind({"did": did}));
    return result;
  }
}

@riverpod
PairNetworkRepository pairNetworkRepository(PairNetworkRepositoryRef ref) {
  return PairNetworkRepository(ref.watch(apiClientProvider));
}
