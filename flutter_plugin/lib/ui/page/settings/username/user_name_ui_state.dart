import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_name_ui_state.freezed.dart';

@freezed
class UserNameUiState with _$UserNameUiState {
  factory UserNameUiState({
    @Default(false) bool enableSaveButton, //修改
    @Default('') String userName, //@Default('') String name,
    @Default(false) bool dataPrepared,
  }) = _UserNameUiState;
}
