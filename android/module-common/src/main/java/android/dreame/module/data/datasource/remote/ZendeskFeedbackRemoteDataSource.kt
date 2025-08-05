package android.dreame.module.data.datasource.remote

import android.dreame.module.BuildConfig
import android.dreame.module.LocalApplication
import android.dreame.module.data.Result
import android.dreame.module.data.entry.CommentDataRes
import android.dreame.module.data.entry.CommentRes
import android.dreame.module.data.entry.TicketRes
import android.dreame.module.data.entry.help.AfterSaleInfoRes
import android.dreame.module.data.entry.help.HistoryCountRes
import android.dreame.module.data.entry.help.SuggestionTagRes
import android.dreame.module.exception.DreameException
import android.dreame.module.manager.AccountManager
import android.dreame.module.util.FileUtil
import android.dreame.module.util.LogUtil
import android.dreame.module.util.download.rn.RnPluginInfoHelper
import android.os.Build
import com.blankj.utilcode.util.EncryptUtils
import com.zendesk.logger.Logger
import com.zendesk.service.ErrorResponse
import com.zendesk.service.ZendeskCallback
import zendesk.core.Identity
import zendesk.core.JwtIdentity
import zendesk.core.Zendesk
import zendesk.support.Comment
import zendesk.support.CommentsResponse
import zendesk.support.CreateRequest
import zendesk.support.CustomField
import zendesk.support.EndUserComment
import zendesk.support.Request
import zendesk.support.RequestProvider
import zendesk.support.Support
import zendesk.support.UploadProvider
import zendesk.support.UploadResponse
import zendesk.support.User
import java.io.File
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/03/15
 *     desc   :
 *     version: 1.0
 * </pre>
 */


object ZendeskFeedbackRemoteDataSource : IFeedbackDataSource() {
    private const val isProdEnv = BuildConfig.BUILD_TYPE == "release"

    private val ZENDESK_URL by lazy {
        if (isProdEnv)
            "https://dreametech.zendesk.com"
        else
            "https://dreametech1648544714.zendesk.com"
    }
    private val ZENDESK_APP_ID by lazy {
        if (isProdEnv)
            "df9a040bca0b0fb807b859981258416406b4d4a2b05e4656"
        else
            "1fe1ec5b67df6129e27a88ed416093578aff14672a6a52a9"
    }
    private val ZENDESK_CLIENT_ID by lazy {
        if (isProdEnv)
            "mobile_sdk_client_2d17233cd430fd2c6e56"
        else
            "mobile_sdk_client_594408f2955ff3b17fd2"
    }

    private val CUSTOM_FIELD_FEEDBACK_TYPE_ID by lazy {
        if (isProdEnv)
            6190697632793L
        else
            5260622553241L
    }

    private val CUSTOM_FIELD_CONTACT_ID by lazy {
        if (isProdEnv)
            6186895117721L
        else
            5260617311129L
    }
    private val CUSTOM_FIELD_DEVICE_NAME_ID by lazy {
        if (isProdEnv)
            6186952116633L
        else
            5260635099545L
    }
    private val CUSTOM_FIELD_DEVICE_MODEL_ID by lazy {
        if (isProdEnv)
            6186996398489L
        else
            5260621602969L
    }
    private val CUSTOM_FIELD_DEVICE_PIC_ID by lazy {
        if (isProdEnv)
            6187053128857L
        else
            5260653459097L
    }
    private val CUSTOM_FIELD_COUNTRY_ID by lazy {
        if (isProdEnv)
            900009773483L
        else
            5551216313241L
    }
    private val CUSTOM_FIELD_PLATFORM_ID by lazy {
        if (isProdEnv)
            6187066491801L
        else
            5560304227097L
    }
    private val CUSTOM_FIELD_DEVICE_SN_ID by lazy {
        if (isProdEnv)
            6187236107801L
        else
            5641291569689L
    }
    private val CUSTOM_FIELD_APP_NAME_ID by lazy {
        if (isProdEnv)
            6187238808345L
        else
            5641285789209L
    }
    private val CUSTOM_FIELD_APP_VERSION_NAME_ID by lazy {
        if (isProdEnv)
            6187233664281L
        else
            5641295115801L
    }
    private val CUSTOM_FIELD_FIRMWARE_VERSION_ID by lazy {
        if (isProdEnv)
            6187280170009L
        else
            5641332969625L
    }
    private val CUSTOM_FIELD_UID_ID by lazy {
        if (isProdEnv)
            6187283502105L
        else
            5641373427993L
    }
    private val CUSTOM_FIELD_MOBILE_BRAND_ID by lazy {
        if (isProdEnv)
            6187318806809L
        else
            5641361382425L
    }
    private val CUSTOM_FIELD_MOBILE_SYSTEM_VERSION_ID by lazy {
        if (isProdEnv)
            6187351787161L
        else
            5641390896409L
    }
    private val CUSTOM_FIELD_DID_ID by lazy {
        if (isProdEnv)
            6187484781209L
        else
            5655566094745L
    }
    private val CUSTOM_FIELD_UPLOAD_LOG_ID by lazy {
        if (isProdEnv)
            0L
        else
            6691356188185L
    }

