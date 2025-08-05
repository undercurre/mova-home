import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/developer/discuz_debug/discuz_debug_page_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscuzDebugPage extends BasePage {
  static const String routePath = '/discuz_debug_page';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return DiscuzDebugPageState();
  }
}

class DiscuzDebugPageState extends BasePageState {
  final TextEditingController _ipController = TextEditingController();

  @override
  String get centerTitle => super.centerTitle = '论坛调试';
  @override
  void initData() {
    ref.read(discuzDebugPageStateNotifierProvider.notifier).initData();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        discuzDebugPageStateNotifierProvider.select((value) => value.host),
        (previous, next) {
      _ipController.text = next ?? '';
    });
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'host:',
                style: TextStyle(color: style.textMainBlack),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                flex: 1,
                child: TextField(
                  style: TextStyle(color: style.textMainBlack),
                  controller: _ipController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: style.click), // 自定义下划线颜色
                    ),
                  ),
                  onChanged: (value) {
                    ref
                        .read(discuzDebugPageStateNotifierProvider.notifier)
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
                onClickCallback: (_) {
                  ref
                      .read(discuzDebugPageStateNotifierProvider.notifier)
                      .updateEnable();
                },
                prefixWidget: Icon(
                  Icons.lightbulb_circle,
                  color: ref.watch(discuzDebugPageStateNotifierProvider
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
