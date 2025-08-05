import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/ui/dynamic_widget/dynamic_widget.dart';
import 'package:flutter_plugin/ui/dynamic_widget/utils.dart';

class PaddingWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener, DataBuilder? dataBuilder) {
    return Padding(
      padding: map.containsKey('padding')
          ? parseEdgeInsetsGeometry(map['padding'])!
          : EdgeInsets.zero,
      child: DynamicWidgetBuilder.buildFromMap(
          map['child'], buildContext, listener, dataBuilder),
    );
  }

  @override
  String get widgetName => 'Padding';

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Padding;
    var padding = realWidget.padding as EdgeInsets;
    return <String, dynamic>{
      'type': widgetName,
      'padding': padding != null
          ? '${padding.left},${padding.top},${padding.right},${padding.bottom}'
          : null,
      'child': DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  Type get widgetType => Padding;
}
