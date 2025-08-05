import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';

// ignore: must_be_immutable
class DMDefaultAvatorImage extends StatefulWidget {
  String? uid;
  double? width;
  double? height;

  DMDefaultAvatorImage({
    super.key,
    this.uid,
    this.width = 46,
    this.height = 46,
  });

  @override
  State<DMDefaultAvatorImage> createState() => _DMSwitchState();
}

class _DMSwitchState extends State<DMDefaultAvatorImage> {
  late String currentImage;

  @override
  void initState() {
    super.initState();
    defaultAvatar();
  }

  void defaultAvatar() {
    if (widget.uid != null && widget.uid?.isNotEmpty == true) {
      String UID = widget.uid!;
      String lastChar = UID.substring(UID.length - 1);
      int? lastCharAsInt = int.tryParse(lastChar);
      int modResult = ((lastCharAsInt ?? 0) % 7) + 1;
      _generateRandomImage(modResult);
    } else {
      final random = Random();
      int randomNumber = random.nextInt(100);
      int modResult = randomNumber % 7 + 1;
      _generateRandomImage(modResult);
    }
  }

  @override
  void didUpdateWidget(covariant DMDefaultAvatorImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uid != widget.uid) {
      defaultAvatar();
    }
  }

  void _generateRandomImage(int index) {
    String imageName = 'ic_avatar_$index';
    currentImage = imageName;
    setState(() {
      currentImage = currentImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return SizedBox(
          child: Image.asset(
            resource.getResource(currentImage),
            width: widget.width,
            height: widget.height,
          ));
    });
  }
}
