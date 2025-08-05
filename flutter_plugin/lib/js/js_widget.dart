import 'dart:convert';

import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_plugin/common/configure/app_config_prodiver.dart';
import 'package:flutter_plugin/js/js_runtime.dart';
import 'package:flutter_plugin/model/local_model.dart';
import 'package:flutter_plugin/ui/dynamic_widget/dynamic_widget.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JSWidget extends ConsumerStatefulWidget {
  String jsContent;
  JSWidget({super.key, required this.jsContent});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JSWidgetState();
}

class _JSWidgetState extends ConsumerState
    with JSRuntime
    implements ClickListener {
  String json = '';
  late JavascriptRuntime flutterJs;

  @override
  void initState() {
    super.initState();
    flutterJs = init();
  }

  @override
  void didUpdateWidget(covariant ConsumerStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    String oldJsContent = (oldWidget as JSWidget).jsContent;
    String newJsContent = (widget as JSWidget).jsContent;
    if (oldJsContent != newJsContent) {
      if (newJsContent != '') {
        flutterJs.evaluate(newJsContent);
        flutterJs
            .evaluateAsync('main()')
            .then((jsResult) => flutterJs.handlePromise(jsResult))
            .then((asyncResult) => LogUtils.d(asyncResult.stringResult));
        flutterJs.executePendingJob();
      }
    }
  }

  Future<Widget?> _buildWidget(BuildContext context) async {
    return DynamicWidgetBuilder.build(json, context, this, null);
  }

  @override
  Widget build(BuildContext context) {
    if (json != '') {
      return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              LogUtils.e(snapshot.error);
            }
            return snapshot.hasData
                ? SizedBox.expand(
                    child: snapshot.data,
                  )
                : const Text('Loading...');
          },
          future: _buildWidget(context));
    }
    return const SizedBox.shrink();
  }

  @override
  void buildUI(String json) {
    setState(() {
      this.json = json;
    });
  }

  @override
  Future<String> getAppConfig() async {
    LocalModel localModel =
        await ref.read(appConfigProvider.notifier).getConfig();
    Map<String, dynamic> localModelMap = {
      'region': localModel.region,
      'userInfo': jsonEncode(localModel.userInfo),
    };
    return localModelMap.toString();
  }

  @override
  void onClicked(String? event) {
    flutterJs.evaluate('$event');
  }

  @override
  void showJSToast(msg) {
    SmartDialog.showToast(msg['msg']);
  }

  @override
  Future<String> getCurrentDevice() {
    // TODO: implement getCurrentDevice
    throw UnimplementedError();
  }

  @override
  Future<String> getKeyDefine(params) {
    // TODO: implement getKeyDefine
    throw UnimplementedError();
  }

  @override
  Future<String> getLocalImagePath() {
    // TODO: implement getLocalImagePath
    throw UnimplementedError();
  }

  @override
  void sendCommond(params) {
    // TODO: implement sendCommond
  }

  @override
  void showJSDialog(msg) {
    // TODO: implement showJSDialog
  }
}
