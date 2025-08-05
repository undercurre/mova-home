import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/mixin/pair_net_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_network_repository.dart';
import 'package:flutter_plugin/ui/page/pair_network/product_list/product_list_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_list_state_notifier.g.dart';

@riverpod
class ProductListStateNotifier extends _$ProductListStateNotifier
    with PairNetMixin {
  @override
  ProdcutListUiState build() {
    return ProdcutListUiState();
  }

  Future<void> initData() async {
    try {
      await getAllProducts();
    } catch (e) {
      LogUtils.e('initData error: $e');
    }
  }

  void updateScanDeviceList(List<IotDevice> scanList) {
    state = state.copyWith(scannedList: scanList);
  }

  Future<void> getAllProducts() async {
    var categories =
        await ref.read(pairNetworkRepositoryProvider).getProductCategory();
    List<SeriesOfProduct> productList = [];
    List<KindOfProduct> menuList = [];
    Map<String, DMIndexPath> menuMap = {};
    var allKinds =
        categories.where((element) => element.childrenList.isNotEmpty).toList();
    allKinds.asMap().forEach((key, value) {
      var series = value.childrenList;
      if (series.isNotEmpty) {
        List<SeriesOfProduct> mutableSeries = List.from(series);
        series.asMap().forEach((idx, item) {
          if (item.isValid) {
            productList.add(item);
            var finalIdx = mutableSeries.indexOf(item);
            menuMap[item.categoryId] = DMIndexPath(section: key, row: finalIdx);
          } else {
            var index = mutableSeries
                .indexWhere((element) => element.name == item.name);
            if (index != -1) {
              mutableSeries.removeAt(index);
            }
          }
        });
        if (mutableSeries.isNotEmpty) {
          var mutableKind = KindOfProduct(
              categoryId: value.categoryId,
              categoryOrder: value.categoryOrder,
              name: value.name,
              childrenList: mutableSeries);
          menuList.add(mutableKind);
        }
      }
    });
    state = state.copyWith(
        menuList: menuList,
        productList: productList,
        menuIndexPath: menuMap,
        selectedIdx: DMIndexPath(section: 0, row: 0));
  }

  void updateSelctedIdx(List offsetSectionList, double offset) {
    var menuMap = state.menuIndexPath;
    var productList = state.productList;
    if (offsetSectionList.last <= offset) {
      state = state.copyWith(selectedIdx: menuMap[productList.last.categoryId]);
    } else {
      for (int i = 1; i < offsetSectionList.length; i++) {
        if (offsetSectionList[i] > offset + 0.1) {
          var categoryId = productList[i - 1].categoryId;
          state = state.copyWith(selectedIdx: menuMap[categoryId]);
          break;
        }
      }
    }
  }

  int setSelectedIdx(IndexPath idxPath) {
    var menuItem = state.menuList[idxPath.section].childrenList[idxPath.index];
    int index = state.productList
        .indexWhere((element) => element.categoryId == menuItem.categoryId);
    var selectedPath =
        DMIndexPath(section: idxPath.section, row: idxPath.index);
    state = state.copyWith(selectedIdx: selectedPath);
    return index;
  }

  /// 跳转到下一页，开始配网
  /// iotDevice !=null,表示是附近扫描的设备
  Future<void> gotoNextPage(IotDevice? iotDevice, Product product) async {
    pairEntry.product = product;
    pairEntry.pairEntrance = iotDevice != null
        ? IotPairEntrance.nearby
        : IotPairEntrance.productList;
    pairEntry.selectIotDevice = iotDevice;
    pairEntry.deviceSsid = iotDevice?.wifiSsid;
    // 配网来源上报
    LogModule().eventReport(15, 1, int1: pairEntry.pairEntrance.code - 1);

    await gotoPairNet(product, () {
      state = state.copyWith(loading: true);
    }, () {
      state = state.copyWith(loading: false);
    });
  }

  void reportPushToPage() {
    LogModule().eventReport(15, 16,
        str1: pairEntry.sessionID ?? '', str2: 'ProductListPage');
  }

  void reportPopToPage() {
    var startTime = int.parse(pairEntry.sessionID ?? '');
    var endTime = DateTime.timestamp().millisecondsSinceEpoch;
    var takeTime = (endTime - startTime) ~/ 1000;
    LogModule().eventReport(15, 17,
        str1: pairEntry.sessionID ?? '',
        int1: takeTime,
        str2: 'ProductListPage');
  }
}
