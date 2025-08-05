import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/widget/gradient_circular_progress_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedLoadingBox(
      child: GradientCircularProgressIndicator(
          stokeWidth: 5,
          strokeCapRound: true,
          colors: [
            Color(0x00DDBCA1),
            Color(0x60DDBCA1),
            Color(0x80DDBCA1),
            Color(0xFFDDBCA1),
            Color(0xFFDDBCA1),
          ],
          radius: 20,
          value: 1,
          backgroundColor: Colors.transparent,
        ),
    ) ;
  }
}
class AnimatedLoadingBox extends StatefulWidget {
  final Widget child;
  const AnimatedLoadingBox({super.key, required this.child});

  @override
  State<AnimatedLoadingBox> createState() => _AnimatedRotationBoxState();
}

class _AnimatedRotationBoxState extends State<AnimatedLoadingBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: widget.child,
    );
  }
}


