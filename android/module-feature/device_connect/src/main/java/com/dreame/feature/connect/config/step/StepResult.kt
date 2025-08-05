package com.dreame.smartlife.config.step


/**
 * 配网步骤结果
 */
data class StepResult(
    var stepName: StepName,
    var stepState: StepState,
    var stepId: Int = SmartStepHelper.instance.getCurrentStepId(),
    var canManualConnect: Boolean = true,
    var reason: String = "",
    val map: Map<String, Any>? = null
)

/**
 * 配网步骤
 */
enum class StepName(var step: Int) {
    STEP_CONNECT(1),
    STEP_TRANSFORM(2),
    STEP_PAIR(3),
    STEP_CHECK(4),
    STEP_QR_NET_PAIR(5),
    STEP_MAUNAL(6),

    // 割草机新增
    STEP_PIN_CODE_GET(7),
    STEP_PIN_CODE_INPUT(8),
    STEP_PIN_CODE_BIND(9),
    STEP_ROUTE_CONFIG_NET(10),
    STEP_ROUTE_CONNECT_NET(11),

}

/**
 * 配网结果状态
 */
enum class StepState {
    START,
    SUCCESS,
    FAILED,
    STOP,
}

/**
 *手动配网页面点击事件
 */
const val CLICK_MANUAL_SETTING = 11001

/**
 * 绑定PinCode
 */
const val CLICK_PIN_CODE_CONNECT = 11002
const val CLICK_PIN_CODE_BIND = 11003
const val CLICK_PIN_CODE_BIND_ERROR = 11004
const val CLICK_PIN_CODE_CONFIG = 11005
const val CLICK_PIN_CODE_CONFIG_SKIP = 11006
const val CLICK_PIN_CODE_BIND_WIFI = 11007

/**
 * 断开蓝牙
 */
const val CODE_DISCONNECT_BLE = 21001
