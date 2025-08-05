import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_plugin/ui/widget/restart_widget_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestartWidget extends ConsumerStatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    //查找顶层_RestartWidgetState并重启
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends ConsumerState<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey(); //重新生成key导致控件重新build
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ref.watch(restartWidgetNotifierProvider),
      child: widget.child,
    );
  }
}
