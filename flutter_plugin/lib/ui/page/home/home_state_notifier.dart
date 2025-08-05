// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_mqtt/dreame_flutter_base_mqtt.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/home/home_download_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/alify_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/common/theme/index.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind/bind_page/mobile_bind_page.dart';
import 'package:flutter_plugin/ui/page/home/device_offline_tips_page.dart';
import 'package:flutter_plugin/ui/page/home/device_status/key_define_provider.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/home/home_local_repository.dart';
import 'package:flutter_plugin/ui/page/home/home_repository.dart';
import 'package:flutter_plugin/ui/page/home/home_ui_state.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/home/plugin/rn_plugin_update_model.dart';
import 'package:flutter_plugin/ui/page/main/main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_handle_notifier.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing/device_sharing_list_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_add_contacts_page.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart';
import 'package:flutter_plugin/ui/widget/home/device/base_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/device/home_device_content_widget.dart';
import 'package:flutter_plugin/utils/debounce_utils.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/utils/hold_common_feature_data.dart';

part 'home_state_notifier.g.dart';

@Riverpod(keepAlive: true)
class HomeStateNotifier extends _$HomeStateNotifier {
  final Map _cachedStatus = {};

  // 存储 widgetKey
  final Map<String, GlobalKey<BaseDeviceWidgetState>> _itemKeyMap = {};
  bool _monitorClickEnable = true;

  // 设备引导弹窗二次检验
  bool _needCheckGuideAgain = false;

  // ignore: non_constant_identifier_names
  final String _FIRST_TAB_DID = '-1';

  HomeDeviceVideoPlayerImpl homeDeviceVideoPlayerImpl =
      HomeDeviceVideoPlayerImpl();

  @override
  HomeUiState build() {
    listenThemeChange();
    ref.onDispose(() async {
      try {
        await homeDeviceVideoPlayerImpl.disposePlayer();
      } catch (disposeError) {
        LogUtils.e(
            '[homeDeviceVideoPlayerImpl]dispose失败:${disposeError.toString()}');
      }
    });
    return const HomeUiState();
  }

  GlobalKey<BaseDeviceWidgetState> getItemKey(String did, String hashCode) {
    final itemKey = '${did}_${hashCode}_${this.hashCode}';
    LogUtils.d('getItemKey: $itemKey');
    var key = _itemKeyMap[itemKey];
    if (key == null) {
      key = GlobalKey(debugLabel: itemKey);
      _itemKeyMap[itemKey] = key;
    }
    return key;
  }

  void clearItemKeys() {
    LogUtils.d('getItemKey: clearItemKeys $this');
    _itemKeyMap.clear();
  }

  GlobalKey<BaseDeviceWidgetState> createItemKey(String did, String hashCode) {
    final itemKey = '${did}_${hashCode}_${this.hashCode}';
    LogUtils.d('getItemKey: createItemKey $itemKey');
    return getItemKey(did, hashCode);
  }

  Future<void> initData() async {
    clearItemKeys();
    _registeMqttCallback();
    await _readCacheDevice();
    Future.delayed(const Duration(milliseconds: 200), () {
      refreshDevice();
    });
  }

  void listenThemeChange() {
    ref.listen(appThemeStateNotifierProvider, (previous, next) async {
      // 销毁正在播放的播放器，重新加载资源
      try {
        HomeDeviceVideoPlayerImpl homeVideoPlayerImpl = ref
            .read(homeStateNotifierProvider.notifier)
            .homeDeviceVideoPlayerImpl;
        homeVideoPlayerImpl.isReady.value = false;
        final themeMode = ref.read(appThemeStateNotifierProvider);
        String themePath = themeMode == ThemeMode.dark ? 'dark' : 'light';
        String keyRes = '${state.currentDevice?.model}_res_rn_plugin';
        final pluginResLocalModel = await ref
            .read(pluginLocalRepositoryProvider.notifier)
            .getLocalInfo(keyRes);
        final path = await homeVideoPlayerImpl.getFilePath(
            state.currentDevice?.model,
            pluginResLocalModel.partition ?? '',
            themePath,
            state.currentDevice?.latestStatus);
        print(
            'bolinyyyy -- getFilePath: $path, model=${state.currentDevice?.model}');
        await homeVideoPlayerImpl.loadDataSource(
            (state.currentDevice?.online ?? false) ? path : '',
            forceRefresh: true);
      } catch (e) {
        LogUtils.e('HomePage Error during theme change: $e');
      }
    });
  }

  void _registeMqttCallback() {
    MqttConnector().addConnectErrorCallback((exception) async {
      if (exception is DMMqttAuthException) {
        LogUtils.e('HomePage mqtt auth error: ${exception.code}');
        // 重新获取token
        try {
          await ref.read(accountSettingRepositoryProvider).getUserInfo();
          await MqttConnector().connect();
        } catch (e) {
          LogUtils.e('HomePage mqtt refresh token error: $e');
        }
      }
    });
    MqttConnector().setWillMessageCallback((did, lastwill) {
      var device =
          state.deviceList.firstWhereOrNull((element) => element.did == did);
      if (device != null) {
        LogUtils.i(
            'HomePage updateDevice targetDid: $did, name: ${device.getShowName()}, lastWill: $lastwill');
        updateDevice(device, lastWill: lastwill);
      }
    });

    MqttConnector().setPropChangeCallback((did, props) {
      var device =
          state.deviceList.firstWhereOrNull((element) => element.did == did);

      MqttDataBean messageBean = MqttDataBean.fromJson(props);

      if (device != null &&
          messageBean.params != null &&
          messageBean.params?.isNotEmpty == true) {
        int oldStatus = device.latestStatus;
        bool needUpdate = device.handleMqttPropChange(messageBean.params);
        if (needUpdate) {
          int newStatus = device.latestStatus;
          final jsonMap = device.toJson();
          LogUtils.i(
              'HomePage updateDevice: targetDid: ${device.did}, name: ${device.getShowName()}, battery: ${device.battery}, '
              'latestStatus: ${device.latestStatus}, fastCommandList: ${jsonMap['fastCommandList']}, '
              'featureCode: ${jsonMap['featureCode']}, featureCode2: ${jsonMap['featureCode2']}, '
              'lastWill: ${device.lastWill}, monitorStatus: ${jsonMap['monitorStatus']}, '
              'cleanArea: ${jsonMap['cleanArea']}, cleanTime: ${jsonMap['cleanTime']}, commonBtnProtol: ${device.commonBtnProtol}, oldStatus: $oldStatus, newStatus: $newStatus');
          updateDevice(device,
              latestStatus: oldStatus != newStatus ? newStatus : null);
        }
      }
    });
  }

  /// 获取售后服务配置
  Future<void> _getAfterSaleConfig() async {
    try {
      final result =
          await ref.read(homeRepositoryProvider).getAfterSaleConfig();
      state = state.copyWith(
        showCustomerS: result.onlineService == 1,
      );
      ref.read(homeRepositoryProvider).saveAfterSaleConfig(result);
    } catch (error) {
      LogUtils.e('_getAfterSaleConfig error: $error');
    }
  }

  Future<void> _readCacheDevice() async {
    final cachedDevices =
        await ref.read(homeLocalRepositoryProvider).readCachedDevice();
    List<BaseDeviceModel> list = _convertDeviceModel(cachedDevices);
    var cachedTabDid =
        await ref.read(homeLocalRepositoryProvider).getLastTabDid() ?? '';
    final result = findTargetShowTab(list, cachedTabDid, false);
    state = HomeUiState(
      refreshing: true,
      deviceList: list,
      currentDevice: result.second,
      targetTab: result.first,
    );
  }

