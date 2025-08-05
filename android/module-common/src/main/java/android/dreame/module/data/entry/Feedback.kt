package android.dreame.module.data.entry

import android.os.Parcel
import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import java.util.ArrayList

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/03/15
 *     desc   :
 *     version: 1.0
 * </pre>
 */
data class TicketReq(
    val appVersion: Int?,
    val appVersionName: String?,
    val contact: String,
    val title: String?,
    val content: String,
    val did: String?,
    val ip: String?,
    val model: String?,
    val os: Int,
    val plugin: Int?,
    @SerializedName("adviseTagIds") val adviseTagIds: String?,
    val type: Int?,
    val uploadLog: Int? = 0,
    val images: List<String>?,
    val videos: List<String>?,
    val adviseType: Int = 1,
)

data class TicketDataRes(
    val current: Int,
    val hitCount: Boolean,
    val pages: Int,
    val records: List<TicketRes>,
    val searchCount: Boolean,
    val size: Int,
    val total: Int,
)

data class TicketRes(
    val appVersion: Int,
    val appVersionName: String?,
    @SerializedName("id")
    val requestId: String?,
    @SerializedName("title")
    val subject: String?,
    @SerializedName("content")
    val description: String?,
    val status: Int?,
    val createTime: Long?,
    val type: Int?,
    val contact: String?,
    @SerializedName("modelName")
    val deviceName: String?,
    @SerializedName("model")
    val deviceModel: String?,
    @SerializedName("deviceIconUrl")
    val devicePic: String?,
    var isReply: Boolean = false,
    val updateTime: Long?,
    val adviseType: Int?,
    val images: MutableList<String>?,
    val videos: MutableList<String>?,
    val adviseTagNames: MutableList<String>?
) : Parcelable {
    constructor(parcel: Parcel) : this(
        parcel.readInt(),
        parcel.readString(),
        parcel.readString(),
        parcel.readString(),
        parcel.readString(),
        parcel.readValue(Int::class.java.classLoader) as? Int,
        parcel.readValue(Long::class.java.classLoader) as? Long,
        parcel.readValue(Int::class.java.classLoader) as? Int,
        parcel.readString(),
        parcel.readString(),
        parcel.readString(),
        parcel.readString(),
        parcel.readByte() != 0.toByte(),
        parcel.readValue(Long::class.java.classLoader) as? Long,
        parcel.readValue(Int::class.java.classLoader) as? Int,
        parcel.createStringArrayList(),
        parcel.createStringArrayList(),
        parcel.createStringArrayList()
    ) {
    }

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeInt(appVersion)
        parcel.writeString(appVersionName)
        parcel.writeString(requestId)
        parcel.writeString(subject)
        parcel.writeString(description)
        parcel.writeValue(status)
        parcel.writeValue(createTime)
        parcel.writeValue(type)
        parcel.writeString(contact)
        parcel.writeString(deviceName)
        parcel.writeString(deviceModel)
        parcel.writeString(devicePic)
        parcel.writeByte(if (isReply) 1 else 0)
        parcel.writeValue(updateTime)
        parcel.writeValue(adviseType)
        parcel.writeStringList(images)
        parcel.writeStringList(videos)
        parcel.writeStringList(adviseTagNames)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<TicketRes> {
        override fun createFromParcel(parcel: Parcel): TicketRes {
            return TicketRes(parcel)
        }

        override fun newArray(size: Int): Array<TicketRes?> {
            return arrayOfNulls(size)
        }
    }
}


data class CommentReq(
    val content: String,
    val contentType: Int? = 0,
    val images: List<String>?,
    val videos: List<String>?,
)

data class CommentDataRes(
    val status: Int,
    val threads: List<CommentRes>,
)

data class CommentRes(
    val isAgent: Boolean? = false,
    val id: String,
    @SerializedName("feedbackId")
    val ticketId: String,
    val content: String?,
    @SerializedName("uid")
    val nickName: String?,
    val createTime: Long?,
    val images: List<String>?,
    val videos: List<String>?,
)


