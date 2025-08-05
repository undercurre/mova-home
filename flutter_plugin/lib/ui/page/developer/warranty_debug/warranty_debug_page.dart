import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/developer/warranty_debug/warranty_debug_state_notifier.dart';
import 'package:flutter_plugin/ui/page/mine/warranty_cards/warranty_handler_utils.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:lifecycle/lifecycle.dart';

class WarrantyDebugPage extends BasePage {
  static const String routePath = '/mine/developer/warranty';
  const WarrantyDebugPage({super.key});

  @override
  WarrantyDebugPageState createState() {
    return WarrantyDebugPageState();
  }
}

class WarrantyDebugPageState extends BasePageState with ResponseForeUiEvent {
  final TextEditingController _controller = TextEditingController();

  void _updateCountryCode(String code) {
    _controller.text = code;
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);
    if (event == LifecycleEvent.inactive) {
      ref.read(warrantyDebugStateNotifierProvider.notifier).clearMockedData();
    }
  }

  @override
  Future<void> initData() async {
    super.initData();
    await ref.read(warrantyDebugStateNotifierProvider.notifier).initData();
    final initCountryCode = await WarrantyHandlerUtils.getCountryCode();
    _controller.text = initCountryCode;
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        warrantyDebugStateNotifierProvider.select(
          (value) => value.event,
        ), (previous, next) {
      responseFor(next);
    });
  }

  @override
  String get centerTitle => '保修卡调试';

  @override
  Widget get rightItemWidget => SizedBox(
        width: 60,
        height: 52,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            '保存',
            style: TextStyle(
              color: ref.watch(styleModelProvider).textMainBlack,
            ),
          ),
        ).onClick(() async {
          await ref
              .read(warrantyDebugStateNotifierProvider.notifier)
              .saveCountry();
        }),
      );

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    bool isDebug =
        ref.watch(warrantyDebugStateNotifierProvider).debugModel?.isDebug ??
            false;
    bool useCNShopifyLink = ref
            .watch(warrantyDebugStateNotifierProvider)
            .debugModel
            ?.useCNShopifyLink ??
        false;
    bool showOverseaMall = ref
            .read(warrantyDebugStateNotifierProvider)
            .debugModel
            ?.showOverseaMall ??
        false;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        color: style.bgGray,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              key: const Key('country_code_input'),
              controller: _controller,
              style: TextStyle(color: style.textMainBlack),
              decoration: const InputDecoration(
                hintText: '国家编码: ',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              child: DMButton(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(10),
                onClickCallback: (_) async {
                  await ref
                      .read(warrantyDebugStateNotifierProvider.notifier)
                      .updateWarrantyContry(isDebug: !isDebug);
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
                text: '开启保修卡调试',
                textColor: style.textMainBlack,
              ),
            ),
            SizedBox(
              child: DMButton(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(10),
                onClickCallback: (_) async {
                  await ref
                      .read(warrantyDebugStateNotifierProvider.notifier)
                      .updateWarrantyContry(
                          useCNShopifyLink: !useCNShopifyLink);
                },
                prefixWidget: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    resource.getResource(useCNShopifyLink
                        ? 'btn_checkbox_selected'
                        : 'btn_checkbox_normal'),
                    width: 20,
                    height: 20,
                  ),
                ),
                text: '使用国内订单链接',
                textColor: style.textMainBlack,
              ),
            ),
            SizedBox(
              child: DMButton(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(10),
                onClickCallback: (_) async {
                  await ref
                      .read(warrantyDebugStateNotifierProvider.notifier)
                      .updateWarrantyContry(showOverseaMall: !showOverseaMall);
                },
                prefixWidget: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    resource.getResource(showOverseaMall
                        ? 'btn_checkbox_selected'
                        : 'btn_checkbox_normal'),
                    width: 20,
                    height: 20,
                  ),
                ),
                text: '设置海外商城可用',
                textColor: style.textMainBlack,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 13,
                itemBuilder: (context, index) {
                  String country = '';
                  String code = '';
                  switch (index) {
                    case 0:
                      country = '德国';
                      code = 'DE';
                      break;
                    case 1:
                      country = '法国';
                      code = 'FR';
                      break;
                    case 2:
                      country = '意大利';
                      code = 'IT';
                      break;
                    case 3:
                      country = '西班牙';
                      code = 'ES';
                      break;
                    case 4:
                      country = '英国';
                      code = 'GB';
                      break;
                    case 5:
                      country = '瑞士';
                      code = 'CH';
                      break;
                    case 6:
                      country = '奥地利';
                      code = 'AT';
                      break;
                    case 7:
                      country = '荷兰';
                      code = 'NL';
                      break;
                    case 8:
                      country = '比利时';
                      code = 'BE';
                      break;
                    case 9:
                      country = '卢森堡';
                      code = 'LU';
                      break;
                    case 10:
                      country = '葡萄牙';
                      code = 'PT';
                      break;
                    case 11:
                      country = '爱尔兰';
                      code = 'IE';
                      break;
                    case 12:
                      country = '中国';
                      code = 'CN';
                      break;
                  }
                  return ListTile(
                    title: Text(
                      country,
                      style: TextStyle(color: style.textMainBlack),
                    ),
                    subtitle: Text(
                      '国家编码: $code',
                      style: TextStyle(color: style.textMainBlack),
                    ),
                    onTap: () {
                      _updateCountryCode(code);
                      ref
                          .read(warrantyDebugStateNotifierProvider.notifier)
                          .updateWarrantyContry(countryCode: code);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
