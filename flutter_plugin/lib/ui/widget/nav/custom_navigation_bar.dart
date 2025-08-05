import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/nav/lottie_item.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomNavigationBar extends ConsumerStatefulWidget {
  final List<NavigationItemProtocol> items;
  final Function(int index) onSelected;
  final int selectedIndex;
  const CustomNavigationBar({
    required this.items,
    required this.onSelected,
    required this.selectedIndex,
    super.key,
  });

  @override
  ConsumerState<CustomNavigationBar> createState() =>
      _CustomNavigationBarState();
}

class _CustomNavigationBarState extends ConsumerState<CustomNavigationBar>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width / widget.items.length;
    
    return ThemeWidget(builder: (_, style, resource) {
      bool isDarkMode = style.brightness == Brightness.dark ? true : false;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < widget.items.length; i++)
            SizedBox(
              width: maxWidth,
              child: LottieItem(
                selected: i == widget.selectedIndex,
                itemName: widget.items[i].navName,
                normalImage: widget.items[i].getNormalImage(isDarkMode),
                checkedImage: widget.items[i].getCheckedImage(isDarkMode),
                lottieUrl: widget.items[i].lottieUrl ?? '',
              ),
            ).onClick(() {
              widget.onSelected(i);
            })
        ],
      );
    });
  }
}

abstract class NavigationItemProtocol {
  String get navName;
  String getNormalImage(bool isDarkMode);
  String getCheckedImage(bool isDarkMode);
  String? get lottieUrl;
}

class NavBean implements NavigationItemProtocol {
  @override
  final String navName;
  final String normalImage;
  final String checkedImage;
  @override
  final String? lottieUrl;

  NavBean(
    this.navName, {
    this.normalImage = '',
    this.checkedImage = '',
    this.lottieUrl = '',
  });

  @override
  String getNormalImage(bool isDarkMode) => normalImage;

  @override
  String getCheckedImage(bool isDarkMode) => checkedImage;
}

class ThemeNavBean implements NavigationItemProtocol {
  @override
  final String navName;
  final String normalImage;
  final String darkNormalImage;
  final String checkedImage;
  final String darkCheckedImage;
  @override
  final String? lottieUrl;

  ThemeNavBean(
    this.navName, {
    required this.normalImage,
    required this.darkNormalImage,
    required this.checkedImage,
    required this.darkCheckedImage,
    this.lottieUrl = '',
  });

  @override
  String getNormalImage(bool isDarkMode) {
    if (darkNormalImage.isEmpty) {
      return normalImage;
    }
    return isDarkMode ? darkNormalImage : normalImage;
  }

  @override
  String getCheckedImage(bool isDarkMode) {
    if (darkCheckedImage.isEmpty) {
      return checkedImage;
    }
    return isDarkMode ? darkCheckedImage : checkedImage;
  }
}
