import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_signin_bind_uistate.freezed.dart';

@freezed
class SocialSignInBindUiState with _$SocialSignInBindUiState {
  const factory SocialSignInBindUiState({
    @Default(false) bool isInputPhoneNumber,
    @Default(false) bool isMobileOnly,
    @Default(false) bool isButtonEnable,
    @Default(true) bool hidePassword,
    @Default(false) bool showSkip,
    required RegionItem currentRegion,
    required RegionItem currentPhone,
    String? account,
    String? password,
    String? codeKey,
    String? socialUUid,
    String? source,
  }) = _SocialSignInBindUiState;
}

sealed class SocialSignInBindUiEvent {}

class DefaultEvent extends SocialSignInBindUiEvent {}

class Success extends SocialSignInBindUiEvent {
  final OAuthModel oAuthRes;

  Success({required this.oAuthRes});
}

class BindCoverDialog extends SocialSignInBindUiEvent {
  final String msg;

  BindCoverDialog({required this.msg});
}

class ToastShow extends SocialSignInBindUiEvent {
  final String msg;

  ToastShow({required this.msg});
}

class ShowAccountLocked extends SocialSignInBindUiEvent {}
