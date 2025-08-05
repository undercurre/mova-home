package android.dreame.module.data.entry

data class SendEmailCodeReqCover(
    val email: String, val lang: String,
    val skipEmailBoundVerify: Boolean,
    val token: String,
    val sessionId: String,
    val sig: String,
)
