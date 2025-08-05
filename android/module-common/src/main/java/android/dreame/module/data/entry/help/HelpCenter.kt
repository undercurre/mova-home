package android.dreame.module.data.entry.help

import android.os.Parcel
import android.os.Parcelable


data class HelpCenterProductItemRes(
    val displayName: String?,
    val mainImage: MainImage?,
    val model: String?,
    val productId: String?,
    var sortOrder: Int = Int.MAX_VALUE,
    val did: String?,
    val ver: String?
) : Parcelable {
    constructor(parcel: Parcel) : this(
        parcel.readString(),
        parcel.readParcelable(MainImage::class.java.classLoader),
        parcel.readString(),
        parcel.readString(),
        parcel.readInt(),
        parcel.readString(),
        parcel.readString()
    ) {
    }

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeString(displayName)
        parcel.writeParcelable(mainImage, flags)
        parcel.writeString(model)
        parcel.writeString(productId)
        parcel.writeInt(sortOrder)
        parcel.writeString(did)
        parcel.writeString(ver)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<HelpCenterProductItemRes> {
        override fun createFromParcel(parcel: Parcel): HelpCenterProductItemRes {
            return HelpCenterProductItemRes(parcel)
        }

        override fun newArray(size: Int): Array<HelpCenterProductItemRes?> {
            return arrayOfNulls(size)
        }
    }
}

data class MainImage(
    val `as`: String?,
    val caption: String?,
    val height: Int,
    val imageUrl: String?,
    val smallImageUrl: String?,
    val width: Int,
) : Parcelable {
    constructor(parcel: Parcel) : this(
        parcel.readString(),
        parcel.readString(),
        parcel.readInt(),
        parcel.readString(),
        parcel.readString(),
        parcel.readInt()
    ) {
    }

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeString(`as`)
        parcel.writeString(caption)
        parcel.writeInt(height)
        parcel.writeString(imageUrl)
        parcel.writeString(smallImageUrl)
        parcel.writeInt(width)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<MainImage> {
        override fun createFromParcel(parcel: Parcel): MainImage {
            return MainImage(parcel)
        }

        override fun newArray(size: Int): Array<MainImage?> {
            return arrayOfNulls(size)
        }
    }

}


data class AfterSaleInfoRes(
    val onlineService: Int?,
    val contactNumber: String?,
    val website: String?,
    val email: String?,
    val country: String?,
    var ext:String?
)

data class ContactUsGroupItemBean(
    var key: String?,
    val name: String?,
    val valueList: List<ContactUsChildItemBean>?,
    val tag:String? = null /* 本地字段，用来区分 */
)
data class ContactUsChildItemBean(
    val channelContent: String?,
    val jumpContent: String?,
    val androidJumpLink: String?,
    val iosJumpLink: String?
)