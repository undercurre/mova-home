import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';

const Color defaultStokeColor = Color(0x80000000);

class BatteryLevel {
  int color;
  // 左闭右开
  Pair<int, int> level;

  BatteryLevel(this.color, this.level);
}

/// 电池电量控件
class HomeBattery extends StatefulWidget {
  /// 电池电量
  int electricQuantity;

  /// 控件宽高
  double width;
  double height;

  // 是否正在充电中
  bool isCharging;

  /// 控件描边颜色
  Color strokeColor;

  /// 电池充电中
  Color strokeColorCharging;

  List<BatteryLevel> batteryLeve;

  HomeBattery(
      {super.key,
      this.width = 30,
      this.height = 20,
      this.isCharging = false,
      this.strokeColor = defaultStokeColor,
      this.strokeColorCharging = const Color(0xff72e544),
      required this.electricQuantity,
      this.batteryLeve = const []});

  @override
  State<StatefulWidget> createState() {
    return HomeBatteryState();
  }
}

class HomeBatteryState extends State<HomeBattery> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return Stack(
          children: [
            Image.asset(
              resource.getResource('ic_battery_bg'),
              width: widget.width,
              height: widget.height,
            ),
            CustomPaint(
                size: Size(widget.width, widget.height),
                painter: _BatteryViewPainter(
                    isCharging: widget.isCharging,
                    strokeColor: widget.strokeColor,
                    electricQuantity: widget.electricQuantity,
                    batteryLeve: widget.batteryLeve,
                    colorCharging: widget.strokeColorCharging))
          ],
        );
      },
    );
  }
}

class _BatteryViewPainter extends CustomPainter {
  late Paint mPaint;
  double mPaintStrokeWidth = 2;

  // 电池电量
  int electricQuantity;
  // 电量阈值
  List<BatteryLevel> batteryLeve;

  // 是否正在充电中
  final bool isCharging;

  /// 控件描边颜色
  final Color strokeColor;

  /// 电池充电中
  final Color colorCharging;

  _BatteryViewPainter({
    required this.electricQuantity,
    required this.batteryLeve,
    required this.isCharging,
    required this.strokeColor,
    required this.colorCharging,
  }) {
    mPaint = Paint()..strokeWidth = mPaintStrokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    mPaint.color = strokeColor;
    double paddingHorizontal = 2.3;
    double paddingVertical = 4;

    double batteryTop = 1; // 电池顶部

    /// 3、画电池电量
    double percent = electricQuantity / 100;
    double electricQuantityLeft = paddingHorizontal;
    double electricQuantityRight = size.width - paddingHorizontal;
    double electricQuantityBottom = size.height - paddingVertical;
    double paddingTop = batteryTop + paddingVertical;
    double electricQuantityTop =
        paddingTop + (electricQuantityBottom - paddingTop) * (1 - percent);
    mPaint.strokeWidth = 0;
    mPaint.style = PaintingStyle.fill;
    if (batteryLeve.isEmpty) {
      batteryLeve = [
        BatteryLevel(0xff72e544, Pair(100, 15)),
        BatteryLevel(0xFFF44336, Pair(15, 0)),
        BatteryLevel(0x00000000, Pair(0, -100)),
      ];
    }
    for (var element in batteryLeve) {
      if (electricQuantity <= element.level.first &&
          electricQuantity > element.level.second) {
        mPaint.color = Color(element.color);
      }
    }

    if (isCharging) {
      mPaint.color = colorCharging;
    }
    canvas.drawRRect(
        RRect.fromLTRBR(
            electricQuantityLeft,
            electricQuantityTop,
            electricQuantityRight,
            electricQuantityBottom,
            const Radius.circular(2)),
        mPaint);
  }

  @override
  bool shouldRepaint(_BatteryViewPainter other) {
    return true;
  }
}
