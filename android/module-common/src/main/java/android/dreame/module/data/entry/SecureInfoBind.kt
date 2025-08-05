package android.dreame.module.data.entry


data class SecureInfoBindReq(
    val codeKey: String,
    val phone: String? = null,
    val phoneCode: String? = null,
    val email: String? = null,
)

data class SecureInfoBindPhoneReqCover(
    val codeKey: String,
    val phone: String? = null,
    val phoneCode: String? = null,
    val email: String? = null,
    val coverOtherAccountPhone: Boolean,
)

