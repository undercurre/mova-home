import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'dart:math' as math;

import 'package:flutter_plugin/utils/widget_extension.dart';

/// 帮助中心设置cell
class HelpCenterSettingCell extends StatelessWidget {
  final String image;
  final String title;
  final String? desc;
  final StyleModel style;
  final bool isExpand;
  final ResourceModel resource;
  final VoidCallback onTap;

  const HelpCenterSettingCell(
      {required this.style,
      required this.resource,
      required this.image,
      required this.title,
      this.desc,
      required this.onTap,
      this.isExpand = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, child: buildWidget(context));
  }

  Widget buildWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 12).withRTL(context),
      constraints: const BoxConstraints(minHeight: 90),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(
              resource.getResource(image),
            ),
            width: 40,
            height: 40,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: desc != null
                  ? [
                      Text(
                        title,
                        style: style.mainStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc ?? '',
                        style: style.disableStyle(fontSize: 12),
                      ),
                    ]
                  : [
                      Text(
                        title,
                        style: style.mainStyle(fontSize: 16),
                      ),
                    ],
            ),
          )),
          Container(
            height: 90,
            child: isExpand
                ? Transform.rotate(
                    angle: isExpand
                        ? (isLTR(context) ? math.pi / 2 : -math.pi / 2)
                        : 0,
                    child: Image(
                      image: AssetImage(
                        resource.getResource('ic_help_arrow_24'),
                      ),
                      width: 24,
                      height: 24,
                    ).flipWithRTL(context),
                  )
                : Image.asset(
                    width: 24,
                    height: 24,
                    resource.getResource('ic_help_arrow_24'),
                  ).flipWithRTL(context),
          )
        ],
      ),
    );
  }
}
