import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_page.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/help_center/model/feedback_tag.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_report_media.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_report_param.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest/product_suggest_ui_state.dart';
import 'package:flutter_plugin/ui/page/home/home_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'product_suggest_state_notifier.g.dart';

@riverpod
class ProductSuggestStateNotifier extends _$ProductSuggestStateNotifier {
  List<SuggestReportMedia> medias = [];
  String? content;
  String? contact;

  @override
  ProductSuggestUiState build() {
    return const ProductSuggestUiState();
  }

  void showConfirmAlert(CommonUIEvent event) {
    state = state.copyWith(event: event);
  }

  void initData() async {
    // 中国地区默认不展示选择， 直接上传，
    final countryCode = await LocalModule().getCountryCode();
    if (countryCode == "cn") {
      state = state.copyWith(enableUploadLog: true, visibleUploadLog: false);
    } else {
      state = state.copyWith(enableUploadLog: false, visibleUploadLog: true);
    }
  }

  Future<void> loadData(String? did) async {
    updateMedias();
    try {
      List<DeviceModel> list =
          (await ref.read(homeRepositoryProvider).getDeviceList()).page.records;
      DeviceModel? selectDevice;
      int result = list.indexWhere((element) => element.did == did);

      if (result < 0) {
        result = list.isNotEmpty ? 0 : -1;
      }

      if (result >= 0) {
        selectDevice = list[result];
      }
      List<FeedBackTag> tags =
          await loadTag(selectDevice?.deviceInfo?.categoryPath);
      state = state.copyWith(
        deviceList: list,
        selectedDevice: selectDevice,
        selectIndex: result >= 0 ? result : null,
        tags: tags,
        showTags: tags.isNotEmpty,
      );
    } catch (e) {
      rethrow;
    }
  }

  void selectIndex(int selectIndex) {
    DeviceModel selectDevice = state.deviceList[selectIndex];
    state = state.copyWith(
      selectedDevice: selectDevice,
      selectIndex: selectIndex,
    );
  }

  Future<List<FeedBackTag>> loadTag(String? category) async {
    String appCategory = 'App';
    if (category != null && category.isNotEmpty) {
      appCategory = category;
    }
    return await ref
        .read(helpCenterRepositoryProvider)
        .getFeedBackTags(category: appCategory);
  }

  void selectTag(FeedBackTag tag) {
    List<FeedBackTag> fixTags = [];
    for (FeedBackTag e in state.tags) {
      bool isSelected = e.tagId == tag.tagId ? !e.isSelected : e.isSelected;
      fixTags.add(e.copyWith(isSelected: isSelected));
    }
    state = state.copyWith(tags: fixTags);
  }

  void addVideos(List<AssetEntity> files) {
    for (AssetEntity file in files) {
      SuggestReportMedia media = SuggestReportMedia.from(file: file);
      medias.add(media);
      updateMedias();
    }
  }

  void updateMedias() {
    List<SuggestReportMedia> fixmedias = medias.toList();
    if (fixmedias.length < 4) {
      fixmedias.add(SuggestReportMedia(type: SuggestReportMediaType.add));
    }
    state = state.copyWith(medias: fixmedias);
  }

  void removeMedia(SuggestReportMedia media) {
    medias.remove(media);
    updateMedias();
  }

  void onContentChange(String content) {
    this.content = content;
    String number = '${content.length}/500';
    state = state.copyWith(contentNumber: number);
  }

  void onContactChange(String contact) {
    this.contact = contact;
  }

  Future<void> submit() async {
    if (content == null || content!.isEmpty) {
      state = state.copyWith(
          event: ToastEvent(text: 'text_please_input_your_suggestion'.tr()));
      return;
    }

    state = state.copyWith(event: const LoadingEvent(isLoading: true));
    try {
      List<String> imageUrls = [];
      List<String> videoUrls = [];
      for (SuggestReportMedia e in medias) {
        final url =
            await ref.read(helpCenterRepositoryProvider).uploadFeedBack(e);
        if (e.type == SuggestReportMediaType.image) {
          imageUrls.add(url);
        } else if (e.type == SuggestReportMediaType.video) {
          videoUrls.add(url);
        }
      }
      final packageInfo = await PackageInfo.fromPlatform();
      String tags = '';
      for (FeedBackTag tag in state.tags) {
        if (tag.isSelected) {
          tags += '${tag.tagId},';
        }
      }

      SuggestReportParam params = SuggestReportParam(
        appVersion: packageInfo.buildNumber,
        appVersionName: packageInfo.version,
        os: Platform.isIOS ? 0 : 1,
        type: 0,
        content: content,
        contact: contact,
        adviseType: 1,
        adviseTagIds: tags.isEmpty ? null : tags.substring(0, tags.length - 1),
        images: imageUrls.isEmpty ? null : imageUrls,
        videos: videoUrls.isEmpty ? null : videoUrls,
      );
      if (state.selectedDevice != null) {
        params = params.copyWith(
          did: state.selectedDevice!.did,
          model: state.selectedDevice!.model,
          type: 1,
        );
      }

      await ref.read(helpCenterRepositoryProvider).submitFeedBack(params);
      if (state.enableUploadLog) {
        /// 上传日志
        await LogModule().uploadLog('');
      }
      state = state.copyWith(event: const LoadingEvent(isLoading: false));

      state = state.copyWith(
          event: AlertConfirmEvent(
        title: 'text_suggestion_submit_success_title'.tr(),
        content: 'text_suggestion_submit_success_content'.tr(),
        confirmContent: 'know'.tr(),
        confirmCallback: () {
          state = state.copyWith(
              event: PushEvent(
            func: RouterFunc.pop,
          ));
        },
      ));
    } catch (e) {
      state = state.copyWith(event: const LoadingEvent(isLoading: false));
      if (e is DreameException && e.code == 3000) {
        state = state.copyWith(
            event: ToastEvent(text: 'input_has_sensitive_words'.tr()));
      } else {
        state = state.copyWith(event: ToastEvent(text: 'operate_failed'.tr()));
      }
      rethrow;
    }
  }

  void pushToChat() {
    state = state.copyWith(
      event: PushEvent(
        path: HelpCenterPage.routePath,
        func: RouterFunc.go,
      ),
    );
  }

  void toggleEnableUploadLogBtn() {
    state = state.copyWith(
      enableUploadLog: !state.enableUploadLog,
    );
  }
}
