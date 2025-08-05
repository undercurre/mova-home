import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin GlobalResourceManager {
  ResourceModel getResourceModel(WidgetRef ref) {
    ResourceModel resourceBuilder = ref.watch(resourceModelProvider);
    return resourceBuilder;
  }

}
