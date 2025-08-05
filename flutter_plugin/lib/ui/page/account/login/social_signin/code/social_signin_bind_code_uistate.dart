import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_signin_bind_code_uistate.freezed.dart';

@freezed
class SocialSignInBindCodeUiState with _$SocialSignInBindCodeUiState {
  const factory SocialSignInBindCodeUiState(
      {@Default(false) bool isLoading,
      @Default(false) bool isInputInvalid,
      required RegionItem currentRegion,
      required RegionItem currentPhone,
      @Default(60) int interval,
      String? account,
      String? codeKey,
      String? code,
      String? socialUUid,
      String? source}) = _SocialSignInBindCodeUiState;
}

class SocialSignInBindCodeUiEvent {}

class BindCoverDialog extends SocialSignInBindCodeUiEvent {
  final String msg;

  BindCoverDialog({required this.msg});
}

class ShowAccountLocked extends SocialSignInBindCodeUiEvent {}

class ToastShow extends SocialSignInBindCodeUiEvent {
  final String msg;

  ToastShow({required this.msg});
}
