package android.dreame.module.data.entry.mall

import android.dreame.module.data.network.MallSignUtils
import androidx.annotation.Keep
import com.google.gson.annotations.JsonAdapter

@Keep
data class MallPersonInfoReq(
    val user_id: String, val sessid: String,
    var sign: String = "", val sign_time: Long = System.currentTimeMillis() / 1000,
    val api: String = "a_1664246268", val version: String = "1.0.0",
)

fun MallPersonInfoReq.toMap(): Map<String, String> {
    val map = mutableMapOf<String, String>()
    map["user_id"] = this.user_id
    map["sessid"] = this.sessid
    map["sign_time"] = this.sign_time.toString()
    map["version"] = this.version
    map["api"] = this.api
    map["sign"] = MallSignUtils.mallCalculateSign(map)
    return map
}


@Keep
data class MallPersonInfoRes(
    val user_id: String, val nick: String, val avatar: String, var point: Int, val coupon: Int,
    val wait_pay: Int, val wait_send: Int, val wait_receive: Int, val finished: Int, val refunding: Int,
    val reg_popup_count: Int, val order_popup_count: Int, val order_reward_point: Int, val reg_reward_point: Int
)