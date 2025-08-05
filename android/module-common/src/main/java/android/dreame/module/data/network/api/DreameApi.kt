package android.dreame.module.data.network.api

import android.dreame.module.bean.*
import android.dreame.module.data.entry.*
import android.dreame.module.data.entry.device.*
import android.dreame.module.data.entry.help.AfterSaleInfoRes
import android.dreame.module.data.entry.help.HelpCenterProductItemRes
import android.dreame.module.data.entry.help.HelpDeviceModel
import android.dreame.module.data.entry.help.HistoryCountRes
import android.dreame.module.data.entry.help.ProductFaqRes
import android.dreame.module.data.entry.help.SuggestionTagRes
import android.dreame.module.data.entry.log.AppLogReq
import android.dreame.module.data.entry.message.*
import android.dreame.module.data.entry.monitor.*
import android.dreame.module.data.entry.product.OpenDeviceInfo
import android.dreame.module.data.entry.product.ProductInstructionRes
import android.dreame.module.data.network.HttpResult
import android.dreame.module.dto.IoTActionReq
import android.dreame.module.dto.IoTBaseReq
import android.dreame.module.dto.IoTPropertyReq
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import okhttp3.MultipartBody
import retrofit2.Call
import retrofit2.Response
import retrofit2.http.*

/**
 * <pre>
 *     author : wufei
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/07/29
 *     desc   :http api service
 *     version: 1.0
 * </pre>
 */
interface DreameApi {
    @FormUrlEncoded
    @POST("/dreame-auth/oauth/token")
    fun refreshAccessToken(
        @Header("Tenant-Id") telentId: String,
        @FieldMap params: Map<String, String>
    ): Call<OAuthBean?>

    /**
     * 获取个人信息
     */
    @GET("/dreame-user/v1/info")
    suspend fun getUserInfo(): HttpResult<UserInfo>

    @GET("/dreame-auth/countryCode")
    suspend fun getCountryCode(): HttpResult<String>

    /************************************************************************************************************/
    /**
     * 配网过程，第三步 绑定
     */
    @POST("/dreame-user-iot/iotuserbind/pair")
    suspend fun getDevicePair(@Body req: DevicePairReq): HttpResult<Boolean>

    @POST("/dreame-user-iot/iotuserbind/pair4ble")
    suspend fun getDevicePair4Ble(@Body req: DeviceBlePairReq): HttpResult<Boolean>

    @POST("/dreame-user-iot/iotuserbind/pairByNonce")
    suspend fun getDevicePairByNonce(@Body req: DeviceBlePairNonceReq): HttpResult<Boolean>

    /**
     * 配网过程，第三步 绑定 with pairCode
     */
    @Deprecated(message = "not use in projects")
    @POST("/dreame-user-iot/iotuserbind/pairCode")
    suspend fun getDevicePairWithPairCode(@Body req: DevicePairCodeReq): HttpResult<Boolean>

    @POST("/dreame-user-iot/iotuserbind/pairQRKey")
    suspend fun getDeviceQRNetPairResult(@Body req: DeviceQRNetPairReq): HttpResult<DeviceQRNetPairRes>

    /**
     * 配网过程，第四步 在线
     */
    @POST("/dreame-iot-com-{host}/device/sendCommand")
    suspend fun trySendCommand(
        @Path("host") host: String,
        @Body req: IoTBaseReq<IoTPropertyReq>,
    ): HttpResult<JsonElement>

    @POST("/dreame-iot-com-{host}/device/sendCommand")
    suspend fun trySendActionCommand(
        @Path("host") host: String,
        @Body req: IoTBaseReq<IoTActionReq>,
    ): HttpResult<IoTActionResult>

    @POST("/dreame-iot-com-{host}/device/sendCommand")
    suspend fun sendAction(
        @Path("host") host: String,
        @Body req: IoTBaseReq<IoTActionReq>,
    ): HttpResult<IoTActionResult>

