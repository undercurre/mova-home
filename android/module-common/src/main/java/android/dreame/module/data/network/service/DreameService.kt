package android.dreame.module.data.network.service

import android.dreame.module.bean.OAuthBean
import android.dreame.module.bean.UniappVersionBean
import android.dreame.module.bean.VersionBean
import android.dreame.module.data.entry.AlexaApp2AppReq
import android.dreame.module.data.entry.AlexaBindAuthReq
import android.dreame.module.data.entry.AlexaLinkAuthReq
import android.dreame.module.data.entry.CommentReq
import android.dreame.module.data.entry.DeleteDeviceReq
import android.dreame.module.data.entry.DeviceListReq
import android.dreame.module.data.entry.DeviceLogPackageReq
import android.dreame.module.data.entry.DevicePropsReq
import android.dreame.module.data.entry.LogUploadedReq
import android.dreame.module.data.entry.ModifyPassword
import android.dreame.module.data.entry.PrivacyUpgradeBean
import android.dreame.module.data.entry.ProductCategoryRes
import android.dreame.module.data.entry.ProductListBean
import android.dreame.module.data.entry.SettingPassword
import android.dreame.module.data.entry.TicketReq
import android.dreame.module.data.entry.UserInfo
import android.dreame.module.data.entry.addFormDataPart
import android.dreame.module.data.entry.device.DeleteShareUserReq
import android.dreame.module.data.entry.device.DeviceBlePairNonceReq
import android.dreame.module.data.entry.device.DeviceBlePairReq
import android.dreame.module.data.entry.device.DevicePairReq
import android.dreame.module.data.entry.device.DeviceQRNetPairReq
import android.dreame.module.data.entry.device.ShareFeatureReq
import android.dreame.module.data.entry.device.ShareUserListReq
import android.dreame.module.data.entry.device.UserFeatureReq
import android.dreame.module.data.entry.log.AppLogReq
import android.dreame.module.data.entry.message.AckShareFromDeviceReq
import android.dreame.module.data.entry.message.AckShareFromMessageReq
import android.dreame.module.data.entry.message.DeviceInfoReq
import android.dreame.module.data.entry.message.MessageHomeRecord
import android.dreame.module.data.entry.message.MessageRecord
import android.dreame.module.data.entry.message.MessageSetting
import android.dreame.module.data.entry.message.SystemMessageSettingReq
import android.dreame.module.data.entry.monitor.CheckAliFyDeviceData
import android.dreame.module.data.entry.monitor.CloudDevBindReq
import android.dreame.module.data.network.HttpResult
import android.dreame.module.data.network.api.DreameApi
import android.dreame.module.data.network.interceptor.HeaderIntercept
import android.dreame.module.data.network.utils.DreameHostVerify
import android.dreame.module.data.network.utils.HttpClientUtils
import android.dreame.module.dto.IoTActionReq
import android.dreame.module.dto.IoTBaseReq
import android.dreame.module.dto.IoTPropertyReq
import android.dreame.module.manager.AreaManager
import android.dreame.module.task.RetrofitInitTask
import com.google.gson.JsonObject
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.logging.HttpLoggingInterceptor
import org.json.JSONObject
import retrofit2.Call
import java.io.File
import java.net.Proxy
import java.util.concurrent.TimeUnit

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/02
 *     desc   :
 *     version: 1.0
 * </pre>
 */
object DreameService {

    private var service =
        ServiceCreator.create(DreameApi::class.java, RetrofitInitTask.getBaseUrl())

    fun createService(baseUrl: String) {
        service = ServiceCreator.create(DreameApi::class.java, baseUrl)
    }

    suspend fun getUserInfo(): HttpResult<UserInfo> {
        return service.getUserInfo()
    }

