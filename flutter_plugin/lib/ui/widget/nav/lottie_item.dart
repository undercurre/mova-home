import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_plugin/ui/widget/nav/custom_navigation_bar.dart';
import 'package:lottie/lottie.dart';

class LottieItem extends ConsumerStatefulWidget {
  final String? normalImage;
  final String? checkedImage;
  final String? lottieUrl;
  final String itemName;
  final bool selected;

  const LottieItem({
    super.key,
    required this.itemName,
    required this.selected,
    this.normalImage = '',
    this.checkedImage = '',
    this.lottieUrl = '',
  });
  factory LottieItem.fromNavBean({
    Key? key,
    required NavBean bean,
    required bool selected,
  }) {
    return LottieItem(
      key: key,
      itemName: bean.navName,
      selected: selected,
      normalImage: bean.normalImage,
      checkedImage: bean.checkedImage,
      lottieUrl: bean.lottieUrl,
    );
  }
  factory LottieItem.fromThemeNavBean({
    Key? key,
    required ThemeNavBean bean,
    required bool selected,
    required bool isDarkMode,
  }) {
    return LottieItem(
      key: key,
      itemName: bean.navName,
      selected: selected,
      normalImage: bean.getNormalImage(isDarkMode),
      checkedImage: bean.getCheckedImage(isDarkMode),
      lottieUrl: bean.lottieUrl,
    );
  }

  @override
  ConsumerState<LottieItem> createState() => _LottieItemState();
}

class _LottieItemState extends ConsumerState<LottieItem>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIcon(StyleModel style) {

    if (widget.lottieUrl != null && widget.lottieUrl!.isNotEmpty) {
      return Lottie.network(
        widget.lottieUrl!,
        width: 30,
        height: 30,
        controller: _controller,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
          if (widget.selected) {
            _controller.forward();
          } else {
            _controller.reset();
          }
        },
      );
    }

    if (widget.selected) {
      return _buildImage(style, widget.checkedImage!);
    } else {
      return _buildImage(style, widget.normalImage!);
    }
  }

  Widget _buildImage(StyleModel style, String imageName) {
    if (imageName.isEmpty) {
      return const SizedBox.shrink();
    }
    if (imageName.contains('http')) {
      return CachedNetworkImage(
        imageUrl: imageName,
        width: 30,
        height: 30,
      );
      
      
    } else {
      String themePath = style.brightness == Brightness.dark ? 'dark' : 'light';
      return Image.asset(
        'assets/$themePath/icons/3.0x/$imageName',
        width: 30,
        height: 30,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    if (!widget.selected) {
      _controller.reset();
    } else {
      _controller.forward();
    }
    return ThemeWidget(builder: (_, style, resource) {
      return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(style),
              Padding(
                  padding: const EdgeInsets.only(top: 5).withRTL(context),
                  child: Text(
                    widget.itemName,
                    maxLines: 1,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: widget.selected
                            ? style.tabBarSelected
                            : style.tabBarNormal),
                  ))
            ],
          ));
    });
  }
}
