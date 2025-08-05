import 'dart:convert';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/voice/ai_sound_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/voice/detail/voice_detail_page.dart';
import 'package:flutter_plugin/ui/page/voice/voice_control_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'voice_control_state_notifier.g.dart';

const JSON_FILE_FOLDER = 'dreame_resource';

@riverpod
class VoiceControlStateNotifier extends _$VoiceControlStateNotifier {
  @override
  VoiceControlUiState build() {
    return VoiceControlUiState();
  }

  void init() {
    final countryCode = RegionStore().currentRegion.countryCode;
    if (countryCode.toLowerCase() != 'cn') {
      state = state.copyWith(isForeign: true);
    }

    _getData();
  }

  Future<void> _getData() async {
    try {
      final lang = await LocalModule().getLangTag();
      String json = '';
      try {
        final response = await DMHttpManager().dio.get<String>(
            'https://oss.iot.dreame.tech/pub/$JSON_FILE_FOLDER/ai_sound_tmall.json?${DateTime.now().microsecondsSinceEpoch}');
        if (response.statusCode == 200 && response.data?.isNotEmpty == true) {
          // 防止不是json格式错误，下面json不为空，不会读取本地json
          jsonDecode(response.data!);
          json = response.data!;
        }
      } catch (error) {
        LogUtils.e('Error fetching remote JSON: $error');
      }
      if (json.isEmpty) {
        json =
            await rootBundle.loadString('assets/resource/ai_sound_tmall.json');
      }
      Map<String, dynamic> jsonData = jsonDecode(json);
      List<String> whiteList = (jsonData['models'] as List<dynamic>)
          .map((e) => e.toString().toLowerCase())
          .toList();
      List<String> userDevice = ref
          .read(homeStateNotifierProvider)
          .deviceList
          .map((e) => e.model.toLowerCase())
          .toList();
      bool showTmall = false;
      for (var element in userDevice) {
        for (var white in whiteList) {
          if (element.contains(white)) {
            showTmall = true;
            break;
          }
        }
      }
      await ref
          .read(apiClientProvider)
          .getVoideProductList(
              lang, 'v2', Platform.isAndroid ? 'android' : 'ios')
          .then((resp) {
        if (resp.successed()) {
          List<AiSoundModel> data = resp.data ?? [];
          data = data.where((element) {
            if (element.ios?.packageName == '1158753204' ||
                element.android?.packageName == 'com.alibaba.ailabs.tg') {
              return showTmall;
            }
            return true;
          }).toList();
          state = state.copyWith(
            soundList: data,
          );
        }
      });
    } catch (e) {
      LogUtils.e('VoiceControlStateNotifier _getData error: $e');
    }
  }

  void onItemClick(AiSoundModel item) {
    final name = item.name.toLowerCase();
    if (name.contains('alexa')) {
      final linkUrl = base64Encode(utf8.encode(item.linkUrl));
      if (Platform.isAndroid) {
        UIModule()
            .openPage('/app/voiceControlAlexa?link=$linkUrl&name=${item.name}');
      } else {
        UIModule().openPage(
            '/app/voiceControlAlexa?link=${item.linkUrl}&name=${item.name}');
      }
    } else if (name == 'siri') {
      UIModule().openPage('/app/voiceControlSiri?name=${item.name}');
    } else {
      state = state.copyWith(
          uiEvent: PushEvent(path: VoiceDetailPage.routePath, extra: item));
    }
  }
}