    fun refreshAccessToken(tenantId: String, params: Map<String, String>): Call<OAuthBean?> {
        val httpClient = OkHttpClient.Builder()
            .addInterceptor(HeaderIntercept())
            .addInterceptor(HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY))
            .hostnameVerifier(DreameHostVerify)
            .connectionSpecs(HttpClientUtils.connectionSpecs)
            .readTimeout(10000, TimeUnit.MILLISECONDS)
            .writeTimeout(10000, TimeUnit.MILLISECONDS)
            .connectTimeout(10000, TimeUnit.MILLISECONDS)
            .proxy(Proxy.NO_PROXY)
            .build()
        val dreameApi = ServiceCreator.create(
            DreameApi::class.java,
            RetrofitInitTask.getBaseUrl(),
            httpClient
        )
        return dreameApi.refreshAccessToken(tenantId, params)
    }


    suspend fun getDevicePair(req: DevicePairReq) =
        service.getDevicePair(req)

    suspend fun getDevicePair4Ble(req: DeviceBlePairReq) =
        service.getDevicePair4Ble(req)

    suspend fun getDevicePairByNonce(req: DeviceBlePairNonceReq) =
        service.getDevicePairByNonce(req)

    suspend fun getDeviceQRNetPairResult(req: DeviceQRNetPairReq) =
        service.getDeviceQRNetPairResult(req)

    suspend fun trySendCommand(host: String, req: IoTBaseReq<IoTPropertyReq>) =
        service.trySendCommand(host, req)

    suspend fun trySendActionCommand(host: String, req: IoTBaseReq<IoTActionReq>) =
        service.trySendActionCommand(host, req)

    suspend fun sendAction(host: String, req: IoTBaseReq<IoTActionReq>) =
        service.sendAction(host, req)

    suspend fun settingPassword(req: SettingPassword) =
        service.settingPassword(req)

    suspend fun modifyPassword(req: ModifyPassword) =
        service.modifyPassword(req)

    suspend fun getDomain(region: String = AreaManager.getRegion()) = service.getDomain(region)
    suspend fun getMqttDomainV2(region: String = AreaManager.getRegion(), qrCodePair: Boolean) =
        service.getMqttDomainV2(region, qrCodePair)


    suspend fun getAlexaApp2AppUrl(alexaApp2AppReq: AlexaApp2AppReq) =
        service.getAlexaApp2AppUrl(alexaApp2AppReq)

    suspend fun alexaSkillAccountLink(alexaLinkAuthReq: AlexaLinkAuthReq) =
        service.alexaSkillAccountLink(alexaLinkAuthReq)

    suspend fun unbindAlexaAccountLink() = service.unbindAlexaAccountLink()

    suspend fun skillAuthorizeCode(req: AlexaBindAuthReq) = service.skillAuthorizeCode(req)

    suspend fun getVoiceProductList(lang: String, version: String, os: String) = service.getVoiceProductList(lang, version, os)

    suspend fun getDeviceList(deviceListReq: DeviceListReq) =
        service.getDeviceList(deviceListReq)

    suspend fun deleteDeviceByDid(deleteDeviceReq: DeleteDeviceReq) =
        service.deleteDeviceByDid(deleteDeviceReq)

    suspend fun createFeedback(ticketReq: TicketReq) = service.createFeedback(ticketReq)

    suspend fun getFileUploadPath(filename: String) = service.getFileUploadPath(filename)

    suspend fun getFeedbackList(page: Int, size: Int, adviseType: Int) = service.getFeedbackList(page, size, adviseType)

    suspend fun addComment(id: String, commentReq: CommentReq) = service.addComment(id, commentReq)

    suspend fun getCommentsByFeedbackId(id: String) = service.getCommentsByFeedbackId(id)

    suspend fun getDevicePropsByDid(did: String, keys: String) = service.getDevicePropsByDid(
        DevicePropsReq(did, keys)
    )

    /**
     * 日志上传
     */
    suspend fun logUpload(req: LogUploadedReq, file: File): HttpResult<Boolean> {
        val requestBody = MultipartBody.Builder().apply {
            setType(MultipartBody.FORM)
            req.addFormDataPart(this)
            addFormDataPart(
                "file",
                file.name,
                file.asRequestBody("application/octet-stream".toMediaType())
            )
        }.build()
        return service.logUpload(requestBody)
    }

    suspend fun appLogUpload(req: AppLogReq): HttpResult<Nothing> {
        return service.appLogUpload(req)
    }

    suspend fun aliFyAuth(): HttpResult<String> {
        return service.aliFyAuth(JSONObject())
    }

    /**
     * ali设备云云绑定
     */
    suspend fun cloudDevBind(did: String, uids: List<String>) =
        service.cloudDevBind(CloudDevBindReq(did, uids))

    suspend fun checkAliFyDevice(did: String, openId: String): HttpResult<CheckAliFyDeviceData> {
        val jsonObject = JsonObject().apply {
            addProperty("did", did)
            addProperty("openId", openId)
        }
        return service.checkAliFyDevice(jsonObject)
    }

    suspend fun transferAliFyPDD(did: String): HttpResult<Boolean?> {
        val jsonObject = JsonObject().apply {
            addProperty("did", did)
        }
        return service.transferAliFyPDD(jsonObject)
    }

    @Deprecated(message = "Deprecated")
    suspend fun getProductsByModels(
        models: String,
        language: String,
        tenantId: String = "000002",
    ): HttpResult<List<ProductListBean>> {
        return service.getProductsByModels(models, tenantId, language)
    }

    @Deprecated(message = "Deprecated")
    suspend fun getProductsByPids(
        pids: String,
        tenantId: String = "000002",
    ): HttpResult<List<ProductListBean>> {
        return service.getProductsByPids(pids, tenantId)
    }

    suspend fun checkModel(model: String) = service.checkModel(model)
    suspend fun getProductsCategoryByModels(models: String): HttpResult<List<ProductListBean>> {
        return service.getProductsCategoryByModels(models)
    }

    suspend fun getProductsCategoryByPids(pids: String): HttpResult<List<ProductListBean>> {
        return service.getProductsCategoryByPids(pids)
    }

    suspend fun queryProductCategoryList(): HttpResult<List<ProductCategoryRes>> {
        return service.queryProductCategoryList()
    }

    suspend fun deviceLogPackage(did: String, model: String): HttpResult<Nothing> {
        return service.deviceLogPackage(DeviceLogPackageReq(did, model))
    }

    /**
     * 获取最新的隐私政策配置
     * @param version 隐私版本
     */
    suspend fun getPrivacy(version: String): HttpResult<PrivacyUpgradeBean> {
        return service.getPrivacy(version)
    }

    /**
     * 同意隐私政策接口（新安装调用1次）
     */
    suspend fun agreePrivacy(version: Int): HttpResult<Nothing> {
        return service.agreePrivacy(mapOf("version" to version))
    }

    suspend fun queryCommonPluginUpgrade(
        appVer: String,
        pluginType: String = "mall",
    ): HttpResult<UniappVersionBean> {
        val map = mapOf(
            "appVer" to appVer,
            "os" to "1",
            "pluginType" to pluginType
        )
        return service.queryCommonPluginUpgrade(map)
    }

    suspend fun checkoutSDKPluginVersion(appVer: Int): HttpResult<VersionBean> {
        return service.checkoutSDKPluginVersion(appVer)
    }

    suspend fun checkoutPluginVersion(model: String, appVer: Int): HttpResult<VersionBean> {
        return service.checkoutPluginVersion(model, appVer)
    }

    suspend fun getMessageHomeRecord(version: String?): HttpResult<MessageHomeRecord> =
        service.getMessageHomeRecord(version)

    suspend fun markAllMessageRead(): HttpResult<Nothing> = service.markAllMessageRead()

    suspend fun deleteMessages(params: Map<String, String>): HttpResult<Nothing> =
        service.deleteMessages(params)

    suspend fun getMessageRecord(
        msgCategory: String,
        currentTimeStamp: Long,
        page: Int,
        size: Int,
    ): HttpResult<MessageRecord> =
        service.getMessageRecord(msgCategory, currentTimeStamp, page, size)

    suspend fun deleteMessageRecord(msgIds: String): HttpResult<Nothing> =
        service.deleteMessageRecord(msgIds)

    suspend fun clearMessageRecord(msgCategory: String): HttpResult<Nothing> =
        service.clearMessageRecord(msgCategory)

    suspend fun getDeviceMessageList(did: String, language: String, offset: Int, limit: Int) =
        service.getDeviceMessageList(did, language, offset, limit)

    suspend fun setMessagesRead(ids: String) = service.setMessagesRead(ids)

    suspend fun setMessagesReadByDid(did: String) = service.setMessagesReadByDid(did)

    suspend fun queryDeviceInfoByDid(req: DeviceInfoReq) = service.queryDeviceInfoByDid(req)

    suspend fun getSystemMessageSetting() = service.getSystemMessageSetting()

    suspend fun updateSystemMessageSetting(req: SystemMessageSettingReq) =
        service.updateSystemMessageSetting(req)

    suspend fun getMsgSetting() = service.getMsgSetting()

    suspend fun updateMsgSetting(req: MessageSetting) = service.updateMsgSetting(req)

    suspend fun getShareMessageList(limit: Int, offset: Int, version: String?) =
        service.getShareMessageList(limit, offset, version)

    suspend fun deleteShareMessage(msgIds: String) = service.deleteShareMessage(msgIds)

    suspend fun readAllShareMessage() = service.readAllShareMessage()
    suspend fun readShareMessageByIds(msgIds: String) =
        service.readShareMessageByIds(mapOf("msgIds" to msgIds))

    suspend fun ackShareFromMessage(
        messageId: String,
        ackShareFromMessageReq: AckShareFromMessageReq,
    ) = service.ackShareFromMessage(messageId, ackShareFromMessageReq)

    suspend fun ackShareFromDevice(ackShareFromDeviceReq: AckShareFromDeviceReq) =
        service.ackShareFromDevice(ackShareFromDeviceReq)

    suspend fun readMessageByCategory(msgCategory: String?, msgIds: String?) =
        service.readMessageByCategory(msgCategory, msgIds)

    suspend fun getShareUserListByDid(req: ShareUserListReq) =
        service.getShareUserListByDid(req)

    suspend fun deleteShareUser(req: DeleteShareUserReq) =
        service.deleteShareUser(req)

    suspend fun getAllDeviceShareFeatures(productId: String) =
        service.getAllDeviceShareFeatures(productId)

    suspend fun getUserFeatures(req: UserFeatureReq) =
        service.getUserFeatures(req)

    suspend fun getShareContactList(size: Int) =
        service.getShareContactList(size)

    suspend fun addShareContactList(contactUid: String) =
        service.addShareContactList(contactUid)

    suspend fun queryUserInfoByKeyword(keyword: String) =
        service.queryUserInfoByKeyword(keyword)

    suspend fun checkShareStatus(req: ShareFeatureReq) =
        service.checkShareStatus(req)

    suspend fun shareWithFeatures(req: ShareFeatureReq) =
        service.shareWithFeatures(req)

    suspend fun updateUserFeatures(req: ShareFeatureReq) =
        service.updateUserFeatures(req)

    suspend fun getHelpCenterProductList() = service.getHelpCenterProductList()

    suspend fun getHelpCenterAfterSaleInfo(country: String) =
        service.getHelpCenterAfterSaleInfo(country)

    suspend fun getProductFaq(lang: String, productIds: String) =
        service.getProductFaq(lang, productIds)

    suspend fun getProductConnectIns(productId: String, language: String, tenantId: String) =
        service.getProductConnectIns(productId, language, tenantId)

    suspend fun getOpenDeviceInfo(productId: String, dictKey: String) =
        service.getOpenDeviceInfo(productId, dictKey)

    suspend fun getProductInfo(productModel: String) = service.getProductInfo(productModel)

    suspend fun getUrlRedirect(urlRedirect: String) = service.getUrlRedirect(urlRedirect)

    suspend fun getUrlRedirect2(urlRedirect: String) = service.getUrlRedirect2(urlRedirect)

    suspend fun getBugReportDevices(req: DeviceListReq) = service.getBugReportDevices(req)

    suspend fun getSuggestionTags(category: String) = service.getSuggestionTags(category)

    suspend fun getFeedbackHistoryCount() = service.getFeedbackHistoryCount()

    suspend fun findUidAliRegion(params: JsonObject) = service.findUidAliRegion(params)
}