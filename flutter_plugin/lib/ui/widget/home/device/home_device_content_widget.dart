import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/model/home/product_resource_config_model.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/home/home_repository.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_plugin/utils/foldable_screen_utils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:video_player/video_player.dart';
import 'package:synchronized/synchronized.dart';

Map<String, String> deviceShadowUrl = {};
Map<String, bool> deviceShadowUrlQuery = {};

class HomeDeviceContentWidget extends ConsumerStatefulWidget {
  final BaseDeviceModel currentDevice;
  final String imageUrl;
  final VoidCallback enterPluginClick;

  final bool online;
  final String productId;

  const HomeDeviceContentWidget({
    required this.currentDevice,
    required this.imageUrl,
    required this.enterPluginClick,
    required this.online,
    required this.productId,
    super.key,
  });

  @override
  ConsumerState<HomeDeviceContentWidget> createState() =>
      _HomeDeviceContentWidgetState();
}

class _HomeDeviceContentWidgetState
    extends ConsumerState<HomeDeviceContentWidget> with WidgetsBindingObserver {
  bool isShowPlayer = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeDeviceVideoPlayerImpl homeVideoPlayerImpl = ref
          .read(homeStateNotifierProvider.notifier)
          .homeDeviceVideoPlayerImpl;
      isShowPlayer = homeVideoPlayerImpl.controller != null &&
          homeVideoPlayerImpl.isReady.value;
      if (mounted) setState(() {});

      homeVideoPlayerImpl.isReady.addListener(() {
        var value2 = homeVideoPlayerImpl.isReady.value;
        if (mounted) {
          setState(() {
            isShowPlayer = value2;
          });
        }
      });
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeDeviceContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // 检查是否已销毁
    return ThemeWidget(builder: (context, style, resource) {
      return LayoutBuilder(builder: (context, constraints) {
        HomeDeviceVideoPlayerImpl homeVideoPlayerImpl = ref
            .read(homeStateNotifierProvider.notifier)
            .homeDeviceVideoPlayerImpl;
        try {
          var isInitialized = homeVideoPlayerImpl.isInitialized();
          if (isInitialized && isShowPlayer) {
            return _buildPlayerWidget(
                style, resource, homeVideoPlayerImpl, constraints);
          }
        } catch (e) {
          return _buildImageWidget(
              style, resource, widget.imageUrl, constraints);
        }
        final shadowUrl = getDeviceShadowUrl(widget.productId);
        if (shadowUrl != null && shadowUrl.isNotEmpty == true) {
          return _buildImageWidget(style, resource, shadowUrl, constraints);
        }
        return _buildImageWidget(style, resource, widget.imageUrl, constraints);
      });
    });
  }

  String? getDeviceShadowUrl(String productId) {
    final themeMode = ref.read(appThemeStateNotifierProvider);
    String dictKey = themeMode == ThemeMode.dark
        ? 'deviceProjectionDark'
        : 'deviceProjectionLight';
    var cacheKey = 'dictKey_${productId}_${dictKey}';
    final url = deviceShadowUrl[cacheKey];
    unawaited(getShadowUrl(productId));
    return url;
  }

  Widget _buildPlayerWidget(
      StyleModel style,
      ResourceModel resource,
      HomeDeviceVideoPlayerImpl homeVideoPlayerImpl,
      BoxConstraints constraints) {
    final videoController = homeVideoPlayerImpl.controller();
    final videoSize = videoController?.value.size;
    var width = constraints.maxWidth;
    var height = constraints.maxHeight;
    if (width == 0 || height == 0 || videoSize == null) {
      return const SizedBox.shrink();
    }
    if (FoldableScreenUtils().isFoldScreenHorizontalExpansion(context)) {
      width = height * videoSize.width / videoSize.height;
    } else {
      width = width;
      height = height;
    }
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRect(
          child: OverflowBox(
            maxWidth: width,
            maxHeight: height,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: videoSize.width,
                height: videoSize.height,
                child: (homeVideoPlayerImpl.isInitialized())
                    ? VideoPlayer(homeVideoPlayerImpl.controller()!)
                    : _buildImageWidget(
                        style, resource, widget.imageUrl, constraints),
              ),
            ),
          ),
        ),
      ).onClick(() {
        LogModule().eventReport(5, 5,
            did: widget.currentDevice.did, model: widget.currentDevice.model);
        widget.enterPluginClick.call();
      }),
    );
  }

  // 获取投影网络url
  Future<String?> getShadowUrl(String productId) async {
    try {
      final themeMode = ref.read(appThemeStateNotifierProvider);
      String dictKey = themeMode == ThemeMode.dark
          ? 'deviceProjectionDark'
          : 'deviceProjectionLight';
      var cacheKey = 'dictKey_${productId}_${dictKey}';
      final url = deviceShadowUrl[cacheKey];
      final isQuery = deviceShadowUrlQuery[cacheKey] ?? false;
      if (url == null && !isQuery) {
        deviceShadowUrlQuery[cacheKey] = true;
        final productResourceConfigModel = await ref
            .read(homeRepositoryProvider)
            .getProductResourceConfig(productId, dictKey);
        if (productResourceConfigModel.filePath == null) {
          deviceShadowUrl[cacheKey] = productResourceConfigModel.filePath!;
          setState(() {});
        }
      } else {}
    } catch (e) {
      final themeMode = ref.read(appThemeStateNotifierProvider);
      String dictKey = themeMode == ThemeMode.dark
          ? 'deviceProjectionDark'
          : 'deviceProjectionLight';
      var cacheKey = 'dictKey_${productId}_${dictKey}';
      deviceShadowUrlQuery[cacheKey] = true;
      return null;
    }
    return null;
  }

  Widget _buildImageWidget(StyleModel style, ResourceModel resource,
      String imageUrl, BoxConstraints constraints,
      {bool isShadowUrlImage = false}) {
    // 270
    var maxWidth = constraints.maxWidth;
    var maxHeight = constraints.maxHeight;
    if (maxWidth == 0 || maxHeight == 0) {
      return const SizedBox.shrink();
    }
    if (maxWidth / maxHeight > 390 / 752) {
      maxWidth = maxHeight * 390 / 752;
      maxWidth = maxWidth - maxWidth * 120 / 390;
    } else {
      maxWidth = maxWidth - maxWidth * 120 / 390;
    }

    // if (isShadowUrlImage) {
    //   maxWidth = getShadowWidth(constraints);
    // }
    // 占位图组件
    Widget buildPlaceholder() {
      return Image(
        width: maxWidth,
        height: maxWidth,
        image: AssetImage(resource.getResource('ic_placeholder_robot')),
      ).withDynamic();
    }

    // 主图片组件
    Widget buildMainImage() {
      if (imageUrl.isNotEmpty) {
        return CachedNetworkImage(
          fit: BoxFit.fitHeight,
          imageUrl: imageUrl,
          height: maxWidth,
          width: maxWidth,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          errorWidget: (context, url, error) => buildPlaceholder(),
          placeholder: (context, url) => buildPlaceholder(),
        );
      }
      return buildPlaceholder();
    }

    return Center(
      child: Semantics(
        label: 'text_enter_plugin'.tr(),
        child: buildMainImage().onClick(() {
          LogModule().eventReport(5, 5,
              did: widget.currentDevice.did, model: widget.currentDevice.model);
          widget.enterPluginClick.call();
        }),
      ),
    );
  }
}

