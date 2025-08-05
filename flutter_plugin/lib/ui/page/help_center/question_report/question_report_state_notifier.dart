import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/help_center/model/question_report_item.dart';
import 'package:flutter_plugin/ui/page/help_center/question_report/question_report_ui_state.dart';
import 'package:flutter_plugin/ui/page/home/home_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'question_report_state_notifier.g.dart';

@riverpod
class QuestionReportStateNotifier extends _$QuestionReportStateNotifier {
  @override
  QuestionReportUiState build() {
    return const QuestionReportUiState();
  }

  void loadData() {
    ref.read(homeRepositoryProvider).getDeviceList().then((value) {
      updateRecord(value.page.records);
    });
  }

  Future<void> updateRecord(List<DeviceModel> list) async {
    UserInfoModel? userInfo = await AccountModule().getUserInfo();
    List<QuestionReportItem> reports = list.map((e) {
      String title = e.getShowName();
      bool showShareTag = e.masterUid != userInfo?.uid;
      bool isCheck = false;
      QuestionReportItem item = QuestionReportItem(
        title: title,
        showShareTag: showShareTag,
        isCheck: isCheck,
        did: e.did,
        model: e.model,
      );
      return item;
    }).toList();
    reports.firstOrNull?.isCheck = true;

    bool isCheckDevice = reports.any((element) => element.isCheck);

    state = state.copyWith(
        reports: reports,
        submitEnable: isCheckDevice || state.appFeedbackIsCheck);
  }

  void onCheckAppreport() {
    bool isCheckDevice = state.reports.any((element) => element.isCheck);
    bool isCheckAppFeedback = !state.appFeedbackIsCheck;
    state = state.copyWith(
        appFeedbackIsCheck: isCheckAppFeedback,
        submitEnable: isCheckDevice || isCheckAppFeedback);
  }

  void onCheckItem(int index) {
    List<QuestionReportItem> reports = state.reports;
    List<QuestionReportItem> _reports = [];
    for (int i = 0; i < reports.length; i++) {
      QuestionReportItem item = reports[i];
      QuestionReportItem newItem = QuestionReportItem(
        title: item.title,
        showShareTag: item.showShareTag,
        isCheck: item.isCheck,
        did: item.did,
        model: item.model,
      );
      if (i == index) {
        newItem.isCheck = !newItem.isCheck;
      }
      _reports.add(newItem);
    }

    bool isCheckDevice = _reports.any((element) => element.isCheck);

    state = state.copyWith(
        reports: _reports,
        submitEnable: isCheckDevice || state.appFeedbackIsCheck);
  }

  Future<void> updateLog() async {
    try {
      SmartDialog.showLoading();
      await _reportDeviceLog();
      await LogModule().uploadLog('');
      SmartDialog.dismiss();
      state = state.copyWith(
          event: ToastEvent(text: 'text_bug_report_success'.tr()));
    } catch (e) {
      LogUtils.e('updateLog error: $e');
      SmartDialog.dismiss();
      state = state.copyWith(
          event: ToastEvent(text: 'text_bug_report_failed'.tr()));
    }
  }

  Future<void> _reportDeviceLog() async {
    for (QuestionReportItem item in state.reports) {
      if (item.isCheck) {
        await ref
            .read(helpCenterRepositoryProvider)
            .uploadDeviceLog(did: item.did, model: item.model);
      }
    }
  }
}
