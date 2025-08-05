import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/share/popup/device_share_popup_notifier.dart';
import 'package:flutter_plugin/ui/page/message/share/share_message_list_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceSharePopup extends ConsumerStatefulWidget {
  final String deviceName;
  final String shareContent;
  final String imageUrl;
  final String? messageId;
  final int? ackResult;
  final String? did;
  final String? model;
  final String? ownUid;
  final VoidCallback dismissCallback;

  const DeviceSharePopup(this.deviceName, this.shareContent, this.imageUrl,
      {this.messageId,
      this.ackResult,
      this.did,
      this.model,
      this.ownUid,
      required this.dismissCallback,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeviceSharePopupState();
}

class _DeviceSharePopupState extends ConsumerState<DeviceSharePopup>
    with CommonDialog {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deviceSharePopupNotifierProvider.notifier).initData(
          widget.ackResult ?? 0,
          widget.did ?? '',
          widget.model ?? '',
          widget.ownUid ?? '',
          widget.messageId ?? '');
    });
    ref
        .read(deviceSharePopupNotifierProvider.notifier)
        .readMessageById(widget.messageId ?? '');
  }

  Widget _buildBtn(StyleModel style) {
    switch (widget.ackResult) {
      case 0:
        if (widget.messageId == null || widget.messageId!.isEmpty) {
          return Row(
            children: [
              Expanded(
                  child: DMButton(
                      width: double.infinity,
                      onClickCallback: (_) {
                        ref
                            .read(deviceSharePopupNotifierProvider.notifier)
                            .ackshareFromDevice(
                              false,
                              widget.did ?? '',
                              widget.model ?? '',
                              widget.ownUid ?? '',
                            );
                      },
                      text: 'reject'.tr(),
                      fontsize: 14,
                      textColor: style.textMainWhite,
                      fontWidget: FontWeight.w500,
                      backgroundGradient: style.cancelBtnGradient,
                      borderRadius: style.buttonBorder,
                      padding: const EdgeInsets.symmetric(vertical: 14))),
              const Visibility(
                  visible: true,
                  child: SizedBox(
                    width: 32,
                  )),
              Expanded(
                  child: DMButton(
                      width: double.infinity,
                      onClickCallback: (_) {
                        ref
                            .read(deviceSharePopupNotifierProvider.notifier)
                            .ackshareFromDevice(
                              true,
                              widget.did ?? '',
                              widget.model ?? '',
                              widget.ownUid ?? '',
                            );
                      },
                      text: 'accept'.tr(),
                      fontsize: 14,
                      textColor: style.btnText,
                      fontWidget: FontWeight.w500,
                      backgroundGradient: style.confirmBtnGradient,
                      borderRadius: style.buttonBorder,
                      padding: const EdgeInsets.symmetric(vertical: 14)))
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                  child: DMButton(
                      width: double.infinity,
                      onClickCallback: (_) async {
                        await ref
                            .read(deviceSharePopupNotifierProvider.notifier)
                            .ackShareFromMessage(widget.messageId ?? '', false);
                      },
                      text: 'reject'.tr(),
                      fontsize: 14,
                      textColor: style.lightDartBlack,
                      fontWidget: FontWeight.w500,
                      backgroundGradient: style.cancelBtnGradient,
                      borderRadius: style.buttonBorder,
                      padding: const EdgeInsets.symmetric(vertical: 14))),
              const Visibility(
                  visible: true,
                  child: SizedBox(
                    width: 32,
                  )),
              Expanded(
                  child: DMButton(
                      width: double.infinity,
                      onClickCallback: (_) async {
                        await ref
                            .read(deviceSharePopupNotifierProvider.notifier)
                            .ackShareFromMessage(widget.messageId ?? '', true);
                      },
                      text: 'accept'.tr(),
                      fontsize: 14,
                      textColor: style.btnText,
                      fontWidget: FontWeight.w500,
                       backgroundGradient: style.confirmBtnGradient,
                      borderRadius: style.buttonBorder,
                      padding: const EdgeInsets.symmetric(vertical: 14)))
            ],
          );
        }
      case 1:
        return DMButton(
            width: double.infinity,
            onClickCallback: (_) {},
            text: 'already_accept'.tr(),
            textColor: style.green,
            fontsize: 14,
            fontWidget: FontWeight.w500,
            backgroundColor: style.lightBlack,
            borderRadius: style.buttonBorder,
            padding: const EdgeInsets.symmetric(vertical: 14));
      case 2:
        return DMButton(
            width: double.infinity,
            onClickCallback: (_) {},
            text: 'already_reject'.tr(),
            textColor: style.red1,
            fontsize: 14,
            fontWidget: FontWeight.w500,
            backgroundColor: style.lightBlack,
            borderRadius: style.buttonBorder,
            padding: const EdgeInsets.symmetric(vertical: 14));
      case 3:
        return DMButton(
            width: double.infinity,
            onClickCallback: (_) {},
            text: 'already_invalid'.tr(),
            textColor: style.textDisable,
            fontsize: 14,
            fontWidget: FontWeight.w500,
            backgroundColor: style.lightBlack,
            borderRadius: style.buttonBorder,
            padding: const EdgeInsets.symmetric(vertical: 14));
    }
    return const Spacer();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
        deviceSharePopupNotifierProvider.select((value) => value.uiEvent),
        ((previous, next) {
      if (next is ToastEvent) {
        if (next.text.isNotEmpty) {
          showToast(next.text);
        }
        widget.dismissCallback.call();
      }
    }));
    bool rtl = (Directionality.of(context) == view_direction.TextDirection.rtl);
    bool isAfterSale =
        ref.watch(developerMenuPageStateNotifierProvider).afterSaleEnable;
    return Semantics(
      explicitChildNodes: true,
      child: ThemeWidget(
        builder: (_, style, resource) {
          return Column(
            children: [
              const Spacer(),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 90).withRTL(context),
                    child: GestureDetector(
                      onTap: () {
                        if (isAfterSale) {
                          LogUtils.d('tap tap');
                          ref
                              .read(shareMessageListNotifierProvider.notifier)
                              .openPlugin('home', widget.did);
                        }
                      },
                      child: Container(
                        height: 360,
                        decoration: BoxDecoration(
                            color: style.bgWhite,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(style.circular20),
                                topRight: Radius.circular(style.circular20))),
                        child: Semantics(
                          explicitChildNodes: true,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12, top: 12)
                                              .withRTL(context),
                                      child: Align(
                                        alignment: rtl
                                            ? Alignment.centerLeft
                                            : Alignment.centerRight,
                                        child:
                                        Semantics(
                                          label: 'close_popup'.tr(),
                                          button: true,
                                          enabled: true,
                                          child: Image(
                                            image: AssetImage(resource
                                                .getResource('ic_dialog_close')),
                                            width: 24,
                                            height: 24,
                                          ).withDynamic().onClick(() {
                                            widget.dismissCallback.call();
                                          }),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                            top: 150, left: 48, right: 48)
                                        .withRTL(context),
                                    child: Text(
                                      widget.deviceName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: style.mainStyle(fontSize: 24),
                                    ),
                                  ),
                                  Visibility(
                                    visible: isAfterSale,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                              top: 2, left: 48, right: 48)
                                          .withRTL(context),
                                      child: Text('did: ${widget.did ?? ''}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 13)),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 50,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                                  top: 10, left: 48, right: 48)
                                              .withRTL(context),
                                          child: Text(
                                            widget.shareContent,
                                            textAlign: TextAlign.center,
                                            style: style.secondStyle(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ))),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                            left: 32,
                                            right: 32,
                                            top: 16,
                                            bottom: 16)
                                        .withRTL(context),
                                    child: FocusableActionDetector(
                                        autofocus: true,
                                        child: _buildBtn(style)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Semantics(
                    explicitChildNodes: true,
                    child: Align(
                      alignment: Alignment.center,
                      child: widget.imageUrl.isEmpty == true
                          ? Semantics(
                              label: 'popup_image'.tr(),
                              child: Image.asset(
                                resource.getResource('ic_placeholder_robot'),
                                height: 260,
                              ).withDynamic(),
                            )
                          : Semantics(
                              label: 'popup_image'.tr(),
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrl,
                                errorWidget: (context, url, _) => Image.asset(
                                  resource
                                      .getResource('ic_placeholder_robot'),
                                  height: 260,
                                ).withDynamic(),
                                width: 260,
                                height: 260,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