    /**
     * 设置密码
     */
    @POST("/dreame-user/v1/set-password")
    suspend fun settingPassword(@Body req: SettingPassword): HttpResult<Boolean>

    /**
     * 修改密码
     */
    @POST("/dreame-user/v1/change-password")
    suspend fun modifyPassword(@Body req: ModifyPassword): HttpResult<Boolean>

    /**
     * 获取domain列表
     */
    @Deprecated(
        message = "Deprecated use getMqttDomainV2",
        replaceWith = ReplaceWith(expression = "this.getMqttDomainV2")
    )
    @GET("/dreame-user-iot/iotmqttdomain/list")
    suspend fun getDomain(@Query("region") region: String): HttpResult<String>

    /**
     * 获取domain列表
     */
    @GET("/dreame-user-iot/iotmqttdomain/v2/list")
    suspend fun getMqttDomainV2(
        @Query("region") region: String,
        @Query("qrCodePair") qrCodePair: Boolean
    ): HttpResult<DomainRes>

    /**
     * 获取Alexa绑定状态和url
     */
    @POST("/dreame-smarthome/alexaApp2App/getUrl")
    suspend fun getAlexaApp2AppUrl(@Body alexaApp2AppReq: AlexaApp2AppReq): HttpResult<AlexaApp2AppRes>

    /**
     * 绑定Alexa 技能
     */
    @POST("dreame-smarthome/alexaApp2App/skillAccountLink")
    suspend fun alexaSkillAccountLink(@Body alexaLinkAuthReq: AlexaLinkAuthReq): HttpResult<Boolean>

    @POST("dreame-smarthome/alexaApp2App/disableSkillAccountLink")
    suspend fun unbindAlexaAccountLink(): HttpResult<Boolean>

    @POST("dreame-smarthome/alexaApp2App/skillAuthorizeCode")
    suspend fun skillAuthorizeCode(@Body req: AlexaBindAuthReq): HttpResult<AlexaBindAuthRes>

    @POST("/dreame-user-iot/iotuserbind/device/listV2")
    suspend fun getDeviceList(@Body deviceListReq: DeviceListReq): HttpResult<DeviceListRes>

    @POST("/dreame-user-iot/iotuserbind/device/listV2")
    suspend fun getDeviceListByMap(@Body map: HashMap<String, Any>): HttpResult<DeviceListRes>

    @POST("/dreame-user-iot/iotuserbind/device/del")
    suspend fun deleteDeviceByDid(@Body deleteDeviceReq: DeleteDeviceReq): HttpResult<Boolean>

    /**
     * 获取智能音箱列表
     */
    @GET("dreame-product/public/smarthomeManual/list")
    suspend fun getVoiceProductList(
        @Query("lang") lang: String,
        @Query("version")
        version: String,
        @Query("os")
        os: String
    ): HttpResult<List<AiSoundBean>>


    /**
     * 获取意见反馈历史列表
     */
    @GET("/dreame-user/v1/feedback")
    suspend fun getFeedbackList(
        @Query("page") page: Int,
        @Query("size") size: Int,
        @Query("adviseType") adviseType: Int?,
    ): HttpResult<TicketDataRes>

    /**
     * 创建意见反馈
     */
    @POST("/dreame-user/v1/feedback")
    suspend fun createFeedback(@Body request: TicketReq): HttpResult<TicketRes>

    @POST("/dreame-user/v1/feedback/gen-upload-url")
    suspend fun getFileUploadPath(@Query("filename") filename: String): HttpResult<FileUploadRes>

    /**
     * 根据意见反馈ID获取追问列表
     */
    @GET("/dreame-user/v1/feedback/{id}")
    suspend fun getCommentsByFeedbackId(@Path("id") id: String): HttpResult<CommentDataRes>

    /**
     * 发起追问
     */
    @POST("/dreame-user/v1/feedback/{id}/thread")
    suspend fun addComment(
        @Path("id") id: String,
        @Body commentReq: CommentReq,
    ): HttpResult<CommentRes>

