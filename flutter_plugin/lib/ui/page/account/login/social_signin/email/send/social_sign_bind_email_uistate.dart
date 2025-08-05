import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_sign_bind_email_uistate.freezed.dart';

@freezed
class SocailSignBindEmailUiState with _$SocailSignBindEmailUiState {
  const factory SocailSignBindEmailUiState({
    @Default(false) bool enableSend,
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(false) bool showSkip,
  }) = _SocailSignBindEmailUiState;
}