  /// 获取设备列表
  ///
  /// [slience] 静默刷新-适用于非当前页面刷新
  /// [refreshData] 是否下拉刷新数据
  /// [didInCurrentTab] 当前tab的did
  ///
  Future<void> _getDeviceList(
      {bool slience = false,
      bool refreshData = false,
      String didInCurrentTab = ''}) async {
    state = state.copyWith(refreshing: true, targetTab: -1);
    try {
      final result = await ref.read(homeRepositoryProvider).getDeviceList();
      LogUtils.d('getDeviceList result: $result');
      final recordsData = result.page.records;
      List<BaseDeviceModel> records = _convertDeviceModel(recordsData);
      // list widget keys
      _itemKeyMap.clear();
      // 处理缓存设备状态
      _fixDeviceStatus(records);
      // set first device
      final Pair<int, BaseDeviceModel?> findResult;
      if (didInCurrentTab == _FIRST_TAB_DID) {
        findResult = Pair(0, records.isEmpty ? null : records[0]);
      } else {
        findResult = findTargetShowTab(records, didInCurrentTab, refreshData);
      }
      BaseDeviceModel? currentDevice = findResult.second;
      int targetTab = findResult.first;

      if (currentDevice != null) {
        String status = _cachedStatus[currentDevice.did] ?? '';
        if (status.isNotEmpty) {
          currentDevice.latestStatusStr = status;
        } else {
          String latestStatusStr = await getLatestStatusStr(currentDevice);
          currentDevice.latestStatusStr = latestStatusStr;
          _cachedStatus[currentDevice.did] = latestStatusStr;
        }
      }
      state = HomeUiState(
        showCustomerS: state.showCustomerS,
        deviceList: records,
        currentDevice: currentDevice,
        targetTab: targetTab,
        currentIndex: targetTab,
        refreshing: false,
        firstLoad: false,
      );
      if (!slience) {
        if (ref.read(schemeHandleNotifierProvider).schemeType.isNotEmpty) {
          LogUtils.i('[Scheme] SchemeHandleNotifier  _getDeviceList slience');
          ref.read(schemeHandleNotifierProvider.notifier).handleSchemeEvent();
        } else if (currentDevice != null) {
          if (_needCheckGuideAgain) {
            _needCheckGuideAgain = false;
            await _checkDeviceGuide(currentDevice);
          }
        }
        await ref.read(dialogJobManagerProvider.notifier).areUReady();
      }
      await MqttConnector().addDeviceTopics(records);
      await ref.read(homeLocalRepositoryProvider).updateKeyDefine(records);
      await ref.read(homeLocalRepositoryProvider).updateCacheDevice(records);
      MessageChannel().updateAllAppWidget(json.encode(records));
      refreshMsgCount();
      if (currentDevice != null) {
        await _getDeviceStatus(currentDevice);
      }
    } catch (error) {
      LogUtils.e('getDeviceList error: $error');
      final cachedDeviceList =
          await ref.read(homeLocalRepositoryProvider).readCachedDevice();
      if (cachedDeviceList.isEmpty) {
        state =
            HomeUiState(showCustomerS: state.showCustomerS, loadError: true);
      } else {
        List<BaseDeviceModel> records = _convertDeviceModel(cachedDeviceList);
        await MqttConnector().addDeviceTopics(records);
        // set first device
        final findResult =
            findTargetShowTab(records, didInCurrentTab, refreshData);
        BaseDeviceModel? currentDevice = findResult.second;
        int targetTab = findResult.first;
        // list widget keys
        _itemKeyMap.clear();
        state = HomeUiState(
          showCustomerS: state.showCustomerS,
          deviceList: records,
          currentDevice: currentDevice,
          targetTab: targetTab,
          currentIndex: targetTab,
        );
      }
    } finally {
      if (!slience) {
        await ref.read(dialogJobManagerProvider.notifier).areUReady();
      }
      await MqttConnector().connect();
    }
  }

  void _fixDeviceStatus(List<BaseDeviceModel> records) {
    final lastStatusMap = {};
    final lastBatteryMap = {};
    final cachedLastWill = {};
    final cachedButtonProtol = {};
    final cachedRepairInfo = {};
    Map<String, Pair> featureCodeMap = {};
    // read cached property
    for (var element in state.deviceList) {
      if (!element.isLocalCache) {
        if (element.supportLastWill()) {
          cachedLastWill[element.did] = element.lastWill;
        }
        lastStatusMap[element.did] = element.latestStatus;
        lastBatteryMap[element.did] = element.battery;
        cachedButtonProtol[element.did] = element.getBtnProtol();
        cachedRepairInfo[element.did] = element.deviceRepairInfo;
      }
      if (element is VacuumDeviceModel) {
        featureCodeMap[element.did] =
            Pair(element.featureCode, element.featureCode2);
      }
    }

    // write property
    final List<BaseDeviceModel> dirtyList = [];
    for (var element in records) {
      if (element.deviceInfo == null) {
        dirtyList.add(element);
        continue;
      }
      if (element.supportLastWill()) {
        element.lastWill = cachedLastWill[element.did];
      }
      element.latestStatus = lastStatusMap[element.did] ?? element.latestStatus;
      element.battery = lastBatteryMap[element.did] ?? element.battery;
      if (element is VacuumDeviceModel) {
        element.featureCode =
            featureCodeMap[element.did]?.first as int? ?? element.featureCode;
        element.featureCode2 =
            featureCodeMap[element.did]?.second as int? ?? element.featureCode2;
      }
      element.commonBtnProtol = cachedButtonProtol[element.did];
    }
    if (dirtyList.isNotEmpty) {
      var reportData = '';
      // 不展示脏数据
      for (var element in dirtyList) {
        records.remove(element);
        reportData += '${element.model},';
      }
      LogModule().eventReport(100, 12, rawStr: reportData);
    }
  }

  /// 将DeviceModel转换为BaseDeviceModel
  List<BaseDeviceModel> _convertDeviceModel(List<DeviceModel> list) {
    List<BaseDeviceModel> records = [];
    for (var element in list) {
      if (element.deviceType() == DeviceType.vacuum) {
        records.add(VacuumDeviceModel.fromDevice(element));
      } else if (element.deviceType() == DeviceType.hold) {
        records.add(HoldDeviceModel.fromDevice(element));
      } else if (element.deviceType() == DeviceType.feeder) {
        records.add(FeederDeviceModel.fromDevice(element));
      } else if (element.deviceType() == DeviceType.litterbox) {
        records.add(LitterBoxDeviceModel.fromDevice(element));
      } else {
        records.add(BaseDeviceModel.fromDevice(element));
      }
    }
    return records;
  }

  /// 获取刷新时的设备与索引
  Pair<int, BaseDeviceModel?> findTargetShowTab(
      List<BaseDeviceModel> records, String didInCurrentTab, bool isRefresh) {
    int targetTab = 0;
    BaseDeviceModel? currentDevice;
    if (didInCurrentTab == _FIRST_TAB_DID) {
      return Pair(targetTab, currentDevice);
    }
    // find target tab and device
    records.forEachIndexed((index, element) {
      if (element.did == didInCurrentTab) {
        currentDevice = element;
        targetTab = index;
      }
    });
    if (records.isNotEmpty && currentDevice == null) {
      // 未找到当前设备，出现在设备被删除/被取消分享
      currentDevice = records[0];
      targetTab = 0;
    } else if (didInCurrentTab.isEmpty) {
      // didInCurrentTab为空，1.在添加设备页面 2.首次进入请求列表
      if (isRefresh) {
        // 下拉刷新时，在添加设备页面
        currentDevice = null;
        targetTab = records.length;
      } else {
        currentDevice = records.isEmpty ? null : records[0];
        targetTab = 0;
      }
    }
    return Pair(targetTab, currentDevice);
  }

