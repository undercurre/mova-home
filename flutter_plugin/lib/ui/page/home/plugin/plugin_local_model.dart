/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-19 17:46:46
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-10-25 18:37:57
 * @FilePath: /flutter_plugin/lib/ui/page/home/plugin/plugin_local_model.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:io';

import 'package:flutter_plugin/model/mall_debug_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'plugin_local_model.freezed.dart';

@unfreezed
class PluginLocalModel with _$PluginLocalModel {
  PluginLocalModel._();

  factory PluginLocalModel(
      {String? type,
      String? version,
      String? path,
      String? partition,
      String? sourceCommonExtensionId,
      String? sourceCommonPluginId,
      String? sourceCommonPluginVer,
      String? md5}) = _PluginLocalModel;

  Future<String?> getPath() async {
    if (path != null) {
      Directory? appDocumentsDir = await getApplicationDocumentsDirectory();
      return '${appDocumentsDir.path}/$path';
    }
    return null;
  }

  Future<Uri> getUri() async {
    MallDebugModel debug =
        await MallDebugModel.getMallDebugInfo('mall_debug_info');
    if (debug.enable == true && debug.host.isNotEmpty) {
      if (debug.host.startsWith('https://') ||
          debug.host.startsWith('http://')) {
        Uri uri = Uri.parse(debug.host);
        return uri;
      }
      Uri uri = Uri(path: debug.host, scheme: 'http');
      return uri;
    }

    // if (path != null && path!.isNotEmpty) {
    if (path!.startsWith('assets')) {
      String flutterFrameworkPath;
      if (Platform.isIOS) {
        flutterFrameworkPath =
            '${Platform.resolvedExecutable}/Frameworks/App.framework/flutter_assets/'
                .replaceFirst('Mova_Smarthome/', '');
      } else {
        flutterFrameworkPath = 'android_asset/flutter_assets/';
      }
      String indexPath = '$flutterFrameworkPath$path/index.html';
      return Uri(
        path: indexPath,
        scheme: 'file',
      );
    } else if (path!.startsWith('http')) {
      return Uri(host: path);
    } else {
      Directory? appDocumentsDir = await getApplicationDocumentsDirectory();
      return Uri(
        path: '${appDocumentsDir.path}/$path/index.html',
        scheme: 'file',
      );
    }
    // }
    // return uri;
  }
}
