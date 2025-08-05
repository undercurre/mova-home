package android.dreame.module.data.entry.mall

import android.dreame.module.data.network.MallSignUtils
import androidx.annotation.Keep

@Keep
data class MallLoginReq(
    val jwtToken: String,
    var sign: String = "",
    val sign_time: Long = System.currentTimeMillis() / 1000,
    val api: String = "a_1664246268"
)

fun MallLoginReq.toMap(): Map<String, String> {
    val map = mutableMapOf<String, String>()
    map["jwtToken"] = this.jwtToken
    map["sign_time"] = this.sign_time.toString()
    map["api"] = this.api
    map["sign"] = MallSignUtils.mallCalculateSign(map)
    return map
}


@Keep
data class MallLoginRes(
    val nick_name: String, val uid: String, val phone: String,
    val phone_code: String, val avatar: String, val register_type: Int = 0,
    val update_time: Long = 0, val mall_id: String, val user_id: String,
    val sessid: String, val isTodayFirst: Int, val active_time: Long,
    val bind_popup_count: Int = 0, val other_bind_popup: Int, val bind_reward_price: Long,
    val bind_reward_point: Int = 0, val isAppRegister: Int
)

