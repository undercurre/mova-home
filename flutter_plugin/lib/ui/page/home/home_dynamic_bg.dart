import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/configure/app_dynamic_res_config_provider.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/home/looping_video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class HomeDynamicBg extends ConsumerWidget {
  const HomeDynamicBg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var type = ref.watch(appDynamicResConfigProviderProvider
        .select((value) => value.addDeviceBgType));
    var path = ref.watch(appDynamicResConfigProviderProvider
        .select((value) => value.addDeviceBg));
    var isExpired = ref.watch(
        appDynamicResConfigProviderProvider.select((value) => value.isExpired));
    final file = File(path);
    if (isExpired || !file.existsSync()) {
      type = 'lottie';
      path = ref.read(resourceModelProvider).getResource('add_device_bg', suffix: '.json');
      return Center(
        child: Lottie.asset(
          path,
          repeat: true,
          fit: BoxFit.fitWidth,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    switch (type) {
      case 'image':
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      case 'video':
        return VideoPlayerWidget(videoPath: path);
      case 'lottie':
        return Center(
          child: Lottie.file(
            file,
            repeat: true,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      default:
        return Container(); // 默认返回空容器
    }
  }
}