    @POST("/dreame-user-iot/iotstatus/props")
    suspend fun getDevicePropsByDid(@Body devicePropsReq: DevicePropsReq)
            : HttpResult<List<DevicePropsRes>>

    @POST("dreame-smarthome/aliIot/getAuthCodeV3")
    suspend fun aliFyAuth(@Body any: Any): HttpResult<String>

    @POST("/dreame-user-iot/iotuserbind/cloudDevBindV2")
    suspend fun cloudDevBind(@Body request: CloudDevBindReq): HttpResult<CloudDevBindData>

    @POST("/dreame-user-iot/iotuserbind/device/updateProperty")
    suspend fun updateAliItoId(@Body jsonObject: JsonObject): HttpResult<Nothing>

    @POST("/dreame-user-iot/aliiotcloud/getUserDevice")
    suspend fun checkAliFyDevice(@Body jsonObject: JsonObject): HttpResult<CheckAliFyDeviceData>

    @POST("/dreame-user-iot/aliiotcloud/mvDeviceRegion")
    suspend fun transferAliFyPDD(@Body jsonObject: JsonObject): HttpResult<Boolean?>

    /**
     * 日志文件上传
     *
     * @return
     */
    @POST("/dreame-resource/file/upload")
    suspend fun logUpload(@Body param: MultipartBody): HttpResult<Boolean>

    @POST("/dreame-mqtt-log/appLog")
    suspend fun appLogUpload(@Body req: AppLogReq): HttpResult<Nothing>

    @GET("/dreame-product/public/apps/latest")
    suspend fun appUpgradeInfo(
        @Query("version") version: Long,
        @Query("os") os: Int = 1,
        @Query("tenantId") tenantId: String,
        @Query("abi") abi: Int,
        @Query("model") model: String? = null,
    ): HttpResult<AppUpgradeBean>

    /**
     * 根据设备WiFi查询设备类型
     *
     * @param models   模型名成
     * @param language 语言类型
     * @return
     */
    @Deprecated(message = "Deprecated")
    @GET("/dreame-product/public/products/by-models")
    suspend fun getProductsByModels(
        @Query("models") models: String,
        @Query("tenantId") tenantId: String,
        @Query("language") language: String,
    ): HttpResult<List<ProductListBean>>

    @GET("/dreame-product/public/v1/productCategory/by-pids")
    suspend fun getProductsCategoryByPids(@Query("pids") pids: String): HttpResult<List<ProductListBean>>

    @GET("/dreame-product/public/v1/productCategory/by-models")
    suspend fun getProductsCategoryByModels(@Query("models") models: String): HttpResult<List<ProductListBean>>

    /**
     * 扫码model 校验上线和国家
     */
    @GET("/dreame-product/public/v1/productCategory/checkModel")
    suspend fun checkModel(@Query("model") models: String): HttpResult<ProductListBean>

    @GET("/dreame-product/public/products/by-pids")
    suspend fun getProductsByPids(
        @Query("pids") pids: String,
        @Query("tenantId") tenantId: String,
    ): HttpResult<List<ProductListBean>>

    /**
     * 扫码model 校验上线和国家
     */
    @GET("/dreame-product/public/v1/productCategory")
    suspend fun queryProductCategoryList(): HttpResult<List<ProductCategoryRes>>


    /**
     * 设备日志大脑
     *
     * @param did     模型名成
     * @return
     */
    @POST("/dreame-user-iot/iotuserbind/deviceLogPackage")
    suspend fun deviceLogPackage(@Body deviceLogPackageReq: DeviceLogPackageReq): HttpResult<Nothing>

    /**
     * 获取隐私政策配置
     *
     * @return
     */
    @GET("/dreame-product/public/privacy")
    suspend fun getPrivacy(@Query("version") version: String): HttpResult<PrivacyUpgradeBean>

    /**
     * 同意隐私政策接口
     *
     * @return
     */
    @POST("/dreame-user/v1/privacy/agree")
    suspend fun agreePrivacy(@Body params: Map<String, Int>): HttpResult<Nothing>

