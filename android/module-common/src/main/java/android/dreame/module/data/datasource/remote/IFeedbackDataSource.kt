package android.dreame.module.data.datasource.remote

import android.dreame.module.data.Result
import android.dreame.module.data.entry.CommentDataRes
import android.dreame.module.data.entry.CommentRes
import android.dreame.module.data.entry.DeviceListReq
import android.dreame.module.data.entry.TicketRes
import android.dreame.module.data.entry.help.AfterSaleInfoRes
import android.dreame.module.data.entry.help.HistoryCountRes
import android.dreame.module.data.entry.help.SuggestionTagRes
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/03/16
 *     desc   :
 *     version: 1.0
 * </pre>
 */
abstract class IFeedbackDataSource {
    open suspend fun getDeviceList(
        current: Int,
        size: Int,
        lang: String,
    ) = processApiResponse {
        val devListReq = DeviceListReq(
            current,
            size,
            lang
        )
        devListReq.sharedStatus = 1
        DreameService.getDeviceList(
            devListReq
        )
    }

    open suspend fun getSnAndFirmwareVersion(did: String, keys: String) = processApiResponse {
        DreameService.getDevicePropsByDid(did, keys)
    }

    abstract suspend fun getAllTickets(page: Int, size: Int,adviseType:Int? = null): Result<List<TicketRes>>

    abstract suspend fun createTicket(
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
        adviseType: Int?
    ): Result<TicketRes>

    abstract suspend fun addTicketComment(
        ticketId: String,
        commentContent: String,
        imageList: List<String>?,
        videoList: List<String>?
    ): Result<CommentRes>

    abstract suspend fun getCommentsByTicketId(ticketId: String): Result<CommentDataRes>

    abstract suspend fun getSuggestionTags(category: String): Result<List<SuggestionTagRes>>
    abstract suspend fun getFeedbackHistoryCount(): Result<HistoryCountRes>

    abstract suspend fun getHelpCenterAfterSaleInfo(country: String) : Result<AfterSaleInfoRes>
}