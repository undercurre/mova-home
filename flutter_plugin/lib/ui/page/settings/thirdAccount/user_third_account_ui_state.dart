import 'package:flutter_plugin/model/account/social.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/widget/account/social/model/social_userinfo_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_third_account_ui_state.freezed.dart';

@freezed
class UserThirdAccountUiState with _$UserThirdAccountUiState {
  factory UserThirdAccountUiState({
    @Default(false) bool bindApple, // apple 绑定状态
    @Default(false) bool bindWeChat, // 微信  绑定状态
    @Default(false) bool bindGoogle, // google  绑定状态
    @Default(false) bool bindFacebook, // facebook  绑定状态

    @Default(false) bool showApple, // apple 展示状态
    @Default(false) bool showWeChat, // 微信 展示状态
    @Default(false) bool showGoogle, // google 展示状态
    @Default(false) bool showFacebook, // facebook 展示状态
    @Default([]) List<SocialInfo> platformList,

    // 临时变量（用于强制绑定）
    dynamic token,
    @Default(SocialPlatformType.none) SocialPlatformType platform, //平台ID
    @Default('') String platformName, //平台名称

    @Default(false) bool isChina, //是国内还是海外
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _UserThirdAccountUiState;
}
