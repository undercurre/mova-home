library dynamic_widget;

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/align_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/appbar_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/aspectratio_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/baseline_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/button_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/card_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/center_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/container_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/divider_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/dropcaptext_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/expanded_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/fittedbox_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/image_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/indexedstack_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/limitedbox_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/listtile_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/offstage_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/opacity_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/padding_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/placeholder_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/row_column_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/safearea_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/scaffold_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/selectabletext_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/sizedbox_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/stack_positioned_widgets_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/text_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/basic/wrap_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/scrolling/gridview_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/scrolling/listview_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/scrolling/pageview_widget_parser.dart';
import 'package:flutter_plugin/ui/dynamic_widget/scrolling/single_child_scroll_view_widget_parser.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';

import 'basic/cliprrect_widget_parser.dart';
import 'basic/overflowbox_widget_parser.dart';
import 'basic/rotatedbox_widget_parser.dart';

class DynamicWidgetBuilder {
  static final Logger log = Logger('DynamicWidget');

  static final _parsers = [
    ContainerWidgetParser(),
    TextWidgetParser(),
    SelectableTextWidgetParser(),
    RowWidgetParser(),
    ColumnWidgetParser(),
    AssetImageWidgetParser(),
    NetworkImageWidgetParser(),
    CachedNetworkImageWidgetParser(),
    PlaceholderWidgetParser(),
    GridViewWidgetParser(),
    ListViewWidgetParser(),
    PageViewWidgetParser(),
    ExpandedWidgetParser(),
    PaddingWidgetParser(),
    CenterWidgetParser(),
    AlignWidgetParser(),
    AspectRatioWidgetParser(),
    FittedBoxWidgetParser(),
    BaselineWidgetParser(),
    StackWidgetParser(),
    PositionedWidgetParser(),
    IndexedStackWidgetParser(),
    ExpandedSizedBoxWidgetParser(),
    SizedBoxWidgetParser(),
    OpacityWidgetParser(),
    WrapWidgetParser(),
    DropCapTextParser(),
    ClipRRectWidgetParser(),
    SafeAreaWidgetParser(),
    ListTileWidgetParser(),
    ScaffoldWidgetParser(),
    AppBarWidgetParser(),
    LimitedBoxWidgetParser(),
    OffstageWidgetParser(),
    OverflowBoxWidgetParser(),
    ElevatedButtonParser(),
    DividerWidgetParser(),
    TextButtonParser(),
    RotatedBoxWidgetParser(),
    CardParser(),
    SingleChildScrollViewParser(),
  ];

  static final _widgetNameParserMap = <String, WidgetParser>{};

  static bool _defaultParserInited = false;

  // use this method for adding your custom widget parser
  static void addParser(WidgetParser parser) {
    log.info(
        "add custom widget parser, make sure you don't overwirte the widget type.");
    _parsers.add(parser);
    _widgetNameParserMap[parser.widgetName] = parser;
  }

  static void initDefaultParsersIfNess() {
    if (!_defaultParserInited) {
      for (var parser in _parsers) {
        _widgetNameParserMap[parser.widgetName] = parser;
      }
      _defaultParserInited = true;
    }
  }

  static Future<Widget>? build(String json, BuildContext buildContext,
      ClickListener? listener, DataBuilder? dataBuilder) async {
    initDefaultParsersIfNess();
    var map = jsonDecode(json);
    return buildFromMap(map, buildContext, listener, dataBuilder)!;
  }

  static Widget? buildFromMap(
      Map<String, dynamic>? map,
      BuildContext buildContext,
      ClickListener? listener,
      DataBuilder? dataBuilder) {
    initDefaultParsersIfNess();
    if (map == null) {
      return null;
    }
    String? widgetName = map['type'];
    if (widgetName == null) {
      return null;
    }
    var parser = _widgetNameParserMap[widgetName];
    if (parser != null) {
      if (map['click'] != null) {
        return parser
            .parse(map, buildContext, listener, dataBuilder)
            .onClick(() => {listener?.onClicked(map['click'])});
      } else {
        return parser.parse(map, buildContext, listener, dataBuilder);
      }
    }
    log.warning("Not support parser type: $widgetName");
    return null;
  }

  static List<Widget> buildWidgets(
      List<dynamic> values,
      BuildContext buildContext,
      ClickListener? listener,
      DataBuilder? dataBuilder) {
    initDefaultParsersIfNess();
    List<Widget> rt = [];
    for (var value in values) {
      var buildFromMap2 =
          buildFromMap(value, buildContext, listener, dataBuilder);
      if (buildFromMap2 != null) {
        rt.add(buildFromMap2);
      }
    }
    return rt;
  }

  static Map<String, dynamic>? export(
      Widget? widget, BuildContext? buildContext) {
    initDefaultParsersIfNess();
    var parser = _findMatchedWidgetParserForExport(widget);
    if (parser != null) {
      Map<String, dynamic>? exportedMap = parser.export(widget, buildContext);
      exportedMap?.removeWhere((key, value) => value == null);
      return exportedMap;
    }
    log.warning(
        "Can't find WidgetParser for Type ${widget.runtimeType} to export.");
    return null;
  }

  static List<Map<String, dynamic>?> exportWidgets(
      List<Widget?> widgets, BuildContext? buildContext) {
    initDefaultParsersIfNess();
    List<Map<String, dynamic>?> rt = [];
    for (var widget in widgets) {
      rt.add(export(widget, buildContext));
    }
    return rt;
  }

  static WidgetParser? _findMatchedWidgetParserForExport(Widget? widget) {
    for (var parser in _parsers) {
      if (parser.matchWidgetForExport(widget)) {
        return parser;
      }
    }
    return null;
  }
}

/// extends this class to make a Flutter widget parser.
abstract class WidgetParser {
  /// parse the json map into a flutter widget.
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener? listener, DataBuilder? dataBuilder);

  /// the widget type name for example:
  /// {"type" : "Text", "data" : "Denny"}
  /// if you want to make a flutter Text widget, you should implement this
  /// method return "Text", for more details, please see
  /// @TextWidgetParser
  String get widgetName;

  /// export the runtime widget to json
  Map<String, dynamic>? export(Widget? widget, BuildContext? buildContext);

  /// match current widget
  Type get widgetType;

  bool matchWidgetForExport(Widget? widget) => widget.runtimeType == widgetType;
}

abstract class ClickListener {
  void onClicked(String? event);
}

abstract class DataBuilder {
  Future<String> buildData(String data);
}

class NonResponseWidgetClickListener implements ClickListener {
  static final Logger log = Logger('NonResponseWidgetClickListener');

  @override
  void onClicked(String? event) {
    log.info("receiver click event: " + event!);
    print("receiver click event: " + event);
  }
}
