import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
// ignore: depend_on_referenced_packages
import 'package:visibility_detector/visibility_detector.dart';

class SampleVideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final ValueNotifier<bool> isPlayingNotifier;

  const SampleVideoPlayerWidget({
    Key? key,
    required this.videoPath,
    required this.isPlayingNotifier,
  }) : super(key: key);

  @override
  SampleVideoPlayerWidgetState createState() => SampleVideoPlayerWidgetState();
}

class SampleVideoPlayerWidgetState extends State<SampleVideoPlayerWidget>
    with WidgetsBindingObserver {
  late VideoPlayerController? _controller;
  String? _currentVideoPath;
  bool _isDisposed = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    initialize(widget.videoPath);
  }

  Future<void> initialize(String videoPath) async {
    // 如果是相同的视频源且已经初始化，直接返回
    if (_currentVideoPath == videoPath && _controller != null) {
      return;
    }

    _currentVideoPath = videoPath;
    final options = VideoPlayerOptions(
      mixWithOthers: true,
      allowBackgroundPlayback: true,
    );

    _controller = videoPath.startsWith('asset')
        ? VideoPlayerController.asset(videoPath, videoPlayerOptions: options)
        : VideoPlayerController.file(File(videoPath),
            videoPlayerOptions: options);

    await _controller?.initialize();
    await _controller?.setLooping(true);
    _controller?.addListener(() {
      if (_controller!.value.isPlaying && !_controller!.value.isBuffering) {
        widget.isPlayingNotifier.value = true;
      } else if (_controller!.value.isPlaying == false) {
        widget.isPlayingNotifier.value = false;
      }
    });
  }

  void _onControllerUpdate() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final isPlaying = _controller!.value.isPlaying;
    if (widget.isPlayingNotifier.value != isPlaying) {
      widget.isPlayingNotifier.value = isPlaying;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _currentVideoPath = null;
  }

  Future<void> play() async {
    await _controller?.play();
  }

  Future<void> pause() async {
    await _controller?.pause();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_controller == null) return;

    switch (state) {
      case AppLifecycleState.paused:
        if (widget.isPlayingNotifier.value) {
          pause();
        }
        break;
      case AppLifecycleState.resumed:
        if (widget.isPlayingNotifier.value) {
          play();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoPath),
      onVisibilityChanged: (visibilityInfo) {
        if (!_isDisposed) {
          final visibleFraction = visibilityInfo.visibleFraction;
          LogUtils.d('ddddd visibleFraction: $visibleFraction');
          if (visibleFraction == 0) {
            _controller?.pause();
          } else if (visibleFraction != 0) {
            _controller?.play();
          }
        }
      },
      child: Center(
          child: _controller != null && _controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : CircularProgressIndicator()),
    );
  }
}
