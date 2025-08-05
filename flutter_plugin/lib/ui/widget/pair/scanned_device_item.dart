import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';

class ScannedDeviceItem extends StatefulWidget {
  final IotDevice iotDevice;
  final ItemPosition position;
  final VoidCallback? onSelect;

  ScannedDeviceItem({
    required this.iotDevice,
    this.position = ItemPosition.qrScan,
    this.onSelect,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return ScannedDeviceItemState();
  }
}

class ScannedDeviceItemState extends State<ScannedDeviceItem> {
  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return GestureDetector(
        onTap: () {
          if (widget.onSelect != null) {
            widget.onSelect!();
          }
        },
        child: Container(
          width: widget.position == ItemPosition.qrScan ? 233 : 187,
          height: widget.position == ItemPosition.qrScan ? 72 : 64,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(style.buttonBorder)),
              color: widget.position == ItemPosition.qrScan
                  ? style.lightDartWhite
                  : style.lightBlack),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 3,
                child: (widget.iotDevice.product?.mainImage?.imageUrl ?? '')
                        .isEmpty
                    ? Image.asset(
                        resource.getResource('ic_placeholder_robot'),
                        width: 56,
                        height: 56,
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            widget.iotDevice.product?.mainImage?.imageUrl ?? '',
                        width: 56,
                        height: 56,
                        fit: BoxFit.contain,
                      ),
              ),
              widget.position == ItemPosition.qrScan
                  ? Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            widget.iotDevice.product?.displayName ?? '',
                            minFontSize: 12,
                            maxFontSize: 14,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: style.lightDartBlack,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'search_nearby_device'.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: style.textSecondGray,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  : Expanded(
                      flex: 4,
                      child: Text(
                        widget.iotDevice.product!.displayName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: style.carbonBlack,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
              Expanded(
                flex: 2,
                child: Image.asset(
                  resource.getResource('ic_product_scanned_indicator'),
                  width: 24,
                  height: 24,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

enum ItemPosition { qrScan, productList }
