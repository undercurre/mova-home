import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/help_center/manual/product_manual_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/model/after_sale_item.dart';
import 'package:flutter_plugin/ui/page/help_center/model/app_faq.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/faq_cell.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/help_center_setting_cell.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class ProductManualPage extends BasePage {
  static const String routePath = '/product_manual_page';
  HelpCenterProduct product;

  ProductManualPage({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ProductManualPage();
  }
}

class _ProductManualPage extends BasePageState<ProductManualPage>
    with CommonDialog, ResponseForeUiEvent {

  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  Map<String, FlickManager> _flickManagers = {};
  List<String> _mediaUrlList = [];
  bool _isDisposed = false;
  static const int MAX_CONCURRENT_PLAYERS = 2; // 限制最大同时播放器数量
  Map<String, bool> _isPreloading = {};
  bool _isFullscreen = false;
  bool _isPlaying = false;
  final ValueNotifier<int> _pageNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
  }

  @override
  String get centerTitle => 'user_help'.tr();

  @override
  Color? get backgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  Color? get navBackgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  void initData() {
    ref
        .read(productManualStateNotifierProvider.notifier)
        .loadData(widget.product);
  }

  @override
  void dispose() {
    UIModule().lockOrientation(false);
    _isDisposed = true;
    _disposeAllVideoPlayers();
    super.dispose();
  }

  void _disposeAllVideoPlayers() {
    for (var manager in _flickManagers.values) {
      manager.flickControlManager?.autoPause();
      manager.dispose();
    }
    _flickManagers.clear();
    _isPreloading.clear();
  }

  Future<void> _initializeVideoPlayer(String url) async {
    if (_isDisposed) return;

    // 如果正在预加载，直接返回
    if (_isPreloading[url] == true) return;

    // 如果已经存在播放器，检查是否需要重新初始化
    if (_flickManagers.containsKey(url)) {
      final manager = _flickManagers[url];
      if (manager?.flickVideoManager?.isVideoInitialized == true) {
        return;
      }
    }

    _isPreloading[url] = true;

    try {
      // 如果超过最大播放器数量，先释放最远的播放器
      if (_flickManagers.length >= MAX_CONCURRENT_PLAYERS) {
        _disposeFurthestPlayers();
      }

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      await controller.initialize();

      if (_isDisposed) {
        controller.dispose();
        return;
      }

      var flickManager = FlickManager(
        videoPlayerController: controller,
        autoPlay: false,
        autoInitialize: true,
      );

      // 添加全屏状态监听
      flickManager.flickControlManager?.addListener(() {
        final isFullscreen =
            flickManager.flickControlManager?.isFullscreen ?? false;
        final isPlaying = flickManager.flickVideoManager?.isPlaying ?? false;
        if (_isFullscreen != isFullscreen) {
          setState(() {
            _isFullscreen = isFullscreen;
          });
        } else {
          UIModule().lockOrientation(false);
        }
        if (_isPlaying != isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      });

      _flickManagers[url] = flickManager;
      if (mounted) setState(() {});
    } catch (e) {
      LogUtils.e('Video initialization error: $e');
      if (mounted) setState(() {});
    } finally {
      _isPreloading[url] = false;
    }
  }

  void _disposeFurthestPlayers() {
    if (_mediaUrlList.isEmpty) return;

    // 计算每个播放器到当前索引的距离
    final distances = _flickManagers.keys.map((url) {
      final index = _mediaUrlList.indexOf(url);
      if (index == -1) return MapEntry(url, double.infinity);
      return MapEntry(url, (_currentIndex - index).abs().toDouble());
    }).toList();

    // 按距离排序
    distances.sort((a, b) => b.value.compareTo(a.value));

    // 释放最远的播放器，直到数量符合限制
    while (_flickManagers.length >= MAX_CONCURRENT_PLAYERS) {
      final urlToRemove = distances.removeLast().key;
      _flickManagers[urlToRemove]?.dispose();
      _flickManagers.remove(urlToRemove);
    }
  }

  void _preloadAdjacentVideos() {
    if (_mediaUrlList.isEmpty) return;

    // 预加载当前视频的前后各一个视频
    final indicesToPreload = [
      _currentIndex - 1,
      _currentIndex + 1,
    ].where((index) => index >= 0 && index < _mediaUrlList.length);

    for (final index in indicesToPreload) {
      final url = _mediaUrlList[index];
      if (isVideoPath(url)) {
        _initializeVideoPlayer(url);
      }
    }
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        productManualStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      if (mounted) responseFor(next);
    });
    ref.listen(
        productManualStateNotifierProvider
            .select((value) => value.displayMediaList), (previous, next) {
      final mediaList = next ?? [];
      _mediaUrlList = mediaList.map((e) => e.filePath ?? '').toList();

      // 清理不需要的视频播放器
      final currentUrls = Set<String>.from(_mediaUrlList);
      final keysToRemove =
          _flickManagers.keys.where((key) => !currentUrls.contains(key));
      for (var key in keysToRemove) {
        _flickManagers[key]?.dispose();
        _flickManagers.remove(key);
      }

      // 初始化当前视频和预加载相邻视频
      if (_mediaUrlList.isNotEmpty) {
        final currentUrl = _mediaUrlList[_currentIndex];
        if (isVideoPath(currentUrl)) {
          _initializeVideoPlayer(currentUrl);
        }
        _preloadAdjacentVideos();
      }
    });
  }

  bool isVideoPath(String? filePath) {
    if (filePath == null) return false;
    return filePath.endsWith('.mp4') ||
        filePath.endsWith('.mov') ||
        filePath.endsWith('.avi');
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);
    if (event == LifecycleEvent.inactive) {
      for (var manager in _flickManagers.values) {
        manager.flickControlManager?.autoPause();
      }
    }
  }

  void onPageChange(index, reason) {
    if (!mounted) return;
    _currentIndex = index;
    _pageNotifier.value = index;

    // 更新视频播放状态
    for (int i = 0; i < _mediaUrlList.length; i++) {
      final key = _mediaUrlList[i];
      final manager = _flickManagers[key];
      if (manager != null) {
        if (i == _currentIndex) {
          manager.flickControlManager?.autoResume();
        } else {
          if (manager.flickVideoManager?.isPlaying == true) {
            manager.flickControlManager?.autoPause();
          }
        }
      }
    }

    // 预加载相邻视频
    _preloadAdjacentVideos();
  }

  Widget buildHeader(String title) {
    final style = ref.watch(styleModelProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: style.secondStyle(fontSize: 16),
            )
          ]),
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Platform.isIOS
        ? buildContent(context, style, resource)
        : WillPopScope(
            onWillPop: () async {
              bool isHandling = false;
              for (var key in _mediaUrlList) {
                final flickManager = _flickManagers[key];
                // 正在播放，则暂停
                if (flickManager != null &&
                    flickManager.flickVideoManager?.isPlaying == true) {
                  await flickManager.flickControlManager?.pause();
                }
                // 正在全屏，则退出全屏
                if (flickManager != null &&
                    flickManager.flickControlManager?.isFullscreen == true) {
                  flickManager.flickControlManager?.exitFullscreen();
                  isHandling = true;
                }
              }
              if (isHandling) {
                return false;
              }
              return true;
            },
            child: buildContent(context, style, resource));
  }

  Widget _buildVideoPlayer(
      int index, StyleModel style, ResourceModel resource) {
    final videoUrl = _mediaUrlList[index];
    final flickManager = _flickManagers[videoUrl];
    final isPreloading = _isPreloading[videoUrl] ?? false;

    if (isPreloading) {
      return AspectRatio(
        aspectRatio: 350 / 197,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.8,
              child: Center(
                child: (widget.product.mainImage?.imageUrl ?? '').isEmpty ==
                        true
                    ? Image.asset(resource.getResource('ic_placeholder_robot'))
                    : CachedNetworkImage(
                        imageUrl: widget.product.mainImage?.imageUrl ?? '',
                        errorWidget: (context, string, _) {
                          return Image.asset(
                            resource.getResource('ic_placeholder_robot'),
                          );
                        },
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: style.brandGoldColor,
              ),
            )
          ],
        ),
      );
    }

    return flickManager?.flickVideoManager?.isVideoInitialized == true
        ? AspectRatio(
            aspectRatio: 350 / 197,
            child: FlickVideoPlayer(
              key: ValueKey(videoUrl),
              flickManager: flickManager!,
              flickVideoWithControls: const FlickVideoWithControls(
                controls: FlickPortraitControls(),
                videoFit: BoxFit.contain,
              ),
            ),
          )
        : AspectRatio(
            aspectRatio: 350 / 197,
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.8,
                  child: Center(
                    child: (widget.product.mainImage?.imageUrl ?? '').isEmpty ==
                            true
                        ? Image.asset(
                            resource.getResource('ic_placeholder_robot'))
                        : CachedNetworkImage(
                            imageUrl: widget.product.mainImage?.imageUrl ?? '',
                            errorWidget: (context, string, _) {
                              return Image.asset(
                                resource.getResource('ic_placeholder_robot'),
                              );
                            },
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: style.brandGoldColor,
                  ),
                )
              ],
            ),
          );
  }

  Widget upOrDownWidget(
      StyleModel style, ResourceModel resource, bool isExpand, bool needShow) {
    if (!needShow) {
      return const SizedBox.shrink();
    }
    if (isLTR(context)) {
      // 左对齐
      return Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            color: style.white,
            child: isExpand
                ? Transform.rotate(
                    angle: isExpand ? (math.pi / 2) : 0,
                    child: Image.asset(
                      width: 18,
                      height: 18,
                      resource.getResource('ic_help_arrow_24'),
                    ))
                : Transform.rotate(
                    angle: !isExpand ? (-math.pi / 2) : 0,
                    child: Image(
                      image: AssetImage(
                        resource.getResource('ic_help_arrow_24'),
                      ),
                      width: 18,
                      height: 18,
                    ),
                  ),
          ));
    } else {
      // 右对齐
      return Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            color: Colors.white,
            child: isExpand
                ? Transform.rotate(
                    angle: isExpand ? (math.pi / 2) : 0,
                    child: Image.asset(
                      width: 20,
                      height: 20,
                      resource.getResource('ic_help_arrow_24'),
                    ))
                : Transform.rotate(
                    angle: !isExpand ? -(math.pi / 2) : 0,
                    child: Image(
                      image: AssetImage(
                        resource.getResource('ic_help_arrow_24'),
                      ),
                      width: 20,
                      height: 20,
                    ),
                  ),
          ));
    }
  }

  Widget buildProductIntroductWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    final productIntroduce = ref.watch(productManualStateNotifierProvider
        .select((value) => value.productIntroduce));
    final isExpand = ref.watch(
        productManualStateNotifierProvider.select((value) => value.isExpand));

    // 创建 TextPainter 用于计算文本高度
    final screenWidth = MediaQuery.of(context).size.width - 20;
    final textPainter = TextPainter(
      text: TextSpan(
          text: productIntroduce,
          style: style.normalStyle(
            color: style.textSecond,
            fontSize: 14,
          )),
      maxLines: 2,
      textDirection: Directionality.of(context),
    );

    // 设置文本宽度
    textPainter.layout(maxWidth: screenWidth);
    final isExceedingTwoLines = textPainter.didExceedMaxLines;
    final showQrCode = !isExceedingTwoLines || !isExpand;
    if (productIntroduce.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.zero,
                    child: Text(
                      productIntroduce,
                      overflow: TextOverflow.visible,
                      style: style.normalStyle(
                        color: style.textSecond,
                        fontSize: 14,
                      ),
                      maxLines: isExpand ? 2 : null,
                      textAlign: TextAlign.start,
                    )),
                upOrDownWidget(style, resource, isExpand, isExceedingTwoLines),
              ],
            ).onClick(() {
              ref
                  .read(productManualStateNotifierProvider.notifier)
                  .expandedProductIntroduce();
            })),
      ],
    );
  }

  Widget buildProductIntroduceWidget(BuildContext context, StyleModel style,
      ResourceModel resource, bool showAR) {
    return Column(
      children: [
        if (_mediaUrlList.isNotEmpty)
          Column(children: [
            CarouselSlider.builder(
              itemCount: _mediaUrlList.length,
              itemBuilder: (context, index, realIdx) {
                final filePath = _mediaUrlList[index];
                return isVideoPath(filePath)
                    ? _buildVideoPlayer(index, style, resource)
                    : filePath.isEmpty == true
                        ? Image.asset(
                            resource.getResource('ic_placeholder_robot'),
                          )
                        : CachedNetworkImage(
                            imageUrl: filePath ?? '',
                            errorWidget: (context, string, _) {
                              return Image.asset(
                                resource.getResource('ic_placeholder_robot'),
                              );
                            },
                            width: double.infinity,
                            height: double.infinity,
                          );
              },
              carouselController: _carouselController,
              options: CarouselOptions(
                  aspectRatio: 350 / 197,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: _mediaUrlList.length > 1,
                  reverse: false,
                  autoPlay: !_isFullscreen && !_isPlaying && _mediaUrlList.length > 1,
                  // 根据全屏状态控制自动播放
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: onPageChange),
            ),
            if (_mediaUrlList.length > 1)
              AnimatedBuilder(
                animation: _pageNotifier,
                builder: (context, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_mediaUrlList.length, (index) {
                      bool isActive = index == _currentIndex;
                      return GestureDetector(
                        onTap: () => _carouselController.animateToPage(index),
                        child: Container(
                          width: 4.0,
                          height: 4.0,
                          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? style.gray2 : style.gray2.withOpacity(0.5),
                          ),
                        ),
                      );
                    }),
                  );
                },
              )
            else
              const SizedBox.shrink()
          ])
        else
          AspectRatio(
            aspectRatio: 350 / 197,
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              child: (widget.product.mainImage?.imageUrl ?? '').isEmpty == true
                  ? Image.asset(
                      resource.getResource('ic_placeholder_robot'),
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.product.mainImage?.imageUrl ?? '',
                      errorWidget: (context, string, _) {
                        return Image.asset(
                          resource.getResource('ic_placeholder_robot'),
                        );
                      },
                      width: double.infinity,
                      height: double.infinity,
                    ).onClick(() {
                      ref
                          .read(productManualStateNotifierProvider.notifier)
                          .pushToManualViewer();
                    }),
            ),
          ),
        Column(children: [
          if (showAR)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: DMCommonClickButton(
                backgroundGradient: style.confirmBtnGradient,
                disableBackgroundGradient: style.disableBtnGradient,
                textColor: style.confirmBtnTextColor,
                disableTextColor: style.disableBtnTextColor,
                borderRadius: style.buttonBorder,
                enable: true,
                text: 'ar_navtitle_guide'.tr(),
                onClickCallback: () {
                  ref
                      .read(productManualStateNotifierProvider.notifier)
                      .pushToAR();
                },
              ),
            ),
          const SizedBox(height: 16),
          DMCommonClickButton(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            backgroundGradient: style.confirmBtnGradient,
            textColor: style.confirmBtnTextColor,
            enable: true,
            borderRadius: style.buttonBorder,
            text: 'view_ModelPage_UserManual_title'.tr(),
            onClickCallback: () {
              ref
                  .read(productManualStateNotifierProvider.notifier)
                  .pushToManualViewer();
            },
          ),
          const SizedBox(height: 16),
          buildProductIntroductWidget(context, style, resource),
        ]),
      ],
    );
  }

  Widget buildContent(
      BuildContext context, StyleModel style, ResourceModel resource) {
    List<AppFaq> faqs = ref.watch(
        productManualStateNotifierProvider.select((value) => value.faqs));
    bool showAR = ref.watch(
        productManualStateNotifierProvider.select((value) => value.showAR));
    return ListView(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 26),
        children: [
          Column(children: [
            buildHeader('ModelPage_UserManual'.tr()),
            Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: style.bgWhite,
                  borderRadius: BorderRadius.circular(style.circular8),
                ),
                child: buildProductIntroduceWidget(
                    context, style, resource, showAR)),
          ]),
          if (ref.watch(productManualStateNotifierProvider
              .select((value) => value.showFaq)))
            Column(children: [
              buildHeader(
                'feedback_common_question'.tr(),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: style.bgWhite,
                  borderRadius: BorderRadius.circular(style.circular8),
                ),
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.only(top: 6, bottom: 17),
                child: Column(children: [
                  for (int i = 0; i < faqs.length; i++)
                    FaqCell(
                        faq: faqs[i],
                        onExpand: () {
                          ref
                              .read(productManualStateNotifierProvider.notifier)
                              .changeExpanded(i);
                        }),
                  if (ref.watch(productManualStateNotifierProvider
                      .select((value) => value.showMore)))
                    InkWell(
                      onTap: () {
                        ref
                            .read(productManualStateNotifierProvider.notifier)
                            .pushToSearchFaq();
                      },
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.only(left: 20, right: 12)
                            .withRTL(context),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'view_all_question'.tr(),
                                style: style.normalStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              Image.asset(
                                resource.getResource(
                                    'ic_help_arrow' /*'ic_check_all_question'*/),
                                width: 20,
                                height: 20,
                              )
                            ]),
                      ),
                    )
                ]),
              ),
            ]),
          if (ref.watch(productManualStateNotifierProvider
              .select((value) => value.saleContacts.isNotEmpty)))
            Column(children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'problem_not_contact_tip'.tr(),
                style: style.disableStyle(fontSize: 14),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: style.bgWhite,
                    borderRadius: BorderRadius.circular(style.cellBorder),
                  ),
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(children: [
                    for (AfterSaleContactItem item in ref.watch(
                        productManualStateNotifierProvider
                            .select((value) => value.saleContacts)))
                      HelpCenterSettingCell(
                          style: style,
                          resource: resource,
                          title: item.title,
                          desc: item.desc,
                          image: item.image,
                          onTap: () {
                            if (item.contact == AfterSaleContact.onlineServer) {
                              List<BaseDeviceModel> deviceList = [];
                              if (ref.exists(homeStateNotifierProvider)) {
                                deviceList = ref.read(homeStateNotifierProvider
                                    .select((value) => value.deviceList));
                              }
                              ref.read(helpCenterRepositoryProvider).pushToChat(
                                  context: context,
                                  info: item.onlineServiceInfo,
                                  deviceList: deviceList);
                            } else {
                              item.onTap?.call(
                                  item.valueList?.isNotEmpty == true
                                      ? item.valueList?.first
                                      : null);
                            }
                          }),
                  ])),
            ])
        ]);
  }
}
