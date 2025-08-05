import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/privacy_res.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'privacy_policy_state_notifier.g.dart';

@riverpod
class PrivacyPolicy extends _$PrivacyPolicy {
  @override
  PrivacyInfoBean build() {
    return PrivacyInfoBean.create();
  }

  /// 检查隐私更新
  Future<void> checkPrivacy() async {
    try {
      PrivacyInfoBean bean = await _queryPrivacyPolicy();
      if (bean.privacyUrl.isNotEmpty && bean.agreementUrl.isNotEmpty) {
        var localPrivacy = await AccountModule().getPrivacyInfo();
        if (localPrivacy == null ||
            bean.privacyVersion > localPrivacy.privacyVersion) {
          ref
              .watch(dialogJobManagerProvider.notifier)
              .sendJobMessage(DialogJob(DialogType.privacy, bundle: bean));
        }
      }
    } catch (e) {
      LogUtils.e(e);
    }
  }

  /// 查看隐私
  Future<PrivacyInfoBean> viewPrivacyInfo(
      {bool showLoading = false, bool isForce = false}) async {
    if (!isForce && state.isValid()) {
      return state;
    }
    try {
      if (showLoading) {
        SmartDialog.showLoading();
      }
      state = await _queryPrivacyPolicy();
    } catch (e) {
      LogUtils.e(e);
    } finally {
      if (showLoading) {
        SmartDialog.dismiss(status: SmartStatus.loading);
      }
    }
    return state;
  }

  /// 切换地区，隐私reset
  /// countryCode 非null 正常清理内存中的缓存， null 则会清理磁盘缓存
  Future<void> reset(String? countryCode) async {
    LogUtils.i(
        '----- PrivacyPolicy reset -----${state.countryCode}   $countryCode');
    if (state.countryCode != countryCode || countryCode == null) {
      state = PrivacyInfoBean.create();
      if (countryCode == null) {
        await updateLocalStorage(state);
      }
    }
  }

  /// 读取隐私缓存
  Future<PrivacyInfoBean?> _readLocalStorage() async {
    var privacyInfo = await AccountModule().getPrivacyInfo();
    LogUtils.i('-------- _readLocalStorage ---------${privacyInfo?.toJson()}');
    return privacyInfo;
  }

  /// 更新隐私缓存
  Future<void> updateLocalStorage(PrivacyInfoBean bean) async {
    var ret = await AccountModule().savePrivacyInfo(bean);
    LogUtils.i('-------- updateLocalStorage --------- $ret  ${bean.toJson()}');
  }

  /// 查询隐私信息
  Future<PrivacyInfoBean> _queryPrivacyPolicy() async {
    var remotePrivacy =
        await ref.read(accountRepositoryProvider).queryPrivacyPolicy();
    PrivacyInfoBean bean = PrivacyInfoBean.create();
    if (remotePrivacy.privacyList.isNotEmpty) {
      for (var element in remotePrivacy.privacyList) {
        /// 用户协议
        if (element.type == '1') {
          bean
            ..agreementVersion = element.version
            ..agreementChangelog = element.changelog
            ..agreementUrl = element.url;
        }

        /// 隐私政策
        if (element.type == '2') {
          bean
            ..privacyVersion = element.version
            ..privacyChangelog = element.changelog
            ..privacyUrl = element.url;
        }
      }
    }
    return bean;
  }

  Future<void> feedback(PrivacyInfoBean bean) async {
    try {
      await AccountModule().savePrivacyInfo(bean);
      var version = bean.privacyVersion;
      await ref.read(accountRepositoryProvider).agreePrivacy(version: version);
    } catch (e) {
      LogUtils.e(e);
    }
  }

  /// 后台默认同意隐私
  Future<void> agreePrivacy() async {
    try {
      int version = 0;
      if (state.isValid()) {
        version = state.privacyVersion;
        await updateLocalStorage(state);
      } else {
        var bean = await _queryPrivacyPolicy();
        version = bean.privacyVersion;
        await updateLocalStorage(bean);
      }
      await ref.read(accountRepositoryProvider).agreePrivacy(version: version);
    } catch (e) {
      LogUtils.e(e);
    }
  }
}
