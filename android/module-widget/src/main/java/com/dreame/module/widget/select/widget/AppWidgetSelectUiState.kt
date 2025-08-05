package com.dreame.module.widget.select.widget

import android.dreame.module.data.entry.Device
import android.dreame.module.data.entry.FastCommand
import android.graphics.Bitmap
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState
import com.dreame.module.widget.select.bean.SelectDevice

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/09/05
 *     desc   :
 *     version: 1.0
 * </pre>
 */
data class AppWidgetSelectUiState(
    val did: String,
    val deviceName: String,
    val deviceImageUrl: String,
    val currentDevice: Device?,
    val deviceBitmap: Bitmap? = null,
    val appWidgetId: Int,
    val appWidgetType: Int,
    val params: MutableMap<String, Any>,
    val isLoading: Boolean,
    val isNeedShowTipsPopup: Boolean,
    ) : UiState

sealed class AppWidgetSelectUiEvent : UiEvent {
    data class ShowToast(val message: String?) : AppWidgetSelectUiEvent()
    object DeviceLinked : AppWidgetSelectUiEvent()
    object ShowTips : AppWidgetSelectUiEvent()
    object DismissTips : AppWidgetSelectUiEvent()

}

sealed class AppWidgetSelectUiAction : UiAction {
    /**
     * 添加小组件
     */
    data class InitData(val deviceName: String, val deviceImageUrl: String, val did: String, val currentDevice: Device) : AppWidgetSelectUiAction()

    data class AddAppWidget(val position: Int) : AppWidgetSelectUiAction()
    data class LinkAppWidget(val appWidgetId: Int) : AppWidgetSelectUiAction()

}