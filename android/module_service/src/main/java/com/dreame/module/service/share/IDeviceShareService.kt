package com.dreame.module.service.share



interface IDeviceShareService  {
    fun showShareDialog(
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
    )
}