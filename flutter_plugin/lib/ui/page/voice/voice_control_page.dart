import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/voice/voice_control_state_notifier.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:go_router/go_router.dart';

class VoiceControlPage extends BasePage {
  static const String routePath = '/voice_control_page';

  const VoiceControlPage({super.key});

  @override
  VoiceControlPageState createState() => VoiceControlPageState();
}

class VoiceControlPageState extends BasePageState<VoiceControlPage>
    with ResponseForeUiEvent {
  @override
  String get centerTitle => 'VoiceControl_Page_Title'.tr();

  @override
  void initData() {
    ref.read(voiceControlStateNotifierProvider.notifier).init();
  }

  @override
  void addObserver() {
    ref.listen(
        voiceControlStateNotifierProvider.select((value) => value.uiEvent),
        (previous, next) {
      if (next != null) {
        responseFor(next);
      }
    });
  }

  Widget _buildFooter(StyleModel style, ResourceModel resource) {
    return Visibility(
        visible: !ref.watch(voiceControlStateNotifierProvider).isForeign,
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 4, bottom: 14).withRTL(context),
                child: Text(
                  'manual_for_speaker'.tr(),
                  style: style.secondStyle(),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: style.bgWhite,
                  borderRadius: BorderRadius.circular(style.circular8),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(WebPage.routePath,
                            extra: WebViewRequest(
                                defaultTitle: 'manual_for_voice_command'.tr(),
                                uri: WebUri(
                                    'https://cdn.cnbj2.fds.api.mi-img.com/000002-public/resource/smarthome_useSpecial.html?${DateTime.now().millisecondsSinceEpoch}')));
                      },
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              resource.getResource('ic_voice_usage'),
                              width: 24,
                            ),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'manual_for_voice_command'.tr(),
                                style: style.mainStyle(),
                              ),
                            )),
                            Image.asset(
                              resource.getResource('icon_arrow_right2'),
                              width: 7,
                              height: 13,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 26).withRTL(context),
                      child: Divider(
                        height: 1,
                        color: style.lightBlack1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push(WebPage.routePath,
                            extra: WebViewRequest(
                                defaultTitle:
                                    'manual_for_designate_room_cleaning'.tr(),
                                uri: WebUri(
                                    'https://cdn.cnbj2.fds.api.mi-img.com/000002-public/resource/smarthome_roomUseSpecial.html?${DateTime.now().millisecondsSinceEpoch}')));
                      },
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              resource.getResource('ic_voice_clean'),
                              width: 24,
                            ),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'manual_for_designate_room_cleaning'.tr(),
                                style: style.mainStyle(),
                              ),
                            )),
                            Image.asset(
                              resource.getResource('icon_arrow_right'),
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      color: style.bgGray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 29, top: 22),
            child: Text(
              'manual_for_speaker_connect'.tr(),
              style: style.mainStyle(fontSize: 18),
            ),
          ),
          GridView.builder(
            itemCount:
                ref.watch(voiceControlStateNotifierProvider).soundList.length,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item =
                  ref.read(voiceControlStateNotifierProvider).soundList[index];
              return GestureDetector(
                onTap: () => ref
                    .read(voiceControlStateNotifierProvider.notifier)
                    .onItemClick(item),
                child: Container(
                  decoration: BoxDecoration(
                    color: style.bgWhite,
                    borderRadius: BorderRadius.circular(style.circular8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: AspectRatio(
                        aspectRatio: 0.42,
                        child: item.imageUrl.isEmpty == true
                            ? Image(
                                fit: BoxFit.fitWidth,
                                image: AssetImage(resource
                                    .getResource('ic_placeholder_robot')),
                              ).withDynamic()
                            : CachedNetworkImage(
                                imageUrl: item.imageUrl,
                                errorWidget: (context, url, error) => Image(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(resource
                                      .getResource('ic_placeholder_robot')),
                                ).withDynamic(),
                                placeholder: (context, url) => Image(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(resource
                                      .getResource('ic_placeholder_robot')),
                                ).withDynamic(),
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                fit: BoxFit.fitWidth,
                              ),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 16),
                        child: Text(
                          item.name,
                          style: style.mainStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // 暂时没有配置mova的使用教程链接
          // _buildFooter(style, resource),
        ],
      ),
    );
  }
}
