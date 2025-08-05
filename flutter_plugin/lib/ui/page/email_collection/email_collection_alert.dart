import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/email_collection_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class EmailCollectionAlert extends ConsumerStatefulWidget {
  const EmailCollectionAlert({super.key});

  @override
  EmailCollectionAlertState createState() {
    return EmailCollectionAlertState();
  }
}

class EmailCollectionAlertState extends ConsumerState<EmailCollectionAlert> {
  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.only(left: 32, right: 32),
              decoration: BoxDecoration(
                color: style.bgBlack, // 背景色
                borderRadius: BorderRadius.circular(style.circular20), // 圆角半径
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, right: 14),
                        child: Image.asset(
                          resource.getResource('email_collect_exit'),
                          width: 24,
                          height: 24,
                        ),
                      ),
                      onTap: () {
                        SmartDialog.dismiss(
                            tag: 'tag_email_collection_check_dialog');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Text(
                      'email_collection_top_title'.tr(),
                      style:  TextStyle(
                        color: style.carbonBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // if ((ref.watch(emailCollectionRespositoryProvider
                  //             .select((value) => value.email)) ??
                  //         '')
                  //     .isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 12, top: 17),
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: style.bgBlack, // 背景色
                      borderRadius:
                          BorderRadius.circular(style.circular20), // 圆角半径
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          resource.getResource('email_collect_email'),
                          width: 24,
                          height: 24,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              ref.watch(emailCollectionRespositoryProvider
                                      .select((value) => value.email)) ??
                                  '',
                              style:  TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: style.carbonBlack),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref
                                .watch(
                                    emailCollectionRespositoryProvider.notifier)
                                .changeemain();
                            // updateEvent(PushEvent(
                            // path: MineEmailBindPage.routePath));
                          },
                          child: Image.asset(
                            resource.getResource('email_collect_switch'),
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      'email_collection_alert_content'.tr(),
                      style: TextStyle(
                          fontSize: 12, color: style.textSecondGray),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(24),
                    height: 48,
                    decoration: BoxDecoration(
                      color: style.normal, // 背景色
                      borderRadius:
                          BorderRadius.circular(style.circular8), // 圆角半径
                    ),
                    child: const Text('Subscribe'),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    resource.getResource('email_collect_unselect'),
                    width: 14,
                    height: 14,
                  ),
                ),
                Text(
                  'Not  reminder',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: style.textMainWhite),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
