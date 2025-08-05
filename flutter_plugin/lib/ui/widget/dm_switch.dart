import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DMSwitch extends StatefulWidget {
  bool? value;                          //Switch当前选中状态
  double? width;                        //Switch宽度
  double? height;                       //Switch高度
  ImageProvider ? activeImage;          //选中状态switch背景图
  ImageProvider ? inActiveImage;        //未选中状态switch背景图
  final ValueChanged<bool>? onChanged;  //switch 状态发生改变回调

  DMSwitch({
      super.key,
      required this.value,
      required this.onChanged,
      this.width = 46,
      this.height = 24,
      this.activeImage = const AssetImage('assets/light/icons/btn_switch_on.png'),
      this.inActiveImage = const AssetImage('assets/light/icons/btn_switch_off.png'),
      });

  @override
  State<DMSwitch> createState() => _DMSwitchState();
}

class _DMSwitchState extends State<DMSwitch> {
  late ImageProvider currentImage;
  bool get isInteractive => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentImage = ((widget.value == true)? widget.activeImage : widget.inActiveImage)!;
    });
  }

  @override
  void didUpdateWidget(covariant DMSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      currentImage = ((widget.value == true)? widget.activeImage : widget.inActiveImage)!;
    });
  }

  Widget buildButton() {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.center,
        width: widget.width,
        height: widget.height,
        child: Image(image: currentImage));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapUp: (details) {
          if (isInteractive) {
            widget.onChanged!(!(widget.value!));
          }
          setState(() {
            currentImage = ((widget.value == true)? widget.activeImage : widget.inActiveImage)!;
          });
        },
        child: Container(
            child: buildButton(),
        ));
  }
}
