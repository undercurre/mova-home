import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/configure/app_res_config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension WidgetDetectorExtension on Widget {
  Widget onClick(onClickCallback,
      {int ms = 800, HitTestBehavior behavior = HitTestBehavior.opaque}) {
    bool clickable = true;
    return GestureDetector(
      behavior: behavior,
      child: this,
      onTap: () {
        if (clickable) {
          clickable = false;
          onClickCallback();
          Future.delayed(Duration(milliseconds: ms), () {
            clickable = true;
          });
        }
      },
    );
  }

  Widget flipWithRTL(BuildContext context) {
    bool rtl = (Directionality.of(context) == TextDirection.rtl);
    return !rtl
        ? this
        : Transform(
            transform: Matrix4.rotationY(pi),
            alignment: FractionalOffset.center,
            child: this);
  }
}

extension PositionedExtension on Positioned {
  Positioned withRTL(BuildContext context) {
    bool rtl = (Directionality.of(context) == TextDirection.rtl);
    if (rtl) {
      if (left != null && left != 0) {
        return Positioned(
          right: left,
          top: top,
          bottom: bottom,
          child: child,
        );
      } else if (right != null && right != 0) {
        return Positioned(
          left: right,
          top: top,
          bottom: bottom,
          child: child,
        );
      }
    }
    return this;
  }
}

extension ImageExtention on Image {
  Widget withDynamic() {
    if (image is AssetBundleImageProvider) {
      String assetName = '';
      if (image is AssetImage) {
        assetName = (image as AssetImage).assetName;
      } else if (image is ExactAssetImage) {
        assetName = (image as ExactAssetImage).assetName;
      }
      return Consumer(builder: (_, ref, child) {
        String path = ref
            .read(appResConfigProviderProvider.notifier)
            .getIconPath(assetName);
        return path.isEmpty
            ? this
            : Image.file(
                File(path),
                width: width,
                height: height,
                fit: fit,
                semanticLabel: semanticLabel,
                excludeFromSemantics: excludeFromSemantics,
                color: color,
                colorBlendMode: colorBlendMode,
                alignment: alignment,
                repeat: repeat,
                centerSlice: centerSlice,
                matchTextDirection: matchTextDirection,
                gaplessPlayback: gaplessPlayback,
                filterQuality: filterQuality,
              );
      });
    }
    return this;
  }
}
