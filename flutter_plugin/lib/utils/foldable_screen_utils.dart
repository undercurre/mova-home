import 'dart:ui';

import 'package:flutter/material.dart';

class FoldableScreenUtils {
  FoldableScreenUtils._();

  static final FoldableScreenUtils _instance = FoldableScreenUtils._();

  factory FoldableScreenUtils() => _instance;

  /// 屏幕处于横向展开状态
  bool isFoldScreenHorizontalExpansion(BuildContext context) {
    final displayFeatures = MediaQuery.of(context).displayFeatures;

    if (displayFeatures.isEmpty) {
      return _isFoldScreenRatio(context);
    }
    // 如果有 hinge，并且状态是折叠（铰链区域有效）
    for (var feature in displayFeatures) {
      if (feature.type == DisplayFeatureType.hinge ||
          feature.type == DisplayFeatureType.fold) {
        return _isFoldScreenRatio(context);
      }
    }
    return false;
  }

  bool _isFoldScreenRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if (width / height > 9 / 16) {
      // 横屏展开
      return true;
    }
    return false;
  }
}
