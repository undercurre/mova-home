import 'package:flutter/material.dart';

class StyleModel {
  final Brightness brightness;

  // main color
  Color normal;
  Color click;
  Color btnText;

  // text color
  Color textMain;
  Color textBrand;
  Color textNormal;
  Color textSecond;
  Color textDisable;
  Color textWhite;
  Color bgGray;
  Color bgClear;
  Color divider;

  // danger color
  Color red1;

  /// dialog 背景色
  double input_number = 36;
  double huge = 28;
  double large = 24;
  double head = 20;
  double secondary = 18;
  double largeText = 16;
  double middleText = 14;
  double smallText = 12;
  double miniText = 10;

  double viewBorder = 4;
  double cellBorder = 8;
  double circular12 = 12;
  double circular20 = 20;
  double circular8 = 8;
  double circular4 = 4;
  double buttonBorder = 8;
  double textFieldBorder = 8;
  double tagBorder = 3;

  //Alert
  Color cancelBtnBg;
  Gradient cancelBtnGradient;
  Gradient confirmBtnGradient;
  Gradient disableBtnGradient;
  Color disableBtnTextColor;
  Color enableBtnTextColor;

  /// 统一主题颜色设计稿：
  /// dark主题：https://mastergo.com/file/151869082265920?fileOpenFrom=project&page_id=1%3A43057
  /// light主题：
  /// https://mastergo.com/file/145051188544903?page_id=1%3A3994&shareId=145051188544903&devMode=true
  /// (MovaHome主题flutter规范):
  /// [https://dreametech.feishu.cn/wiki/IwXYwDtHAisSDZkaAYucq25Xnle?from=from_copylink]
  ///
  /// 颜色值透明度的百分数：https://blog.csdn.net/ezconn/article/details/90052114
  /// (light)黑色/炭黑 ---- (dark)灰色1
  /// (light)灰色2/灰色3 ---- (dark)灰色3
  /// (light)纯白 ---- (dark)炭黑
  /// (light)重点金 ---- (dark)品牌金色
  /// (light)红色 ---- (dark)红色
  /// (light)绿色 ---- (dark)绿色
  /// (light)黄色 ---- (dark)黄色

  /// 品牌色
  Gradient brandColorGradient; // 金色渐变
  Gradient brandAlphaColorGradient; // 金色渐变50%
  Color brandGoldColor; // 品牌金色
  Color largeGold; // 重金（一级按钮文字）
  Color largeAlphaGold; // 重金（一级按钮文字）50%
  Color lightGold; // 浅金色

  /// 其他颜色
  Color white; // 纯白
  Color carbonBlack; // 炭黑
  Color black; // 纯黑
  Color lightBlack; // 浅黑
  Color lightBlack1; // 浅黑1
  Color lightBlack2; // 浅黑2
  Color lightBlack3; // 浅黑3
  Color bgBlack; // 背景黑
  Color blackAlpha80; // 黑色透明20%
  Color gray1; // 灰色1(背景)
  Color gray2; // 灰色2（次级按钮文字失效 /分隔线）
  Color gray3; // 灰色3（辅助/说明）
  Color red; // 红色（高级警告/禁区）
  Color green; // 绿色（正常/确认）
  Color yellow; // 黄色（中级警告/拖地禁区）
  Color blueShare; // 蓝色
  Color linkGold; // 可点击金色, 亮色模式是重点金, 深色模式的品牌金
  Color lightBeige; // 浅棕色

  // 弹窗按钮左右的颜色
  Color cancelBtnTextColor;
  Color confirmBtnTextColor;

  Gradient badgeBlueGradient; // 角标蓝色
  Gradient badgeGoldGradient; // 角标金色
  Gradient smartManagedGradient; // 智能托管色
  Gradient blackGradient; // 黑色渐变
  Gradient grayGradient; //灰色渐变

  // light和dark模式下的颜色值是相同的
  Color lightDartWhite;
  Color lightDartBlack;

