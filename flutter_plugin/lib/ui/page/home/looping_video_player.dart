import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerImpl {
  VideoPlayerController? controller;
  final _progressController = StreamController<double>.broadcast();
  final _playStateController = StreamController<bool>.broadcast();
  String? _currentVideoPath;

  Future<void> initialize(String videoPath) async {
    if (_currentVideoPath == videoPath && controller != null) {
      return;
    }

    await dispose();

    _currentVideoPath = videoPath;
    final options = VideoPlayerOptions(
      mixWithOthers: true,
      allowBackgroundPlayback: true,
    );

    controller = videoPath.startsWith('asset')
        ? VideoPlayerController.asset(videoPath, videoPlayerOptions: options)
        : VideoPlayerController.file(File(videoPath),
            videoPlayerOptions: options);

    await controller?.initialize();
    await controller?.setLooping(true);
    _setupProgressListener();
    _setupPlayStateListener();
  }

  void _setupProgressListener() {
    controller?.addListener(() {
      if (isInitialized && isPlaying) {
        final progress = controller!.value.position.inMilliseconds / 12000.0;
        _progressController.add(progress);
      }
    });
  }

  void _setupPlayStateListener() {
    controller?.addListener(() {
      bool isBuffering = controller!.value.isBuffering;
      bool playing = controller!.value.isPlaying;
      _playStateController.add(playing);
    });
  }

  Future<void> dispose() async {
    await controller?.dispose();
    controller = null;
    _currentVideoPath = null;
  }

  bool get isInitialized => controller?.value.isInitialized ?? false;

  bool get isPlaying => controller?.value.isPlaying ?? false;

  String get url => _currentVideoPath ?? '';

  Stream<double> get progressStream => _progressController.stream;

  Stream<bool> get playState => _playStateController.stream;

  Future<void> pause() async {
    try {
      if (!isInitialized) {
        LogUtils.e('VideoPlayer pause failed: controller not initialized');
        return;
      }

      await controller?.pause();
    } catch (e) {
      LogUtils.e('VideoPlayer pause failed: $e');
      rethrow;
    }
  }

  Future<void> play() async {
    try {
      if (!isInitialized) {
        LogUtils.e('VideoPlayer play failed: controller not initialized');
        return;
      }

      await controller?.play();
    } catch (e) {
      LogUtils.e('VideoPlayer play failed: $e');
      rethrow;
    }
  }
}

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoPath;
  final GlobalKey<VideoPlayerWidgetState>? playerKey;
  final ValueNotifier<bool>? isPlayingNotifier;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
    this.playerKey,
    this.isPlayingNotifier,
  });

  @override
  ConsumerState<VideoPlayerWidget> createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget>
    with WidgetsBindingObserver {
  bool _isDisposed = false;
  late VideoPlayerImpl _videoPlayer;
  StreamSubscription? _progressSubscription;
  StreamSubscription? _playStateSubscription;
  bool isPlaying = false;
  bool _isMounted = false;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _videoPlayer = VideoPlayerImpl();
    _isMounted = true;
    WidgetsBinding.instance.addObserver(this);
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoPath != widget.videoPath) {
      _initializePlayer();
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _isDisposed = true;
    _progressSubscription?.cancel();
    _videoPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    if (!_isMounted) return;

    try {
      await _videoPlayer.initialize(widget.videoPath);

      if (!_isMounted) return;

      _progressSubscription = _videoPlayer.progressStream.listen((progress) {
        if (_isMounted) {
          setState(() {
            this.progress = progress;
            isPlaying = _videoPlayer.isPlaying;
          });
        }
        _playStateSubscription = _videoPlayer.playState.listen((isPlaying) {
          if (_isMounted) {
            setState(() {
              widget.isPlayingNotifier?.value = isPlaying;
            });
          }
        });
      });
    } catch (e) {
      if (_isMounted) {
        LogUtils.e('Video player initialization failed: $e');
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        isPlaying = _videoPlayer.isPlaying;
        _videoPlayer.pause();
        break;
      case AppLifecycleState.resumed:
        if (isPlaying) {
          _videoPlayer.play();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听首页状态

    // 获取屏幕和视频尺寸
    final screenSize = MediaQuery.of(context).size;
    final videoController = _videoPlayer;
    final videoSize = videoController.controller?.value.size ?? Size.zero;
    final aspectRatio = videoSize.width / videoSize.height;

    final scaledVideoHeight = screenSize.width / aspectRatio;
    final scaledVideoWidth = screenSize.height * aspectRatio;

    return VisibilityDetector(
      key: Key(widget.videoPath),
      onVisibilityChanged: (visibilityInfo) {
        if (!_isDisposed) {
          final visibleFraction = visibilityInfo.visibleFraction;
          LogUtils.d('ddddd visibleFraction: $visibleFraction');
          if (visibleFraction == 0) {
            _videoPlayer.pause();
          } else if (visibleFraction != 0) {
            _videoPlayer.play();
          }
        }
      },
      child: Center(
        child: SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: ClipRect(
            child: OverflowBox(
              maxWidth: scaledVideoWidth > screenSize.width
                  ? scaledVideoWidth
                  : screenSize.width,
              maxHeight: scaledVideoHeight > screenSize.height
                  ? scaledVideoHeight
                  : screenSize.height,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: videoSize.width,
                  height: videoSize.height,
                  child: (videoController.isInitialized)
                      ? VideoPlayer(videoController.controller!)
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> play() async {
    await _videoPlayer.play();
    // setState(() {
    //   isPlaying = true;
    // });
  }

  Future<void> pause() async {
    await _videoPlayer.pause();
    // setState(() {
    //   isPlaying = false;
    // });
  }
}
