package android.dreame.module.data.entry

import com.google.gson.annotations.SerializedName

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/07/29
 *     desc   :登录成功返回数据实体类
 *     version: 1.0
 * </pre>
 */
data class OAuthRes(
    @field: SerializedName("access_token") val accessToken: String?,
    @field: SerializedName("token_type") val tokenType: String,
    @field: SerializedName("refresh_token") val refreshToken: String,
    @field: SerializedName("expires_in") val expiresIn: String,
    @field: SerializedName("scope") val scope: String,
    @field: SerializedName("tenant_id") val tenantId: String,
    @field: SerializedName("country") val country: String,
    @field: SerializedName("user_name") val userName: String,
    @field: SerializedName("real_name") val realName: String,
    @field: SerializedName("permission") val permission: String,
    @field: SerializedName("avatar") val avatar: String,
    @field: SerializedName("client_id") val clientId: String,
    @field: SerializedName("role_name") val roleName: String,
    @field: SerializedName("uid") val uid: String,
    @field: SerializedName("user_id") val userId: String,
    @field: SerializedName("role_id") val roleId: String,
    @field: SerializedName("nick_name") val nickName: String,
    @field: SerializedName("user_token") val userToken: Boolean,
    @field: SerializedName("lang") val lang: String,
    @field: SerializedName("jti") val jti: String,
    @field: SerializedName("domain") val domain: String,
    @field: SerializedName("region") val region: String,
    @field: SerializedName("code") val code:Int = 0
)