import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_model.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_ui_state.dart';
import 'package:flutter_plugin/ui/widget/dm_switch.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageSettingPage extends BasePage {
  static const String routePath = '/message_settings';

  const MessageSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MessageSettingPageState();
  }
}

class MessageSettingPageState extends BasePageState {
  @override
  String get centerTitle => 'mine_message_setting'.tr();
  final double _contentPadidng = 20;

  @override
  void initPageState() {}

  @override
  void initData() {
    ref.watch(messageSettingNotifierProvider.notifier).initData();
    ref.watch(messageSettingNotifierProvider.notifier).getDefaultServerData();
    ref.watch(messageSettingNotifierProvider.notifier).getMessageSet();
  }

  void _serverSetingValueChange(ServiceSetingModel model, bool value) {
    ref
        .watch(messageSettingNotifierProvider.notifier)
        .putMessageSettingWithServiceModel(model);
  }

  void _deviceSetingValueChange(DeviceItemModel model, bool value) {
    ref
        .watch(messageSettingNotifierProvider.notifier)
        .putMessageSettingWithDeviceModel(model);
  }

  Widget _setingItemWithModel(BuildContext context, StyleModel style,
      ResourceModel resource, ServiceSetingModel model, bool showLine) {
    String titleString = model.title;
    String subTitleString = model.subTitle;
    bool switchValue = model.value;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0).withRTL(context),
          height: 84,
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 2).withRTL(context),
                        child: Text(
                          titleString,
                          style: TextStyle(
                              fontSize: style.largeText,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              color: style.textMain),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2).withRTL(context),
                        child: Text(subTitleString,
                            style: TextStyle(
                                fontSize: style.middleText,
                                fontWeight: FontWeight.normal,
                                color: style.textSecond)),
                      )
                    ]),
              ),
              SizedBox(
                width: 60,
                height: 24,
                child: DMSwitch(
                  width: 46,
                  height: 24,
                  activeImage:
                      AssetImage(resource.getResource('btn_switch_on')),
                  inActiveImage:
                      AssetImage(resource.getResource('btn_switch_off')),
                  value: switchValue,
                  onChanged: (value) {
                    _serverSetingValueChange(model, value);
                  },
                ),
              ),
              /*

                  */
            ],
          ),
        ),
        (showLine == true)
            ? Container(
                padding: const EdgeInsets.only(left: 0, right: 0),
                height: 1,
                child: Container(
                    color: style.lightBlack1,
                    width: double.infinity,
                    child: const SizedBox(height: 1)))
            : const SizedBox()
      ],
    );
  }

  Widget _deviceItemWithModel(BuildContext context, StyleModel style,
      ResourceModel resource, DeviceItemModel model) {
    String? titleString = model.deviceName;
    String? iconURL = model.icon;
    bool? switchValue = model.notify;
    List<Widget> textLabels = [
      Flexible(
        flex: 1,
        child: Container(
          padding: const EdgeInsets.only(bottom: 4, right: 8).withRTL(context),
          child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: style.largeText,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  color: style.textMain),
              titleString!),
        ),
      ),
    ];

    if (model.share == 1) {
      textLabels.add(Container(
        margin: const EdgeInsets.only(right: 10).withRTL(context),
        decoration: BoxDecoration(
            color: style.blueShare,
            borderRadius: BorderRadius.all(Radius.circular(style.circular4))),
        padding: const EdgeInsets.fromLTRB(6, 4, 6, 3),
        child: RichText(
          text: TextSpan(
            text: 'message_setting_share'.tr(),
            style: TextStyle(
              height: 1,
              color: style.textWhite,
              fontSize: style.miniText,
            ),
          ),
        ),
      ));
    }

    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0).withRTL(context),
        height: 80,
        decoration: BoxDecoration(
            color: style.bgClear,
            borderRadius: BorderRadius.all(Radius.circular(style.circular8))),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(right: 12).withRTL(context),
                    width: 64,
                    height: 64,
                    child: (iconURL ?? '').isEmpty == true
                        ? Image.asset(
                            resource.getResource('ic_placeholder_robot'),
                            width: 48,
                            height: 48,
                          )
                        : CachedNetworkImage(
                            imageUrl: iconURL!,
                            placeholder: (context, string) {
                              return Image.asset(
                                resource.getResource('ic_placeholder_robot'),
                                width: 48,
                                height: 48,
                              );
                            },
                            errorWidget: (context, string, _) {
                              return Image.asset(
                                resource.getResource('ic_placeholder_robot'),
                                width: 48,
                                height: 48,
                              );
                            },
                            width: 48,
                            height: 48,
                          )),
                Expanded(
                  flex: 1,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: textLabels),
                ),
                SizedBox(
                    width: 46,
                    height: 24,
                    child: DMSwitch(
                      width: 46,
                      height: 24,
                      activeImage:
                          AssetImage(resource.getResource('btn_switch_on')),
                      inActiveImage:
                          AssetImage(resource.getResource('btn_switch_off')),
                      value: switchValue,
                      onChanged: (value) {
                        _deviceSetingValueChange(model, value);
                      },
                    )),
              ],
            )
          ],
        ));
  }

  Widget _settingSection(BuildContext context, StyleModel style,
      ResourceModel resource, MessageSettingUiState uiState) {
    List<ServiceSetingModel> sourceList = [];
    List<Widget> widgetList = [];
    if (uiState.systemMessage != null) sourceList.add(uiState.systemMessage!);
    if (uiState.shareMessage != null) sourceList.add(uiState.shareMessage!);
    if (uiState.serviceMessage != null) sourceList.add(uiState.serviceMessage!);

    for (int i = 0; i < sourceList.length; i++) {
      ServiceSetingModel? model = sourceList[i];
      bool showLine = (i == (sourceList.length - 1)) ? true : false;
      widgetList
          .add(_setingItemWithModel(context, style, resource, model, showLine));
    }

    Widget section = Container(
      decoration: BoxDecoration(
          color: style.bgClear,
          borderRadius: BorderRadius.all(Radius.circular(style.circular8))),
      child: Column(
        children: widgetList,
      ),
    );
    return section;
  }

  List<Widget> _devciceSection(BuildContext context, StyleModel style,
      ResourceModel resource, MessageSettingUiState uiState) {
    List<Widget> widgetList = [];
    if (uiState.devieList.isEmpty) {
      return widgetList;
    }

    Widget titleSection = Container(
      color: style.bgClear,
      padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('text_device_message'.tr(),
              style: TextStyle(
                  fontSize: style.largeText,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  color: style.textMain)),
          Text('text_receive_device_message'.tr(),
              style: TextStyle(
                  fontSize: style.middleText, color: style.textSecond))
        ],
      ),
    );

    Widget deviceSection = Column(
      children: [
        ...uiState.devieList
            .map((e) => _deviceItemWithModel(context, style, resource, e)),
      ],
    );
    widgetList.add(titleSection);
    widgetList.add(deviceSection);
    return widgetList;
  }

  Widget buildSectionListSection(BuildContext context, StyleModel style,
      ResourceModel resource, MessageSettingUiState uiState) {
    List<Widget> widgetList = [];
    widgetList.add(_settingSection(context, style, resource, uiState));
    widgetList.addAll(_devciceSection(context, style, resource, uiState));

    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        scrollDirection: Axis.vertical,
        reverse: false,
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: _contentPadidng),
          child: Column(children: widgetList),
        ));
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    MessageSettingUiState uiState = ref.watch(messageSettingNotifierProvider);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: style.bgGray,
      child: buildSectionListSection(context, style, resource, uiState),
    );
  }
}
