import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/developer/mall_debug/mall_debug_page_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MallDebugPage extends BasePage {
  static const String routePath = '/mall_debug_page';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MallDebugPageState();
  }
}

class MallDebugPageState extends BasePageState {
  final TextEditingController _ipController = TextEditingController();

  @override
  // TODO: implement centerTitle
  String get centerTitle => super.centerTitle = '商城调试';
  @override
  void initData() {
    ref.read(mallDebugPageStateNotifierProvider.notifier).initData();
  }

  @override
  void addObserver() {
    // TODO: implement addObserver
    super.addObserver();
    ref.listen(mallDebugPageStateNotifierProvider.select((value) => value.host),
        (previous, next) {
      _ipController.text = next ?? '';
    });
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    // TODO: implement buildBody
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Text('host:', style: TextStyle(color: style.textMainBlack),),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                flex: 1,
                child: TextField(
                  controller: _ipController,
                  style: TextStyle(color: style.textMainBlack),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: style.click), // 自定义下划线颜色
                    ),
                  ),
                  onChanged: (value) {
                    // ref
                    //     .read(developerModePageStateNotifierProvider.notifier)
                    //     .saveModels(ip: value);
                    ref
                        .read(mallDebugPageStateNotifierProvider.notifier)
                        .updateHost(value);
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            child: DMButton(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(10),
                onClickCallback: (_) async {
                  await ref
                      .read(mallDebugPageStateNotifierProvider.notifier)
                      .updateEnable();
                },
                prefixWidget: Icon(
                  Icons.lightbulb_circle,
                  color: ref.watch(mallDebugPageStateNotifierProvider
                          .select((value) => value.enable))
                      ? Colors.lightGreen
                      : Colors.grey,
                  size: 60,
                )),
          )
        ],
      ),
    );
  }
}