    private val CUSTOM_FIELD_PLUGIN_VERSION_ID by lazy {
        17298482858905L
    }

    private var requestProvider: RequestProvider? = null
    private var uploadProvider: UploadProvider? = null

    init {
        Logger.setLoggable(!isProdEnv)
        Zendesk.INSTANCE.init(
            LocalApplication.getInstance(), ZENDESK_URL,
            ZENDESK_APP_ID,
            ZENDESK_CLIENT_ID
        )
        Support.INSTANCE.init(Zendesk.INSTANCE)
        val tenantId = LocalApplication.getInstance().tenantId
        val encryptStr = EncryptUtils.encryptAES2HexString(
            "${tenantId}-${AccountManager.getInstance().getUserInfo().uid}".toByteArray(),
            byteArrayOf(103, 105, 103, 120, 108, 109, 113, 119, 90, 93, 55, 111, 87, 90, 85, 70),
            "AES/ECB/pkcs5padding",
            byteArrayOf()
        )
        val identity: Identity = JwtIdentity("mova_appv1-${encryptStr.toLowerCase()}")
        Zendesk.INSTANCE.setIdentity(identity)
        Support.INSTANCE.init(Zendesk.INSTANCE)

        requestProvider = Support.INSTANCE.provider()?.requestProvider()
        uploadProvider = Support.INSTANCE.provider()?.uploadProvider()
    }

    override suspend fun getAllTickets(
        page: Int,
        size: Int,
        adviseType: Int?,
    ): Result<List<TicketRes>> {
        return suspendCoroutine {
            requestProvider?.getAllRequests(object : ZendeskCallback<List<Request>>() {
                override fun onSuccess(resultList: List<Request>?) {
                    val ticketRes = resultList?.map { request ->
                        var resultType: Int? = 0
                        var resultContact: String? = null
                        var resultDeviceModel: String? = null
                        var resultDeviceName: String? = null
                        var resultDevicePic: String? = null
                        var appVersionCode: Int? = 0
                        var appVersionName: String? = "1.0"
                        LogUtil.i(
                            "ZendeskFeedbackRemoteDataSource",
                            "onSuccess attachments: ${request.firstComment?.attachments?.size}"
                        )
                        request.customFields?.forEach { customField ->
                            if (customField.id == CUSTOM_FIELD_FEEDBACK_TYPE_ID) {
                                try {
                                    resultType = customField.value?.toInt()
                                } catch (e: Exception) {
                                    e.printStackTrace()
                                }
                            } else if (customField.id == CUSTOM_FIELD_CONTACT_ID) {
                                resultContact = customField.value
                            } else if (customField.id == CUSTOM_FIELD_DEVICE_MODEL_ID) {
                                resultDeviceModel = customField.value
                            } else if (customField.id == CUSTOM_FIELD_DEVICE_NAME_ID) {
                                resultDeviceName = customField.value
                            } else if (customField.id == CUSTOM_FIELD_DEVICE_PIC_ID) {
                                resultDevicePic = customField.value
                            } else if (customField.id == CUSTOM_FIELD_APP_VERSION_NAME_ID) {
                                appVersionName = customField.value
                            }
                        }

                        val imageList = mutableListOf<String>()
                        val videoList = mutableListOf<String>()

                        val map = hashMapOf<Long, User>()
                        request.lastCommentingAgents?.forEach { user ->
                            map[user.id!!] = user
                        }
                        val isReply = map[request.lastComment?.authorId]?.isAgent ?: false
                        TicketRes(
                            appVersionCode ?: 0,
                            appVersionName,
                            request.id,
                            request.subject,
                            request.description,
                            request.status?.ordinal,
                            request.createdAt?.time,
                            resultType,
                            resultContact,
                            resultDeviceName,
                            resultDeviceModel,
                            resultDevicePic,
                            isReply = isReply,
                            request.updatedAt?.time,
                            null,
                            imageList,
                            videoList,
                            null
                        )
                    }
                        ?: emptyList()
                    it.resume(Result.Success(ticketRes))
                }

                override fun onError(error: ErrorResponse?) {
                    if (error != null) {
                        it.resume(Result.Error(DreameException(error.status, error.reason)))
                    } else {
                        it.resume(Result.Error(DreameException(-1, "")))
                    }
                }

            })
        }
    }

