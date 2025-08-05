import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 用户评价弹窗
class UserMarkDialog extends ConsumerStatefulWidget {
  final VoidCallback clickClose;
  final VoidCallback clickConfirm;
  final VoidCallback clickFeedback;

  const UserMarkDialog({
    super.key,
    required this.clickClose,
    required this.clickConfirm,
    required this.clickFeedback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserMarkDialogState();
}

class UserMarkDialogState extends ConsumerState<UserMarkDialog> {
  Widget _buildContent() {
    return ThemeWidget(builder: (context, style, resource) {
      return SizedBox(
        width: MediaQuery.of(context).size.width - 44,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'user_mark_title'.tr(),
                style: style.mainStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
              child: Text('user_mark_subtitle'.tr(),
                  style: TextStyle(fontSize: 14, color: style.textNormal),
                  textAlign: TextAlign.center),
            ),
            DMButton(
              borderRadius: 100,
              height: 48,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 32, left: 28, right: 28),
              onClickCallback: (_) {
                widget.clickConfirm.call();
              },
              text: 'user_mark_positive'.tr(),
              textColor: style.enableBtnTextColor,
              fontWidget: FontWeight.w500,
              backgroundGradient: style.confirmBtnGradient,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
              child: Text('user_mark_negative'.tr(),
                  style: TextStyle(
                      fontSize: 14, color: style.click.withOpacity(0.7))),
            ).onClick(widget.clickFeedback),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 345 / 412,
                    child: Image.asset(
                      resource.getResource('ic_home_mark_bg'),
                    ),
                  ),
                  Positioned(top: 176, child: _buildContent()),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16).withRTL(context),
                child: Image.asset(
                  resource.getResource('ic_ad_cancel'),
                  width: 40,
                ),
              ).onClick(() {
                widget.clickClose.call();
              }),
            ],
          ),
        );
      },
    );
  }
}
