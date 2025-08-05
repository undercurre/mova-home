import 'package:flutter_plugin/model/voice/ai_sound_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alexa_auth_ui_state.freezed.dart';

@freezed
class AlexaAuthUiState with _$AlexaAuthUiState {
  factory AlexaAuthUiState({
    String? clientId,
    String? responseType,
    String? state,
    String? scope,
    String? redirectUri,
    CommonUIEvent? uiEvent,
  }) = _AlexaAuthUiState;
}