    override suspend fun createTicket(
        uid: String?,
        appVersion: Int?,
        appVersionName: String?,
        did: String?,
        subject: String?,
        description: String,
        type: Int?,
        contact: String,
        deviceName: String?,
        deviceModel: String?,
        devicePic: String?,
        country: String,
        uploadLog: Boolean?,
        imageList: List<String>?,
        videoList: List<String>?,
        tags: List<String>?,
        adviseType: Int?,
    ): Result<TicketRes> {

        //获取sn和固件版本
        var sn: String? = null
        var firmwareVersion: String? = null
        did?.let {
            val snRet = getSnAndFirmwareVersion(it, "1.5,99.17")
            if (snRet is Result.Success) {
                snRet.data?.forEach { deviceProp ->
                    if (deviceProp.key == "1.5") {
                        sn = deviceProp.value
                    } else if (deviceProp.key == "99.17") {
                        firmwareVersion = deviceProp.value
                    }
                }
            }
        }

        val request = CreateRequest()
        request.subject = subject
        request.description = description
        request.tags = tags
        request.attachments

        val customFields = mutableListOf<CustomField>()
        if (appVersionName != null) {
            customFields.add(CustomField(CUSTOM_FIELD_APP_VERSION_NAME_ID, appVersionName))
        }
        if (did != null) {
            customFields.add(CustomField(CUSTOM_FIELD_DID_ID, did))
        }
        customFields.add(CustomField(CUSTOM_FIELD_FEEDBACK_TYPE_ID, type))
        customFields.add(CustomField(CUSTOM_FIELD_CONTACT_ID, contact))
        customFields.add(CustomField(CUSTOM_FIELD_PLATFORM_ID, "Android"))
        customFields.add(CustomField(CUSTOM_FIELD_COUNTRY_ID, country))
        customFields.add(CustomField(CUSTOM_FIELD_APP_NAME_ID, "MOVAhome"))
        customFields.add(CustomField(CUSTOM_FIELD_UID_ID, uid))
        customFields.add(CustomField(CUSTOM_FIELD_MOBILE_BRAND_ID, "${Build.BRAND} ${Build.MODEL}"))
        customFields.add(CustomField(CUSTOM_FIELD_MOBILE_SYSTEM_VERSION_ID, Build.VERSION.RELEASE))
        customFields.add(CustomField(CUSTOM_FIELD_UPLOAD_LOG_ID, if (uploadLog == true) 1 else 0))
        if (deviceName != null) {
            customFields.add(CustomField(CUSTOM_FIELD_DEVICE_NAME_ID, deviceName))
        }
        if (deviceModel != null) {
            customFields.add(CustomField(CUSTOM_FIELD_DEVICE_MODEL_ID, deviceModel))
            val entity = RnPluginInfoHelper.getRnPluginUse(deviceModel ?: "")
            customFields.add(
                CustomField(
                    CUSTOM_FIELD_PLUGIN_VERSION_ID,
                    entity?.pluginVersion ?: 0
                )
            )
        }
        if (devicePic != null) {
            customFields.add(CustomField(CUSTOM_FIELD_DEVICE_PIC_ID, devicePic))
        }
        if (sn != null) {
            customFields.add(CustomField(CUSTOM_FIELD_DEVICE_SN_ID, sn))
        }
        if (firmwareVersion != null) {
            customFields.add(CustomField(CUSTOM_FIELD_FIRMWARE_VERSION_ID, firmwareVersion))
        }
        request.customFields = customFields
        request.tags = tags
        LogUtil.d(
            "ZendeskFeedbackRemoteDataSource",
            "imageList.size:${imageList?.size},videoList : ${videoList?.size}"
        )
        val attachmentList = mutableListOf<String>()
        imageList?.forEach { url ->
            val file = File(url)
            LogUtil.i(
                "ZendeskFeedbackRemoteDataSource",
                "Upload file:${file.name}, ${FileUtil.getFileMimeType(file.path)} , ${file.path}"
            )
            val attachment = uploadFile(file)
            if (attachment is Result.Success) {
                attachmentList.add(attachment.data!!)
            } else {
                return Result.Error(DreameException(-1, ""))
            }
        }
        videoList?.forEach { videoUrl ->
            val file = File(videoUrl)
            LogUtil.i(
                "ZendeskFeedbackRemoteDataSource",
                "Upload file:${file.name}, ${FileUtil.getFileMimeType(file.path)} , ${file.path}"
            )
            val attachment = uploadFile(file)
            if (attachment is Result.Success) {
                attachmentList.add(attachment.data!!)
            } else {
                return Result.Error(DreameException(-1, ""))
            }
        }
        request.attachments = attachmentList
        return suspendCoroutine {
            requestProvider?.createRequest(request, object : ZendeskCallback<Request>() {
                override fun onSuccess(result: Request?) {
                    val ticketRes = if (result != null) {
                        var resultType: Int? = null
                        var resultContact: String? = null
                        var resultDeviceModel: String? = null
                        var resultDeviceName: String? = null
                        var resultDevicePic: String? = null
                        var appVersionCode: Int? = 0
                        var appVersionName: String? = "1.0"
                        var did: String? = "1.0"
                        result.customFields?.forEach { customField ->
                            if (customField.id == CUSTOM_FIELD_FEEDBACK_TYPE_ID) {
                                try {
                                    resultType = customField.value?.toInt()
                                } catch (e: Exception) {
                                    e.printStackTrace()
                                }
                            } else if (customField.id == CUSTOM_FIELD_CONTACT_ID) {
                                resultContact = customField.value
                            } else if (customField.id == CUSTOM_FIELD_DEVICE_MODEL_ID) {
                                resultDeviceModel = customField.value
                            } else if (customField.id == CUSTOM_FIELD_DEVICE_NAME_ID) {
                                resultDeviceName = customField.value
                            } else if (customField.id == CUSTOM_FIELD_DEVICE_PIC_ID) {
                                resultDevicePic = customField.value
                            } else if (customField.id == CUSTOM_FIELD_APP_VERSION_NAME_ID) {
                                appVersionName = customField.value
                            } else if (customField.id == CUSTOM_FIELD_DID_ID) {
                                did = customField.value
                            }
                        }
                        result.firstComment?.attachments?.forEach {

                        }
                        val imageList = mutableListOf<String>()
                        val videoList = mutableListOf<String>()
                        TicketRes(
                            appVersionCode ?: 0,
                            appVersionName,
                            request.id,
                            request.subject,
                            request.description,
                            result.status?.ordinal,
                            result.createdAt?.time,
                            resultType,
                            resultContact,
                            resultDeviceName,
                            resultDeviceModel,
                            resultDevicePic,
                            isReply = false,
                            result.updatedAt?.time,
                            null,
                            imageList,
                            videoList,
                            null
                        )
                    } else {
                        null
                    }
                    it.resume(Result.Success(ticketRes))
                }

                override fun onError(error: ErrorResponse?) {
                    if (error != null) {
                        it.resume(Result.Error(DreameException(error.status, error.reason)))
                    } else {
                        it.resume(Result.Error(DreameException(-1, "")))
                    }
                }

            })
        }
    }

