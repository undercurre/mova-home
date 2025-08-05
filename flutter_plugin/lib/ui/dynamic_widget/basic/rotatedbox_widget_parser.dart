import 'package:flutter_plugin/ui/dynamic_widget/dynamic_widget.dart';
import 'package:flutter/widgets.dart';

class RotatedBoxWidgetParser extends WidgetParser {
  @override
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext) {
    var realWidget = widget as RotatedBox;
    return <String, dynamic>{
      "type": widgetName,
      "quarterTurns": realWidget.quarterTurns,
      "child": DynamicWidgetBuilder.export(realWidget.child, buildContext),
    };
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener, DataBuilder? dataBuilder) {
    return RotatedBox(
      quarterTurns: map['quarterTurns'],
      child: DynamicWidgetBuilder.buildFromMap(
          map["child"], buildContext, listener, dataBuilder),
    );
  }

  @override
  String get widgetName => "RotatedBox";

  @override
  Type get widgetType => RotatedBox;
}
