import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_helper.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:lifecycle/lifecycle.dart';

mixin SmartStepLifecycleMixin on BasePageState {
  @override
  void onAppPaused() {
    super.onAppPaused();
    LogUtils.i(' sunzhibin iotScanDeviceMixin onAppPaused $this');
  }

  @override
  void onAppResumeAndActive() {
    super.onAppResumeAndActive();
    LogUtils.i(' sunzhibin iotScanDeviceMixin onAppResume $this');
    SmartStepHelper().onAppResume();
  }

  @override
  void onBecomeActive() {
    super.onBecomeActive();
    LogUtils.i(' sunzhibin iotScanDeviceMixin onBecomeActive $this');
    SmartStepHelper().onAppResume();
  }
  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);
    SmartStepHelper().onLifecycleEvent(event);
  }

  @override
  void dispose() {
    super.dispose();
    SmartStepHelper().dispose();
  }
}