  Future<void> checkDeviceGuide() async {
    final currentDevice = state.deviceList.isNotEmpty
        ? state.deviceList[state.currentIndex]
        : null;
    if (currentDevice != null) {
      await _checkDeviceGuide(currentDevice);
    } else {
      _needCheckGuideAgain = true;
    }
  }

  /// 检查设备引导
  ///
  /// [device] 目标设备
  ///
  Future<void> _checkDeviceGuide(BaseDeviceModel device) async {
    /// fixme: 临时关闭
    /// fixme: 临时关闭
    /// fixme: 临时关闭
    if (true) {
      return;
    }
    var deviceType = device.deviceType();
    var supportFastCommand =
        device is VacuumDeviceModel ? device.isSupportFastCommand() : false;
    var holdActionType = device is HoldDeviceModel
        ? device.holdActionType()
        : HoldActionType.cleanDry;
    if (deviceType != DeviceType.hold &&
        deviceType != DeviceType.vacuum &&
        deviceType != DeviceType.mower) {
      return;
    }
    final showGuide = await ref.read(homeRepositoryProvider).checkGuideTip(
            deviceType,
            holdExtra: holdActionType == HoldActionType.cleanDeepClean
                ? '_deep'
                : '') ??
        false;
    if (!showGuide) {
      if (ref
          .read(mainStateNotifierProvider.notifier)
          .isTargetTab(TabItemType.device)) {
        DialogJob? currentJob = ref.read(dialogJobManagerProvider);
        if (currentJob?.jobType == DialogType.guide) {
          if (currentJob?.bundle['type'] != deviceType) {
            ref
                .read(dialogJobManagerProvider.notifier)
                .sendJobMessage(DialogJob(DialogType.guide, bundle: {
                  'type': deviceType,
                  'supportFastCommand': supportFastCommand,
                  'holdActionType': holdActionType
                }));
          }
        } else {
          ref
              .read(dialogJobManagerProvider.notifier)
              .sendJobMessage(DialogJob(DialogType.guide, bundle: {
                'type': deviceType,
                'supportFastCommand': supportFastCommand,
                'holdActionType': holdActionType
              }));
        }
      }
    }
  }

  /// 配网或删除设备，主动刷新列表
  Future<void> pairOrDeleteDevice() async {
    if (ref
        .read(mainStateNotifierProvider.notifier)
        .isTargetTab(TabItemType.device)) {
      await refreshDevice(forceFirstTab: true);
    } else {
      await refreshDevice(slience: true, forceFirstTab: true);
    }
  }

  /// App前后台切换
  Future<void> onAppResume() async {
    DebounceUtils.debounce(
        key: 'onAppResume',
        duration: const Duration(milliseconds: 50),
        callback: () async {
          await _onAppResume();
        });
  }

  Future<void> _onAppResume() async {
    LogUtils.i('-[home_state_notifier.dart]- onAppResume');
    refreshMsgCount();
    if (ref
        .read(mainStateNotifierProvider.notifier)
        .isTargetTab(TabItemType.device)) {
      LogUtils.d(
          '--------onAppResume--------state.deviceList: ${state.deviceList.length} ,state.currentIndex:${state.currentIndex}');
      var deviceBean = state.currentDevice;
      try {
        MessageChannel().updateAllAppWidget(json.encode(state.deviceList));
      } catch (e) {
        LogUtils.e('onAppResume updateAllAppWidget error: $e');
      }
      if (deviceBean != null) {
        await _getDeviceStatus(deviceBean, errorCallback: (code) async {
          // 设备被删除
          if (code == 80002) {
            await refreshDevice();
          }
        });
      }
    }
    await MqttConnector().connect();
  }

  /// 刷新设备列表
  /// [slience] 静默刷新-适用于非当前页面刷新
  /// [forceFirstTab] 强制切换到第一个tab
  Future<void> refreshDevice(
      {bool slience = false, bool forceFirstTab = false}) async {
    final didInCurrentTab = forceFirstTab
        ? _FIRST_TAB_DID
        : (state.currentDevice?.did ?? _FIRST_TAB_DID);
    await _getDeviceList(
        slience: slience, refreshData: true, didInCurrentTab: didInCurrentTab);
    if (!slience) {
      // 主动下拉时获取客服配置
      await _getAfterSaleConfig();
    }
  }

  Future<String> getLatestStatusStr(BaseDeviceModel deviceBean) async {
    String latestStatusStr = '';
    String langTag = await LocalModule().getLangTag();
    try {
      if (deviceBean.isOnline()) {
        Map keyDefine = await ref
            .read(keyDefineProvider.notifier)
            .getKeyDefine(deviceBean.model, language: langTag);
        if (keyDefine.isNotEmpty &&
            keyDefine['${deviceBean.latestStatus}'] != null &&
            keyDefine['${deviceBean.latestStatus}'] != '') {
          latestStatusStr = keyDefine['${deviceBean.latestStatus}'];
        } else {
          Map keyDefine = await ref
              .read(keyDefineProvider.notifier)
              .getKeyDefine(deviceBean.model, language: 'en');
          latestStatusStr = keyDefine['${deviceBean.latestStatus}'] ?? '';
        }
      } else {
        latestStatusStr = 'device_offline'.tr();
      }
    } catch (e) {
      LogUtils.e('getLatestStatusStr error: $e');
    }
    return latestStatusStr;
  }