  StyleModel._({
    required this.brightness,
    required this.normal,
    required this.click,
    required this.btnText,
    required this.blueShare,
    required this.textMain,
    required this.textBrand,
    required this.textNormal,
    required this.textSecond,
    required this.textDisable,
    required this.textWhite,
    required this.bgGray,
    required this.bgClear,
    required this.divider,
    required this.red1,
    required this.huge,
    required this.large,
    required this.head,
    required this.secondary,
    required this.largeText,
    required this.middleText,
    required this.smallText,
    required this.miniText,
    required this.cancelBtnBg,
    required this.cancelBtnGradient,
    required this.confirmBtnGradient,
    required this.disableBtnGradient,
    required this.disableBtnTextColor,
    required this.enableBtnTextColor,
    required this.brandColorGradient, // 品牌色渐变
    required this.brandAlphaColorGradient, // 品牌色渐变50%
    required this.brandGoldColor, // 品牌金色
    required this.largeGold, // 重金（一级按钮文字）
    required this.largeAlphaGold, // 重金（一级按钮文字）50%
    required this.lightGold, // 浅金色
    required this.linkGold, // 可点击金色
    required this.lightBeige, // 浅棕色
    required this.white, // 纯白
    required this.carbonBlack, // 炭黑
    required this.black, // 纯黑
    required this.lightBlack, // 浅黑
    required this.lightBlack1, // 浅黑1
    required this.lightBlack2, // 浅黑2
    required this.lightBlack3, // 浅黑3
    required this.bgBlack, // 背景黑
    required this.blackAlpha80, // 黑色透明20%
    required this.gray1, // 灰色1(背景)
    required this.gray2, // 灰色2（次级按钮文字失效 /分隔线）
    required this.gray3, // 灰色3（辅助/说明）
    required this.red, // 红色（高级警告/禁区）
    required this.green, // 绿色（正常/确认）
    required this.yellow, // 黄色（中级警告/拖地禁区）
    required this.cancelBtnTextColor, // 取消按钮文字颜色
    required this.confirmBtnTextColor, // 确认按钮文字颜色
    required this.badgeBlueGradient, // 角标蓝色
    required this.badgeGoldGradient, // 角标金色
    required this.smartManagedGradient, // 智能托管色
    required this.blackGradient, // 黑色渐变
    required this.grayGradient, // 灰色渐变
    required this.lightDartWhite, // light和dark模式下的白色
    required this.lightDartBlack, // light和dark模式下的黑色
  });

