import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';

class DiagnosticsProgressWidget extends StatefulWidget {
  bool isRunning;
  final ResourceModel resource;

  DiagnosticsProgressWidget({super.key, this.isRunning = false, required this.resource});

  @override
  State<StatefulWidget> createState() {
    return DiagnosticsProgressWidgetState();
  }
}

class DiagnosticsProgressWidgetState extends State<DiagnosticsProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  int _animateTime = 3000;
  late Tween<double> _sizeTween;
  double _heightOffset = 0;
  bool _isAnimateRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: _animateTime),
        upperBound: 1);
  }

  @override
  void activate() {
    super.activate();
    widget.isRunning = true;
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.isRunning = false;
    stopAnimation();
    _controller.dispose();
  }

  void startAnimation() {
    if (_isAnimateRunning) {
      return;
    }
    _isAnimateRunning = true;
    _sizeTween = Tween<double>(begin: 0, end: 182.0);
    _controller.repeat(reverse: false);
    _controller.addListener(() {
      if (mounted && _isAnimateRunning) {
        setState(() {
          _heightOffset = _sizeTween.evaluate(_controller);
        });
      }
    });
  }

  void stopAnimation() {
    if (!_isAnimateRunning) {
      return;
    }
    _isAnimateRunning = false;
    _controller.stop(canceled: true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRunning) {
      startAnimation();
    } else {
      stopAnimation();
    }
    return SizedBox(
      width: 264,
      height: 264,
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Center(
            child: Image.asset(
              widget.resource.getResource('ic_offline_diagnostic_status'),
              width: 264,
              height: 264,
            ),
          ),
        ],
      ),
    );
  }
}
