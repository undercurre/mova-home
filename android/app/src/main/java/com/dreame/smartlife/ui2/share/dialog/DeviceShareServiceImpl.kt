package com.dreame.smartlife.ui2.share.dialog

import android.content.Context
import android.dreame.module.RoutPath
import android.dreame.module.util.ActivityUtil
import androidx.appcompat.app.AppCompatActivity
import com.therouter.router.Route
import com.dreame.module.service.share.IDeviceShareService

@Route(path = RoutPath.SHARE_DEVICE_SHARE_MESSAGE_SERVICE)
class DeviceShareServiceImpl : IDeviceShareService {
    override fun showShareDialog(
        formMessage: Boolean,
        title: String?,
        deviceName: String?,
        deviceDes: String?,
        devicePic: String?,
        messageId: String?,
        ackResult: Int?,
        did: String?,
        model: String?,
        ownUid: String?
    ) {
        val currentActivity = ActivityUtil.getInstance().currentActivity
        BottomShareMessageDialog(
            currentActivity!!,
            formMessage,
            title,
            deviceName,
            deviceDes,
            devicePic,
            messageId,
            ackResult,
            did,
            model,
            ownUid
        ).show();
    }


}

@com.therouter.inject.ServiceProvider
fun deviceShareServiceProvider(): IDeviceShareService = DeviceShareServiceImpl()