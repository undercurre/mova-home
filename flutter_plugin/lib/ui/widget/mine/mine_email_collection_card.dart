import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/mine/expand_text.dart';
import 'package:flutter_plugin/ui/widget/mine/expand_text_span.dart';
import 'package:flutter_plugin/ui/widget/mine/mine_email_collection_painter.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';

class MineEmailCollectionCard extends StatefulWidget {
  MineEmailCollectionCard({
    super.key,
    this.exitCallBack,
    this.bindCallBack,
    this.subscribeCallBack,
    this.email,
  });

  final Function()? exitCallBack;
  final Function()? bindCallBack;
  final Function()? subscribeCallBack;
  String? email;
  @override
  MineEmailCollectionCardState createState() => MineEmailCollectionCardState();
}

class MineEmailCollectionCardState extends State<MineEmailCollectionCard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ThemeWidget(
          builder: (context, style, resource) {
            return Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white, // 背景色
                borderRadius: BorderRadius.circular(style.cellBorder), // 圆角半径
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        // width: double.infinity,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 12).withRTL(context),
                          child: Column(children: [
                            if (widget.email != null)
                              Container(
                                margin: const EdgeInsets.only(top: 17),
                                padding: const EdgeInsets.only(
                                    top: 12, bottom: 12, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  color: style.bgColor, // 背景色
                                  borderRadius:
                                      BorderRadius.circular(8), // 圆角半径
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      resource
                                          .getResource('email_collect_email'),
                                      width: 24,
                                      height: 24,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Text(
                                          widget.email ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: style.carbonBlack),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        widget.bindCallBack?.call();
                                      },
                                      child: Image.asset(
                                        resource.getResource(
                                            'email_collect_switch'),
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12, left: 10)
                                  .withRTL(context),
                              child: ExpandText(
                                'email_collection_alert_content'.tr(),
                                style: style.secondStyle(fontSize: 12),
                                animation: true,
                                animationDuration: const Duration(seconds: 1),
                                expandWidget: ExpandTextSpan(
                                    child: SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: Image.asset(
                                        resource.getResource('more_text_open'),
                                        width: 12,
                                        height: 8,
                                      ),
                                    ),
                                    size: const Size(12, 12)),
                                collapseWidget: ExpandTextSpan(
                                    child: SizedBox(
                                      width: 12,
                                      height: 15,
                                      child: Image.asset(
                                        resource.getResource('more_text_close'),
                                        width: 12,
                                        height: 8,
                                      ),
                                    ),
                                    size: const Size(12, 15)),
                                maxLines: 4,
                              ),
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                        width: 37,
                        child: GestureDetector(
                          onTap: () {
                            widget.exitCallBack?.call();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Image.asset(
                              resource.getResource('email_collect_exit'),
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  DMCommonClickButton(
                    backgroundGradient: style.confirmBtnGradient,
                    disableBackgroundGradient: style.disableBtnGradient,
                    borderRadius: style.buttonBorder,
                    disableTextColor: style.disableBtnTextColor,
                    textColor: style.enableBtnTextColor,
                    text: (widget.email ?? '').isNotEmpty
                        ? 'subscribe'.tr()
                        : 'bind_and_subscribe'.tr(),
                    onClickCallback: () {
                      widget.subscribeCallBack?.call();
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
