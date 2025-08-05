import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:flutter_plugin/model/account/mall_my_info_res.dart';
import 'package:flutter_plugin/model/account/privacy_res.dart';
import 'package:flutter_plugin/model/account/signup.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/social.dart';
import 'package:flutter_plugin/model/base_response_v2.dart';
import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/model/device_share/mine_share_permission_entity.dart';
import 'package:flutter_plugin/model/home/after_sale_config.dart';
import 'package:flutter_plugin/model/home/message_stat.dart';
import 'package:flutter_plugin/model/home/product_resource_config_model.dart';
import 'package:flutter_plugin/model/home/tab_config.dart';
import 'package:flutter_plugin/model/key_value_model.dart';
import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/model/otc_info.dart';
import 'package:flutter_plugin/model/rn_version_model.dart';
import 'package:flutter_plugin/model/user_mark_model.dart';
import 'package:flutter_plugin/model/ux_plan_model.dart';
import 'package:flutter_plugin/model/voice/ai_sound_model.dart';
import 'package:flutter_plugin/model/voice/alexa/alexa_auth_req.dart';
import 'package:flutter_plugin/ui/page/help_center/model/after_sale_info.dart';
import 'package:flutter_plugin/ui/page/help_center/model/app_faq.dart';
import 'package:flutter_plugin/ui/page/help_center/model/feed_back_upload.dart';
import 'package:flutter_plugin/ui/page/help_center/model/feedback_tag.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product_medias.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_history_box.dart';
import 'package:flutter_plugin/ui/page/main/home_rule_app_model.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient({Dio? dio, String? baseUrl}) {
    dio ??= DMHttpManager().dio;
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  /// tab配置
  @POST('/dreame-user/home/rule/app/list')
  Future<BaseResponse<HomeRuleAppModel>> getHomeRuleAppList(
      @Body() Map<String, dynamic> req);
  
  @GET('/dreame-log/common/log/report')
  Future<BaseResponse<dynamic>> reportChannelData(
    @Query('channel') String channel,
    @Query('tenantId') String tenantId,
    @Query('biz') String biz,
    @Query('visitUrl') String visitUrl,
  );

  /// 设备列表
  @POST('/dreame-user-iot/iotuserbind/device/listV2')
  Future<BaseResponse<DeviceListModel>> getDeviceList(
      @Body() Map<String, dynamic> req);

  /// 删除设备
  @POST('/dreame-user-iot/iotuserbind/device/del')
  Future<BaseResponse<bool>> deleteDevice(@Body() Map<String, String> req);

  /// 首页消息统计
  @GET('/dreame-message-push/v1/message-record/homestat')
  Future<BaseResponse<MessageStat>> getHomeMsgStat(
      @Query('version') String version);

  /// 设备重命名
  @POST('/dreame-user-iot/iotuserbind/device/rename')
  Future<BaseResponse<bool>> renameDevice(@Body() Map<String, String> req);

  /// 获取设备property属性
  @POST('/dreame-iot-com-{host}/device/sendCommand')
  Future<BaseResponse<IotResultData>> updateProperty(
      @Path('host') String host, @Body() IotCommandRequest req);

  @POST('/dreame-iot-com-{host}/device/sendCommand')
  Future<BaseResponse<IotResultData>> sendCommand(
      @Path('host') String host, @Body() Map<String, dynamic> req);

  /// action下发
  @POST('/dreame-iot-com-{host}/device/sendCommand')
  Future<BaseResponse<IotActionData>> sendAction(
      @Path('host') String host, @Body() IotCommandRequest req);

  /// 首页广告列表
  @GET('/dreame-product/public/advertisement/v1/list-by-position')
  Future<BaseResponse<List<ADModel>>> getADList(
      @Query('platform') int platform,
      @Query('position') String position,
      @Query('timeZoneId') String timeZoneId);


  @POST('/dreame-product/aduserswitch')
  Future<BaseResponse<dynamic>> setAduserswitch(@Field() int status);

  @GET('/dreame-product/aduserswitch/get')
  Future<BaseResponse<int>> getAduserswitch();

  @GET('/dreame-product/public/product-resource-config')
  Future<BaseResponse<ProductResourceConfigModel>> getProductResourceConfig(
    @Query('productId') String productId,
    @Query('dictKey') String dictKey,
  );

  /**************************************** 登录注册模块 start ********************************************/

  /// 手机号登录发送验证码接口
  @POST('/dreame-auth/v2/oauth/sms')
  Future<BaseResponse<SmsCodeRes>> getLoginVerificationCode(
      @Body() SmsCodeReq req);

  /// 手机号忘记密码发送验证码接口
  @POST('/dreame-user/v2/forgotpass/sms/code')
  Future<BaseResponse<SmsTrCodeRes>> getRecoverByPhoneVerificationCode(
      @Body() SmsCodeReq req);

  /// 手机号忘记密码发送验证码接口
  @POST('/dreame-user/v2/secure-info/sms/code-new')
  Future<BaseResponse<SmsTrCodeRes>> getSecureByPhoneVerificationCode(
      @Body() SmsCodeReq req);

  /// 解绑手机号获取验证码
  @POST('/dreame-user/v2/phone/unbind/sms/code')
  Future<BaseResponse<SmsTrCodeRes>> unbindGetPhoneVertificationCode(
      @Body() SmsCodeReq req);

  /// 邮箱忘记密码发送验证码接口
  @POST('/dreame-user/v1/forgotpass/email/code')
  Future<BaseResponse<SmsTrCodeRes>> getRecoverByMailVerificationCode(
      @Body() EmailCodeReq req);

  @POST('/dreame-user/v2/secure-info/email/code-new')
  Future<BaseResponse<SmsTrCodeRes>> getSecureByMailVerificationCode(
      @Body() EmailCodeReq req);

  /// 修改密码接口
  @POST('/dreame-user/v1/change-password')
  Future<BaseResponse> changePassword(@Body() ChangePwdCheckReq req);

  /// 设置密码接口
  @POST('/dreame-user/v1/set-password')
  Future<BaseResponse> settingPassword(@Body() SettingPwdCheckReq req);

  /// 解除邮箱绑定
  @POST('/dreame-user/v1/email/unbind')
  Future<BaseResponse> unbindEmail(@Body() UnbindEmailReq req);

  /// 重置邮箱密码
  @POST('/dreame-user/v1/forgotpass/email/code/verification')
  Future<BaseResponse<SmsCodeCheckRes>> checkRecoverByMailVerificationCode(
      @Body() EmailCheckCodeReq req);

  ///邮箱校验安全验证码
  @POST('/dreame-user/v1/secure-info/email/code/verification')
  Future<BaseResponse<SmsCodeCheckRes>> checkSecureByMailVerificationCode(
      @Body() EmailCheckCodeReq req);

  /// 手机校验验证码接口
  @POST('/dreame-user/v1/forgotpass/sms/code/verification')
  Future<BaseResponse<SmsCodeCheckRes>> checkRecoverByPhoneVerificationCode(
      @Body() MobileCheckCodeReq req);

  /// 手机号解绑验证
  @POST('/dreame-user/v1/phone/unbind/sms/code/verification')
  Future<BaseResponse<SmsCodeCheckRes>> checkUnBindPhoneVerificationCode(
      @Body() MobileCheckCodeReq req);

  @POST('/dreame-user/v1/phone/unbind')
  Future<BaseResponse<dynamic>> unBindPhone(@Body() MobileUnbindReq req);

  /// 修改安全信息验证短信验证码 (phone\email)
  @POST('/dreame-user/v1/secure-info/sms/code/verification')
  Future<BaseResponse<SmsCodeCheckRes>> checkSecureByPhoneVerificationCode(
      @Body() MobileCheckCodeReq req);

  /// 修改用户信息(phone、email）
  @PUT('/dreame-user/v1/secure-info-new')
  Future<BaseResponse<UserInfoModel>> fixUserSafeInfoByVerificationCode(
      @Body() FixSafeInfoCodeReq req);

  /// 验证邮箱/手机验证码
  @POST('/dreame-user/v1/secure-info/email/code/verification')
  Future<BaseResponse<dynamic>> checkPhoneOrEmailVerification(
      @Body() EmailCheckCodeReq req);

  /// 邮箱修改密码接口
  @POST('/dreame-user/v1/forgotpass/reset-by-email')
  Future<BaseResponse<SmsCodeCheckRes>> changeRecoverByMailVerificationCode(
      @Body() ResetPswByMailReq req);

  /// 手机修改密码接口
  @POST('/dreame-user/v1/forgotpass/reset-by-sms')
  Future<BaseResponse<SmsCodeCheckRes>> changeRecoverByPhoneVerificationCode(
      @Body() ResetPswByPhoneReq req);

  // checkRecoverByMailVerificationCode

  /// 获取用户信息
  @GET('/dreame-user/v1/info')
  Future<BaseResponse<UserInfoModel>> getUserInfo();

  // 海外邮箱注册获取信息
  @GET('/dreame-user/v1/userext/info')
  Future<BaseResponse<EmailCollectionRes>> getSeaEmailCollectInfo();

  /// 订阅海外邮箱
  @POST('/dreame-user/v1/userext/subscribe')
  Future<BaseResponse<dynamic>> emailCollectionSubscribe(
      @Body() EmailCollectionSubscribeRep req);

  /// 跟新用户信息
  @PUT('/dreame-user/v1/info')
  Future<BaseResponse<UserInfoModel>> putUserInfo(
      @Body() Map<String, dynamic> req);

  /// 上传用户头像
  @POST('/dreame-user/v1/avatar')
  Future<BaseResponse> uploadUserAvator(
      @Header('Content-Type') String contentType, @Body() FormData req);

  /// 更改性别
  @POST('/dreame-user/v1/set-sex')
  Future<BaseResponse> updateSex(@Body() Map<String, int> params);

  /// 更改性别
  @POST('/dreame-user/v1/set-birthday')
  Future<BaseResponse> updateBirthday(@Body() Map<String, int> params);

  // 退出登录用户
  @GET('/dreame-auth/oauth/logout')
  Future<BaseResponseV2> logoutUser();

  // 用户
  @DELETE('/dreame-user/v1/logoff')
  Future<BaseResponse> deleteUser();

  // 获取第三方绑定列表
  @GET('/dreame-user/v1/social/binds')
  Future<BaseResponse<List<SocialInfo>>> getThirdSociaPlatformlBindList();

  // 绑定第三方社交平台
  @POST('/dreame-user/v1/social/bind')
  Future<BaseResponse> bindThirdSocialPlatform(@Body() SocialBindReq req);

  // 解除第三方社交平台绑定
  @POST('/dreame-user/v1/social/unbind')
  Future<BaseResponse> unbindThirdSocialPlatform(@Body() SocialUnBindReq req);

  //******** 商城接口 start********/
  @FormUrlEncoded()
  @POST('https://wxmall.mova-tech.com/main/login/app-login')
  Future<BaseMallResponse<MallLoginRes>> loginForMall(@Body() MallLoginReq req);

  @FormUrlEncoded()
  @POST('https://wxmall.mova-tech.com/main/my/info')
  Future<BaseMallResponse<MallMyInfoRes>> mallMyInfo(@Body() MallMyInfoReq req);

  @FormUrlEncoded()
  @POST('https://wxmall.mova-tech.com/main/home/banner')
  Future<BaseMallResponse<List<MallBannerRes>>> getMallBanner(
      @Body() MallBannerReq req);

  /// 上传openInstall数据
  @FormUrlEncoded() 
  @POST('https://wxmall.mova-tech.com/comm/invited-record')
  Future<BaseMallResponse<dynamic>> uploadRecordParams(
    @Body() MallOpenInstallReq params,
  );

  // 透传数据落库
  @FormUrlEncoded()
  @POST('https://wxmall.mova-tech.com/comm/app-msg')
  Future<BaseMallResponse<dynamic>> putAppMessageWithParams(
    @Body() MallOpenInstallReq params,
  );

  //******** 商城接口 end ********/

  ///
  @FormUrlEncoded()
  @POST('/dreame-auth/oauth/token')
  Future<HttpResponse<OAuthModel>> loginWithPhone(
      @Header('Sms-Key') String codeKey,
      @Header('Sms-Code') String code,
      @Body() Map<String, dynamic> req);

  @FormUrlEncoded()
  @POST('/dreame-auth/oauth/token')
  Future<HttpResponse<OAuthModel>> login(@Body() Map<String, dynamic> req);

  ///
  @FormUrlEncoded()
  @POST('/dreame-auth/oauth/token')
  Future<HttpResponse<OAuthModel>> oneKeySignIn(@Body() OneKeyLoginReq req);

  @FormUrlEncoded()
  @POST('/dreame-auth/oauth/token')
  Future<HttpResponse<OAuthModel>> loginWithPassword(
      @Body() PasswordLoginReq req);

  @FormUrlEncoded()
  @POST('/dreame-auth/oauth/token')
  Future<HttpResponse<OAuthModel>> socialSignIn(@Body() SocialLoginReq req);

  @GET('/dreame-auth/oauth/authCode')
  Future<BaseResponse<String?>> getDiscuzAuthCode(
    @Header('target-client-id') String? clientId,
  );

  @POST('/dreame-auth/v3/oauth/social/autoregisterbind/sms')
  Future<BaseResponse<SmsCodeRes>> autoRegisterBindSms(
      @Body() SmsCodeSocialReq req);

  /// 手机号注册短信验证码发送
  @POST('/dreame-user/v2/register/sms')
  Future<BaseResponse<SmsTrCodeRes>> sendRegisterSmsCode(
      @Body() SmsCodeReq req);

  /// 邮箱注册短信验证码发送（新 2024-03-04）
  @POST('/dreame-user/v2/register/email/code')
  Future<BaseResponse<SmsTrCodeRes>> sendRegisterEmailCode(
      @Body() EmailCodeReq req);

  //第三方邮箱绑定发送验证码
  @POST('/dreame-user/v2/register/email/bind/code')
  Future<BaseResponse<SmsTrCodeRes>> sendSocialBindEmailCode(
      @Body() EmailCodeReq req);

  /// 手机号注册短信验证码发送
  @POST('/dreame-user/v1/register/sms/verification')
  Future<BaseResponse<dynamic>> verifyRegisterSmsCode(
      @Body() MobileCheckCodeReq req);

  /// 邮箱注册短信验证码验证
  @POST('/dreame-user/v2/register/email/verification')
  Future<BaseResponse<dynamic>> verifyRegisterEmailCode(
      @Body() EmailCheckCodeReq req);

  @POST('/dreame-user/v2/register/email/bind/verification')
  Future<BaseResponse<dynamic>> verifySocialEmailCode(
      @Body() EmailCheckCodeReq req);

  /// 手机号注册接口,此接口带了验证验证码的逻辑
  @POST('/dreame-user/v1/register/new-phone')
  Future<BaseResponse<dynamic>> registerByPhoneAndPassword(
      @Body() RegisterByPhonePasswordReq req);

  /// 手机号注册接口，此接口前要验证验证码
  @POST('/dreame-user/v1/register/phone')
  Future<BaseResponse<dynamic>> registerByPhoneAndPassword1(
      @Body() RegisterByPhoneReq req);

  /// 邮箱注册接口，此接口前要验证验证码
  @POST('/dreame-user/v2/register/email')
  Future<BaseResponse<dynamic>> registerByEmailAndPassword1(
      @Body() RegisterByEmailReq req);

  /// 邮箱注册接口
  @POST('/dreame-user/v1/register/email')
  Future<BaseResponse<dynamic>> registerByEmail(@Body() EmailRegisterReq req);

  /// 获取隐私政策配置
  @GET('/dreame-product/public/privacy')
  Future<BaseResponse<PrivacyUpgradeRes>> getPrivacy(
      @Query('version') String version);

  /// 同意隐私政策接口
  @POST('/dreame-user/v1/privacy/agree')
  Future<BaseResponse<dynamic>> agreePrivacy(@Body() Map<String, int> params);

  /// 获取用户信息绑定开关
  @GET('/dreame-user/public/user/bind/switch')
  Future<BaseResponse<bool>> getBindSwitch();

  /**************************************** 登录注册模块 end ******************************************/

  /// 获取rn sdk版本
  @GET('/dreame-product/upgrades/sdk')
  Future<BaseResponse<RNVersionModel>> getRNSDKPlugin(
      @Query('appVer') String appVer, @Query('os') String os);

  /// 获取rn插件版本
  @GET('/dreame-product/upgrades/appplugin')
  Future<BaseResponse<RNVersionModel>> getRNPlugin(@Query('model') String model,
      @Query('appVer') String appVer, @Query('os') String os);

  /// 获取通用插件版本
  @POST('/dreame-product/public/common-plugin')
  Future<BaseResponse<RNVersionModel>> getCommonPlugin(
      @Body() Map<String, String> params);

  /// 会员中心获取信息
  @GET('/dreame-member-center/public/memberinfo/all-info')
  Future<BaseResponse<MemberModel>> getMemberInfo();

  @GET('/dreame-product/public/apps/latest')
  Future<BaseResponse<AppVersionModel>> checkAppVersion(
      @Query('version') int version,
      @Query('os') int os,
      @Query('tenantId') String tenantId,
      @Query('app') String app,
      @Query('abi') int? abi,
      @Query('model') String? model);

  /// 消息中心首页
  @GET('/dreame-message-push/v1/message-record/list')
  Future<BaseResponse<MessageMainModel>> getMessageHomeRecord(
      @Query('version') String version);

  /// 标记所有消息为已读
  @PUT('/dreame-message-push/v1/message-record/mark-allmessages-read')
  Future<BaseResponse<dynamic>> markAllMessageRead();

  @DELETE('/dreame-messaging/user/device-messages')
  Future<BaseResponse<dynamic>> deleteMessages(
      @Queries() Map<String, dynamic> params);

  /// 从分享消息接受或者拒绝分享
  @POST('/dreame-messaging/user/share-messages/{messageId}/ack')
  Future<BaseResponse<dynamic>> ackShareFromMessage(
      @Path('messageId') String messageId, @Body() Map<String, dynamic> params);

  ///从设备列表接受或者拒绝分享
  @POST('/dreame-messaging/user/share-messages/device/ack')
  Future<BaseResponse<dynamic>> ackShareFromDevice(
      @Body() Map<String, dynamic> params);

  @PUT('/dreame-messaging/user/share-messages')
  Future<BaseResponse<dynamic>> readShareMessageByIds(
      @Body() Map<String, dynamic> params);

  /// 获取共享消息列表
  @GET('/dreame-messaging/user/share-messages')
  Future<BaseResponse<ShareMessagePage>> getShareMessageList(
    @Query('limit') int limit,
    @Query('offset') int offset,
    @Query('version') String? version,
  );

  @PUT('/dreame-messaging/user/share-messages')
  Future<BaseResponse<dynamic>> readAllShareMessage();

  @DELETE('/dreame-messaging/user/share-messages')
  Future<BaseResponse<dynamic>> deleteShareMessage(
      @Query('msgIds') String? msgIds);

  @GET('/dreame-messaging/user/device-messages')
  Future<BaseResponse<DeviceMessageModel>> getDeviceMessageList(
      @Query('did') String did,
      @Query('language') String language,
      @Query('offset') int offset,
      @Query('limit') int limit);

  /// 消息查询接口
  /// @param msgCategory 消息类型 ： 系统消息system_msg、订单消息order_msg、会员消息member_msg、活动消息activity_msg
  /// @param currentTimeStamp 秒
  /// @return
  @GET('/dreame-message-push/v1/message-record')
  Future<BaseResponse<CommonMsgRecordRes>> getCommonMessageRecord(
    @Query('msgCategory') String msgCategory,
    @Query('currentTimeStamp') int currentTimeStamp,
    @Query('page') int page,
    @Query('size') int size,
  );

  @PUT('/dreame-message-push/v1/message-record/mark-messages-read')
  Future<BaseResponse<dynamic>> readMessageByCategory(
      @Query('msgCategory') String? msgCategory,
      {@Query('msgIds') String? msgIds});

  /// 消息删除接口
  /// @param msgIds 逗号拼接 111,222,333
  /// @return
  @DELETE('/dreame-message-push/v1/message-record/remove-messages')
  Future<BaseResponse<dynamic>> deleteCommonMessageRecord(
      @Query('msgIds') String msgIds);

  /// 消息删除接口
  /// @param msgCategory 消息类型 ： 系统消息system_msg、订单消息order_msg、会员消息member_msg、活动消息activity_msg
  /// @return
  @DELETE('/dreame-message-push/v1/message-record/remove-all-messages')
  Future<BaseResponse<dynamic>> clearCommonMessageRecord(
      @Query('msgCategory') String msgCategory);

  @PUT('/dreame-messaging/user/device-messages/mark-read-by-deviceid')
  Future<BaseResponse<dynamic>> setMessagesReadByDid(
      @Query('deviceId') String deviceId);

  @POST('/dreame-messaging/user/push/devices/evictKey')
  Future<BaseResponse<dynamic>> removePushToken(
      @Body() Map<String, dynamic> params);

  @POST('/dreame-messaging/user/push/devices/manusave')
  Future<BaseResponse<bool>> registerPushToken(
      @Body() Map<String, dynamic> params);

  /// 查询设备
  /// @param params
  /// @return
  @POST('/dreame-user-iot/iotuserbind/device/info')
  Future<BaseResponse<DeviceModel>> queryDeviceInfoByDid(
      @Body() Map<String, dynamic> params);

  @GET('/dreame-messaging/user/message-settings')
  Future<BaseResponse<MessageSettingModel>> messageSettingGet();

  @PUT('/dreame-messaging/user/message-settings')
  Future<BaseResponse<MessageSettingModel>> messageSettingSet(
      @Body() Map<String, dynamic> model);

  @GET('/dreame-message-push/v1/message-set')
  Future<BaseResponse<MessageGetModel>> messageGet();

  @PUT('/dreame-message-push/v1/message-set')
  Future<BaseResponse<MessageGetModel>> messageSet(
      @Body() Map<String, dynamic> model);

  /// 获取售后配置信息
  @GET('/dreame-user/v1/aftersale')
  Future<BaseResponse<AfterSaleConfig>> getAfterSaleConfig(
      @Query('country') String country);

  @POST('/dreame-user-iot/userExper/query')
  Future<BaseResponse<UXPlanModel>> getUXPlanAuthState();

  @POST('/dreame-user-iot/userExper/set')
  Future<BaseResponse<dynamic>> setUXPlanAuthState(
      @Body() Map<String, dynamic> params);

  @GET('/dreame-messaging/user/switch-settings/query')
  Future<BaseResponse<List<KVModel>>> getUserConfigSetting(
      @Query('keys') String keys);

  @POST('/dreame-messaging/user/switch-settings/saveOrUpdate')
  Future<BaseResponse<dynamic>> setUserConfigSetting(
      @Body() Map<String, dynamic> params);

  @FormUrlEncoded()
  @POST('/dreame-user/overseas/shopping/mall/config')
  Future<BaseResponse<String?>> getOverseasMallConfig(
      @Body() Map<String, dynamic> params);

  @POST('/dreame-system/appCommonUrl/queryUrlByCountryBatch')
  Future<BaseResponse<List<TabConfig>>> getTabConfig(
      @Body() Map<String, dynamic> params);

  @POST('/dreame-user/overseas/shopping/mall/user/shopify')
  Future<BaseResponse<String?>> getShopifyUrl(
      @Body() Map<String, dynamic> params);

  @POST('/dreame-user/v2/register/email/check/code')
  Future<BaseResponse<SmsTrCodeRes>> sendEmailCheckVerificationCode(
      @Body() EmailCodeReq rea);

  @POST('/dreame-user/v2/register/email/check/verification')
  Future<BaseResponse<dynamic>> verificationEmailCheckCode(
      @Body() EmailCheckCodeReq req);

  /// 用户评价
  @POST('/dreame-user-iot/userEvaluate/queryNeedDialog')
  Future<BaseResponse<UserMarkModel>> queryUserMarkStatus();

  /// 更新用户评价
  @POST('/dreame-user-iot/userEvaluate/submit')
  Future<BaseResponse> updateUserMark(@Body() Map<String, dynamic> params);

  /// 获取智能音箱列表
  @GET('/dreame-product/public/smarthomeManual/list')
  Future<BaseResponse<List<AiSoundModel>>> getVoideProductList(
      @Query('lang') String lang,
      @Query('version') String version,
      @Query('os') String os);

  @POST('/dreame-smarthome/aliIot/getAuthCodeV3')
  Future<BaseResponse<String>> getAlifyAuthCode(
      @Body() Map<String, dynamic> params);

  /// ******************配网相关接口 start ********************

  @GET('/dreame-product/public/v1/productCategory')
  Future<BaseResponse<List<KindOfProduct>>> productCategory();

  @GET('/dreame-product/public/products/{productId}/v2/productDesc')
  Future<BaseResponse<HelpCenterProductMedias>> productMediaList(
      @Path('productId') String productId);

  @GET('/dreame-product/public/v1/productCategory/by-pids')
  Future<BaseResponse<List<Product>>> getProductInfoByPids(
      @Query('pids') String pids);

  @GET('/dreame-product/public/v1/productCategory/by-models')
  Future<BaseResponse<List<Product>>> getProductInfoByModels(
      @Query('models') String models);

  @GET('/dreame-product/public/v1/productCategory/checkModel')
  Future<BaseResponse<Product>> checkModel(@Query('model') String model);

  @POST('/dreame-user-iot/iotuserbind/pair')
  Future<BaseResponse<bool>> getDevicePair(@Body() Map<String, dynamic> params);

  @POST('/dreame-user-iot/iotuserbind/pairByNonce')
  Future<BaseResponse<bool>> postDevicePairByNonce(
      @Body() PairNonceRequest req);

  @POST("/dreame-user-iot/iotuserbind/pair4ble")
  Future<BaseResponse<bool>> postDevicePair4Ble(
      @Body() Map<String, dynamic> params);

  /// 获取domain列表
  @GET('/dreame-user-iot/iotmqttdomain/v2/list')
  Future<BaseResponse<PairDomainModel>> getMqttDomainV2(
      @Query('region') String region, @Query('qrCodePair') bool qrCodePair);

  // 获取配网引导
  @GET('/dreame-product/public/products/{productId}/connect-instructions-new')
  Future<BaseResponse<PairGuideWrapper>> getPairGuideList(
      @Path('productId') String productId);

  /// 查询 did 是否已绑定 0:未绑定 1:绑定别人 2:绑定自己
  @POST('/dreame-user-iot/iotuserbind/checkDeviceBind')
  Future<BaseResponse<int>> checkDeviceBind(
      @Body() Map<String, dynamic> params);

  @POST('/dreame-user-iot/iotuserbind/pairQRKey')
  Future<BaseResponse<PairQrCheck>> getDeviceQRPair(
      @Body() Map<String, dynamic> params);

  @POST('/dreame-user-iot/iotstatus/devOTCInfo')
  Future<BaseResponse<OtcInfoRes>> devOTCInfo(
      @Body() Map<String, dynamic> params);

  /********************配网相关接口 end *********************/

  /// 获取用户ip
  @GET('/dreame-auth/countryCode')
  Future<BaseResponse<String>> checkUserIp();

  ///获取帮助中心产品列表
  @GET('/dreame-product/public/v1/productCategory/list')
  Future<BaseResponse<List<HelpCenterProduct>>> getHelpCenterProductList();

  @GET('/dreame-user/v1/aftersale')
  Future<BaseResponse<AfterSaleInfo>> getAfterSale(
      @Query('country') String country);

  @GET('/dreame-product/public/faqs/product')
  Future<BaseResponse<List<AppFaq>>> getHelpCenterProductFaq(
      @Query('lang') String lang, @Query('productId') String? productId);

  @GET('/dreame-product/public/faqs/pdf')
  Future<BaseResponse<String>> getHelpCenterProductPdf(
      @Query('lang') String lang, @Query('model') String? model);

  //上传机器日志
  @POST('/dreame-user-iot/iotuserbind/deviceLogPackage')
  Future<BaseResponse<dynamic>> uploadDeviceLog(
      @Body() Map<String, dynamic> params);

  @GET('/dreame-product/public/advisetag/bycategory')
  Future<BaseResponse<List<FeedBackTag>>> getFeedBackTags(
      @Query('category') String category);

  @POST('/dreame-user/v1/feedback/gen-upload-url?filename={filename}')
  Future<BaseResponse<FeedBackUpload>> getFeedBacUploadUrl(
      @Path('filename') String filename);

  @POST('/dreame-user/v1/feedback')
  Future<BaseResponse<dynamic>> postFeedBack(
      @Body() Map<String, dynamic> params);

  @GET('/dreame-user/v1/feedback')
  Future<BaseResponse<SuggestHistoryBox>> getSuggestList(
      @Query('page') int page,
      @Query('size') int size,
      @Query('adviseType') int adviseType);

  /// ******************设备分享接口 start ********************
  @POST('/dreame-user-iot/iotuserbind/device/listV2')
  Future<BaseResponse<DeviceListModel>> fetchMyDeviceList(
      @Body() Map<String, dynamic> req);

  @POST('/dreame-user-iot/iotuserbind/device/sharedUserList')
  Future<BaseResponse<List<MineRecentUser>>> fetchSharedUserList(
      @Body() Map<String, dynamic> params);

  @GET('/dreame-user/v1/contacts')
  Future<BaseResponse<List<MineRecentUser>>> fetchRecentUserList(
      @Query('size') int size);

  @GET('/dreame-user/v1/query')
  Future<BaseResponse<List<MineRecentUser>>> fetchSearchedUserList(
      @Query('keyword') String text);

  @POST('/dreame-user-iot/iotuserbind/device/shareCheck')
  Future<BaseResponse<bool>> checkDeviceShareStatus(
      @Body() Map<String, dynamic> params);

  @POST('/dreame-user-iot/iotuserbind/device/shareWithPermissions')
  Future<BaseResponse<bool>> toShareDevice(
    @Body() Map<String, dynamic> params,
  );

  @POST('/dreame-user-iot/iotuserbind/device/delShared')
  Future<BaseResponse<bool>> cancelShareDevice(
    @Body() Map<String, dynamic> params,
  );

  @POST('/dreame-user/v1/contacts/{uid}')
  Future<BaseResponse<bool>> addRecentContact(
    @Path('uid') String uid,
  );

  @POST('/dreame-user-iot/iotuserbind/devicePermit')
  Future<BaseResponse<bool>> editSharedPermit(
    @Body() Map<String, dynamic> params,
  );

  @GET('/dreame-product/public/products/{productId}/permitInfo')
  Future<BaseResponse<List<MineSharePermissionEntity>>> devicePermissionInfo(
    @Path('productId') String productId,
  );

  ///获取帮助中心产品列表
  @GET('/dreame-product/public/products/{productId}/productDesc')
  Future<BaseResponse<String>> productContent(
    @Path('productId') String productId,
  );

  @POST('/dreame-user-iot/iotuserbind/queryDevicePermit')
  Future<BaseResponse<String>> queryDevicePermit(
    @Body() Map<String, dynamic> params,
  );

  @POST(
      'https://eu.iot.mova-tech.com:13267/dreame-smarthome/alexaApp2App/skillAuthorizeCode')
  Future<BaseResponse<AlexaBindAuthRes>> skillAuthorizeCode(
    @Body() AlexaBindAuthReq req,
  );

  ///********************设备分享接口 end *********************
}
