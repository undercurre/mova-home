import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_history_box.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class SuggestHistoryMediaCell extends StatefulWidget {
  final SuggestHistoryMedia item;

  final VoidCallback? onTap;

  const SuggestHistoryMediaCell({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  State<SuggestHistoryMediaCell> createState() =>
      _SuggestHistoryMediaCellState();
}

class _SuggestHistoryMediaCellState extends State<SuggestHistoryMediaCell> {
  String thumurl = '';

  @override
  void initState() {
    super.initState();
    prepareData();
  }

  Future<void> prepareData() async {
    if (widget.item.isVideo) {
      // ImageCacheManager;
      FileInfo? info =
          await DefaultCacheManager().getFileFromMemory(widget.item.thumbUrl);
      info ??=
          await DefaultCacheManager().getFileFromCache(widget.item.thumbUrl);

      if (info != null) {
        setState(() {
          thumurl = widget.item.thumbUrl;
        });
        return;
      }

      final path = (await getTemporaryDirectory()).path;
      final fileName = await VideoThumbnail.thumbnailFile(
        video: widget.item.url,
        thumbnailPath: path,
        imageFormat: ImageFormat.JPEG,
      );
      if (fileName == null) {
        return;
      }
      File file = File(fileName);
      File s = await DefaultCacheManager()
          .putFileStream(fileName, file.openRead(), key: widget.item.thumbUrl);
      debugPrint('info---4: $s');
      setState(() {
        thumurl = widget.item.thumbUrl;
      });
    } else {
      setState(() {
        thumurl = widget.item.thumbUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(style.cellBorder),
            color: style.bgGray,
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: thumurl.isEmpty == true
                    ? Container()
                    : CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: thumurl,
                        errorWidget: (context, string, _) {
                          return Container(
                            color: style.bgGray,
                          );
                        },
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
              if (widget.item.isVideo)
                Image.asset(
                  resource.getResource('ic_video_tag'),
                  width: 18,
                  height: 24,
                ),
            ],
          ),
        ),
      );
    });
  }
}
