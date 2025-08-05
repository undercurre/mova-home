import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class HomeAdWidget extends StatefulWidget {
  final List<ADModel> adList;
  final VoidCallback dismissCallback;
  final Function(ADModel) detailCallback;

  const HomeAdWidget(
      {super.key,
      required this.adList,
      required this.dismissCallback,
      required this.detailCallback});

  @override
  HomeAdWidgetState createState() => HomeAdWidgetState();
}

class HomeAdWidgetState extends State<HomeAdWidget>
    with WidgetsBindingObserver {
  PageController? _controller;
  int currentIndex = 0;
  int realPosition = 0;
  Timer? _timer;
  bool isActive = true; //当前页面是否处于活跃状态（是否可视）
  bool isUserGesture = false; //用户是否正在拖拽页面
  bool isEnd = false; //用户拖拽是否结束
  final List<ADModel> _adList = [];

  bool get isTimer => widget.adList.length > 1;
  var showMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.adList.isEmpty) {
      return;
    }
    if (widget.adList.length == 1) {
      _adList.addAll(widget.adList);
      _controller = PageController(initialPage: 0);
    } else {
      _adList.add(widget.adList[widget.adList.length - 1]);
      _adList.addAll(widget.adList);
      _adList.add(widget.adList[0]);
      _controller = PageController(initialPage: 1);
    }
    _start();
  }

  @override
  void dispose() {
    cancelTimer();
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed: //onResume
        isActive = true;
        _start();
        break;
      case AppLifecycleState.paused: //onPause
        isActive = false;
        _stop();
        break;
      default:
        break;
    }
  }

  ///创建定时器
  void createTimer() {
    if (isTimer) {
      cancelTimer();
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        ++currentIndex;
        int next = currentIndex % _adList.length;
        _controller?.animateToPage(next,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      });
    }
  }

  /// 开始定时滑动
  void _start() {
    if (!isTimer) return;
    if (!isActive) return;
    if (_adList.length <= 1) return;
    createTimer();
  }

  /// 停止定时滑动
  void _stop() {
    if (!isTimer) return;
    cancelTimer();
  }

  /// 取消定时器
  void cancelTimer() {
    _timer?.cancel();
  }

  void _onPageChange(int index) {
    if (widget.adList.length < 2) return;
    if (index == 0) {
      //当前选中的是第一个位置，自动选中倒数第二个位置
      currentIndex = _adList.length - 2;
      _controller?.jumpToPage(currentIndex);
      realPosition = currentIndex - 1;
    } else if (index == _adList.length - 1) {
      //当前选中的是倒数第一个位置，自动选中第二个索引
      currentIndex = 1;
      _controller?.jumpToPage(currentIndex);
      realPosition = 0;
    } else {
      currentIndex = index;
      realPosition = index - 1;
      if (realPosition < 0) realPosition = 0;
    }
    setState(() {});
    var adId = _adList[index].id;
    if (showMap.containsKey(adId)) {
      showMap[adId] = 0;
      LogModule().eventReport(99, 1, str1: adId);
    }
  }

  /// Page滑动监听
  bool _onNotification(notification) {
    if (notification is ScrollStartNotification) {
      isEnd = false;
    } else if (notification is UserScrollNotification) {
      //用户滑动时回调顺序：start - user , end - user
      if (isEnd) {
        isUserGesture = false;
        _start();
        return false;
      }
      isUserGesture = true;
      _stop();
    } else if (notification is ScrollEndNotification) {
      isEnd = true;
      if (isUserGesture) {
        _start();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final double ratio = MediaQuery.of(context).size.aspectRatio;
    return Semantics(
      explicitChildNodes:  true,
      child: ThemeWidget(
        builder: (context, style, resource) {
          return AspectRatio(
            aspectRatio: ratio > 0.5 ? 0.5 : ratio,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AspectRatio(
                      aspectRatio: 345 / 428,
                      child: Stack(
                        children: [
                          NotificationListener(
                            onNotification: (notification) =>
                                _onNotification(notification),
                            child: PageView.builder(
                              controller: _controller,
                              onPageChanged: (value) => _onPageChange(value),
                              itemCount: _adList.length,
                              itemBuilder: (_, index) {
                                final adModel = _adList[index];
                                return adModel.picture.isEmpty == true
                                    ? Container()
                                    : Semantics(
                                      label: 'popup_image'.tr(),
                                      child: CachedNetworkImage(
                                                                      imageUrl: adModel.picture,
                                                                      imageBuilder: (context, imageProvider) =>
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                                                    ).onClick(
                                        () => widget.detailCallback.call(adModel),
                                                                    ),
                                    );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                _controller?.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              onTapUp: (_) => _start(),
                              onTapDown: (_) => _stop(),
                              child: Visibility(
                                  visible: widget.adList.length != 1,
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 12)
                                          .withRTL(context),
                                      child: Semantics(
                                        label: 'previous_page'.tr(),
                                        child: Image(
                                            width: 40,
                                            height: 40,
                                            image: AssetImage(resource
                                                .getResource('ic_ad_left'))),
                                      ))),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: () {
                                  _controller?.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                },
                                onTapUp: (_) => _start(),
                                onTapDown: (_) => _stop(),
                                child: Visibility(
                                    visible: widget.adList.length != 1,
                                    child: Padding(
                                        padding: const EdgeInsets.only(right: 12)
                                            .withRTL(context),
                                        child: Semantics(
                                          label: 'next_page'.tr(),
                                          child: Image(
                                              width: 40,
                                              height: 40,
                                              image: AssetImage(resource
                                                  .getResource('ic_ad_right'))),
                                        )))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                        const EdgeInsets.only(top: 16).withRTL(context),
                        child: Semantics(
                          label: 'close_popup'.tr(),
                          child: Image(
                              width: 36,
                              height: 36,
                              image: AssetImage(
                                  resource.getResource('ic_ad_cancel'))),
                        ))
                        .onClick(() {
                      widget.dismissCallback.call();
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