    override suspend fun addTicketComment(
        ticketId: String,
        commentContent: String,
        imageList: List<String>?,
        videoList: List<String>?,
    ): Result<CommentRes> {
        val comment = EndUserComment()
        comment.setValue(commentContent)

        val attachmentList = mutableListOf<String>()
        imageList?.forEach { url ->
            val file = File(url)
            LogUtil.i(
                "ZendeskFeedbackRemoteDataSource",
                "Upload file:${file.name}, ${FileUtil.getFileMimeType(file.path)} , ${file.path}"
            )
            val attachment = uploadFile(file)
            if (attachment is Result.Success) {
                attachmentList.add(attachment.data!!)
            } else {
                return Result.Error(DreameException(-1, ""))
            }
        }
        videoList?.forEach { videoUrl ->
            val file = File(videoUrl)
            LogUtil.i(
                "ZendeskFeedbackRemoteDataSource",
                "Upload file:${file.name}, ${FileUtil.getFileMimeType(file.path)} , ${file.path}"
            )
            val attachment = uploadFile(file)
            if (attachment is Result.Success) {
                attachmentList.add(attachment.data!!)
            } else {
                return Result.Error(DreameException(-1, ""))
            }
        }
        comment.attachments = attachmentList
        return suspendCoroutine {
            requestProvider?.addComment(ticketId, comment, object : ZendeskCallback<Comment>() {
                override fun onSuccess(result: Comment?) {
                    val commentRes = if (result != null) {
                        CommentRes(
                            isAgent = false,
                            result.id.toString(),
                            result.requestId.toString(),
                            result.body,
                            "",
                            result.createdAt?.time,
                            result.attachments,
                            result.attachments
                        )
                    } else {
                        null
                    }
                    it.resume(Result.Success(commentRes))
                }

                override fun onError(error: ErrorResponse?) {
                    if (error != null) {
                        it.resume(Result.Error(DreameException(error.status, error.reason)))
                    } else {
                        it.resume(Result.Error(DreameException(-1, "")))
                    }
                }
            })
        }
    }

