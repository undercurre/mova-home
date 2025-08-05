package android.dreame.module.data.entry

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/02/28
 *     desc   :
 *     version: 1.0
 * </pre>
 */
data class AlexaApp2AppReq(
    val os: String
)

data class AlexaApp2AppRes(
    val lwaUrl: String,
    val applinkUrl: String,
    val alreadyBind: Boolean
)

data class AlexaLinkAuthReq(
    val awsCode: String,
    val redirectUrl: String
)

data class AlexaLinkAuthRes(
    val boolean: Boolean
)


data class AlexaBindAuthReq(
    val client_id: String?,
    val redirect_uri: String?,
    val scope: String?,
    val response_type: String?,
    val state: String?
)

data class AlexaBindAuthRes(
    val code: String?,
)