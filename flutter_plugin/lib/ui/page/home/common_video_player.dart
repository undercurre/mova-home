import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class IVideoPlayer {
  Future<void> initialize(String videoPath);
  void dispose();
  void play();
  void pause();
  void seekTo(Duration position);
  bool get isInitialized;
  bool get isPlaying;
  Stream<double> get progressStream;
}

abstract class IVideoState {
  bool get isDarkColor;

  double get currentProgress;

  double get currentSeconds;
}

class VideoPlayerImpl implements IVideoPlayer {
  VideoPlayerController? _controller;
  final _progressController = StreamController<double>.broadcast();
  String? _currentVideoPath;

  @override
  Future<void> initialize(String videoPath) async {
    if (_currentVideoPath == videoPath && _controller != null) {
      return;
    }

    await _disposeController();

    _controller = VideoPlayerController.network(videoPath);
    _currentVideoPath = videoPath;

    try {
      await _controller!.initialize();
      _controller!.addListener(_updateProgress);
      _controller!.setLooping(true);
      _progressController.add(0.0);
    } catch (e) {
      print('视频初始化失败: $e');
      _controller = null;
      _currentVideoPath = null;
      rethrow;
    }
  }

  Future<void> _disposeController() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
    }
  }

  void _updateProgress() {
    if (_controller != null && _controller!.value.isInitialized) {
      final position = _controller!.value.position;
      final duration = _controller!.value.duration;
      if (duration.inMilliseconds > 0) {
        final progress = position.inMilliseconds / duration.inMilliseconds;
        _progressController.add(progress);
      }
    }
  }

  @override
  void dispose() {
    _disposeController();
    _progressController.close();
  }

  @override
  void play() {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.play();
    }
  }

  @override
  void pause() {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.pause();
    }
  }

  @override
  void seekTo(Duration position) {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.seekTo(position);
    }
  }

  @override
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  @override
  bool get isPlaying => _controller?.value.isPlaying ?? false;

  @override
  Stream<double> get progressStream => _progressController.stream;
}

class VideoState implements IVideoState {
  final double progress;
  static const double totalDuration = 12.0;
  static const double darkStartTime = 4.4;
  static const double darkEndTime = 10.4;

  VideoState(this.progress);

  @override
  bool get isDarkColor {
    final seconds = currentSeconds;
    return seconds >= darkStartTime && seconds <= darkEndTime;
  }

  @override
  double get currentProgress => progress;

  @override
  double get currentSeconds => progress * totalDuration;
}

final videoStateProvider =
    StateNotifierProvider<VideoStateNotifier, VideoState>((ref) {
  return VideoStateNotifier();
});

class VideoStateNotifier extends StateNotifier<VideoState> {
  VideoStateNotifier() : super(VideoState(0));

  void updateProgress(double progress) {
    state = VideoState(progress);
  }
}

final videoControllerProvider =
    StateNotifierProvider<VideoControllerNotifier, IVideoPlayer?>((ref) {
  return VideoControllerNotifier();
});

class VideoControllerNotifier extends StateNotifier<IVideoPlayer?> {
  bool _isInitializing = false;

  VideoControllerNotifier() : super(null);

  Future<void> initialize(String videoPath) async {
    // 防止重复初始化
    if (state != null || _isInitializing) return;

    _isInitializing = true;
    final player = VideoPlayerImpl();
    // _player = player;
    try {
      await player.initialize(videoPath);
      state = player;
    } catch (e) {
      state = null;
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> play() async {
    state?.play();
  }

  Future<void> pause() async {
    state?.pause();
  }

  @override
  void dispose() {
    state?.dispose();
    state = null;
    super.dispose();
  }

  bool get isPlaying => state?.isPlaying ?? false;

  bool get isInitialized => state?.isInitialized ?? false;
}

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  bool _isDisposed = false;
  StreamSubscription? _progressSubscription;
  bool _wasPlaying = false;
  bool _isMounted = false;
  late VideoControllerNotifier _videoControllerNotifier;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _videoControllerNotifier = ref.read(videoControllerProvider.notifier);
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _videoControllerNotifier.initialize(widget.videoUrl);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _videoControllerNotifier.play();
    });
  }

  @override
  void dispose() {
    _videoControllerNotifier.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    final player = ref.read(videoControllerProvider.notifier);
    switch (state) {
      case AppLifecycleState.paused:
        _wasPlaying = player.isPlaying;
        player.pause();
        break;
      case AppLifecycleState.resumed:
        player.play();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayer = ref.read(videoControllerProvider) as VideoPlayerImpl;

    return FutureBuilder<void>(
      future: _videoControllerNotifier.initialize(widget.videoUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('视频加载失败'));
        } else if (videoPlayer == null || !videoPlayer.isInitialized) {
          return Center(child: Text('视频初始化失败'));
        } else {
          return VideoPlayer(videoPlayer._controller!);
        }
      },
    );
  }

  Future<void> play() async {
    await ref.read(videoControllerProvider.notifier).play();
  }

  Future<void> pause() async {
    await ref.read(videoControllerProvider.notifier).pause();
  }
}
