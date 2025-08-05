import 'package:flutter_plugin/ui/dynamic_widget/dynamic_widget.dart';
import 'package:flutter/widgets.dart';

class ExpandedWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener, DataBuilder? dataBuilder) {
    return Expanded(
      flex: map.containsKey('flex') ? map['flex'] : 1,
      child: DynamicWidgetBuilder.buildFromMap(
          map['child'], buildContext, listener, dataBuilder)!,
    );
  }

  @override
  String get widgetName => 'Expanded';

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as Expanded;
    return <String, dynamic>{
      'type': widgetName,
      'flex': realWidget.flex,
      'child': DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  Type get widgetType => Expanded;
}
