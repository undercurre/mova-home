package android.dreame.module.data.entry

import android.os.Parcelable
import android.text.TextUtils
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize
import org.json.JSONException
import org.json.JSONObject


/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/03/15
 *     desc   :
 *     version: 1.0
 * </pre>
 */
const val STATUS_BE_CONFIRM: Int = 0
const val STATUS_CONFIRMED = 1

enum class DeviceCatagory(val categoryPath: String) {
    DEVICE_CATEGORY_VACUUM("/lifeapps/vacuum"),
    DEVICE_CATEGORY_HOLD("/lifeapps/hold"),

    @Deprecated(message = "debuggable")
    DEVICE_CATEGORY_VACUUM1("/dreame/vacuum"),

    @Deprecated(message = "debuggable")
    DEVICE_CATEGORY_HOLD1("/dreame/hold"),


}

data class DeviceListReq(
    val current: Int,
    val size: Int,
    val lang: String,
) {
    var sharedStatus: Int? = null
    var master: Boolean? = null

    constructor(
        current: Int,
        size: Int,
        lang: String,
        sharedStatus: Int? = null,
        master: Boolean? = null
    ) : this(current, size, lang) {
        this.sharedStatus = sharedStatus
        this.master = master
    }
}

data class DeviceListRes(
    @SerializedName("page")
    val page: Page?
)

data class Page(
    @SerializedName("current")
    val current: String?,
    @SerializedName("hitCount")
    val hitCount: Boolean?,
    @SerializedName("optimizeCountSql")
    val optimizeCountSql: Boolean?,
    @SerializedName("orders")
    val orders: List<String>?,
    @SerializedName("pages")
    val pages: String?,
    @SerializedName("records")
    val records: List<Device>?,
    @SerializedName("searchCount")
    val searchCount: Boolean?,
    @SerializedName("size")
    val size: String?,
    @SerializedName("total")
    val total: String?
)


@Parcelize
data class Device(
    @SerializedName("battery")
    val battery: Int?,
    @SerializedName("bindDomain")
    val bindDomain: String?,
    @SerializedName("customName")
    val customName: String?,
    @SerializedName("deviceInfo")
    val deviceInfo: DeviceInfo?,
    @SerializedName("did")
    val did: String?,
    @SerializedName("featureCode")
    val featureCode: Int?,
    @SerializedName("id")
    val id: String?,
    @SerializedName("lang")
    val lang: String?,
    @SerializedName("latestStatus")
    val latestStatus: Int?,
    @SerializedName("master")
    val master: Boolean?,
    @SerializedName("masterName")
    val masterName: String?,
    @SerializedName("masterUid")
    val masterUid: String?,
    @SerializedName("masterUid2UUID")
    val masterUid2UUID: String?,
    @SerializedName("model")
    val model: String?,
    @SerializedName("online")
    val online: Boolean?,
    @SerializedName("permissions")
    val permissions: String?,
    @SerializedName("property")
    val `property`: String?,
    @SerializedName("region")
    val region: String?,
    @SerializedName("sharedStatus")
    val sharedStatus: Int?,
    @SerializedName("sharedTimes")
    val sharedTimes: Int?,
    @SerializedName("updateTime")
    val updateTime: String?,
    @SerializedName("ver")
    val ver: String?,
    @SerializedName("videoStatus")
    val videoStatus: String?,
    /**
     * 视频监控状态
     * 0: 关闭
     * >=1: 开启
     */
    @SerializedName("monitorStatus")
    val monitorStatus: Int?,
    @SerializedName("featureCode2")
    val featureCode2: Int?,
    @SerializedName("vendor")
    val vendor: String?,

    val supportFastCommand: Boolean?,
    val fastCommandList: List<FastCommand>?,
    val cleanArea: Float?,
    val cleanTime: Int?,

    // 本地使用字段
    @Transient
    val currentControlTab: Int?,
    @Transient
    val isLocalCache: Boolean?,

    ) : Parcelable {
    var iotId: String = ""
        get() {
            if (TextUtils.isEmpty(field)) {
                property?.let { _property ->
                    try {
                        val propertyJson = JSONObject(_property)
                        field = propertyJson.optString("iotId", "")
                    } catch (e: JSONException) {
                        e.printStackTrace()
                    }
                }
            }
            return field
        }

    fun aliDevice(): Boolean {
        return deviceInfo?.feature?.contains("video_ali") == true
    }

    fun isSupportFastCommand(): Boolean {
        return deviceInfo?.feature?.contains("fastCommand") == true
    }

    /**
     * 同时支持清扫与视频
     */
    fun supportVideoMultitask(): Boolean {
        val featureCode = Math.max(featureCode ?: 0, 0)
        val featureCode2 = Math.max(featureCode2 ?: 0, 0)
        val value = featureCode or featureCode2
        return value and 4 == 4
    }

    fun getDeviceHost(): String {
        return if (!TextUtils.isEmpty(bindDomain)) {
            bindDomain?.split(".")?.toTypedArray()?.get(0) ?: ""
        } else ""
    }

    fun getExecutingFastCommand(): Pair<Long, String> {
        if (fastCommandList != null) {
            for (fastCommand in fastCommandList) {
                val state = fastCommand.state
                if ("1" == state || "0" == state) {
                    return fastCommand.id to state
                }
            }
        }
        return -1L to ""
    }

    fun isShowVideo(): Boolean {
        val featureCode = if ((featureCode ?: 0) < 0) 0 else featureCode ?: 0
        val featureCode2 = if ((featureCode2 ?: 0) < 0) 0 else featureCode2 ?: 0
        val value = featureCode or featureCode2
        return value and 1 != 0
    }

    fun hasVideoPermission(): Boolean {
        if (master == true) {
            return true
        }
        return permissions?.contains("VIDEO", true) == true
    }

    fun getFeatureCode(): Int {
        val code1 = Math.max(featureCode!!, 0)
        val code2 = Math.max(featureCode2!!, 0)
        return code1 or code2
    }
}

