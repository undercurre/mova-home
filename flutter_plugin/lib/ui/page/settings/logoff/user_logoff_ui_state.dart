
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_logoff_ui_state.freezed.dart';

@freezed
class DeleteAccountUiState with _$DeleteAccountUiState{
  factory DeleteAccountUiState({
    @Default(false) bool enableBindButton,   
    @Default('') String tipStr,                      //绑定    
  }) = _DeleteAccountUiState;
}