  factory StyleModel.fromBrightness(Brightness brightness) {
    if (brightness == Brightness.light) {
      return StyleModel._(
        brightness: brightness,
        normal: const Color(0xFF353535),
        click: const Color(0xFF855640),
        btnText: const Color(0xFF855640),
        blueShare: const Color(0xff3370FF),
        textMain: const Color(0xFF353535),
        textBrand: const Color(0xFFC69E6D),
        textNormal: const Color(0xFF353535),
        textSecond: const Color(0xFF8D8D8D),
        textDisable: const Color(0xFFC3C3C3),
        textWhite: const Color(0xFFFFFFFF),
        bgGray: const Color(0xFFF4F4F4),
        bgClear: Colors.transparent,
        divider: const Color(0xFFD8D8D8),
        red1: const Color(0xFFFF5252),
        huge: 28,
        large: 24,
        head: 20,
        secondary: 18,
        largeText: 16,
        middleText: 14,
        smallText: 12,
        miniText: 10,
        cancelBtnBg: const Color(0xffEBEBEB),
        cancelBtnGradient: const LinearGradient(
          colors: [Color(0xFFEBEBEB), Color(0xFFE4E2E2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        confirmBtnGradient: const LinearGradient(
          colors: [Color(0xFFF7EAC1), Color(0xFFD7BC9C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        disableBtnGradient: const LinearGradient(
          colors: [Color(0x80F7EAC1), Color(0x80D7BC9C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        disableBtnTextColor: const Color(0x80855640),
        enableBtnTextColor: const Color(0xFF855640),
        brandColorGradient: const LinearGradient(
          colors: [Color(0xFFF7EAC1), Color(0xFFD7BC9C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 品牌色渐变
        brandAlphaColorGradient: const LinearGradient(
          colors: [Color(0x80F7EAC1), Color(0x80D7BC9C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 品牌色渐变50%
        brandGoldColor: const Color(0xFFC69E6D),
        // 品牌金色
        largeGold: const Color(0xFF855640),
        // 重金（一级按钮文字）
        largeAlphaGold: const Color(0x80855640),
        // 重金（一级按钮文字）
        lightGold: const Color(0xFFF1E8DA),
        // 浅金色
        linkGold: const Color(0xFF855640),
        // 浅棕色
        lightBeige: const Color(0xFFE8DEC1),
        // 可点击金色
        white: const Color(0xFFFFFFFF),
        // 背景白
        carbonBlack: const Color(0xFF353535),
        // 炭黑
        black: const Color(0xFFFFFFFF),
        // 纯黑
        lightBlack: const Color(0xFFF6F6F6),
        // 浅黑
        blackAlpha80: const Color(0x66FFFFFF),
        //浅黑1
        lightBlack1: const Color(0xFFEBEBEB),
        //浅黑2
        lightBlack2: const Color(0xFFF4F4F4),
        //浅黑3
        lightBlack3: const Color(0xFFFFFFFF),
        // 黑色透明20%
        bgBlack: const Color(0xFFF4F4F4),
        // 背景黑
        gray1: const Color(0xFFF4F4F4),
        // 灰色1(背景)
        gray2: const Color(0xFFC3C3C3),
        // 灰色2（次级按钮文字失效 /分隔线）
        gray3: const Color(0xFF8D8D8D),
        // 灰色3（辅助/说明）
        red: const Color(0xFFFD1919),
        // 红色（高级警告/禁区）
        green: const Color(0xFF60D625),
        // 绿色（正常/确认）
        yellow: const Color(0xFFFFC60A),
        // 黄色（中级警告/拖地禁区）
        cancelBtnTextColor: const Color(0xFF353535),
        // 取消按钮文字颜色
        confirmBtnTextColor: const Color(0xFF855640),
        // 确认按钮文字颜色
        badgeBlueGradient: const LinearGradient(
          colors: [Color(0xE367ABE8), Color(0x24A3CDF4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 角标蓝色渐变
        badgeGoldGradient: const LinearGradient(
          colors: [Color(0xF0EBE0D6), Color(0x69DDBCA1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 角标金色渐变
        smartManagedGradient: const LinearGradient(
          colors: [Color(0xF75D88EA), Color(0xFF7B4FFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 智能托管渐变
        blackGradient: const LinearGradient(
          colors: [Color(0xFF333333), Color(0xFF1A1A1A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 黑色渐变
        grayGradient: const LinearGradient(
          colors: [Color(0xFFE4E2E2), Color(0xFFEBEBEB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 灰色渐变
        lightDartWhite: const Color(0xFFFFFFFF),
        // light和dark模式下的白色
        lightDartBlack: const Color(0xFF353535), // light和dark模式下的黑色
      );
    } else {
      // 暗黑模式颜色值
      return StyleModel._(
        brightness: brightness,
        normal: const Color(0xFFF4F4F4),
        click: const Color(0xFFC69E6D),
        btnText: const Color(0xFF855640),
        blueShare: const Color(0xff3370FF),
        textMain: const Color(0xFFF4F4F4),
        textBrand: const Color(0xFFC69E6D),
        textNormal: const Color(0xFFF4F4F4),
        textSecond: const Color(0xFF8D8D8D),
        textDisable: const Color(0xFF8D8D8D),
        textWhite: const Color(0xFFFFFFFF),
        bgGray: const Color(0xFF262626),
        bgClear: Colors.transparent,
        divider: const Color(0xFFC3C3C3),
        red1: const Color(0xFFFF5252),
        huge: 28,
        large: 24,
        head: 20,
        secondary: 18,
        largeText: 16,
        middleText: 14,
        smallText: 12,
        miniText: 10,
        cancelBtnBg: const Color(0xffEBEBEB),
        cancelBtnGradient: const LinearGradient(
          colors: [Color(0xFFEBEBEB), Color(0xFFE4E2E2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        confirmBtnGradient: const LinearGradient(
          colors: [Color(0xFFF7EAC1), Color(0xFFD7BC9C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        disableBtnGradient: const LinearGradient(
          colors: [Color(0x80F7EAC1), Color(0x80D7BC9C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        disableBtnTextColor: const Color(0xFF553D32),
        enableBtnTextColor: const Color(0xFF855640),
        brandColorGradient: const LinearGradient(
          colors: [Color(0xFFF7EAC1), Color(0xFFD7BC9C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 品牌色渐变
        brandAlphaColorGradient: const LinearGradient(
          colors: [Color(0x80F7EAC1), Color(0x80D7BC9C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 品牌色渐变50%
        brandGoldColor: const Color(0xFFC69E6D),
        // 品牌金色
        largeGold: const Color(0xFF855640),
        // 重金（一级按钮文字）
        largeAlphaGold: const Color(0xFF553D32),
        // 重金（一级按钮文字）
        lightGold: const Color(0xFFF1E8DA),
        // 浅金色
        linkGold: const Color(0xFFC69E6D),
        // 浅棕色
        lightBeige: const Color(0xFFE8DEC1),
        // 可点击金色
        white: const Color(0xFF353535),
        // 背景白
        carbonBlack: const Color(0xFFF4F4F4),
        // 炭黑
        black: const Color(0xFF000000),
        // 纯黑
        lightBlack: const Color(0xFF404040),
        // 浅黑1
        lightBlack1: const Color(0xFF404040),
        // 浅黑2
        lightBlack2: const Color(0xFF404040),
        // 浅黑3
        lightBlack3: const Color(0xFF262626),
        // 浅黑
        bgBlack: const Color(0xFF262626),
        // 背景黑
        blackAlpha80: const Color(0x33000000),
        // 黑色透明20%
        gray1: const Color(0xFF262626),
        // 灰色1(背景)
        gray2: const Color(0xFFC3C3C3),
        // 灰色2（次级按钮文字失效 /分隔线）
        gray3: const Color(0xFF8D8D8D),
        // 灰色3（辅助/说明）
        red: const Color(0xFFFF5252),
        // 红色（高级警告/禁区）
        green: const Color(0xFF55AB29),
        // 绿色（正常/确认）
        yellow: const Color(0xFFFFC60A),
        // 黄色（中级警告/拖地禁区）
        cancelBtnTextColor: const Color(0xFF353535),
        // 取消按钮文字颜色
        confirmBtnTextColor: const Color(0xFF855640),
        // 确认按钮文字颜色
        badgeBlueGradient: const LinearGradient(
          colors: [Color(0xE367ABE8), Color(0x24A3CDF4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 角标蓝色渐变
        badgeGoldGradient: const LinearGradient(
          colors: [Color(0xF0EBE0D6), Color(0x69DDBCA1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 角标金色渐变
        smartManagedGradient: const LinearGradient(
          colors: [Color(0xF75D88EA), Color(0xFF7B4FFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 智能托管渐变
        blackGradient: const LinearGradient(
          colors: [Color(0xFFE4E2E2), Color(0xFFEBEBEB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 黑色渐变
        grayGradient: const LinearGradient(
          colors: [Color(0xFFE4E2E2), Color(0xFFEBEBEB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // 灰色渐变
        lightDartWhite: const Color(0xFFFFFFFF),
        // light和dark模式下的白色
        lightDartBlack: const Color(0xFF353535), // light和dark模式下的黑色
      );
    }
  }

  // 文字颜色
  Color get textMainBlack => carbonBlack;

  Color get textMainWhite => white;

  Color get textSecondGray => gray3; // 灰色3（辅助/说明）
  Color get bgWhite => white; // 纯白
  Color get bgColor => bgBlack;

  Color get disableBtnTextColorGold => largeAlphaGold;

  Color get enableBtnTextColorGold => largeGold;

  // 首页tabbar的颜色
  Color get tabBarSelected {
    if (brightness == Brightness.light) {
      return carbonBlack;
    } else {
      return brandGoldColor;
    }
  }

  // 首页tabbar的颜色
  Color get tabBarNormal {
    if (brightness == Brightness.light) {
      return gray3;
    } else {
      return gray2;
    }
  }

  // 首页字体颜色
  Color get homeDeviceNameTextColor {
    if (brightness == Brightness.light) {
      return carbonBlack;
    } else {
      return brandGoldColor;
    }
  }

  // 首页字体颜色
  Color get homeDeviceStateTextColor {
    if (brightness == Brightness.light) {
      return textSecondGray;
    } else {
      return gray2;
    }
  }

  // 设备共享页面
  Color get deviceSharedTabIndicatorColor {
    if (brightness == Brightness.light) {
      return lightDartBlack;
    } else {
      return brandGoldColor;
    }
  }

  Color get moreProductTabSelectedColor {
    if (brightness == Brightness.light) {
      return carbonBlack;
    } else {
      return gray2;
    }
  }

  Color get moreProductTextColor {
    return white;
  }

  Color get sendCodeTextColor {
    if (brightness == Brightness.light) {
      return gray3;
    } else {
      return brandGoldColor;
    }
  }

  Color get homeDeviceMonitorColor {
    if (brightness == Brightness.light) {
      return carbonBlack;
    } else {
      return blackAlpha80;
    }
  }

  // 配网进度（active）
  Color get pairProcessActiveColor {
    if (brightness == Brightness.light) {
      return largeGold;
    } else {
      return brandGoldColor;
    }
  }

  // 配网进度（inActive）
  Color get pairProcessInActiveColor {
    if (brightness == Brightness.light) {
      return gray2;
    } else {
      return gray3;
    }
  }

  Color get loadingActiveColor {
    if (brightness == Brightness.light) {
      return brandGoldColor;
    } else {
      return brandGoldColor;
    }
  }

 

  Color get loadingInActiveColor {
    if (brightness == Brightness.light) {
      return gray2;
    } else {
      return lightBlack;
    }
  }

  // 开发模式的颜色
  Color get developerTextColor {
    if (brightness == Brightness.light) {
      return gray2;
    } else {
      return lightDartWhite;
    }
  }

  Color get fastCmdPopBgColor {
    if (brightness == Brightness.light) {
      return const Color(0x80FFFFFF);
    } else {
      return const Color(0x99353535);
    }
  }

  Color get fastCmdPopBtnBgColor {
    if (brightness == Brightness.light) {
      return const Color(0x7FFFFFFF);
    } else {
      return const Color(0x99353535);
    }
  }

  Color get fastCmdPopItemBgColor {
    if (brightness == Brightness.light) {
      return const Color(0x7FFFFFFF);
    } else {
      return const Color(0x99353535);
    }
  }

  Color get fastCmdPopBorderColor {
    if (brightness == Brightness.light) {
      return const Color(0x7FFFFFFF);
    } else {
      return const Color(0x33FFFFFF);
    }
  }

  Color get homeRightMenuBorderColor {
    if (brightness == Brightness.light) {
      return white;
    } else {
      return const Color(0x33FFFFFF);
    }
  }

  Color get homeRightMenuBgColor {
    if (brightness == Brightness.light) {
      return white;
    } else {
      return blackAlpha80;
    }
  }

  Color get homeCleanTextDisableColor {
    if (brightness == Brightness.light) {
      return gray3;
    } else {
      return const Color(0x80D7BC9C);
    }
  }

  // 首页字体颜色
  Color get homeCleanTextColor {
    if (brightness == Brightness.light) {
      return carbonBlack;
    } else {
      // 品牌金色在这个按钮的dark下太暗了。
      return const Color(0xFFE3CDAA);
    }
  }

  Color get homePageIndicatorColor {
    if (brightness == Brightness.light) {
      return gray2;
    } else {
      return const Color(0x33FFFFFF);
    }
  }

  Color get homePageIndicatorActiveColor {
    if (brightness == Brightness.light) {
      return brandGoldColor;
    } else {
      return brandGoldColor;
    }
  }

  Color get questionSuggestTagSelectedBgColor {
    if (brightness == Brightness.light) {
      return const Color(0xFFF4F4F4);
    } else {
      return lightGold;
    }
  }

  Color get questionSuggestTagSelectedTextColor {
    return largeGold;
  }

  Color get questionSuggestTagBgColor {
    return lightBlack2;
  }

  Color get questionSuggestTagTextColor {
    return largeGold;
  }

  /// textStyle
  ///

  TextStyle normalStyle(
      {double fontSize = 14,
      Color? color,
      FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        color: color ?? normal, fontSize: fontSize, fontWeight: fontWeight);
  }

  TextStyle clickStyle(
      {double fontSize = 14, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(color: click, fontSize: fontSize, fontWeight: fontWeight);
  }

  TextStyle buttonTextStyle(
      {double fontSize = 14, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        color: btnText, fontSize: fontSize, fontWeight: fontWeight);
  }

  TextStyle mainStyle(
      {double fontSize = 14, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        color: textMainBlack, fontSize: fontSize, fontWeight: fontWeight);
  }

  TextStyle textNormalStyle({double fontSize = 14}) {
    return TextStyle(
        color: textNormal, fontSize: fontSize, fontWeight: FontWeight.w400);
  }

  TextStyle secondStyle({double fontSize = 14}) {
    return TextStyle(
        color: textSecond, fontSize: fontSize, fontWeight: FontWeight.w400);
  }

  TextStyle thirdStyle({double fontSize = 14}) {
    return TextStyle(
        color: textMainBlack, fontSize: fontSize, fontWeight: FontWeight.w400);
  }

  TextStyle fourthStyle({double fontSize = 16}) {
    return TextStyle(
        color: textMainBlack, fontSize: fontSize, fontWeight: FontWeight.w400);
  }

  TextStyle fifthStyle({double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: textMain,
    );
  }

  TextStyle disableStyle(
      {double fontSize = 14, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        color: textDisable, fontSize: fontSize, fontWeight: fontWeight);
  }

  TextStyle errorStyle(
      {double fontSize = 14, FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(color: red1, fontSize: fontSize, fontWeight: fontWeight);
  }
}
