import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/ui/common/js_action/js_map_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin MapNavigateMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void showNaviteSheet({required JSMapNavigation nav}) {
    showModalBottomSheet(
      isScrollControlled: false,
      useSafeArea: true,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return MapNavigateAlert(
          title: nav.title ?? '',
          callBack: (type) {
            navigateTo(type, nav);
          },
        );
      },
    );
  }

  void navigateTo(NavigateMapType type, JSMapNavigation nav) {
    Navigator.of(context).pop();
    UIModule().mapNavigation(type, nav);
  }
}

void pushToNavigate() {}

typedef NavigateActionCallBack = void Function(NavigateMapType type);

enum NavigateMapType { amap, baidu, apple }

// ignore: must_be_immutable
class MapNavigateAlert extends ConsumerStatefulWidget {
  MapNavigateAlert({super.key, required this.callBack, required this.title});
  NavigateActionCallBack callBack;
  String title;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      MapNavigateAlertState();
}

class MapNavigateAlertState extends ConsumerState<MapNavigateAlert> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          Platform.isIOS ? (324 + MediaQuery.of(context).padding.bottom) : 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(children: getWidges(title: widget.title)),
    );
  }

  List<Widget> getWidges({required String title}) {
    List<Widget> widgets = [
      Container(
        height: 64,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.black26),
          ),
        ),
        child: Align(
          child: Text(
            '导航到$title',
            style: const TextStyle(
              color: Color(0xFF777777),
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    ];
    List<NavigateMapType> naviageTitles = [
      NavigateMapType.amap,
      NavigateMapType.baidu
    ];
    if (Platform.isIOS) {
      naviageTitles.add(NavigateMapType.apple);
    }

    for (int i = 0; i < naviageTitles.length; i++) {
      var element = naviageTitles[i];
      widgets.add(
          listWidget(navMap: element, showSep: naviageTitles.length - i != 1));
    }

    Widget cancelWidget = GestureDetector(
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 10, color: Color(0XFFF6F6F6)),
          ),
        ),
        child: Align(
          child: Text(
            'cancel'.tr(),
            style: const TextStyle(
              color: Color(0xFF121212),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
    widgets.add(cancelWidget);

    return widgets;
  }

  Widget listWidget({required NavigateMapType navMap, bool showSep = true}) {
    String title = '';
    switch (navMap) {
      case NavigateMapType.amap:
        title = '高德地图';
      case NavigateMapType.baidu:
        title = '百度地图';
      default:
        title = '苹果地图(系统)';
    }
    Widget navCell = GestureDetector(
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: showSep
              ? const Border(
                  bottom: BorderSide(width: 0.5, color: Color(0XFFD8D8D8)),
                )
              : null,
        ),
        child: Align(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF121212),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onTap: () {
        widget.callBack(navMap);
      },
    );
    return navCell;
  }
}
