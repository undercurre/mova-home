package com.dreame.module.widget.select.bean

import android.dreame.module.data.entry.Device

data class SelectDevice(
    val deviceName: String, val did: String, val imgUrl: String,
    val device: Device, var isSelect: Boolean, var isUsed: Boolean, val isMaster: Boolean
)