  Future<void> onCleanClick(VacuumDeviceModel currentDevice) async {
    if (!await checkLegalAnction()) {
      return;
    }
    LogUtils.i(
        '[home] HomeStateNotifier onCleanClick: ${currentDevice.did}, latestStatus: ${currentDevice.latestStatus}');

    var latestStatus = currentDevice.latestStatus;
    if (latestStatus == 16) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'text_dock_self_test_tip'.tr()));
    } else if (latestStatus == 19) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'text_shangxiashui_check_tip'.tr()));
    } else if (latestStatus == 105 || latestStatus == 106) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'vacuum_device_change_map'.tr()));
    } else if (currentDevice.supportVideoMultitask() &&
        (latestStatus == 98 || latestStatus == 99)) {
      // 有视频任务,终止当前任务,下发清扫
      state = state.copyWith(
          uiEvent: AlertEvent(
        content: 'video_intercept_task_tip'.tr(),
        confirmContent: 'dialog_determine'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmCallback: () {
          stopTask(currentDevice,
              nextTask: () => _startOrStopClean(currentDevice, false));
        },
      ));
    } else if (!currentDevice.supportVideoMultitask() &&
        (currentDevice.getMonitorStatus() != 0 ||
            latestStatus == 98 ||
            latestStatus == 99)) {
      // 有视频任务,已开启视频,点清扫打断任务
      state = state.copyWith(
          uiEvent: AlertEvent(
        content: 'video_intercept_video_tip'.tr(),
        confirmContent: 'dialog_determine'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmCallback: () {
          _startOrStopClean(currentDevice, false);
        },
      ));
    } else {
      _startOrStopClean(currentDevice, currentDevice.isCanStopCleanTask());
    }
  }

  /// 清扫/暂停清扫
  void _startOrStopClean(VacuumDeviceModel currentDevice, bool pauseAction) {
    bool oldFramwork = currentDevice.model == 'dreame.vacuum.p2029';
    if (pauseAction) {
      var iotParams = IotParams(
          did: currentDevice.did,
          siid: 2,
          aiid: 2,
          inList: oldFramwork
              ? []
              : [const InDTO(piid: 100, value: '1,{"app_pause":1}')]);
      sendAction(currentDevice, iotParams);
    } else {
      var iotParams = IotParams(
          did: currentDevice.did,
          siid: 2,
          aiid: 1,
          inList: oldFramwork
              ? []
              : [const InDTO(piid: 100, value: '2,1,{"app_auto_clean":1}')]);
      sendAction(currentDevice, iotParams);
    }
  }

  Future<void> onChargeClick(VacuumDeviceModel currentDevice) async {
    if (!await checkLegalAnction()) {
      return;
    }

    LogUtils.i(
        '[home] HomeStateNotifier onChargeClick: ${currentDevice.did}, latestStatus: ${currentDevice.latestStatus}');
    final latestStatus = currentDevice.latestStatus;
    if (latestStatus == 16) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'text_dock_self_test_tip'.tr()));
    } else if (latestStatus == 19) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'text_shangxiashui_check_tip'.tr()));
    } else if (latestStatus == 105 || latestStatus == 106) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'vacuum_device_change_map'.tr()));
    } else if (latestStatus == 9 || latestStatus == 21) {
      // 拖布清洗中｜｜ 暂停清洗
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'vacuum_device_moping'.tr()));
    } else if (currentDevice.getExecutingFastCommand() != null) {
      state = state.copyWith(
          uiEvent: AlertEvent(
        content: 'text_operation_interrupt_task_continue'.tr(),
        confirmContent: 'confirm'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmCallback: () {
          stopTask(currentDevice,
              delayNext: true, nextTask: () => _chargeOrPause(currentDevice));
        },
      ));
    } else if (currentDevice.supportVideoMultitask() &&
        (latestStatus == 98 || latestStatus == 99)) {
      // 有视频任务,终止当前任务,下发回充
      state = state.copyWith(
          uiEvent: AlertEvent(
        content: 'video_intercept_task_tip'.tr(),
        confirmContent: 'dialog_determine'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmCallback: () {
          stopTask(currentDevice,
              nextTask: () => _chargeOrPause(currentDevice));
        },
      ));
    } else {
      _chargeOrPause(currentDevice);
    }
  }

  /// 下发回充/暂停回充
  void _chargeOrPause(VacuumDeviceModel currentDevice) {
    final latestStatus = currentDevice.latestStatus;
    if (latestStatus != 5) {
      var iotParams = IotParams(
          did: currentDevice.did,
          siid: 3,
          aiid: 1,
          inList: [const InDTO(piid: 100, value: '{"charge":1}')]);
      sendAction(currentDevice, iotParams);
    } else {
      var iotParams = IotParams(
          did: currentDevice.did,
          siid: 2,
          aiid: 2,
          inList: [const InDTO(piid: 100, value: '{"pause":1}')]);
      sendAction(currentDevice, iotParams);
    }
  }

  /// 洗地机右键
  Future<void> onHoldRightClick(
      HoldDeviceModel currentDevice, bool stop) async {
    // 检查电量是否充足
    if (checkBatteryLow(currentDevice, 'right')) {
      return;
    }
    if (!await checkLegalAnction()) {
      return;
    }
    if (currentDevice == null) return;
    CommonBtnProtolModel? commonBtnProtol = currentDevice.getBtnProtol();
    if (commonBtnProtol != null) {
      bool result = await _sendHoldCommand(
          currentDevice, 200, 2, commonBtnProtol.rightCommandValue,
          successCode: 200);
      if (!result) {
        if (commonBtnProtol.rightWorkMode == 0) {
          state = state.copyWith(
              uiEvent: ToastEvent(text: 'home_tip_hold_dry_fail'.tr()));
        } else {
          state = state.copyWith(
              uiEvent: ToastEvent(text: 'home_tip_hold_slef_clean_fail'.tr()));
        }
      }
    } else {
      bool result = false;
      if (currentDevice.holdActionType() == HoldActionType.cleanDry) {
        final value = stop ? 0 : 1;
        result = await _sendHoldCommand(currentDevice, 1, 2, value);
      } else if (currentDevice.holdActionType() ==
          HoldActionType.cleanDeepClean) {
        // 深度自清洁
        final value = stop ? 0 : 3;
        result = await _sendHoldCommand(currentDevice, 1, 1, value);
      }
      if (!result) {
        if (currentDevice.holdActionType() == HoldActionType.cleanDry) {
          state = state.copyWith(
              uiEvent: ToastEvent(text: 'home_tip_hold_dry_fail'.tr()));
        } else if (currentDevice.holdActionType() ==
            HoldActionType.cleanDeepClean) {
          state = state.copyWith(
              uiEvent: ToastEvent(text: 'home_tip_hold_slef_clean_fail'.tr()));
        }
      }
    }
  }

  /// 洗地机左键
  Future<void> onHoldLeftClick(HoldDeviceModel currentDevice, bool stop) async {
    // 检查电量是否充足
    if (checkBatteryLow(currentDevice, 'left')) {
      return;
    }
    if (!await checkLegalAnction()) {
      return;
    }
    CommonBtnProtolModel? commonBtnProtol = currentDevice.getBtnProtol();
    if (commonBtnProtol != null) {
      bool result = await _sendHoldCommand(
          currentDevice, 200, 2, commonBtnProtol.leftCommandValue,
          successCode: 200);
      if (!result) {
        if (commonBtnProtol.leftWorkMode == 0) {
          state = state.copyWith(
              uiEvent: ToastEvent(text: 'home_tip_hold_dry_fail'.tr()));
        } else {
          state = state.copyWith(
              uiEvent: ToastEvent(text: 'home_tip_hold_slef_clean_fail'.tr()));
        }
      }
    } else {
      int value;
      if (currentDevice.holdActionType() == HoldActionType.cleanDeepClean) {
        value = stop ? 0 : 2;
      } else {
        value = stop ? 0 : 1;
      }
      bool result = await _sendHoldCommand(currentDevice, 1, 1, value);
      if (!result) {
        state = state.copyWith(
            uiEvent: ToastEvent(text: 'home_tip_hold_slef_clean_fail'.tr()));
      }
    }
  }

  /// 电量低
  bool checkBatteryLow(HoldDeviceModel currentDevice, String position) {
    // 电量低于25% Toast提示电量低，开启失败
    if (currentDevice.battery < 25) {
      String text = HoldCommonFeatureData.getToastStrByFeature(
          currentDevice.deviceInfo?.feature, position);
      state = state.copyWith(uiEvent: ToastEvent(text: text));
      return true;
    }
    return false;
  }

  /// 喂食器左键
  Future<void> onFeederLeft(int value) async {
    final currentDevice = state.currentDevice;
    if (currentDevice == null) return;
    final latestStatus = currentDevice.latestStatus;
    if (latestStatus == 1) {
      // 开始喂食
      var iotParams = IotParams(
          did: currentDevice.did,
          siid: 3,
          aiid: 1,
          inList: [InDTO(piid: 1, value: value)]);
      sendAction(currentDevice, iotParams);
    } else {
      //
    }
  }

  /// 猫砂盆左键
  Future<void> onLitterBoxLeft() async {
    final currentDevice = state.currentDevice;
    if (currentDevice == null) return;
    final latestStatus = currentDevice.latestStatus;

    if (latestStatus == 0 || latestStatus == 17) {
      var iotParams =
          IotParams(did: currentDevice.did, siid: 3, aiid: 1, inList: []);
      sendAction(currentDevice, iotParams);
    } else if (latestStatus == 1) {
      var iotParams =
          IotParams(did: currentDevice.did, siid: 3, aiid: 5, inList: []);
      sendAction(currentDevice, iotParams);
    } else if (latestStatus == 2) {
      var iotParams =
          IotParams(did: currentDevice.did, siid: 3, aiid: 6, inList: []);
      sendAction(currentDevice, iotParams);
    } else if (latestStatus == 3) {
      await SmartDialog.showToast('litterbox_emptying'.tr());
    } else if (latestStatus == 4) {
      await SmartDialog.showToast('litterbox_emptying_paused'.tr());
    } else if (latestStatus == 5) {
      await SmartDialog.showToast('litterbox_smoothing'.tr());
    } else if (latestStatus == 6) {
      await SmartDialog.showToast('litterbox_smoothing_paused'.tr());
    } else if (latestStatus == 7 || latestStatus == 8 || latestStatus == 9) {
      var iotParams =
          IotParams(did: currentDevice.did, siid: 3, aiid: 1, inList: []);
      sendAction(currentDevice, iotParams);
    }
    LogModule().eventReport(130, 1,
        str1: '点击立即清理',
        str2: 'home',
        str3: 'clean',
        did: currentDevice.did,
        model: currentDevice.model);
  }

  /// 割草机左键
  Future<void> onMowerLeft(BaseDeviceModel currentDevice) async {
    if (!await checkLegalAnction()) {
      return;
    }
    final latestStatus = currentDevice.latestStatus;
    if (latestStatus == 2 ||
        latestStatus == 3 ||
        latestStatus == 4 ||
        latestStatus == 5 ||
        latestStatus == 6 ||
        latestStatus == 13) {
      // 开始割草
      var iotParams = IotParams(did: currentDevice.did, siid: 5, aiid: 1);
      sendAction(currentDevice, iotParams);
    } else if (latestStatus == 1) {
      var iotParams = IotParams(did: currentDevice.did, siid: 5, aiid: 4);
      sendAction(currentDevice, iotParams);
    }
  }

  /// 割草机右键
  Future<void> onMowerRight(BaseDeviceModel currentDevice) async {
    if (!await checkLegalAnction()) {
      return;
    }
    final latestStatus = currentDevice.latestStatus;
    if (latestStatus == 1 ||
        latestStatus == 2 ||
        latestStatus == 3 ||
        latestStatus == 4) {
      // 开始回充
      var iotParams = IotParams(did: currentDevice.did, siid: 5, aiid: 3);
      sendAction(currentDevice, iotParams);
    } else if (latestStatus == 5) {
      var iotParams = IotParams(did: currentDevice.did, siid: 5, aiid: 4);
      sendAction(currentDevice, iotParams);
    }
  }

  Future<void> onMonitroClick(VacuumDeviceModel currentDevice,
      {String entranceType = 'video'}) async {
    if (!await checkLegalAnction()) {
      return;
    }
    try {
      if (!_monitorClickEnable) return;
      _monitorClickEnable = false;
      if (currentDevice.supportDynamicVideo()) {
        _processVideoMultitask(currentDevice, entranceType);
      } else if (currentDevice.aliDevice()) {
        await _checkAliInfo(currentDevice, entranceType);
      } else {
        _processVideoMultitask(currentDevice, entranceType);
      }
      _monitorClickEnable = true;
    } catch (e) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      _monitorClickEnable = true;
      LogModule().eventReport(102, 4, int3: -1, str1: 'flutter error: $e');
    }
  }

  /// 校验阿里设备信息
  Future<void> _checkAliInfo(
      VacuumDeviceModel currentDevice, String entranceType) async {
    state = state.copyWith(loading: true);
    Map<String, dynamic>? result =
        await AlifyModule().checkAliDevice(currentDevice);
    LogUtils.i('onMonitroClick checkAliDevice result: $result');
    state = state.copyWith(loading: false);
    int code = result?['code'] ?? -1;
    if (code == 0) {
      String iotId = result?['iotId'] ?? '';
      currentDevice.iotId = iotId;
      if (iotId.isNotEmpty) {
        _processVideoMultitask(currentDevice, entranceType);
      } else {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
        LogModule().eventReport(102, 4, int3: -1, str1: 'iotId is empty');
      }
    } else {
      String message = result?['message'] ?? '';
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      LogModule().eventReport(102, 4, int3: code, str1: message);
    }
  }

  /// 处理快捷指令
  void _processVideoMultitask(VacuumDeviceModel device, String entranceType) {
    if (device.supportVideoMultitask()) {
      _handleVideoClick(device, entranceType);
    } else {
      if (device.getExecutingFastCommand() != null) {
        state = state.copyWith(
            uiEvent: AlertEvent(
          content: 'text_operation_interrupt_task_continue'.tr(),
          confirmContent: 'confirm'.tr(),
          cancelContent: 'cancel'.tr(),
          confirmCallback: () {
            stopTask(device,
                delayNext: true,
                nextTask: () => _handleVideoClick(device, entranceType));
          },
        ));
      } else {
        _handleVideoClick(device, entranceType);
      }
    }
  }

  /// 打断/进入插件
  void _handleVideoClick(VacuumDeviceModel device, String entranceType) {
    final latestStatus = device.latestStatus;
    if (latestStatus == 14) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'video_intercept_upgrade_tip'.tr()));
    } else if (device.supportVideoMultitask()) {
      _openPlugin(device, entranceType, isVideo: true);
    } else {
      final taskList = [1, 3, 4, 5, 7, 10, 11, 12, 15];
      if (taskList.contains(latestStatus)) {
        state = state.copyWith(
            uiEvent: AlertEvent(
          content: 'video_intercept_work_tip'.tr(),
          confirmContent: 'dialog_determine'.tr(),
          cancelContent: 'cancel'.tr(),
          confirmCallback: () {
            stopTask(device, delayNext: true, nextTask: () {
              _openPlugin(device, entranceType, isVideo: true);
            });
          },
        ));
      } else if (latestStatus == 9) {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'video_washmop_tip'.tr()));
      } else {
        // open
        _openPlugin(device, entranceType, isVideo: true);
      }
    }
  }

  Future<void> offlineTipClick() async {
    final currentDevice = state.currentDevice;
    if (currentDevice == null) return;
    if (currentDevice.supportLastWill() &&
        currentDevice.lastWill != null &&
        currentDevice.lastWill!.isNotEmpty &&
        currentDevice.lastWill != '0' &&
        currentDevice.lastWill != '100' /*是服务器帮机器报的，未知原因*/ &&
        currentDevice.deviceType() == DeviceType.vacuum) {
      await openPlugin('lastWill');
    } else {
      state = state.copyWith(
          uiEvent: PushEvent(
              path: DeviceOfflineTipsPage.routePath,
              extra: currentDevice.deviceType()));
    }
  }

  /// 打开插件
  Future<void> openPlugin(String entranceType,
      {bool isVideo = false, String extraData = ''}) async {
    if (!await checkLegalAnction()) {
      return;
    }
    _openPlugin(
      state.currentDevice,
      entranceType,
      isVideo: isVideo,
      extraData: extraData,
    );
  }

  /// did打开插件
  Future<void> openPluginByDid(String did, String model, String entranceType,
      {String source = ''}) async {
    LogUtils.i(
        '[Scheme] openPluginByDid, did: $did, model: $model ,entranceType: $entranceType');
    if (!await checkLegalAnction()) {
      return;
    }
    final device = state.deviceList.firstWhereOrNull((element) =>
        element.did == did && (element.model == model || model == 'dreame'));
    if (device == null) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'share_device_not_exist'.tr()));
      return;
    }
    bool isVideo = entranceType == 'video' || entranceType == 'videoCall';
    if (isVideo) {
      await _openVideoPlugin(device as VacuumDeviceModel, entranceType,
          source: source);
    } else {
      _openPlugin(device, entranceType, isVideo: isVideo, source: source);
    }
  }

  /// 打开视频插件
  Future<void> _openVideoPlugin(VacuumDeviceModel device, String entranceType,
      {String source = ''}) async {
    if (device.supportDynamicVideo()) {
      _openPlugin(device, entranceType, isVideo: true, source: source);
    } else if (device.aliDevice()) {
      state = state.copyWith(loading: true);
      Map<String, dynamic>? result = await AlifyModule().checkAliDevice(device);
      LogUtils.i('openVideoPlugin checkAliDevice result: $result');
      state = state.copyWith(loading: false);
      int code = result?['code'] ?? -1;
      if (code == 0) {
        String iotId = result?['iotId'] ?? '';
        device.iotId = iotId;
        if (iotId.isNotEmpty) {
          _openPlugin(device, entranceType, isVideo: true, source: source);
        } else {
          state =
              state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
        }
      } else {
        String message = result?['message'] ?? '';
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
        LogModule().eventReport(102, 4,
            int3: code,
            str1: message,
            rawStr: 'openPluginByDid checkAliDevice failed');
      }
    } else {
      _openPlugin(device, entranceType, isVideo: true, source: source);
    }
  }

  void _openPlugin(BaseDeviceModel? device, String entranceType,
      {bool isVideo = false, String source = '', String extraData = ''}) async {
    if (device == null) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    } else {
      final isSdkTest = await ref
          .read(developerMenuPageStateNotifierProvider.notifier)
          .getSDKTestPluginEnable();

      final enableConventionCenter = await ref
          .read(developerMenuPageStateNotifierProvider.notifier)
          .getConventionCenterEnable();
      if (isSdkTest) {
        _openSDKTestPlugin(device, entranceType,
            isVideo: isVideo, source: source, extraData: extraData);
      } else {
        if (enableConventionCenter) {
          // entranceType 改为 ‘demo’
          _openClassicPlugin(device, 'demo',
              isVideo: isVideo, source: source, extraData: extraData);
        } else {
          // 打开经典插件
          _openClassicPlugin(device, entranceType,
              isVideo: isVideo, source: source, extraData: extraData);
        }
      }
    }
  }

  void _openSDKTestPlugin(BaseDeviceModel device, String entranceType,
      {bool isVideo = false, String source = '', String extraData = ''}) {
    ref
        .read(pluginProvider.notifier)
        .updateSDKTestPlugin(tag: device.did, model: device.model)
        .then((pluginInfo) async {
      if (pluginInfo != null) {
        if (!pluginInfo.hide) {
          SmartDialog.dismiss();
          if (pluginInfo.code == incompatible) {
            state = state.copyWith(
                uiEvent: AlertEvent(
              content: 'Popup_DevicePage_PluginRequest_Failed'.tr(),
              confirmContent: 'upgrade'.tr(),
              cancelContent: 'cancel'.tr(),
              confirmCallback: () {
                UIModule().openAppStore();
              },
            ));
          } else if (pluginInfo.code == downloadFail) {
            state = state.copyWith(
                uiEvent: AlertEvent(
              content: 'Popup_DevicePage_PluginLoading_Failed'.tr(),
              confirmContent: 'retry'.tr(),
              cancelContent: 'cancel'.tr(),
              confirmCallback: () {
                _openPlugin(device, entranceType,
                    isVideo: isVideo, extraData: extraData);
              },
            ));
          } else if (pluginInfo.code == netError) {
            state = state.copyWith(
                uiEvent: AlertEvent(
              content: 'Popup_DevicePage_PluginDownloading_Failed'.tr(),
              confirmContent: 'retry'.tr(),
              cancelContent: 'cancel'.tr(),
              confirmCallback: () {
                _openPlugin(device, entranceType,
                    isVideo: isVideo, extraData: extraData);
              },
            ));
          } else {
            await UIModule().openPlugin(entranceType, device, pluginInfo,
                source: source, isVideo: isVideo, extraData: extraData);
          }
        }
      } else {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      }
    }).catchError((err) {
      SmartDialog.dismiss();
    });
  }

  void _openClassicPlugin(BaseDeviceModel device, String entranceType,
      {bool isVideo = false, String source = '', String extraData = ''}) {
    ref.read(pluginProvider.notifier).updateRNPlugin(
      device.model,
      tag: device.did,
      updateCallback: (showLoading) {
        if (showLoading) {
          SmartDialog.show(
              keepSingle: true,
              clickMaskDismiss: false,
              animationType: SmartAnimationType.fade,
              builder: (context) {
                return HomeDownloadWidget(deviceBean: device);
              },
              onDismiss: () => {
                    ref
                        .read(pluginProvider.notifier)
                        .hideUpdatePlugin(device.did)
                  });
        }
      },
    ).then((pluginInfo) async {
      await _realOpenPlugin(
          pluginInfo, device, entranceType, isVideo, extraData, source);
    }).catchError((err) {
      SmartDialog.dismiss();
    });
  }

  Future<void> _realOpenPlugin(
      RNPluginUpdateModel? pluginInfo,
      BaseDeviceModel device,
      String entranceType,
      bool isVideo,
      String extraData,
      String source) async {
    if (pluginInfo != null) {
      if (!pluginInfo.hide) {
        SmartDialog.dismiss();
        if (pluginInfo.code == incompatible) {
          state = state.copyWith(
              uiEvent: AlertEvent(
            content: 'Popup_DevicePage_PluginRequest_Failed'.tr(),
            confirmContent: 'upgrade'.tr(),
            cancelContent: 'cancel'.tr(),
            confirmCallback: () {
              UIModule().openAppStore();
            },
          ));
        } else if (pluginInfo.code == downloadFail) {
          state = state.copyWith(
              uiEvent: AlertEvent(
            content: 'Popup_DevicePage_PluginLoading_Failed'.tr(),
            confirmContent: 'retry'.tr(),
            cancelContent: 'cancel'.tr(),
            confirmCallback: () {
              _openPlugin(device, entranceType,
                  isVideo: isVideo, extraData: extraData);
            },
          ));
        } else if (pluginInfo.code == netError) {
          state = state.copyWith(
              uiEvent: AlertEvent(
            content: 'Popup_DevicePage_PluginDownloading_Failed'.tr(),
            confirmContent: 'retry'.tr(),
            cancelContent: 'cancel'.tr(),
            confirmCallback: () {
              _openPlugin(device, entranceType,
                  isVideo: isVideo, extraData: extraData);
            },
          ));
        } else {
          // 打开插件
          await UIModule().openPlugin(entranceType, device, pluginInfo,
              source: source, isVideo: isVideo, extraData: extraData);
        }
      }
    } else {
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
  }

  FutureOr<IotActionData?> sendAction(BaseDeviceModel device, IotParams params,
      {bool showMessage = true}) async {
    try {
      final requestId = Random().nextInt(500000) + 100;
      final id = requestId;
      final req = IotCommandRequest(device.did, id,
          IotActionCommandData(id: id, method: 'action', params: params));
      final data =
          await ref.read(homeRepositoryProvider).sendAction(device.host(), req);
      state = state.copyWith(loading: false);
      return Future.value(data);
    } catch (error) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: showMessage ? 'operate_failed'.tr() : ''),
          loading: false);
    }
    return null;
  }

  /// 终止任务
  Future<void> stopTask(BaseDeviceModel device,
      {bool showErrorToast = true,
      bool delayNext = false,
      Function? nextTask}) async {
    final iotParams = IotParams(did: device.did, siid: 4, aiid: 2);
    final data = await sendAction(device, iotParams, showMessage: false);
    if (data != null) {
      if (nextTask != null) {
        Future.delayed(Duration(milliseconds: delayNext ? 800 : 0), () {
          nextTask.call();
        });
      }
    } else {
      if (showErrorToast) {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      }
    }
  }

  /// sendCommand获取设备状态
  Future<void> _getDeviceStatus(BaseDeviceModel device,
      {Function(int)? errorCallback}) async {
    /// fix，不联网的设备不需要查询状态
    if (device.deviceType() == DeviceType.toothbrush ||
        device.deviceType() == DeviceType.detector) {
      return;
    }
    final requestId = Random().nextInt(500000) + 100;
    var id = requestId;
    final did = device.did;
    try {
      Map<String, dynamic> req = {
        'id': id,
        'did': did,
        'data': {
          'id': id,
          'did': did,
          'method': 'get_properties',
          'params': device.devicePropCommandParams(),
        }
      };
      final result = await ref
          .read(homeRepositoryProvider)
          .sendCommand(device.host(), req);
      List<ResultDTO> resultList = result.result;

      if (resultList.isNotEmpty) {
        device.handleCommandResp(resultList);
        LogUtils.i(
            'HomePage updateDevice command: targetDid: ${device.did}, name: ${device.getShowName()}, battery: ${device.battery}, commonBtnProtol: ${device.commonBtnProtol}, latestStatus: ${device.latestStatus}, '
            '${device is VacuumDeviceModel ? 'fastCommandList: ${device.fastCommandList}, featureCode: ${device.featureCode}, featureCode2: ${device.featureCode2}' : ''}');
        await updateDevice(device, latestStatus: device.latestStatus);
      }
    } catch (error) {
      if (error is DreameException) {
        errorCallback?.call(error.code);
      }
      LogUtils.e('查询设备状态失败 did: $did, error: $error');
    }
  }

  Future<bool> _sendHoldCommand(
      BaseDeviceModel device, int siid, int piid, int value,
      {int successCode = 1}) async {
    final requestId = Random().nextInt(500000) + 100;
    var id = requestId;
    final did = device.did;
    final req = {
      'id': id,
      'did': did,
      'data': {
        'id': id,
        'did': did,
        'method': 'set_properties',
        'params': [
          {'did': did, 'piid': piid, 'siid': siid, 'value': value}
        ]
      }
    };
    try {
      final result = await ref
          .read(homeRepositoryProvider)
          .sendCommand(device.host(), req);
      var resultList = result.result;
      if (resultList.isNotEmpty) {
        // 成功,返回1;失败,返回-1
        int value = resultList[0].value;
        return value == successCode;
      }
    } catch (error) {
      debugPrint('_sendHoldCommand error: $error');
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'operate_failed'.tr()), loading: false);
      return false;
    }
    return false;
  }

  Future<void> changeIndex(int index) async {
    var deviceBean =
        index == state.deviceList.length ? null : state.deviceList[index];
    state = state.copyWith(currentIndex: index);
    if (deviceBean != null) {
      await _checkDeviceGuide(deviceBean);
      String status = _cachedStatus[deviceBean.did] ?? '';
      if (status.isNotEmpty) {
        deviceBean.latestStatusStr = status;
      } else {
        deviceBean.latestStatusStr = await getLatestStatusStr(deviceBean);
      }
    }
    state = state.copyWith(currentDevice: deviceBean);
    if (deviceBean != null) {
      await initVideoPlayer(deviceBean.latestStatus, deviceBean,
          curDeviceBean: deviceBean);
      await _getDeviceStatus(deviceBean);
    }
    await ref
        .read(homeLocalRepositoryProvider)
        .updateLastTabDid(deviceBean?.did ?? _FIRST_TAB_DID);
  }

  Future<void> updateDevice(
    BaseDeviceModel device, {
    int? latestStatus,
    String? lastWill,
  }) async {
    if (latestStatus != null) {
      String latestStatusStr = await getLatestStatusStr(device);
      device.latestStatusStr = latestStatusStr;
      _cachedStatus[device.did] = latestStatusStr;
    }
    if (lastWill != null && lastWill.isNotEmpty) {
      if (device.supportLastWill()) {
        /// 机器上线，重新刷状态, 1s不够，经验值1.5s
        if (device.lastWill != '0' && lastWill == '0') {
          Future.delayed(const Duration(milliseconds: 1500), () {
            unawaited(_getDeviceStatus(device));
          });
        }
        device.lastWill = lastWill;
        device.online = '0' == lastWill;
      }
    }
    await initVideoPlayer(latestStatus, device);
    MessageChannel().updateAppWidget(json.encode(device));
    state = state.copyWith(deviceList: state.deviceList);
  }

  Future<void> initVideoPlayer(int? latestStatus, BaseDeviceModel device,
      {BaseDeviceModel? curDeviceBean}) async {
    try {
      final currentDevice = curDeviceBean ?? state.currentDevice;
      LogUtils.d(
          '[homeDeviceVideoPlayerImpl]初始化: latestStatus = $latestStatus, ${device.did}, ${currentDevice?.did}, ${device.model}, ${currentDevice?.model}, ${device.sn}, ${currentDevice?.sn}, offline = ${currentDevice?.online}');
      if (device.did == currentDevice?.did &&
          device.model == currentDevice?.model &&
          device.sn == currentDevice?.sn &&
          latestStatus != null) {
        String keyRes = '${device.model}_res_rn_plugin';
        final pluginResLocalModel = await ref
            .read(pluginLocalRepositoryProvider.notifier)
            .getLocalInfo(keyRes);
        final themeMode = ref.read(appThemeStateNotifierProvider);
        String themePath = themeMode == ThemeMode.dark ? 'dark' : 'light';
        final path = await homeDeviceVideoPlayerImpl.getFilePath(
            currentDevice?.model,
            pluginResLocalModel.partition ?? '',
            themePath,
            latestStatus);

        // Add safety check before loading data source
        await homeDeviceVideoPlayerImpl
            .loadDataSource(currentDevice?.online == true ? path : '');
      }
    } catch (e) {
      LogUtils.e('[homeDeviceVideoPlayerImpl]初始化失败:${e.toString()}');
      // Ensure controller is properly disposed on error
      try {
        await homeDeviceVideoPlayerImpl.disposePlayer();
      } catch (disposeError) {
        LogUtils.e(
            '[homeDeviceVideoPlayerImpl]dispose失败:${disposeError.toString()}');
      }
    }
  }

  Future<void> updateGuide(
    DeviceType type,
    HoldActionType? holdActionType,
  ) async {
    return ref.read(homeRepositoryProvider).updateGuideTip(type,
        holdExtra:
            holdActionType == HoldActionType.cleanDeepClean ? '_deep' : '');
  }

  ///设备删除
  void clickDeleteDevice() {
    final device = state.currentDevice;
    LogModule()
        .eventReport(5, 13, did: device?.did ?? '', model: device?.model ?? '');
    if (device != null) {
      state = state.copyWith(
          uiEvent: AlertEvent(
        content: 'delete_device_confirm'.tr(),
        confirmContent: 'confirm'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmCallback: () {
          _deleteDevice(device);
        },
      ));
    } else {
      state = state.copyWith(uiEvent: ToastEvent(text: 'delete_failed'.tr()));
    }
  }

  Future<void> _deleteDevice(BaseDeviceModel device) async {
    try {
      final result =
          await ref.read(homeRepositoryProvider).deleteDevice(device.did);
      state = state.copyWith(
          uiEvent: ToastEvent(
              text: result ? 'delete_success'.tr() : 'delete_failed'.tr()));
      LogModule().eventReport(5, 14, int1: result ? 1 : 0);
      if (result) {
        _cachedStatus.remove(device.did);
        await MqttConnector().removeDevice(device);
        refreshMsgCount();
        List<BaseDeviceModel> deviceList = List.from(state.deviceList);
        deviceList.remove(device);
        await ref
            .read(homeLocalRepositoryProvider)
            .updateCacheDevice(deviceList);
        final current = deviceList.isEmpty ? null : deviceList[0];
        state = state.copyWith(
            deviceList: deviceList,
            currentDevice: current,
            currentIndex: 0,
            targetTab: 0);
        MessageChannel().deleteDevice(device.did);
      } else {
        state = state.copyWith(uiEvent: ToastEvent(text: 'delete_failed'.tr()));
      }
    } catch (e) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'delete_failed'.tr()));
    }
  }

  /// 设备分享
  Future<void> shareDevice(BaseDeviceModel device) async {
    if (device.master && device.deviceInfo != null) {
      var sharedEntity = SharedDeviceThumbEntity.fromBaseDeviceModel(device);
      sharedEntity.sharedState = SharedState.toShare;

      state = state.copyWith(
        uiEvent: PushEvent(
          func: RouterFunc.push,
          path: DeviceSharingAddContactsPage.routePath,
          extra: sharedEntity,
        ),
      );
    } else {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'share_device_invalid'.tr()));
    }
  }

  /// 设备重命名
  void clickRenameDevice() {
    final device = state.currentDevice;
    LogModule()
        .eventReport(5, 15, did: device?.did ?? '', model: device?.model ?? '');
    if (device != null) {
      var deviceName = device.getShowName();
      state = state.copyWith(
          uiEvent: AlertInputEvent(
        title: 'rename'.tr(),
        hint: 'input_device_name'.tr(),
        content: deviceName,
        confirmContent: 'confirm'.tr(),
        cancelContent: 'cancel'.tr(),
        maxLength: 40,
        maxLengthCallback: () => state = state.copyWith(
            uiEvent: ToastEvent(
          text: 'rename_device_name_too_long'.tr(),
        )),
        confirmCallback: (newName) => _renameDevice(device, newName),
      ));
    }
  }

  Future<void> _renameDevice(BaseDeviceModel device, String name) async {
    try {
      if (name.isEmpty) {
        state = state.copyWith(
            uiEvent: ToastEvent(text: 'rename_device_name_empty'.tr()));
        return;
      }
      final result =
          await ref.read(homeRepositoryProvider).renameDevice(device.did, name);
      if (result) {
        device.customName = name;
      }
      LogModule().eventReport(5, 16, int1: result ? 1 : 0);
      MessageChannel().updateAppWidget(json.encode(device));
      state = state.copyWith(
          currentDevice: device,
          uiEvent: ToastEvent(
              text: result ? 'operate_success'.tr() : 'operate_failed'.tr()));
    } on DreameException catch (e) {
      if (e.code == 10007) {
        state = state.copyWith(
            uiEvent: ToastEvent(text: 'rename_device_name_empty'.tr()));
      } else if (e.code == 30000) {
        state = state.copyWith(
            uiEvent: ToastEvent(text: 'input_has_sensitive_words'.tr()));
      } else {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      }
    } catch (e) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
  }

  /// 刷新消息未读
  void refreshMsgCount() {
    try {
      ref.read(homeRepositoryProvider).getHomeMsgStat().then((value) {
        LogUtils.i(
            '[message] HomeStateNotifier refreshMsgCount: ${value.toJson()}');
        state = state.copyWith(showMsgTips: value.getUnreadCount() > 0);
        if (Platform.isIOS) {
          FlutterAppBadger.updateBadgeCount(value.getUnreadCount() > 0 ? 1 : 0);
        }
      }).catchError((e) {
        debugPrint('refreshMsg error: $e');
      });
    } catch (e) {
      debugPrint('refreshMsg error: $e');
      LogUtils.i('[message] HomeStateNotifier refreshMsgCount error: $e');
    }
  }

  /// 设备分享
  void showShareDialog(
      String title, String deviceName, ShareMessageModel bean) {}

  /// 切换到指定tab
  void jumpToDeviceTab(String did, String model) {
    final device = state.deviceList.firstWhereOrNull((element) =>
        element.did == did && (element.model == model || model == 'dreame'));
    if (device != null) {
      final index = state.deviceList.indexOf(device);
      if (index != -1) {
        state = state.copyWith(
            targetTab: index, currentIndex: index, currentDevice: device);
      }
    }
  }

  void resetTargetTab() {
    state = state.copyWith(targetTab: -1);
  }

  /// 操作是否可用
  /// @return true:可用, false:不可用
  Future<bool> checkLegalAnction() async {
    var isInvalid = await verifyUserIsInvalid();
    if (!isInvalid) {
      state = state.copyWith(
        uiEvent: AlertEvent(
          title: 'set_phone'.tr(),
          content: 'text_phone_binding_desc'.tr(),
          cancelContent: 'cancel'.tr(),
          confirmContent: 'text_goto_binding'.tr(),
          confirmCallback: () {
            state = state.copyWith(
                uiEvent: PushEvent(path: MobileBindPage.routePath));
          },
        ),
      );
    }
    return isInvalid;
  }

  /// 校验用户机器是否非法
  ///
  /// 中国大陆用户,未绑定手机号,且IP非法
  /// @return true:合法, false:非法
  Future<bool> verifyUserIsInvalid() async {
    var country = await LocalModule().getCountryCode();
    if (country.toLowerCase() == 'cn') {
      var user = await AccountModule().getUserInfo();
      var phone = user?.phone ?? '';
      if (phone.isEmpty) {
        var invalidIp = await ref.read(homeRepositoryProvider).checkUserIp();
        return invalidIp;
      }
    }
    return true;
  }

  /// 插件内修改设备名称，成功后回调到flutter
  void updateDeviceName(String did, String deviceName) {
    LogUtils.i('updateDeviceName did: $did, deviceName: $deviceName');
    var device =
        state.deviceList.firstWhereOrNull((element) => element.did == did);
    if (device == null) return;
    device.customName = deviceName;
    state = state.copyWith(currentDevice: device);
  }

  bool isLastPage() {
    return state.deviceList.length == state.currentIndex;
  }

  String getCachedProtocolData(String did) {
    final deviceList = state.deviceList;
    final device = deviceList.firstWhereOrNull((element) => element.did == did);
    if (device != null) {
      return jsonEncode(device.basicProtocolData);
    }
    return '';
  }

  /// 获取设备信息
  /// @param did 设备did
  /// @param model 设备model
  bool? getDeviceByDid(String did, String model) {
    final deviceList = state.deviceList;
    if (deviceList.isEmpty) {
      return null;
    }
    final device = deviceList.firstWhereOrNull((element) => element.did == did);
    if (device != null) {
      return true;
    }
    return false;
  }

  void reset() {
    state = const HomeUiState();
  }
}
