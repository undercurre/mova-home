
import 'dart:math';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_ble_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_bt_wifi_state_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_device_cache_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_device_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_permission_request_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_wifi_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/product_list/product_list_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/qr_scan_page.dart';
import 'package:flutter_plugin/ui/widget/pair/scanned_device_item.dart'
    as scan_device_item;
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProductListPage extends BasePage {
  static const String routePath = '/product_list';

  const ProductListPage({super.key});

  @override
  ProductListPageState createState() => ProductListPageState();
}

class ProductListPageState extends BasePageState
    with
        IotScanPermissionRequestMixin,
        IotScanDeviceCacheMixin,
        IotBtWifiStateMixin,
        IotBleScannerMixin,
        IotWiFiScannerMixin,
        IotScanDeviceMixin {
  final double _rightSeriesTitleHeight = 40;
  final double _leftSeriesTitleHeight = 32;
  final double _leftSeriesItemHeight = 52;
  final int _gridViewCrossAxisCount = 2;
  double scannedAnimHeight = 0;
  double gridPaddingBottom = 0;
  bool _isDisabled = false;
  double _leftScrollViewmaxHeight = 0;
  String model = '';

  final _leftScrollController = ScrollController(debugLabel: 'category left');

  final _rightScrollController = ItemScrollController();
  final scrollOffsetController = ScrollOffsetController();
  final itemPositionsListener = ItemPositionsListener.create();
  final scrollOffsetListener = ScrollOffsetListener.create();

  @override
  String get centerTitle => 'qr_text_add_manually'.tr();

  @override
  Widget get rightItemWidget => SizedBox(
        width: 60,
        height: 52,
        child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            ref.read(resourceModelProvider).getResource('btn_developer_scan'),
            width: 24,
            height: 24,
          ),
        ),
      ).onClick(() {
        var index = Navigator.of(context)
            .widget
            .pages
            .indexWhere((element) => element.name == QrScanPage.routePath);
        if (index == -1) {
          AppRoutes().push(QrScanPage.routePath);
        } else {
          AppRoutes().pop();
        }
      });

  @override
  void initData() {
    super.initData();
    ref.read(productListStateNotifierProvider.notifier).initData();
    stepChainCheckPermission();
    ref.read(productListStateNotifierProvider.notifier).reportPushToPage();
    final arguments =
        AppRoutes().getGoRouterStateExtra<Map<String, dynamic>>(context);
    LogUtils.i('ProductListPage initData arguments: $arguments');
    if (arguments != null) {
      model = arguments['model'] ?? '';
    }
  }

  @override
  void onAppResumeAndActive() {}

  @override
  void updateScanDeviceList(List<IotDevice> scanList) {
    if (mounted) {
      ref
          .read(productListStateNotifierProvider.notifier)
          .updateScanDeviceList(scanList);
    }
  }

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(rightItemPositionsListener);
  }

  var preItemPositionIndex = 0;
  var preSection = 0;
  var preIndex = 0;
  final Map<int, Map<int, GlobalKey>> _itemKeys = {};

  Future<void> rightItemPositionsListener() async {
    if (!mounted) {
      return;
    }
    final itemPosition = itemPositionsListener.itemPositions.value
        .where((element) => element.itemLeadingEdge <= 0 /*部分可见 或者 完整可见*/)
        .firstOrNull;

    // 所有可见的item
    final index = itemPosition?.index ?? -1;
    if (preItemPositionIndex == index || index == -1) {
      return;
    }
    preItemPositionIndex = index;
    final seriesOfProduct = ref.read(productListStateNotifierProvider
        .select((value) => value.productList))[index];
    final menuList = ref.read(
        productListStateNotifierProvider.select((value) => value.menuList));
    for (int section = 0; section < menuList.length; section++) {
      var index = 0;
      // 如果由外部传入的model 则优先根据外部传入的model定位到具体的菜单位置
      if (model.isNotEmpty) {
        for (var element in menuList[section].childrenList) {
          for (int i = 0; i < element.productList.length; i++) {
            if (element.productList[i].model == model) {
              index = i;
            }
          }
        }
        LogUtils.i('ProductListPage initState 如果由外部传入的model: $index');
      } else {
        index = menuList[section].childrenList.indexWhere(
            (element) => element.categoryId == seriesOfProduct.categoryId);
        LogUtils.i('ProductListPage initState 默认流程提取的index: $index');
      }

      if (index >= 0) {
        ref
            .read(productListStateNotifierProvider.notifier)
            .setSelectedIdx(IndexPath(section: section, index: index));
        await scrollLeftGroupListview(section, index);
        return;
      }
    }
  }

  Future<void> scrollLeftGroupListview(int section, int index) async {
    try {
      // 这两种也可以保证item可见, 缺点就是上滑到第一个分类的第一个系列时, 会有一个title的高度的偏移
      final currentContext = _itemKeys[section]?[index]?.currentContext;
      if (currentContext != null) {
        currentContext.findRenderObject()?.showOnScreen();
        // Scrollable.ensureVisible(currentContext);
      }
      if (section == 0 && index == 0) {
        // 保证上滑时第一个分类的的title不会被遮挡
        await _leftScrollController.animateTo(-_leftSeriesTitleHeight,
            duration: const Duration(milliseconds: 100), curve: Curves.ease);
      }
    } catch (e) {
      LogUtils.e('scrollToIndex error: $e');
    }
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        productListStateNotifierProvider.select((value) => value.loading),
        (previous, next) {
      next ? showLoading() : dismissLoading();
    });
  }

  @override
  void onStopCallback(StepId stepId) {
    if (isVisible()) {
      startScanDevice();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    ref.read(productListStateNotifierProvider.notifier).reportPopToPage();
  }

  @override
  void dispose() {
    _leftScrollController.dispose();
    itemPositionsListener.itemPositions
        .removeListener(rightItemPositionsListener);
    super.dispose();
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);
    if (event == LifecycleEvent.active) {
      LogUtils.d('-----sunzhibin------ active ----------- :$this');
      startScanDevice();
    } else if (event == LifecycleEvent.inactive) {
      LogUtils.d('-----sunzhibin------ inactive ----------- :$this');
      stopScanDevice();
    }
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    var scannedList = ref.watch(productListStateNotifierProvider).scannedList;
    scannedAnimHeight = scannedList.isNotEmpty ? 122 : 0;
    return Column(
      children: [
        AnimatedContainer(
          color: style.bgWhite,
          height: scannedAnimHeight,
          duration: const Duration(milliseconds: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text('text_nearby_devices'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: style.textSecondGray,
                      )),
                ),
              ),
              Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 6,
                child: ListView.separated(
                  itemCount: scannedList.length,
                  itemBuilder: (context, index) {
                    var iotDevice = scannedList[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 20 : 0,
                          right: scannedList.length - 1 == index ? 20 : 0),
                      child: scan_device_item.ScannedDeviceItem(
                        iotDevice: iotDevice,
                        position: scan_device_item.ItemPosition.productList,
                        onSelect: () async {
                          await ref
                              .watch(productListStateNotifierProvider.notifier)
                              .gotoNextPage(iotDevice, iotDevice.product!);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 8);
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Expanded(flex: 1, child: Container()),
              Container(
                color: style.gray3,
                height: 0.5,
                width: double.infinity,
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: LayoutBuilder(builder: (_, constraints) {
                  return _buildSeriesMenuList(
                      context, style, resource, constraints);
                }),
              ),
              Expanded(
                flex: 7,
                child: LayoutBuilder(builder: (_, constraints) {
                  return _buildProductList(
                      context, style, resource, constraints);
                }),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSeriesMenuList(BuildContext context, StyleModel style,
      ResourceModel resource, BoxConstraints constraints) {
    var menuList = ref.watch(productListStateNotifierProvider).menuList;
    var selectedIdx = ref.watch(productListStateNotifierProvider).selectedIdx;
    _leftScrollViewmaxHeight = constraints.constrainHeight();
    for (int i = 0; i < menuList.length; i++) {
      _itemKeys[i] = {};
      for (int j = 0; j < menuList[i].childrenList.length; j++) {
        _itemKeys[i]![j] = GlobalKey(debugLabel: 'category $i $j');
      }
    }
    return Container(
      color: style.bgBlack,
      alignment: Alignment.topCenter,
      height: _leftScrollViewmaxHeight,
      child: GroupListView(
        controller: _leftScrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        itemBuilder: (context, index) {
          bool isSelected = selectedIdx?.row == index.index &&
              selectedIdx?.section == index.section;
          return _buildMenuItem(context, style, resource, index, isSelected);
        },
        groupHeaderBuilder: (context, section) {
          return Container(
            height: _leftSeriesItemHeight,
            alignment: Alignment.center,
            child: Text(
              menuList[section].name,
              style: TextStyle(
                  color: style.textMainBlack,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
        sectionsCount: menuList.length,
        countOfItemInSection: (section) {
          return menuList[section].childrenList.length;
        },
      ),
    );
  }

  Widget _buildProductList(BuildContext context, StyleModel style,
      ResourceModel resource, BoxConstraints constraints) {
    var productList = ref.watch(productListStateNotifierProvider).productList;
    if (productList.isNotEmpty) {
      var height1 = MediaQuery.of(context).size.height * 185 / 844;
      var childAspectRatio = 139 / height1;
      final itemWidth = constraints.maxWidth / _gridViewCrossAxisCount;
      final height = itemWidth / childAspectRatio;
      final lastItemHeight = _rightSeriesTitleHeight +
          (productList.last.productList.length ~/ _gridViewCrossAxisCount +
                  productList.last.productList.length %
                      _gridViewCrossAxisCount) *
              height;
      gridPaddingBottom =
          constraints.constrainHeight() - lastItemHeight + 4 /*offset*/;
      gridPaddingBottom = gridPaddingBottom < 0 ? 0 : gridPaddingBottom;
    }
    return Container(
      color: style.bgWhite,
      alignment: Alignment.topCenter,
      child: ScrollablePositionedList.builder(
        padding: EdgeInsets.zero,
        itemCount: productList.length,
        itemScrollController: _rightScrollController,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        itemBuilder: (context, index) {
          var seriesTitle = productList[index].name;
          var seriesProducts = productList[index].productList;
          return Column(
            children: [
              _buildSeriesTitle(context, style, seriesTitle),
              _buildProductGridView(context, style, resource, seriesProducts),
              index == productList.length - 1
                  ? SizedBox(
                      height: gridPaddingBottom,
                    )
                  : const SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductGridView(BuildContext context, StyleModel style,
      ResourceModel resource, List<Product> products) {
    var height = MediaQuery.of(context).size.height * 185 / 844;
    var childAspectRatio = 139 / height;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridViewCrossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var product = products[index];
        return InkWell(
            onTap: () async {
              if (!_isDisabled) {
                _isDisabled = true;
                await ref
                    .watch(productListStateNotifierProvider.notifier)
                    .gotoNextPage(null, product);
                _isDisabled = false;
              }
            },
            child: _buildProductItem(context, style, resource, product));
      },
      itemCount: products.length,
    );
  }

  Size _measureTextSize(String text) {
    // 创建 TextPainter 对象
    final textPainter = TextPainter(
        textDirection: Directionality.of(context),
        text: TextSpan(
            text: text,
            style:
                const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500)),
        maxLines: 2);
    // 进行布局计算
    textPainter.layout();
    // 获取文本的高度
    return textPainter.size;
  }

  Widget _buildProductItem(BuildContext context, StyleModel style,
      ResourceModel resource, Product product) {
    return RepaintBoundary(
      child: LayoutBuilder(builder: (context, constraints) {
        var heightRatio = MediaQuery.of(context).size.height / 844;
        final textHeight = _measureTextSize(product.displayName).height + 16;
        var topPadding = 26 * heightRatio;
        topPadding = min(20, topPadding);

        var middlePadding = 16 * heightRatio;
        middlePadding = min(12, middlePadding);

        var bottomPadding = 20 * heightRatio;
        bottomPadding = min(16, bottomPadding);

        var imageHeight = 95 * heightRatio;
        var imgHeight = constraints.maxHeight -
            textHeight -
            topPadding -
            middlePadding -
            bottomPadding;
        imageHeight = min(imgHeight, imageHeight);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: topPadding, bottom: middlePadding),
              child: (product.mainImage?.imageUrl ?? '').isEmpty == true
                  ? Image.asset(resource.getResource('ic_placeholder_robot'),
                      width: imageHeight, height: imageHeight)
                  : CachedNetworkImage(
                      imageUrl: product.mainImage?.imageUrl ?? '',
                      width: imageHeight,
                      height: imageHeight,
                      memCacheHeight: 300,
                      fit: BoxFit.fitHeight,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                product.displayName,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: style.textMainBlack),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildSeriesTitle(
      BuildContext context, StyleModel style, String title) {
    return Container(
      height: _rightSeriesTitleHeight,
      alignment: Alignment.bottomCenter,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: style.textMainBlack,
              width: 30,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: style.textMainBlack,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              color: style.textMainBlack,
              width: 30,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, StyleModel style,
      ResourceModel resource, IndexPath idxPath, bool isSelected) {
    var menuItem = ref
        .watch(productListStateNotifierProvider)
        .menuList[idxPath.section]
        .childrenList[idxPath.index];
    return GestureDetector(
      onTap: () async {
        // 点击滑动
        var count = 0;
        for (int i = 0; i < idxPath.section; i++) {
          count += ref
              .watch(productListStateNotifierProvider)
              .menuList[i]
              .childrenList
              .length;
        }
        final index = count + idxPath.index;
        ref
            .read(productListStateNotifierProvider.notifier)
            .setSelectedIdx(idxPath);
        // 滑动到指定位置
        _rightScrollController.jumpTo(index: index);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        key: _itemKeys[idxPath.section]?[idxPath.index],
        color: isSelected ? style.bgWhite : Colors.transparent,
        height: _leftSeriesItemHeight,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              menuItem.name,
              style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? style.textMain : style.textSecond,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