// 视频播放器实现
class HomeDeviceVideoPlayerImpl {
  VideoPlayerController? _videoPlayerController;
  bool startedPlaying = false;
  String? _preDataSourcePath;
  final ValueNotifier<bool> isReady = ValueNotifier<bool>(false);

  VideoPlayerController? controller() {
    // Add null check to prevent using disposed controller
    if (_videoPlayerController != null &&
        (_videoPlayerController?.playerId ?? -1) >= 0 &&
        !_videoPlayerController!.value.hasError) {
      return _videoPlayerController;
    }
    return null;
  }

  bool isInitialized() {
    return controller()?.value.isPlaying ?? false;
  }

  bool isNeedShow() {
    return (controller()?.value.position.inMilliseconds ?? 0) > 0;
  }

  final Lock _lock = Lock();

  Future<void> loadDataSource(String dataSourcePath,
      {bool forceRefresh = false}) async {
    return _lock.synchronized(
        () => _loadDataSource(dataSourcePath, forceRefresh: forceRefresh));
  }

  Future<void> _loadDataSource(String dataSourcePath,
      {bool forceRefresh = false}) async {
    if (_preDataSourcePath != dataSourcePath) {
      _preDataSourcePath = dataSourcePath;
      if (forceRefresh) {
        isReady.value = false;
      }
      // Properly dispose the old controller
      if (_videoPlayerController != null) {
        try {
          isReady.value = false;
          await _videoPlayerController?.pause();
          _videoPlayerController?.removeListener(listener);
          await _videoPlayerController?.dispose();
        } catch (e) {
          // Ignore errors during disposal
        }
        _videoPlayerController = null;
      }
      if (dataSourcePath.isEmpty) {
        isReady.value = false;
        return;
      }
      var file = File(dataSourcePath);
      if (!file.existsSync()) {
        isReady.value = false;
        return;
      }

      try {
        _videoPlayerController = VideoPlayerController.file(
          file,
          viewType: VideoViewType.textureView,
        );
        setupListener();
        await _videoPlayerController?.initialize();
        await _videoPlayerController?.setLooping(true);
        await started();
      } catch (e) {
        // Handle initialization errors
        _videoPlayerController?.removeListener(listener);
        _videoPlayerController = null;
      }
    } else {
      await started();
    }
  }

