import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theme_widget.g.dart';

@riverpod
StyleModel styleModel(StyleModelRef ref) {
  final themeMode = ref.watch(appThemeStateNotifierProvider);
  Brightness brightness = themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
  return StyleModel.fromBrightness(brightness);
}

@riverpod
ResourceModel resourceModel(ResourceModelRef ref) {
  final themeMode = ref.watch(appThemeStateNotifierProvider);
  String themePath = themeMode == ThemeMode.dark ? 'dark' : 'light';
  return ResourceModel(themePath: themePath);
}

/// ignore: must_be_immutable
class ThemeWidget extends StatelessWidget {
  ThemeConsumerBuilder builder;
  ThemeWidget({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(builder: builder);
  }
}

typedef ThemeConsumerBuilder = Widget Function(
    BuildContext context, StyleModel style, ResourceModel resource);

class ThemeConsumer extends ConsumerWidget {
  final ThemeConsumerBuilder _builder;

  const ThemeConsumer({super.key, required ThemeConsumerBuilder builder})
      : _builder = builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StyleModel styleBuilder = ref.watch(styleModelProvider);
    ResourceModel resourceBuilder = ref.watch(resourceModelProvider);
    return _builder(context, styleBuilder, resourceBuilder);
  }
}    