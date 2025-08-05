import 'package:freezed_annotation/freezed_annotation.dart';
part 'plugin_state.freezed.dart';

@unfreezed
class PluginState with _$PluginState {
  factory PluginState({
    String? currentModel,
    @Default(false) bool needsUpdate,
    @Default(0) int progress,
  }) = _PluginState;
}
