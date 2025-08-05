import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/ui/dynamic_widget/dynamic_widget.dart';
import 'package:flutter_plugin/ui/dynamic_widget/utils.dart';

class IndexedStackWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener, DataBuilder? dataBuilder) {
    return IndexedStack(
      index: map.containsKey('index') ? map['index'] : 0,
      alignment: map.containsKey('alignment')
          ? parseAlignment(map['alignment'])!
          : AlignmentDirectional.topStart,
      textDirection: map.containsKey('textDirection')
          ? parseTextDirection(map['textDirection'])
          : null,
      children: DynamicWidgetBuilder.buildWidgets(
          map['children'], buildContext, listener, dataBuilder),
    );
  }

  @override
  String get widgetName => 'IndexedStack';

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as IndexedStack;
    return <String, dynamic>{
      'type': widgetName,
      'index': realWidget.index,
      'alignment': realWidget.alignment != null
          ? exportAlignment(realWidget.alignment as Alignment?)
          : AlignmentDirectional.topStart,
      'textDirection': realWidget.textDirection != null
          ? exportTextDirection(realWidget.textDirection)
          : null,
      'children':
          DynamicWidgetBuilder.exportWidgets(realWidget.children, buildContext)
    };
  }

  @override
  Type get widgetType => IndexedStack;
}
