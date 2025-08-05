import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerPage extends BasePage {
  static const String routePath = '/video_player_page';
  final String url;

  const VideoPlayerPage({super.key, required this.url});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _VideoPlayerPageState();
  }
}

class _VideoPlayerPageState extends BasePageState<VideoPlayerPage>{
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      ),
      autoInitialize: true,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Widget buildVideoPlayer(BuildContext context, StyleModel style) {
    return  AspectRatio(
      aspectRatio: 350 / 197,
      child: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: const FlickVideoWithControls(
          controls: FlickPortraitControls(),
          videoFit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context, StyleModel style, ResourceModel resource) {
    return Platform.isIOS
        ? buildVideoPlayer(context, style)
        : WillPopScope(
            onWillPop: () async {
              bool isHandling = false;
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
              if (isHandling) {

                return false;
              }
              return true;
            },
            child: buildVideoPlayer(context, style));
  }
}
