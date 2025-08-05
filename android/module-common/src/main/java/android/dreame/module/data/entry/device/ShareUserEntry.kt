package android.dreame.module.data.entry.device

import android.os.Parcel
import android.os.Parcelable


data class ShareUserRes(
    val avatar: String?,
    val name: String?,
    val uid: String?,
    val sharedStatus: Int = 0 //0：待接受  1：已接受
): Parcelable {
    constructor(parcel: Parcel) : this(
        parcel.readString(),
        parcel.readString(),
        parcel.readString(),
        parcel.readInt()
    ) {
    }

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeString(avatar)
        parcel.writeString(name)
        parcel.writeString(uid)
        parcel.writeInt(sharedStatus)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<ShareUserRes> {
        override fun createFromParcel(parcel: Parcel): ShareUserRes {
            return ShareUserRes(parcel)
        }

        override fun newArray(size: Int): Array<ShareUserRes?> {
            return arrayOfNulls(size)
        }
    }
}

data class ShareUserListReq(
    val did: String
)

data class DeleteShareUserReq(
    val did: String,
    val shareUid: String
)

