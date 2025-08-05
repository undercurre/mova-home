import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/download/download_provider.dart';
import 'package:flutter_plugin/common/download/download_result.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/widget/animated_rotation_box.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/gradient_circular_progress_indicator.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class HomeDownloadWidget extends ConsumerStatefulWidget {
  final BaseDeviceModel deviceBean;
  const HomeDownloadWidget({super.key, required this.deviceBean});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return HomeDownloadState();
  }
}

class HomeDownloadState extends ConsumerState<HomeDownloadWidget> {
  String symbol = ',';
  @override
  void initState() {
    super.initState();
    LocalModule().getLangTag().then((langTag) {
      if (langTag.contains('zh')) {
        setState(() {
          symbol = '，';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      explicitChildNodes:  true,
      child: ThemeWidget(builder: (context, style, resource) {
        return Container(
            decoration: BoxDecoration(
                color: style.bgWhite,
                borderRadius:
                    BorderRadius.all(Radius.circular(style.circular20))),
            child: Stack(
              fit: StackFit.loose,
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: DMButton(
                    backgroundColor: Colors.transparent,
                    onClickCallback: (context) {
                      ref
                          .read(pluginProvider.notifier)
                          .hideUpdatePlugin(widget.deviceBean.did);
                      SmartDialog.dismiss();
                    },
                    prefixWidget: Semantics(
                      label: 'close_popup'.tr(),
                      child: Image(
                        image: AssetImage(resource.getResource('ic_clean_close')),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ).withRTL(context),
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(42, 38, 42, 41).withRTL(context),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const AnimatedRotationBox(
                      child: GradientCircularProgressIndicator(
                        stokeWidth: 5,
                        strokeCapRound: true,
                        colors: [
                          Color(0x00DDBCA1),
                          Color(0x60DDBCA1),
                          Color(0x80DDBCA1),
                          Color(0xFFDDBCA1),
                          Color(0xFFDDBCA1),
                        ],
                        radius: 25,
                        value: 1,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 19),
                    Stack(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 112),
                          child: Text(
                              style: TextStyle(
                                  color: style.textSecond,
                                  fontSize: style.middleText),
                              '${'Text_DevicePage_PluginDownloading_Status'.tr()}$symbol${ref.watch(pluginProvider).progress}%'),
                        ),
                      ],
                    )
                  ]),
                )
              ],
            ));
      }),
    );
  }
}