    /**
     * 查询uniApp插件
     * @param pluginType mall
     * @param appVer BuildConfig.PLUGIN_APP_VERSION
     * @param os 1
     */
    @POST("/dreame-product/public/common-plugin")
    suspend fun queryCommonPluginUpgrade(@Body map: Map<String, String>): HttpResult<UniappVersionBean>

    /**
     * 查询RN SDK插件
     * appVer=%d&os=%s
     */
    @GET("/dreame-product/upgrades/sdk")
    suspend fun checkoutSDKPluginVersion(
        @Query("appVer") appVer: Int,
        @Query("os") os: Int = 1,
    ): HttpResult<VersionBean>

    /**
     * 查询RN插件
     */
    @GET("/dreame-product/upgrades/appplugin")
    suspend fun checkoutPluginVersion(
        @Query("model") model: String,
        @Query("appVer") appVer: Int,
        @Query("os") os: Int = 1,
    ): HttpResult<VersionBean>


    // ************************ //

    /**
     * 消息首页内容接口
     */
    @GET("/dreame-message-push/v1/message-record/list")
    suspend fun getMessageHomeRecord(@Query("version") keyword: String? = null): HttpResult<MessageHomeRecord>

    /**
     * 标记所有消息为已读
     */
    @PUT("/dreame-message-push/v1/message-record/mark-allmessages-read")
    suspend fun markAllMessageRead(): HttpResult<Nothing>


    /**
     * 删除用户设备消息
     *
     * @param params
     * @return
     */
    @DELETE("/dreame-messaging/user/device-messages")
    suspend fun deleteMessages(@QueryMap params: Map<String, String>): HttpResult<Nothing>

    /**
     * 消息查询接口
     * @param msgCategory 消息类型 ： 系统消息system_msg、订单消息order_msg、会员消息member_msg、活动消息activity_msg
     * @param currentTimeStamp 秒
     * @return
     */
    @GET("/dreame-message-push/v1/message-record")
    suspend fun getMessageRecord(
        @Query("msgCategory") msgCategory: String,
        @Query("currentTimeStamp") currentTimeStamp: Long,
        @Query("page") page: Int,
        @Query("size") size: Int,
    ): HttpResult<MessageRecord>

    /**
     * 消息删除接口
     * @param msgIds 逗号拼接 111,222,333
     * @return
     */
    @DELETE("/dreame-message-push/v1/message-record/remove-messages")
    suspend fun deleteMessageRecord(@Query("msgIds") msgIds: String): HttpResult<Nothing>

    /**
     * 消息删除接口
     * @param msgCategory 消息类型 ： 系统消息system_msg、订单消息order_msg、会员消息member_msg、活动消息activity_msg
     * @return
     */
    @DELETE("/dreame-message-push/v1/message-record/remove-all-messages")
    suspend fun clearMessageRecord(@Query("msgCategory") msgCategory: String): HttpResult<Nothing>


    /**
     * 设备消息列表
     *
     * @param did
     * @param language
     * @param limit
     * @param offset
     * @return
     */
    @GET("/dreame-messaging/user/device-messages")
    suspend fun getDeviceMessageList(
        @Query("did") did: String?,
        @Query("language") language: String?,
        @Query("offset") offset: Int,
        @Query("limit") limit: Int,
    ): HttpResult<DeviceMessageRes>


    @PUT("/dreame-messaging/user/device-messages")
    suspend fun setMessagesRead(@Query("msgIds") msgIds: String): HttpResult<Nothing>

    @PUT("/dreame-messaging/user/device-messages/mark-read-by-deviceid")
    suspend fun setMessagesReadByDid(@Query("deviceId") deviceId: String): HttpResult<Nothing>

    /**
     * 查询设备
     * @param req
     * @return
     */
    @POST("/dreame-user-iot/iotuserbind/device/info")
    suspend fun queryDeviceInfoByDid(@Body req: DeviceInfoReq): HttpResult<DeviceListBean.Device>

