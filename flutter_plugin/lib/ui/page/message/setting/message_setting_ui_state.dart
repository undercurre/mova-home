import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_setting_ui_state.freezed.dart';

@freezed
class MessageSettingUiState with _$MessageSettingUiState {
  const factory MessageSettingUiState(
      {MessageSettingModel? currentModel,
      ServiceSetingModel? systemMessage,
      ServiceSetingModel? shareMessage,
      ServiceSetingModel? serviceMessage,
      @Default([]) List<DeviceItemModel> devieList,
      CommonUIEvent? uiEvent}) = _MessageSettingUiState;
}
