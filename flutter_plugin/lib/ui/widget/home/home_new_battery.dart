import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';

// import 'package:flutter_plugin/ui/page/home/common_video_player.dart';

const Color defaultDisableColor = Color(0xFFC3C3C3);

class BatteryLevel {
  int color;
  // 左闭右开
  Pair<int, int> level;

  BatteryLevel(this.color, this.level);
}

/// 电池电量控件
class HomeNewBattery extends StatefulWidget {
  /// 电池电量
  int electricQuantity;

  /// 控件宽高
  double width;
  double height;

  Size? itemSize;
  int? itemSpace;
  // 是否正在充电中
  bool isCharging;

  /// 控件描边颜色

  /// 电池充电中
  Color strokeColorCharging;

  List<BatteryLevel> batteryLeve;

  HomeNewBattery(
      {super.key,
      this.width = 80,
      this.height = 20,
      this.itemSize,
      this.itemSpace,
      this.isCharging = false,
      this.strokeColorCharging = const Color(0xff72e544),
      required this.electricQuantity,
      this.batteryLeve = const []})
      : assert(electricQuantity >= 0 && electricQuantity <= 100,
            'electricQuantity must be between 0 and 100');

  @override
  State<StatefulWidget> createState() {
    return HomeNewBatteryState();
  }
}

class HomeNewBatteryState extends State<HomeNewBattery> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int buttery = widget.electricQuantity;
    double filledRectangles = widget.electricQuantity / 20.0;
    Size itemSize = widget.itemSize ?? const Size(4, 12);
    List<BatteryLevel> batteryLeve = widget.batteryLeve;
    Color fillcolor = Colors.transparent;
    if (widget.batteryLeve.isEmpty) {
      batteryLeve = [
        BatteryLevel(0xff72e544, Pair(100, 20)),
        BatteryLevel(0xFFF44336, Pair(20, 0)),
        BatteryLevel(0x00000000, Pair(0, -100)),
      ];
    }
    for (var element in batteryLeve) {
      if (buttery <= element.level.first && buttery > element.level.second) {
        fillcolor = Color(element.color);
      }
    }
    return ThemeWidget(
      builder: (context, style, resource) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 30,
              height: widget.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {

                  // ceil 向上取整操作
                  // floor 向下取整
                  double blueItemCount = (widget.electricQuantity / 20);

                  return Container(
                    width: itemSize.width,
                    height: itemSize.height,
                    decoration: BoxDecoration(
                      color: (index < blueItemCount)
                          ? fillcolor
                          : defaultDisableColor,
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  );
                }),
              ),
            ),
            Visibility(
                visible: widget.isCharging ? true : false,
                child: ColorFiltered(
                    colorFilter: ColorFilter.mode(fillcolor, BlendMode.srcIn),
                    child: Image(
                  width: 8,
                  height: 12,
                  image: AssetImage(
                      resource.getResource('ic_home_battery_charge')),
                    ))),
          ],
        );
      },
    );
  }
}