    /**
     * 系统消息和服务消息查询接口
     * @param req
     * @return
     */
    @GET("dreame-message-push/v1/message-set")
    suspend fun getSystemMessageSetting(): HttpResult<SystemMessageSetting>

    /**
     * 系统消息和服务消息设置接口
     * @param req
     * @return
     */
    @PUT("dreame-message-push/v1/message-set")
    suspend fun updateSystemMessageSetting(@Body req: SystemMessageSettingReq): HttpResult<SystemMessageSetting>

    /**
     * 获取消息设置
     */
    @GET("/dreame-messaging/user/message-settings")
    suspend fun getMsgSetting(): HttpResult<MessageSetting>

    /**
     * 修改消息设置
     */
    @PUT("/dreame-messaging/user/message-settings")
    suspend fun updateMsgSetting(@Body req: MessageSetting): HttpResult<MessageSetting>

    /**
     * 获取共享消息列表
     */
    @GET("/dreame-messaging/user/share-messages")
    suspend fun getShareMessageList(
        @Query("limit") limit: Int,
        @Query("offset") offset: Int,
        @Query("version") version: String? = null,
    ):
            HttpResult<CommonPageResult<ShareMessage>>

    /**
     * 删除分享消息
     *
     * @param params
     * @return
     */
    @DELETE("/dreame-messaging/user/share-messages")
    suspend fun deleteShareMessage(@Query("msgIds") msgIds: String): HttpResult<Nothing>

    @PUT("/dreame-messaging/user/share-messages")
    suspend fun readAllShareMessage(): HttpResult<Nothing>

    @PUT("/dreame-messaging/user/share-messages")
    suspend fun readShareMessageByIds(@Body map: Map<String, String>): HttpResult<Nothing>

    /**
     * 从分享消息接受或者拒绝分享
     *
     * @return
     */
    @POST("/dreame-messaging/user/share-messages/{messageId}/ack")
    suspend fun ackShareFromMessage(
        @Path("messageId") messageId: String,
        @Body ackShareFromMessageReq: AckShareFromMessageReq,
    ): HttpResult<Nothing>

    /**
     * 从设备列表接受或者拒绝分享
     *
     * @return
     */
    @POST("/dreame-messaging/user/share-messages/device/ack")
    suspend fun ackShareFromDevice(@Body ackShareFromDeviceReq: AckShareFromDeviceReq): HttpResult<Nothing>


    @PUT("/dreame-message-push/v1/message-record/mark-messages-read")
    suspend fun readMessageByCategory(
        @Query("msgCategory") msgCategory: String?,
        @Query("msgIds") msgIds: String?,
    ): HttpResult<Nothing>

    @POST("/dreame-user-iot/iotuserbind/device/sharedUserList")
    suspend fun getShareUserListByDid(@Body req: ShareUserListReq): HttpResult<List<ShareUserRes>>

    @POST("/dreame-user-iot/iotuserbind/device/delShared")
    suspend fun deleteShareUser(@Body req: DeleteShareUserReq): HttpResult<Boolean>

    /**
     * 获取机器支持的分享功能
     */
    @GET("/dreame-product/public/products/{productId}/permitInfo")
    suspend fun getAllDeviceShareFeatures(@Path("productId") productId: String): HttpResult<List<DeviceFeatureShareRes>>

    /**
     * 获取用户已经拥有的功能
     */
    @POST("/dreame-user-iot/iotuserbind/queryDevicePermit")
    suspend fun getUserFeatures(@Body req: UserFeatureReq): HttpResult<String>

    /**
     * 获取最近联系人
     */
    @GET("/dreame-user/v1/contacts")
    suspend fun getShareContactList(@Query("size") size: Int): HttpResult<List<ShareUserRes>>

    /**
     * 添加联系人
     */
    @POST("/dreame-user/v1/contacts/{contactUid}")
    suspend fun addShareContactList(@Path("contactUid") contactUid: String): HttpResult<Boolean>

