import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class HelpCenterProductCell extends StatelessWidget {
  final HelpCenterProduct product;

  final VoidCallback? onTap;

  const HelpCenterProductCell({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    String displayName = product.displayName ?? '';
    String avatarUrl = product.mainImage?.imageUrl ?? '';
    return ThemeWidget(builder: (_, style, resource) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 12).withRTL(context),
        height: 90,
        child: GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                // 图片
                avatarUrl.isEmpty == true
                    ? Image.asset(
                        resource.getResource('ic_placeholder_robot'),
                        width: 60,
                        height: 60,
                      ).withDynamic()
                    : CachedNetworkImage(
                        imageUrl: avatarUrl,
                        width: 60,
                        height: 60,
                        errorWidget: (context, string, _) {
                          return Image.asset(
                            resource.getResource('ic_placeholder_robot'),
                            width: 60,
                            height: 60,
                          );
                        },
                      ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text(displayName,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      style: style.normalStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      )),
                ),
                Image(
                  image: AssetImage(
                    resource.getResource('ic_product_card_enter'),
                  ),
                  width: 24,
                  height: 24,
                ).flipWithRTL(context),
              ],
            )),
      );
    });
  }
}
