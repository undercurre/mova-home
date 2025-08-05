import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'account_setting_ui_state.freezed.dart';

@freezed
class AccountSettingUiState with _$AccountSettingUiState {
  factory AccountSettingUiState({
    UserInfoModel? userInfo,
    String? regin, //@Default('') String name,
    @Default(EmptyEvent()) CommonUIEvent uiEvent,
  }) = _AccountSettingUiState;
}
