import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';

class ProductSuggestDeviceDialog extends StatefulWidget {
  final Offset offset;
  final Size size;
  final List<DeviceModel> productList;
  final int select;
  final Function(int) onSelect;

  const ProductSuggestDeviceDialog({
    super.key,
    required this.offset,
    required this.size,
    required this.productList,
    required this.select,
    required this.onSelect,
  });

  @override
  State<ProductSuggestDeviceDialog> createState() {
    return _ProductSuggestDeviceDialogState();
  }
}

class _ProductSuggestDeviceDialogState
    extends State<ProductSuggestDeviceDialog> {
  @override
  Widget build(BuildContext context) {
    int itemnumber = widget.productList.length;
    if (itemnumber > 3) {
      itemnumber = 3;
    }

    return ThemeWidget(builder: (context, style, resource) {
      return Align(
          alignment: isLTR(context) ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            width: 271,
            height: itemnumber * 52,
            margin: EdgeInsets.only(
              top: widget.offset.dy + widget.size.height,
              right: 20,
            ).withRTL(context),
            decoration: BoxDecoration(
              color: style.bgWhite,
              borderRadius: BorderRadius.circular(style.circular20),
            ),
            clipBehavior: Clip.hardEdge,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.productList.length,
              itemBuilder: (context, index) {
                DeviceModel device = widget.productList[index];
                return GestureDetector(
                  onTap: () {
                    widget.onSelect(index);
                    SmartDialog.dismiss(tag: 'product_suggest_device_dialog');
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 52,
                      child: Column(children: [
                        Expanded(
                            child: Row(children: [
                          (device.deviceInfo?.mainImage.imageUrl ?? '').isEmpty
                              ? Image.asset(
                                  resource.getResource('ic_placeholder_robot'),
                                  width: 36,
                                  height: 36,
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      device.deviceInfo?.mainImage.imageUrl ??
                                          '',
                                  errorWidget: (context, string, _) {
                                    return Image.asset(
                                      resource
                                          .getResource('ic_placeholder_robot'),
                                      width: 36,
                                      height: 36,
                                    );
                                  },
                                  width: 36,
                                  height: 36,
                                ),
                          if (!device.master)
                            Container(
                              decoration: BoxDecoration(
                                color: style.blueShare,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              margin: const EdgeInsets.only(left: 4)
                                  .withRTL(context),
                              clipBehavior: Clip.hardEdge,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              child: Text(
                                'message_setting_share'.tr(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: style.textWhite,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 4, right: 12)
                                  .withRTL(context),
                              child: Text(
                                device.getShowName(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: style.textMain,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: widget.select == index
                                ? Image.asset(
                                    resource.getResource('ic_suggest_check'),
                                    width: 24,
                                    height: 24,
                                  )
                                : null,
                          ),
                        ])),
                        Divider(
                          height: 1,
                          color: style.lightBlack1,
                        )
                      ])),
                );
              },
            ),
          ));
    });
  }
}
