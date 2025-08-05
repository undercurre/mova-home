import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/account/privacy_res.dart';
import 'package:flutter_plugin/model/key_value_model.dart';
import 'package:flutter_plugin/model/ux_plan_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_type.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_ui_state.dart';
import 'package:flutter_plugin/ui/page/settings/settings_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/region_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_config_page_state_notifier.g.dart';

@riverpod
class UserConfigPageStateNotifier extends _$UserConfigPageStateNotifier {
  @override
  UserConfigPageUiState build(UserConfigType? type) {
    return UserConfigPageUiState();
  }

  Future<void> initData() async {
    if (type == UserConfigType.uxPlan) {
      return _initUxPlan();
    } else if (type == UserConfigType.adManage) {
      return _initAdManage();
    } else if (type == UserConfigType.appRes) {
      String type = CommonPluginType.appSource.value;
      final result = await getUserConfig<bool>([type], targetKey: type);
      state = state.copyWith(isOn: result);
    }
    return Future.value();
  }

  /// 用户体验计划-获取配置
  Future<void> _initUxPlan() async {
    try {
      final privacyInfo = await getPrivacyInfo();
      final authState = await getUXPlanAuthState() == 1;
      state = state.copyWith(loading: true);
      state = state.copyWith(
          isOn: authState, privacyUrl: privacyInfo?.privacyUrl ?? '');
      state = state.copyWith(loading: false);
    } catch (error) {
      LogUtils.e('UXPlanPageStateNotifier initData $error');
    }
  }

  /// 广告管理-获取配置
  Future<void> _initAdManage() async {
    try {
      state = state.copyWith(loading: true);
      var status =
          await ref.read(settingsRepositoryProvider).getAduserswitch() == 1;
      state = state.copyWith(isOn: status);
      state = state.copyWith(loading: false);
    } catch (error) {
      LogUtils.e(error);
    }
  }

  /// 通用获取用户配置方法
  Future<dynamic> getUserConfig<T>(List<String> key,
      {String targetKey = ''}) async {
    try {
      List<KVModel> data =
          await ref.read(settingsRepositoryProvider).getUserConfigSetting(key);
      if (targetKey.isEmpty) {
        return data;
      } else {
        for (var element in data) {
          if (element.key == targetKey) {
            return element.value as T;
          }
        }
      }
    } catch (error) {
      LogUtils.e('getUserConfig error: $error');
    }
  }

  /// 用户体验计划- 国内自动同意，国外不做处理
  Future<bool> agreeUXPlan() async {
    String countryCode = await LocalModule().getCountryCode();
    bool isCN = countryCode.toLowerCase() == 'cn';
    if (!isCN) {
      return false;
    }
    return setUXPlanAuthState(true);
  }

  /// 用户体验计划-获取配置
  Future<int> getUXPlanAuthState() async {
    try {
      UXPlanModel uxPlan =
          await ref.watch(settingsRepositoryProvider).getUXPlanState();
      return uxPlan.value ?? 0;
    } catch (error) {
      LogUtils.e('getUXPlanAuthState error: $error');
      return 0;
    }
  }

  /// 用户体验计划-隐私政策链接
  Future<PrivacyInfoBean?> getPrivacyInfo() async {
    var privacyInfo = await AccountModule().getPrivacyInfo();
    var lang = await LocalModule().getLangTag();
    var region = await LocalModule().serverSite();

    privacyInfo?.agreementUrl =
        '${privacyInfo.agreementUrl}&curLang=$lang&curRegion=$region';
    privacyInfo?.privacyUrl =
        '${privacyInfo.privacyUrl}&curLang=$lang&curRegion=$region';
    return privacyInfo;
  }

  /// 操作按钮
  Future<void> operate(bool state) async {
    if (type == UserConfigType.uxPlan) {
      await setUXPlanAuthState(state);
    } else if (type == UserConfigType.adManage) {
      await _setAdsManagementAuthState(state);
    } else if (type == UserConfigType.appRes) {
      await _setUserConfigState(CommonPluginType.appSource.value, state);
    }
  }

  /// 用户体验计划-设置配置
  Future<bool> setUXPlanAuthState(bool authState) async {
    try {
      int onState = authState ? 1 : 0;
      bool succeed =
          await ref.watch(settingsRepositoryProvider).setUXPlanState(onState);
      if (succeed) {
        state = state.copyWith(
            isOn: authState, uiEvent: ToastEvent(text: 'operate_success'.tr()));
      }
      return succeed;
    } catch (error) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      LogUtils.e('setUXPlanAuthState error: $error');
    }
    return false;
  }

  /// 广告管理-设置配置
  Future<void> _setAdsManagementAuthState(bool authState) async {
    try {
      int onState = authState ? 1 : 0;
      try {
        await ref.read(settingsRepositoryProvider).setAduserswitch(onState);
      } catch (error) {
        LogUtils.e(error);
      }
      state = state.copyWith(
          isOn: authState, uiEvent: ToastEvent(text: 'operate_success'.tr()));
    } catch (error) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      LogUtils.e(error);
    }
  }

  /// 通用更新配置方法
  Future<void> _setUserConfigState(String key, bool authState) async {
    try {
      bool succeed = await ref
          .read(settingsRepositoryProvider)
          .setUserConfigSetting([KVModel(key, authState)]);
      if (succeed) {
        state = state.copyWith(
            isOn: authState, uiEvent: ToastEvent(text: 'operate_success'.tr()));
      }
    } catch (error) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      LogUtils.e('setUXPlanAuthState error: $error');
    }
  }

  /// 用户体验计划-提示弹窗
  Future<void> checkUxPlanDialog() async {
    final currentRegion = RegionStore().currentRegion;
    String countryCode = currentRegion.countryCode;
    if (!RegionUtils.isCn(currentRegion.countryCode)) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String key = 'ux_plan_dialog_flag_${countryCode}_$version';
      bool hasShow = await LocalStorage().getBool(key) ?? false;
      UXPlanModel uxPlan =
          await ref.read(settingsRepositoryProvider).getUXPlanState();
      bool agree = uxPlan.value == 1;
      if (!hasShow && !agree) {
        ref
            .read(dialogJobManagerProvider.notifier)
            .sendJobMessage(DialogJob(DialogType.uxPlan));
      }
    }
  }

  /// 用户体验计划-更新本地弹窗状态
  Future<void> updateUxSp({bool show = true}) async {
    final currentRegion = RegionStore().currentRegion;
    String countryCode = currentRegion.countryCode;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String key = 'ux_plan_dialog_flag_${countryCode}_$version';
    await LocalStorage().putBool(key, show);
  }
}
