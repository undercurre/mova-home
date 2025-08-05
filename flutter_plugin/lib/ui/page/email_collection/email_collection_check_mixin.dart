import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/email_collection_respository.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/mine_email_bind_page.dart';
import 'package:flutter_plugin/ui/page/email_collection/userinfo_change_event.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

mixin EmailCollectionCheckMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  late SmartDialogController dialogController = SmartDialogController();
  String? _email;
  bool _selected = false;

  @override
  void dispose() {
    EventBusUtil.getInstance().unRegister(this);
    super.dispose();
    SmartDialog.dismiss(tag: 'tag_email_collection_check_dialog');
  }

  void updateEvent(PushEvent event) {}

  void _listUserInfoChange() {
    _email = ref.read(
        emailCollectionRespositoryProvider.select((value) => value.email));
    EventBusUtil.getInstance().register<UserInfoChangeEvent>(this, (event) {
      _checkStatus();
    });
  }

  Future<void> _checkStatus() async {
    String? email = await ref
        .read(emailCollectionRespositoryProvider.notifier)
        .updateEmail();
    _email = email;
    dialogController.refresh();
    await _dialodDismiss(false);
  }

  void _selectNotMind() {
    _selected = !_selected;
    dialogController.refresh();
  }

  Future<void> subscribeButtonClick() async {
    if ((_email ?? '').isEmpty) {
      updateEvent(PushEvent(
          path: MineEmailBindPage.routePath, extra: 'set_new_email'.tr()));
    } else {
      SmartDialog.showLoading();
      try {
        bool success = await ref
            .read(emailCollectionRespositoryProvider.notifier)
            .subscribe();
        SmartDialog.dismiss(status: SmartStatus.loading);
        if (success) {
          EventBusUtil.getInstance().fire(UserInfoChangeEvent());
          SmartDialog.showToast('operate_success'.tr());
          SmartDialog.dismiss(tag: 'tag_email_collection_check_dialog');
          ref.read(dialogJobManagerProvider.notifier).nextJob();
        } else {
          SmartDialog.showToast('operate_failed'.tr());
        }
      } catch (e) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        SmartDialog.showToast('operate_failed'.tr());
      }
    }
  }

  // @override
  // Future<void> subscribeButtonClick() async {
  //   UserInfo? userInfo = await AccountModule().getUserInfo();
  //   if ((userInfo?.email ?? '').isEmpty) {

  //   }
  // }

  Future<void> _dialodDismiss(bool select) async {
    SmartDialog.dismiss(tag: 'tag_email_collection_check_dialog');
    ref.read(dialogJobManagerProvider.notifier).nextJob();
    String? uid = (await AccountModule().getUserInfo())?.uid;
    if (uid == null) return;
    int timestamp = 1;
    if (!select) {
      DateTime now = DateTime.now();
      timestamp = now.millisecondsSinceEpoch;
    }

    await LocalStorage().putLong(
        'overser_emall_device_collection_$uid', timestamp,
        fileName: 'keepWithoutUid');
  }

  void showEmailCollection() {
    if (!context.mounted) {
      return;
    }
    _listUserInfoChange();

    SmartDialog.show(
        tag: 'tag_email_collection_check_dialog',
        controller: dialogController,
        alignment: Alignment.center,
        backDismiss: false,
        clickMaskDismiss: false,
        builder: (_) {
          return ThemeWidget(builder: (context, style, resource) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    margin: const EdgeInsets.only(left: 32, right: 32),
                    decoration: BoxDecoration(
                      color: Colors.white, // 背景色
                      borderRadius:
                          BorderRadius.circular(style.circular20), // 圆角半径
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, right: 14),
                              child: Image.asset(
                                resource.getResource('email_collect_exit'),
                                width: 24,
                                height: 24,
                              ),
                            ),
                            onTap: () {
                              _dialodDismiss(_selected);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 17),
                          child: Text(
                            'email_collection_top_title'.tr(),
                            style: TextStyle(
                              color: style.carbonBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if ((_email ?? '').isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 12),
                            padding: const EdgeInsets.only(
                                top: 12, bottom: 12, left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: style.bgBlack, // 背景色
                              borderRadius: BorderRadius.circular(8), // 圆角半径
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  resource.getResource('email_collect_email'),
                                  width: 24,
                                  height: 24,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Text(
                                      _email ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: style.carbonBlack),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    updateEvent(PushEvent(
                                        path: MineEmailBindPage.routePath,
                                        extra: 'change_email'.tr()));
                                  },
                                  child: Image.asset(
                                    resource
                                        .getResource('email_collect_switch'),
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            'email_collection_alert_content'.tr(),
                            style:  TextStyle(
                                fontSize: 12, color: style.textSecondGray),
                          ),
                        ),
                        DMButton(
                          height: 48,
                          width: double.infinity,
                          borderRadius: style.buttonBorder,
                          backgroundGradient: style.cancelBtnGradient,
                          margin: const EdgeInsets.all(24),
                          text: (_email ?? '').isEmpty
                              ? 'bind_email'.tr()
                              : 'subscribe'.tr(),
                          onClickCallback: (context) {
                            subscribeButtonClick();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _selectNotMind();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 10).withRTL(context),
                          child: Image.asset(
                            resource.getResource(_selected
                                ? 'email_collect_select'
                                : 'email_collect_unselect'),
                            width: 14,
                            height: 14,
                          ).flipWithRTL(context),
                        ),
                        Text(
                          'not_minder'.tr(),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }

// /// show 隐私更新dialog
// void showPrivacyPolicyUpgradeDialog(PrivacyInfoBean bean) {
//   if (!context.mounted) {
//     return;
//   }
//   LogUtils.i(
//       '-------- showPrivacyPolicyUpgradeDialog ---------  ${bean.toJson()} ');
//   String content = bean.privacyChangelog ?? '';
//   SmartDialog.show(
//       tag: 'tag_privacy_dialog',
//       alignment: Alignment.bottomCenter,
//       backDismiss: false,
//       clickMaskDismiss: false,
//       builder: (_) {
//         LogUtils.d(
//             '---------- showPrivacyPolicyUpgradeDialog showModalBottomSheet ----------- $context');
//         return PrivacyPolicyUpgradeSheet(
//           content: content,
//           agreeClick: () {
//             SmartDialog.dismiss(tag: 'tag_privacy_dialog');
//             // 保存 feedback
//             ref.watch(privacyPolicyProvider.notifier).feedback(bean);
//             ref.read(dialogJobManagerProvider.notifier).nextJob();
//           },
//           rejectClick: () {
//             exit(0);
//             // LifeCycleManager().logOffAccount();
//           },
//         );
//       });
// }
}
