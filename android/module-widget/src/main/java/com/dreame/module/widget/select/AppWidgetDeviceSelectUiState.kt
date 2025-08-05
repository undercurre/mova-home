package com.dreame.module.widget.select

import android.dreame.module.data.entry.Device
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
data class AppWidgetDeviceSelectUiState(
    val did: String,
    val deviceName: String,
    val deviceImageUrl: String,
    val currentDevice: Device? = null,
    val deviceBitmap: Bitmap? = null,
    val appWidgetId: Int,
    val appWidgetType: Int,
    val appWidgetIds: List<Int>,
    val enable: Boolean,
    val isRefresh: Boolean,
    val page: Int,
    val pageSize: Int,
    val deviceList: List<SelectDevice>?,
    val params: MutableMap<String, Any>,
    val isSelectOrBind: Boolean,// true：select false: bind
    val isLoading: Boolean,
    val isChangeDevice: Boolean,

    ) : UiState

sealed class AppWidgetDeviceSelectUiEvent : UiEvent {
    data class ShowToast(val message: String?) : AppWidgetDeviceSelectUiEvent()
    object DeviceLinkedSuccess : AppWidgetDeviceSelectUiEvent()
    object DeviceSelectSuccess : AppWidgetDeviceSelectUiEvent()
    object DeviceAdd : AppWidgetDeviceSelectUiEvent()
    object SignIn : AppWidgetDeviceSelectUiEvent()

}

sealed class AppWidgetDeviceSelectUiAction : UiAction {
    data class InitData(
        val appWidgetId: Int,
        val appWidgetType: Int,
        val appWidgetIds: List<Int>,
        val isSelectOrBind: Boolean,
        val isChangeDevice: Boolean = false
    ) :
        AppWidgetDeviceSelectUiAction()

    object RefreshDevice : AppWidgetDeviceSelectUiAction()
    object LoadMoreDevice : AppWidgetDeviceSelectUiAction()

    data class DeviceSelected(val did: String) : AppWidgetDeviceSelectUiAction()
    object DeviceLinked : AppWidgetDeviceSelectUiAction()
    object DeviceSelect : AppWidgetDeviceSelectUiAction()

}