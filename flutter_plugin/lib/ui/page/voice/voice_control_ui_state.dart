import 'package:flutter_plugin/model/voice/ai_sound_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'voice_control_ui_state.freezed.dart';

@freezed
class VoiceControlUiState with _$VoiceControlUiState {
  factory VoiceControlUiState({
    @Default([]) List<AiSoundModel> soundList,
    @Default(false) bool isForeign,
    CommonUIEvent? uiEvent,
  }) = _VoiceControlUiState;
}
