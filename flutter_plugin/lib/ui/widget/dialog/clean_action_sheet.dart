import 'dart:convert';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/home/command_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CleanActionSheet extends ConsumerStatefulWidget {
  final VoidCallback? addCommandCallback;
  final Function(int)? editCommandCallback;
  final VoidCallback? closeCallback;
  final Function(String)? toastCallback;

  const CleanActionSheet(
      {super.key,
      this.closeCallback,
      this.addCommandCallback,
      this.editCommandCallback,
      this.toastCallback});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return CleanActionSheetState();
  }
}

class CleanActionSheetState extends ConsumerState<CleanActionSheet> {
  Widget _buildTitle(style) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, bottom: 16).withRTL(context),
      child: Text(
        'text_clean_sheet_command_title'.tr(),
        style: TextStyle(
            fontSize: 14, color: style.textNormal, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildEmpty() {
    return ThemeWidget(
      builder: (context, style, resource) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(style),
            Flexible(
                child: view_direction.Center(
              child: Image.asset(
                resource.getResource('ic_empty_command'),
              ).withDynamic(),
            )),
            Padding(
                padding: const EdgeInsets.only(
                        top: 26, left: 32, right: 32, bottom: 18)
                    .withRTL(context),
                child: RichText(
                    text: TextSpan(
                        text: 'text_clean_sheet_command_hint'.tr(),
                        style: TextStyle(
                            color: style.textNormal,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        children: [
                      WidgetSpan(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 5).withRTL(context),
                          child: Image.asset(
                            resource.getResource(''),
                            width: 20,
                            height: 20,
                          ).withDynamic(),
                        ),
                      )
                    ]))),
          ],
        );
      },
    );
  }

  Widget _buildCommand() {
    return ThemeWidget(builder: (context, style, resource) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scrollbar(
          thickness: 3,
          thumbVisibility: (ref.watch(homeStateNotifierProvider).currentDevice
                      as VacuumDeviceModel)
                  .fastCommandList!
                  .length >
              3,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: (ref.watch(homeStateNotifierProvider).currentDevice
                          as VacuumDeviceModel)
                      .fastCommandList!
                      .length +
                  1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildTitle(style);
                }
                FastCommandModel command = (ref
                        .watch(homeStateNotifierProvider)
                        .currentDevice as VacuumDeviceModel)
                    .getFastCommandList()![index - 1];
                return Column(
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.zero,
                      ),
                      margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 6, bottom: 6)
                          .withRTL(context),
                      padding: const EdgeInsets.symmetric(horizontal: 20)
                          .withRTL(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              utf8.decode(base64.decode(command.name ?? '')),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: style.textMain, fontSize: 14),
                            ),
                          ),
                          Image.asset(
                            resource.getResource(
                                command.state == '0' || command.state == '1'
                                    ? 'ic_command_edit_disable'
                                    : 'ic_command_edit'),
                            width: 32,
                            height: 32,
                          ).withDynamic().onClick(() {
                            if (command.state == '0' || command.state == '1') {
                              widget.toastCallback
                                  ?.call('quickCommandPerforming'.tr());
                            } else {
                              widget.editCommandCallback?.call(command.id);
                            }
                          }),
                          Container(
                            width: 1,
                            height: 16,
                            color: const Color(0xFFD8D8D8),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          Image(
                            width: 32,
                            height: 32,
                            image: AssetImage(command.state == '1'
                                ? resource.getResource('ic_command_pause')
                                : resource.getResource('ic_command_normal')),
                          ).withDynamic()
                        ],
                      ),
                    ).onClick(() {
                      ref
                          .read(fastCommandStateNotifierProvider.notifier)
                          .onFastCommandClick(command);
                    }),
                    Visibility(
                      visible: index !=
                          (ref.watch(homeStateNotifierProvider).currentDevice
                                  as VacuumDeviceModel)
                              .fastCommandList!
                              .length,
                      child: Container(
                        height: 0.5,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        color: style.lightBlack1,
                      ),
                    ),
                  ],
                );
              }),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      bool rtl =
          (Directionality.of(context) == view_direction.TextDirection.rtl);
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(style.circular20),
                topRight: Radius.circular(style.circular20)),
            color: style.bgWhite),
        height: 380,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Align(
              alignment: rtl ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 4)
                      .withRTL(context),
                  child: Image(
                    width: 24,
                    height: 24,
                    image: AssetImage(resource.getResource('ic_clean_close')),
                  ).withDynamic().onClick(() {
                    widget.closeCallback?.call();
                  }))),
          Expanded(
              child: ((ref.watch(homeStateNotifierProvider).currentDevice
                                  as VacuumDeviceModel)
                              .fastCommandList ??
                          [])
                      .isNotEmpty
                  ? _buildCommand()
                  : _buildEmpty()),
          DMButton(
              height: 48,
              borderRadius: style.circular8,
              width: double.infinity,
              margin: const EdgeInsets.only(
                      bottom: 45, left: 20, right: 20, top: 20)
                  .withRTL(context),
              backgroundColor: style.lightBlack1,
              onClickCallback: (_) {
                widget.closeCallback?.call();
                widget.addCommandCallback?.call();
              },
              text: 'text_clean_sheet_command_create'.tr(),
              fontsize: 16,
              textColor: style.textMain,
              fontWidget: FontWeight.w400,
              surffixWidget: Padding(
                padding: const EdgeInsets.only(left: 10).withRTL(context),
                child: Image.asset(
                  resource.getResource('ic_add_command'),
                  width: 20,
                  height: 20,
                ).withDynamic(),
              )),
        ]),
      );
    });
  }
}
