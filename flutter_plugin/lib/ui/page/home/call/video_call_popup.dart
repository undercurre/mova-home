import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/home/call/video_call_state_notifier.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class VideoCallPopup extends ConsumerStatefulWidget {
  const VideoCallPopup({super.key});

  @override
  VideoCallPopupState createState() => VideoCallPopupState();
}

class VideoCallPopupState extends ConsumerState<VideoCallPopup> {
  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      return Container(
        color: style.textMain,
        child: Column(
          children: [
            Padding(
                padding:
                    const EdgeInsets.only(top: 180, bottom: 6).withRTL(context),
                child: Text(
                  ref.watch(videoCallStateNotifierProvider).deviceName ?? '',
                  style: TextStyle(fontSize: 36, color: style.textWhite),
                )),
            Text(
              'video_call_invite'.tr(),
              style: TextStyle(fontSize: 16, color: style.textWhite),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 100).withRTL(context),
              child: Row(children: [
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                      image:
                          AssetImage(resource.getResource('ic_call_negative')),
                      width: 80,
                      height: 80,
                    ).onClick(() {
                      ref
                          .read(videoCallStateNotifierProvider.notifier)
                          .acceptOrRejectCall(false);
                    }),
                    Padding(
                        padding: const EdgeInsets.only(top: 5).withRTL(context),
                        child: Text('reject'.tr(),
                            style: TextStyle(
                                fontSize: 14, color: style.textWhite))),
                  ],
                )),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                      image:
                          AssetImage(resource.getResource('ic_call_positive')),
                      width: 80,
                      height: 80,
                    ).onClick(() {
                      SmartDialog.dismiss();
                    }),
                    Padding(
                        padding: const EdgeInsets.only(top: 5).withRTL(context),
                        child: Text('video_call_accept'.tr(),
                            style: TextStyle(
                                fontSize: 14, color: style.textWhite))),
                  ],
                )),
              ]),
            )
          ],
        ),
      );
      // ]);
    });
  }
}
