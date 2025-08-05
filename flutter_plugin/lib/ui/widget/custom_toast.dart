import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class CustomToastStatelessWidget extends StatelessWidget {
  final double toastBottom;
  final double toastTop;

  const CustomToastStatelessWidget(this.msg,
      {super.key, this.toastBottom = 146, this.toastTop = 0});

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: toastTop > 0 ? Alignment.topCenter : Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.fromLTRB(16, toastTop, 16, toastBottom),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
        child: Text(
          msg,
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CustomToastStatefulWidget extends StatefulWidget {
  const CustomToastStatefulWidget(this.msg, {super.key});

  final String msg;

  @override
  State<StatefulWidget> createState() {
    return _CustomToastStatefulWidgetState();
  }
}

class _CustomToastStatefulWidgetState extends State<CustomToastStatefulWidget>
    with WidgetsBindingObserver {
  double bottomPadding = 146;
  double topPadding = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          var viewInsets = MediaQuery.of(context).viewInsets;
          double keyboardHeight = viewInsets.bottom;
          final size = MediaQuery.of(context).size;
          final padding = MediaQuery.of(context).padding;
          final viewPadding = MediaQuery.of(context).viewPadding;
          LogUtils.d(
              'keyboardHeight size: $size $padding $viewPadding $viewInsets');
          double toastBottom = 146;
          if (keyboardHeight > 0) {
            bottomPadding = 0;
            topPadding = size.height -
                padding.top -
                padding.bottom -
                keyboardHeight -
                60 -
                30 -
                20;
          } else {
            bottomPadding = toastBottom;
            topPadding = 0;
          }
          LogUtils.d(
              'keyboardHeight: $keyboardHeight $bottomPadding $topPadding');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomToastStatelessWidget(
      widget.msg,
      toastBottom: bottomPadding,
      toastTop: topPadding,
    );
  }
}

class CustomToast extends StatelessWidget {
  const CustomToast(this.msg, {super.key});

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CustomToastStatelessWidget(msg)
        : CustomToastStatefulWidget(msg);
  }
}
