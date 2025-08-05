import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'password_login_uistate.freezed.dart';
// part 'password_login_uistate.g.dart';

@freezed
class PasswordLoginUiState with _$PasswordLoginUiState {
  const factory PasswordLoginUiState({
    RegionItem? currentItem,
    @Default(null) String? initAccount,
    @Default(null) String? initPassword,
    @Default(true) bool hidePassword,
    @Default(false) bool submitEnable,
    @Default(false) bool agreed,
    @Default(false) bool prepared,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _PasswordLoginUiState;
}