    override suspend fun getCommentsByTicketId(ticketId: String): Result<CommentDataRes> {
        return suspendCoroutine {
            requestProvider?.getComments(
                ticketId,
                object : ZendeskCallback<CommentsResponse>() {
                    override fun onSuccess(result: CommentsResponse?) {
                        val commentList = mutableListOf<CommentRes>()
                        val map = hashMapOf<Long, User>()
                        result?.users?.forEach { user ->
                            map[user.id!!] = user
                        }
                        var status = 0
                        if (result != null) {
                            for (i in result.comments.indices) {
                                val zendeskComment = result.comments[i]
                                val zendeskUser = map[zendeskComment.authorId]

                                val imageList = mutableListOf<String>()
                                val videoList = mutableListOf<String>()
                                zendeskComment.attachments.forEach { attachment ->
                                    if (attachment.contentType?.contains("image", false) == true) {
                                        imageList.add(attachment.contentUrl ?: "")
                                    } else if (attachment.contentType?.contains(
                                            "video",
                                            false
                                        ) == true
                                    ) {
                                        videoList.add(attachment.contentUrl ?: "")
                                    }
                                }
                                commentList.add(
                                    CommentRes(
                                        isAgent = zendeskUser?.isAgent,
                                        zendeskComment.id.toString(),
                                        zendeskComment.requestId.toString(),
                                        zendeskComment.body,
                                        zendeskUser?.name,
                                        zendeskComment.createdAt?.time,
                                        imageList,
                                        videoList
                                    )
                                )
                                if (i == 0) {
                                    status = if (zendeskUser?.isAgent == true) 1 else 0
                                }
                            }
                        }
                        commentList.reverse()
                        it.resume(Result.Success(CommentDataRes(status, commentList)))
                    }

                    override fun onError(error: ErrorResponse?) {
                        if (error != null) {
                            it.resume(Result.Error(DreameException(error.status, error.reason)))
                        } else {
                            it.resume(Result.Error(DreameException(-1, "")))
                        }
                    }

                }
            )
        }
    }

    override suspend fun getSuggestionTags(category: String): Result<List<SuggestionTagRes>> {
        return Result.Success(emptyList())
    }

    override suspend fun getFeedbackHistoryCount(): Result<HistoryCountRes> {
        return suspendCoroutine {
            requestProvider?.getAllRequests(object : ZendeskCallback<List<Request>>() {
                override fun onSuccess(resultList: List<Request>?) {
                    it.resume(Result.Success(HistoryCountRes(resultList?.size)))
                }

                override fun onError(error: ErrorResponse?) {
                    if (error != null) {
                        it.resume(Result.Error(DreameException(error.status, error.reason)))
                    } else {
                        it.resume(Result.Error(DreameException(-1, "")))
                    }
                }

            })
        }
    }

    private suspend fun uploadFile(file: File): Result<String> {
        val attachment = suspendCoroutine<Result<String>> {
            uploadProvider?.uploadAttachment(
                file.name,
                file,
                FileUtil.getFileMimeType(file.path),
                object : ZendeskCallback<UploadResponse>() {
                    override fun onSuccess(uploadResponse: UploadResponse?) {
                        if (uploadResponse != null && uploadResponse.token != null) {
                            it.resume(Result.Success(uploadResponse.token))
                        } else {
                            it.resume(Result.Error(DreameException(-1, "")))
                        }
                    }

                    override fun onError(error: ErrorResponse?) {
                        if (error != null) {
                            it.resume(Result.Error(DreameException(error.status, error.reason)))
                        } else {
                            it.resume(Result.Error(DreameException(-1, "")))
                        }
                    }

                })
        }
        return attachment
    }

    override suspend fun getHelpCenterAfterSaleInfo(country: String): Result<AfterSaleInfoRes> {
        return Result.Success(null)
    }
}