  void setupListener() {
    _videoPlayerController?.addListener(listener);
  }

  void listener() {
    final value = controller()?.value;
    final duration = value?.duration;
    final isPlaying = value?.isPlaying;
    final isInitialized = value?.isInitialized;
    final isBuffering = value?.isBuffering;
    final isCompleted = value?.isCompleted;
    final isLooping = value?.isLooping;
    final aspectRatio = value?.aspectRatio;
    final size = value?.size;
    final position = value?.position ?? const Duration(milliseconds: 0);
    final isReadyS = isReady.value;
    if (isInitialized == true && size != null) {
      if (controller()?.dataSource.contains(_preDataSourcePath ?? '') == true &&
          isPlaying == true &&
          position.inMilliseconds > 0 &&
          !isReady.value) {
        LogUtils.d(
            '[_setupControllerListeners]addListener 首页播放器状态更新:isPlaying:$isPlaying ,isReadyS:$isReadyS} ,controller()?.dataSource:${controller()?.dataSource} ,_preDataSourcePath:$_preDataSourcePath');
        isReady.value = true;
      }
    }
  }

  // 开始播放
  Future<bool> started() async {
    final controller = this.controller();
    if (controller != null) {
      await controller.play();
      startedPlaying = true;
      return true;
    }
    return false;
  }

  // 暂停播放
  Future<bool> paused() async {
    final controller = this.controller();
    if (controller != null) {
      await controller.pause();
      startedPlaying = false;
      return true;
    }
    return false;
  }

  // 获取视频路径
  Future<String> getFilePath(String? model, String partitionPath,
      String themeModel, int? currentLatestStatus,
      {String? fileName, String type = 'mp4', String fileType = 'anim'}) async {
    try {
      final partition = partitionPath == 'a' ? 'a' : 'b';
      final pathPrefix = 'rn_plugins_res/$model/$partition';
      final documentDirectory = await getApplicationDocumentsDirectory();
      final rnPluginsPrefix = '${documentDirectory.path}/$pathPrefix';
      String newCurrentStatePath =
          '$rnPluginsPrefix/resources/$fileType/$themeModel/animation_state_$currentLatestStatus.$type';
      if (fileName != null && fileName.isNotEmpty) {
        newCurrentStatePath =
            '$rnPluginsPrefix/resources/$fileType/$themeModel/$fileName';
      }
      return newCurrentStatePath;
    } catch (error) {
      return '';
    }
  }

  Future<void> disposePlayer() async {
    final controller = this.controller();
    if (controller != null) {
      try {
        await controller.pause();
        _videoPlayerController?.removeListener(listener);
        await controller.dispose();
      } catch (e) {
        // Ignore errors during disposal
      }
    }
    _videoPlayerController = null;
    startedPlaying = false;
  }
}
