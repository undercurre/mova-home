import 'dart:async';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart'
    as dreame_base;
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/ads/home_ads_manager_state_notifier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/email_collection/email_collection_check_mixin.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/user_mark_mixin.dart';
import 'package:flutter_plugin/ui/page/main/main_repository.dart';
import 'package:flutter_plugin/ui/page/main/main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_upgrade_mixin.dart';
import 'package:flutter_plugin/ui/page/settings/about/user_experience_plan/ux_plan_mixin.dart';
import 'package:flutter_plugin/ui/page/settings/settings_repository.dart';
import 'package:flutter_plugin/ui/page/settings/upgrade/app_upgrade_sheet.dart';
import 'package:flutter_plugin/ui/page/settings/upgrade/app_upgrade_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/device_guide_step_first_dialog.dart';
import 'package:flutter_plugin/ui/widget/home/home_ad_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin UserDialogMixin<T extends ConsumerStatefulWidget>
    on
        BasePageState<T>,
        ResponseForeUiEvent<T>,
        PrivacyPolicyUpgradeMixin<T>,
        EmailCollectionCheckMixin<T>,
        UxPlanMixin<T>,
        UserMarkMixin<T> {
  void handleUserDialog(
      {Function(dynamic)? showDeviceGuideAction,
      List<DialogType> dialogTypes = const []}) {
    ref.listen(dialogJobManagerProvider, (previous, next) async {
      var jobType = next?.jobType;
      if (dialogTypes.contains(DialogType.all) ||
          dialogTypes.contains(jobType)) {
        switch (next?.jobType) {
          case DialogType.guide:
            if (ref
                .read(mainStateNotifierProvider.notifier)
                .isTargetTab(TabItemType.device)) {
              final bundle = next!.bundle as Map<String, dynamic>;
              await _showGuide(bundle['supportFastCommand'], bundle['type'],
                  holdActionType: bundle['holdActionType']);
            } else {
              _nextDialog();
            }
            break;
          case DialogType.personalizedAd:
            final String storageKey = next?.bundle['storageKey'];
            final String fileName = next?.bundle['fileName'];
            showCommonDialog(
              title: 'personalized_ads_management'.tr(),
              content: 'personalized_ad_manager_content'.tr(),
              confirmContent: 'agree'.tr(),
              cancelContent: 'disagree'.tr(),
              contentAlign: TextAlign.start,
              confirmCallback: () {
                LocalStorage().putInt(storageKey, 1, fileName: fileName);
                ref.read(settingsRepositoryProvider).setAduserswitch(1);
                ref.watch(homeAdsManagerProvider.notifier).loadHomeAd();
              },
              cancelCallback: () {
                LocalStorage().putInt(storageKey, 2, fileName: fileName);
                ref.read(settingsRepositoryProvider).setAduserswitch(0);
                ref.watch(homeAdsManagerProvider.notifier).loadHomeAd();
              },
            );
            break;
          case DialogType.ad:
            final adList = next?.bundle ?? [];
            if (adList.isNotEmpty) {
              await ref
                  .read(homeAdsManagerProvider.notifier)
                  .updateAdShowInfo(adList);
              await SmartDialog.show(
                  tag: 'tag_ad_dialog',
                  backDismiss: false,
                  clickMaskDismiss: false,
                  maskColor: const Color(0x33000000),
                  animationType: SmartAnimationType.fade,
                  builder: (context) {
                    return Semantics(
                      explicitChildNodes: true,
                      child: HomeAdWidget(
                          adList: adList,
                          dismissCallback: () {
                            SmartDialog.dismiss(tag: 'tag_ad_dialog');
                            _nextDialog();
                            LogModule().eventReport(99, 3);
                          },
                          detailCallback: (adModel) async {
                            // 保存广告点击状态
                            await ref
                                .watch(mainRepositoryProvider)
                                .saveClickAdInfo(
                                  adModel,
                                );
                            ref
                                .read(mainStateNotifierProvider.notifier)
                                .handleAdJump(adModel);
                            LogModule().eventReport(99, 2, str1: adModel.id);
                          }),
                    );
                  });
            }
            break;
          case DialogType.privacy:
            Future.delayed(const Duration(milliseconds: 100), () {
              final bean = next!.bundle;
              showPrivacyPolicyUpgradeDialog(bean);
            });
            break;
          case DialogType.upgrade:
            await ref.read(settingsRepositoryProvider).updateShowTime();
            await SmartDialog.show(
              tag: 'tag_update_dialog',
              alignment: Alignment.bottomCenter,
              clickMaskDismiss: false,
              backDismiss: !ref.read(appUpgradeStateNotifierProvider).isForce,
              builder: (_) {
                return AppUpgradeSheet(
                  dismissCallback: () {
                    SmartDialog.dismiss(tag: 'tag_update_dialog');
                  },
                );
              },
            );
          case DialogType.bindPhone:
            final alertEvent = next!.bundle as AlertEvent;
            responseFor(alertEvent);
            break;
          case DialogType.emailCollect:
            // 邮箱收集
            showEmailCollection();
            break;
          case DialogType.uxPlan:
            // ux计划
            showUxPlanDialog();
            break;
          case DialogType.userMark:
            showUserMarkDialog();
            break;
          default:
            break;
        }
      }
    });
  }

  /// 下一个弹窗
  void _nextDialog() {
    ref.read(dialogJobManagerProvider.notifier).nextJob();
  }

  /// 展示引导第一步
  Future<void> _showGuide(
    bool supportFastCommand,
    dreame_base.DeviceType deviceType, {
    dreame_base.HoldActionType holdActionType =
        dreame_base.HoldActionType.cleanDry,
  }) async {
    bool rtl = (Directionality.of(context) == view_direction.TextDirection.rtl);
    double contentTopMargin = 50;
    if (Platform.isIOS) {
      contentTopMargin = await InfoModule().isNotchScreen() ? 60 : 30;
    }
    final stepCount = deviceType == dreame_base.DeviceType.vacuum
        ? (supportFastCommand ? 4 : 3)
        : 3;
    final desc = rtl ? '($stepCount/1)' : '(1/$stepCount)';
    DeviceGuideStepFirstDialog(
        titleOffset: Offset(24, contentTopMargin),
        provideTitleDescOrders: dreame_base.Triple(
            'text_more_operate'.tr(), 'text_guide_step_1_desc_v2'.tr(), desc),
        provideImageRes: 'ic_home_step_1',
        lastStep: false,
        rtl: rtl,
        skipCallback: () {
          _skipGuide(deviceType, holdActionType);
        },
        nextStepCallback: () {
          final itemKey = ref
              .read(homeStateNotifierProvider.notifier)
              .getItemKey(
                  ref.read(homeStateNotifierProvider).currentDevice?.did ?? '',
                  toStringShort());
          itemKey.currentState == null
              ? _nextDialog()
              : itemKey.currentState?.showDeviceGuide();
        }).show();
  }

  void _skipGuide(dreame_base.DeviceType deviceType,
      dreame_base.HoldActionType? holdActionType) {
    _nextDialog();
    ref
        .read(homeStateNotifierProvider.notifier)
        .updateGuide(deviceType, holdActionType);
  }
}
