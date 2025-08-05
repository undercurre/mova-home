import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rn_plugin_update_model.freezed.dart';

typedef UpdateCallback = void Function(bool showLoading);

int incompatible = -100;
int downloadFail = -101;
int netError = -102;

@unfreezed
class RNPluginUpdateModel with _$RNPluginUpdateModel {
  factory RNPluginUpdateModel(
      {String? model,
      @Default(false) bool hide,
      bool? hasLocal,
      PluginLocalModel? sdkModel,
      PluginLocalModel? pluginModel,
      PluginLocalModel? resModel,
      @Default(false) bool isDebug,
      String? ip,
      String? debugUrl,
      int? code,
      int? progress}) = _RNPluginUpdateModel;
}
