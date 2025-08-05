import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/developer/gps_debug/gps_debug_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:lifecycle/lifecycle.dart';

class GPSDebugPage extends BasePage {
  static const String routePath = '/mine/developer/gps';
  const GPSDebugPage({super.key});

  @override
  GPSDebugPageState createState() {
    return GPSDebugPageState();
  }
}

class GPSDebugPageState extends BasePageState with ResponseForeUiEvent {

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);
    if(event == LifecycleEvent.inactive){
      ref.read(gPSDebugStateNotifierProvider.notifier).clearLocationData();
    }
  }

  @override
  Future<void> initData() async {
    super.initData();
    await ref.read(gPSDebugStateNotifierProvider.notifier).initData();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        gPSDebugStateNotifierProvider.select(
          (value) => value.event,
        ), (previous, next) {
      responseFor(next);
    });
  }

  @override
  String get centerTitle => 'GPS模拟调试';

  @override
  Widget get rightItemWidget => SizedBox(
        width: 60,
        height: 52,
        child: Container(
          alignment: Alignment.center,
          child:  Text('保存', 
            style: TextStyle(
              color: ref.watch(styleModelProvider).textMainBlack,
              fontSize: 16,
            ),
          ),
        ).onClick(() async {
          await ref.read(gPSDebugStateNotifierProvider.notifier).saveLocation();
        }),
      );

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    bool isDebug =
        ref.watch(gPSDebugStateNotifierProvider).debugModel?.isDebug ?? false;
    return Container(
      color: style.bgGray,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedInputText(
            key: const Key('lon_input'),
            initialValue:
                ref.watch(gPSDebugStateNotifierProvider).debugModel?.longitude,
            onTextChanged: (string) async {
              await ref
                  .read(gPSDebugStateNotifierProvider.notifier)
                  .updateLocation(longitude: string);
            },
            showCountryCode: false,
            showGetDynamicCode: false,
            textHint: '经度(至少4位小数):',
          ),
          AnimatedInputText(
            key: const Key('lat_input'),
            initialValue:
                ref.watch(gPSDebugStateNotifierProvider).debugModel?.latitude,
            onTextChanged: (string) async {
              await ref
                  .read(gPSDebugStateNotifierProvider.notifier)
                  .updateLocation(latitude: string);
            },
            showCountryCode: false,
            showGetDynamicCode: false,
            textHint: '纬度(至少4位小数):',
          ),
          SizedBox(
            child: DMButton(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.all(10),
              onClickCallback: (_) async {
                await ref
                    .read(gPSDebugStateNotifierProvider.notifier)
                    .updateLocation(isDebug: !isDebug);
              },
              prefixWidget: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  resource.getResource(isDebug
                      ? 'btn_checkbox_selected'
                      : 'btn_checkbox_normal'),
                  width: 20,
                  height: 20,
                ),
              ),
              textColor: style.textMainBlack,
              text: "开启GPS调试",
            ),
          ),
        ],
      ),
    );
  }
}