    /**
     * 查找用户
     */
    @GET("/dreame-user/v1/query")
    suspend fun queryUserInfoByKeyword(@Query("keyword") keyword: String): HttpResult<List<UserInfo>>

    /**
     * 检查该用户的分享状态
     */
    @POST("/dreame-user-iot/iotuserbind/device/shareCheck")
    suspend fun checkShareStatus(@Body req: ShareFeatureReq): HttpResult<Boolean>

    /**
     * 带权限分享
     */
    @POST("/dreame-user-iot/iotuserbind/device/shareWithPermissions")
    suspend fun shareWithFeatures(@Body req: ShareFeatureReq): HttpResult<Boolean>

    /**
     * 修改分享
     */
    @POST("/dreame-user-iot/iotuserbind/devicePermit")
    suspend fun updateUserFeatures(@Body req: ShareFeatureReq): HttpResult<Boolean>

    @GET("/dreame-product/public/v1/productCategory/list")
    suspend fun getHelpCenterProductList()
            : HttpResult<List<HelpCenterProductItemRes>>

    /**
     * 获取售后信息
     */
    @GET("/dreame-user/v1/aftersale")
    suspend fun getHelpCenterAfterSaleInfo(@Query("country") country: String)
            : HttpResult<AfterSaleInfoRes>

    /**
     * 获取产品faq
     */
    @GET("/dreame-product/public/faqs/product")
    suspend fun getProductFaq(@Query("lang") lang: String, @Query("productId") productIds: String)
            : HttpResult<List<ProductFaqRes>>

    /**
     * 获取App广告
     */
    @GET("/dreame-product/public/advertisement/list-by-position")
    suspend fun getAppAdvertisement(
        @Query("platform") platform: Int,
        @Query("position") position: String,
        @Query("timeZoneId") timeZoneId: String,
    ): HttpResult<List<AppAdvertisementRes>>


    @GET("/dreame-product/public/products/{productId}/connect-instructions")
    suspend fun getProductConnectIns(
        @Path("productId") productId: String,
        @Query("language") language: String,
        @Query("tenantId") tenantId: String
    ): HttpResult<ProductInstructionRes>

    @GET("/dreame-product/public/product-resource-config")
    suspend fun getOpenDeviceInfo(
        @Query("productId") productId: String,
        @Query("dictKey") dictKey: String,
    ): HttpResult<OpenDeviceInfo>

    @Deprecated("需要加时间戳")
    @GET("https://cnbj2.fds.api.xiaomi.com/dreame-product/app/{productModel}/confignet.json")
    suspend fun getProductInfo(
        @Path("productModel") productModel: String,
    ): HttpResult<String>

    @GET
    suspend fun getUrlRedirect(@Url urlRedirect: String): HttpResult<String>

    @GET
    suspend fun getUrlRedirect2(@Url urlRedirect: String): AppConfigRes

    @POST("dreame-smarthome/aliIot/findUidAliRegion")
    suspend fun findUidAliRegion(@Body jsonObject: JsonObject): Response<String>

    @POST("/dreame-user-iot/iotuserbind/device/list")
    suspend fun getBugReportDevices(@Body deviceListReq: DeviceListReq): HttpResult<HelpDeviceModel>

    @GET("/dreame-product/public/advisetag/bycategory")
    suspend fun getSuggestionTags(@Query("category") category: String): HttpResult<List<SuggestionTagRes>>

    @GET("/dreame-user/v1/feedback/tabnum")
    suspend fun getFeedbackHistoryCount(): HttpResult<HistoryCountRes>

    /**
     * 腾讯文档
     * https://lbs.qq.com/service/webService/webServiceGuide/address/Gcoder
     */
    @GET("https://apis.map.qq.com/ws/geocoder/v1")
    @Headers(
        "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
        "Accept-Language: zh-CN,zh;q=0.9"
    )
    suspend fun geocoderByTencentMap(
        @Query("location") latitude: String,
        @Query("key") api_key: String,
        @Query("get_poi") get_poi: Int,
    ): TencentMapGeocoderRes
}