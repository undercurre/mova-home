import 'dart:convert';
import 'dart:io';
import 'package:flutter_plugin/model/app_res_model.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_model.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_type.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_res_config_provider.g.dart';

@Riverpod(keepAlive: true)
class AppResConfigProvider extends _$AppResConfigProvider {
  @override
  AppResModel build() {
    return const AppResModel();
  }

  Future<void> checkAppResConfig() async {
    try {
      String type = CommonPluginType.appSource.value;
      final result = await ref
          .read(userConfigPageStateNotifierProvider
              .call(UserConfigType.appRes)
              .notifier)
          .getUserConfig<bool>([type], targetKey: type);
      if (result) {
        await _checkAppResConfig();
      }
    } catch (e) {
      LogUtils.e('checkAppResConfig error: $e');
    }
  }

  Future<void> _checkAppResConfig() async {
    try {
      Map<String, String> iconMap = {};
      PluginLocalModel model = await ref
          .read(pluginProvider.notifier)
          .getCommonPlugin(CommonPluginType.appSource.value,
              appVer: Constant.appSourceVersion);
      String path = await model.getPath() ?? '';
      LogUtils.d('[AppResConfigProvider] checkAppResConfig path: $path');
      Directory dir = Directory(path);
      int startDate = 0;
      int endDate = 0;
      if (dir.existsSync()) {
        var list = dir.listSync();
        for (var i = 0; i < list.length; i++) {
          var element = list[i];
          if (element is File) {
            if (element.path.endsWith('config.json')) {
              String contents = await element.readAsString();
              Map<String, dynamic> config = jsonDecode(contents);
              startDate = config['startDate'];
              endDate = config['endDate'];
            } else if (element.path.endsWith('.png') ||
                element.path.endsWith('.jpg') ||
                element.path.endsWith('.jpeg') ||
                (element.path.endsWith('.json') &&
                    !element.path.endsWith('config.json'))) {
              String fileName = element.path.split('/').last;
              iconMap[fileName] = element.path;
            }
          }
          if (i == list.length - 1) {
            state = state.copyWith(
                iconMap: iconMap, startDate: startDate, endDate: endDate);
          }
        }
      }
    } catch (e) {
      LogUtils.e('[AppResConfigProvider] checkAppResConfig error: $e');
    }
  }

  String getIconPath(String name) {
    if (name.isEmpty || state.iconMap.isEmpty) {
      return '';
    }
    String key = name.split('/').last;
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now >= state.startDate && now <= state.endDate) {
      String path = state.iconMap[key] ?? '';
      if (File(path).existsSync()) {
        return path;
      }
    }
    return '';
  }

  void reset() {
    state = const AppResModel();
  }
}
