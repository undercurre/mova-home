import 'dart:io';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/main/main_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/user_mark_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inapprating/inapprating.dart';

/// 用户评价弹窗
mixin UserMarkMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void showUserMarkDialog() {
    SmartDialog.show(
      tag: 'user_mark_dialog',
      backDismiss: false,
      clickMaskDismiss: false,
      alignment: Alignment.center,
      maskColor: const Color(0xFF121212).withOpacity(0.5),
      animationType: SmartAnimationType.fade,
      onDismiss: () {
        ref.read(dialogJobManagerProvider.notifier).nextJob();
      },
      builder: (_) {
        return UserMarkDialog(
          clickClose: () {
            _dismissDialog();
            _updatemarkState(3);
          },
          clickConfirm: () {
            if (Platform.isIOS) {
              Inapprating().request();
            } else {
              UIModule().inAppRating();
            }
            _dismissDialog();
            _updatemarkState(1);
          },
          clickFeedback: () {
            _dismissDialog();
            UIModule().openPage('/help/feedback?adviseType=2');
            _updatemarkState(2);
          },
        );
      },
    );
  }

  void _dismissDialog() {
    SmartDialog.dismiss(tag: 'user_mark_dialog');
  }

  /// 1-好评
  /// 2-去吐槽
  /// 3-下次再说
  void _updatemarkState(int markType) {
    ref.read(mainStateNotifierProvider.notifier).updateUserMark(markType);
  }
}
