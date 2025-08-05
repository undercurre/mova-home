import 'package:flutter/material.dart';
import 'package:flutter_plugin/js/js_widget.dart';
import 'package:flutter_plugin/ui/dynamic_widget/dynamic_widget.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoPage extends BasePage {
  const DemoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DemoPageState();
}

class _DemoPageState extends BasePageState {
  GlobalKey key = GlobalKey();
  // late JavascriptRuntime flutterJs;
  String json = "{}";
  String jsContent1 = '';
  String jsContent2 = '';
  @override
  void initState() {
    super.initState();
    // flutterJs = getJavascriptRuntime(xhr: false);
    // flutterJs.onMessage('getData', (args) async {
    //   return '$args back to js';
    // });

    // flutterJs.onMessage('buildUI', (args) async {
    //   setState(() {
    //     json = jsonEncode(args);
    //   });
    //   // SmartDialog.showToast(args.toString());
    // });

    // flutterJs.onMessage('toast', (args) async {
    //   SmartDialog.showToast(args['msg']);
    // });

    // flutterJs.evaluate('''
    //             async function showToast(msg){
    //               console.log("showToast",msg);
    //               await sendMessage("toast", JSON.stringify({msg}));
    //             }
    //         ''');
  }

  @override
  void initData() {
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: JSWidget(
              key: Key('a'),
              jsContent: jsContent1,
            )),
        Expanded(
            flex: 1,
            child: JSWidget(
              key: Key('b'),
              jsContent: jsContent2,
            )),
        const SizedBox(
          height: 100,
        ),
        // DynamicWidgetJsonExportor(
        //     key: key,
        //     child: Column(
        //       children: [
        //         Text(
        //           "12313131",
        //           style: TextStyle(color: Colors.red),
        //         ),
        //         CachedNetworkImage(
        //           imageUrl: '',
        //           errorWidget: (context, url, error) => const Image(
        //               height: 100,
        //               image: AssetImage(
        //                   'assets/light/icons/3.0x/ic_placeholder_robot.png')),
        //           placeholder: (context, url) => const Image(
        //               height: 100,
        //               image: AssetImage(
        //                   'assets/light/icons/3.0x/ic_placeholder_robot.png')),
        //           fadeInDuration: Duration.zero,
        //           fadeOutDuration: Duration.zero,
        //           fit: BoxFit.fitHeight,
        //         ),
        //         CachedNetworkImage(
        //           imageUrl: '',
        //           errorWidget: (context, url, error) => const Image(
        //               height: 100,
        //               image: AssetImage(
        //                   'assets/light/icons/3.0x/ic_placeholder_robot.png')),
        //           placeholder: (context, url) => const Image(
        //               height: 100,
        //               image: AssetImage(
        //                   'assets/light/icons/3.0x/ic_placeholder_robot.png')),
        //           fadeInDuration: Duration.zero,
        //           fadeOutDuration: Duration.zero,
        //           fit: BoxFit.fitHeight,
        //         ),
        //       ],
        //     )),
        DMButton(
          height: 50,
          width: 100,
          text: '111',
          onClickCallback: (context) async {
            // await FileDownloader.downloadFile(
            //   'https://oss.iot.dreame.tech/extensions/1058/plugins/ios/dreame.vacuum.r2215_20.zip',
            // );
          },
        ),
        DMButton(
          height: 50,
          width: 100,
          text: '222',
          onClickCallback: (context) async {
            setState(() {
              jsContent2 = '''
                    function onClick(msg) {
                        showToast(msg);
                    }
                    async function main() {
                        try {
                            var json = JSON.stringify({
                                "type": "CachedNetworkImage",
                                "click": "onClick('hello')",
                                "imageUrl": "https://img.zcool.cn/community/019ef25e79940ba80120a895cec45d.jpg@2o.jpg",
                                "errorWidget": {
                                    "type": "AssetImage",
                                    "name": "assets/light/icons/3.0x/ic_placeholder_robot.png",
                                    "excludeFromSemantics": false,
                                    "height": 100.0,
                                    "alignment": "center",
                                    "repeat": "noRepeat",
                                    "matchTextDirection": false,
                                    "gaplessPlayback": false,
                                    "filterQuality": "low"
                                },
                                "placeholder": {
                                    "type": "AssetImage",
                                    "name": "assets/light/icons/3.0x/ic_placeholder_robot.png",
                                    "excludeFromSemantics": false,
                                    "height": 100.0,
                                    "alignment": "center",
                                    "repeat": "noRepeat",
                                    "matchTextDirection": false,
                                    "gaplessPlayback": false,
                                    "filterQuality": "low"
                                }
                            });
                            buildUI(json)
                            console.log(typeof json);
                            // showToast("dafdas");
                        } catch (e) {
                            err = e.message || e;
                            console.log("??????", e);
                        }
                        return null;
                    }
            ''';
            });
          },
        )
      ],
    );
  }

  // @override
  // Future<String> buildData(String data) async {
  //   if (data.startsWith('property')) {
  //     await Future.delayed(const Duration(seconds: 2));
  //     return data.replaceFirst(RegExp(r'property'), 'this is property');
  //   }
  //   if (data.startsWith('image')) {
  //     return 'https://pic.qqtn.com/up/2018-7/2018072714491670421.jpg';
  //   }
  //   if (data.startsWith('photo')) {
  //     return 'https://ww4.sinaimg.cn/large/9150e4e5ly1fr8ao52sjqg20dw0dw751.gif';
  //   }
  //   return data;
  // }
}

class DefaultClickListener extends ClickListener {
  @override
  void onClicked(String? event) {}
}
