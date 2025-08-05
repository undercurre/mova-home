import 'package:flutter_plugin/ui/dynamic_widget/dynamic_widget.dart';
import 'package:flutter/widgets.dart';

class AspectRatioWidgetParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener, DataBuilder? dataBuilder) {
    return AspectRatio(
      aspectRatio: map["aspectRatio"]?.toDouble(),
      child: DynamicWidgetBuilder.buildFromMap(
          map["child"], buildContext, listener, dataBuilder),
    );
  }

  @override
  String get widgetName => "AspectRatio";

  @override
  Map<String, dynamic> export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as AspectRatio;
    return <String, dynamic>{
      "type": widgetName,
      "aspectRatio": realWidget.aspectRatio,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext)
    };
  }

  @override
  Type get widgetType => AspectRatio;
}
