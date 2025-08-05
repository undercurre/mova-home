import 'dart:convert';

import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/model/rn_debug_packages.dart';
import 'package:flutter_plugin/ui/page/developer/developer_mode_page_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'developer_mode_page_state_notifier.g.dart';

@riverpod
class DeveloperModePageStateNotifier extends _$DeveloperModePageStateNotifier {
  static String RN_DEBUG_MODELS = 'rnDebugModels';

  @override
  Future<DeveloperModePageUIState> build() async {
    RNDebugPackages rnDebugPackages = await getProjects();
    return DeveloperModePageUIState(rnDebugPackages: rnDebugPackages);
  }

  Future<void> initData() async {
    try {
      RNDebugPackages rnDebugPackages = await getProjects();
      state = AsyncValue<DeveloperModePageUIState>.data(
          DeveloperModePageUIState(rnDebugPackages: rnDebugPackages));
    } catch (error) {
      LogUtils.e(error);
    }
  }

  void updateHost(String ip) {
    state.when(
        data: (data) {
          RNDebugPackages rnDebugPackages =
              data.rnDebugPackages ?? RNDebugPackages();
          rnDebugPackages.ip = ip;
          state = AsyncValue<DeveloperModePageUIState>.data(
              DeveloperModePageUIState(rnDebugPackages: rnDebugPackages));
        },
        error: (error, stackTrace) {},
        loading: () {});
  }

  void updateEnable() {
    state.when(
        data: (data) async {
          RNDebugPackages rnDebugPackages =
              data.rnDebugPackages ?? RNDebugPackages();
          rnDebugPackages.enable = !rnDebugPackages.enable;
          state = AsyncValue<DeveloperModePageUIState>.data(
              DeveloperModePageUIState(rnDebugPackages: rnDebugPackages));
          await LocalStorage().putString(
              RN_DEBUG_MODELS, json.encode(rnDebugPackages.toJson()));
        },
        error: (error, stackTrace) {},
        loading: () {});
  }

  void updateProjects(Projects project,
      {int index = -1, bool enableChanged = false}) {
    state.when(
        data: (data) async {
          RNDebugPackages rnDebugPackages =
              data.rnDebugPackages ?? RNDebugPackages();
          List<Projects> projects = rnDebugPackages.projects ?? [];
          if (index == -1) {
            projects.add(project);
          } else {
            projects[index] = project;
          }
          rnDebugPackages.projects = projects;
          state = AsyncValue<DeveloperModePageUIState>.data(
              DeveloperModePageUIState(rnDebugPackages: rnDebugPackages));
          if (enableChanged) {
            await LocalStorage().putString(
                RN_DEBUG_MODELS, json.encode(rnDebugPackages.toJson()));
          }
        },
        error: (error, stackTrace) {},
        loading: () {});
  }

  void updateDeveloperInfoFromQRCode(List list, ip) {
    if (list.isEmpty) {
      return;
    }
    state.when(
        data: (data) {
          RNDebugPackages rnDebugPackages =
              data.rnDebugPackages ?? RNDebugPackages();
          List<Projects> projects = rnDebugPackages.projects ?? [];
          List<Projects> newProjects = [];
          for (var packageName in list) {
            Projects project = projects.firstWhere(
                (element) => element.packageName == packageName,
                orElse: () => Projects());
            if (project.model == null && project.packageName == null) {
              newProjects.add(Projects(
                  packageName: packageName, model: '', selected: false));
            } else {
              newProjects.add(project);
            }
          }
          rnDebugPackages.projects = newProjects;
          rnDebugPackages.ip = ip;
          state = AsyncValue<DeveloperModePageUIState>.data(
              DeveloperModePageUIState(rnDebugPackages: rnDebugPackages));
        },
        error: (error, stackTrace) {},
        loading: () {});
  }

  Future<RNDebugPackages> getProjects() async {
    String rnDebugModels =
        await LocalStorage().getString(RN_DEBUG_MODELS) ?? '';
    if (rnDebugModels.isEmpty) {
      return RNDebugPackages();
    }
    RNDebugPackages rnDebugPackageModel =
        RNDebugPackages.fromJson(json.decode(rnDebugModels));
    return rnDebugPackageModel;
  }

  void deleteModel(int index) {
    state.when(
        data: (data) async {
          RNDebugPackages rnDebugPackages =
              data.rnDebugPackages ?? RNDebugPackages();
          List<Projects> projects = rnDebugPackages.projects ?? [];
          projects.removeAt(index);
          rnDebugPackages.projects = projects;
          state = AsyncValue<DeveloperModePageUIState>.data(
              DeveloperModePageUIState(rnDebugPackages: rnDebugPackages));
          await LocalStorage().putString(
              RN_DEBUG_MODELS, json.encode(rnDebugPackages.toJson()));
        },
        error: (error, stackTrace) {},
        loading: () {});
  }

  void saveModels({String ip = ''}) {
    state.when(
        data: (data) async {
          RNDebugPackages rnDebugPackages =
              data.rnDebugPackages ?? RNDebugPackages();
          if (ip.isNotEmpty) {
            rnDebugPackages.ip = ip;
          }
          LogUtils.d(rnDebugPackages);
          await LocalStorage().putString(
              RN_DEBUG_MODELS, json.encode(rnDebugPackages.toJson()));
        },
        error: (error, stackTrace) {},
        loading: () {});
  }
}