@Parcelize
data class DeviceInfo(
    @SerializedName("categoryPath")
    val categoryPath: String?,
    @SerializedName("createdAt")
    val createdAt: String?,
    @SerializedName("displayName")
    val displayName: String?,
    @SerializedName("extensionId")
    val extensionId: String?,
    @SerializedName("feature")
    val feature: String?,
    @SerializedName("icon")
    val icon: Image?,
    @SerializedName("images")
    val images: List<Image>?,
    @SerializedName("mainImage")
    val mainImage: Image?,
    @SerializedName("model")
    val model: String?,
    @SerializedName("overlook")
    val overlook: Image?,
    @SerializedName("popup")
    val popup: Image?,
    @SerializedName("productId")
    val productId: String?,
    @SerializedName("remark")
    val remark: String?,
    @SerializedName("scType")
    val scType: String?,
    @SerializedName("status")
    val status: String?,
    @SerializedName("updatedAt")
    val updatedAt: String?,
    @SerializedName("permit")
    val permit: String?,
    @SerializedName("videoDynamicVendor")
    val videoDynamicVendor: Boolean?
) : Parcelable

@Parcelize
data class Image(
    @SerializedName("as")
    val asX: String?,
    @SerializedName("caption")
    val caption: String?,
    @SerializedName("height")
    val height: String?,
    @SerializedName("imageUrl")
    val imageUrl: String?,
    @SerializedName("smallImageUrl")
    val smallImageUrl: String?,
    @SerializedName("width")
    val width: String?
) : Parcelable

@Parcelize
data class FastCommand(
    @SerializedName("id")
    val id: Long,
    @SerializedName("name")
    val name: String?,

    /**
     * 1正在执行
     * 0暂停
     * 空字符串：非任务中
     */
    @SerializedName("state")
    var state: String?,
) : Parcelable

data class DeleteDeviceReq(
    @SerializedName("did")
    val did: String
)

