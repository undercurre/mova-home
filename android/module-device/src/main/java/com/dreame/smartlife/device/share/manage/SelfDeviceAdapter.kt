package com.dreame.smartlife.device.share.manage

import android.dreame.module.data.entry.Device
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.graphics.Color
import android.widget.ImageView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.smartlife.device.R

class SelfDeviceAdapter(
    val onItemClick: ((
        did: String?,
        deviceName: String?,
        pid: String?,
        showShareFeature: Boolean
    ) -> Unit)? = null
) :
    BaseQuickAdapter<Device, BaseViewHolder>(
        R.layout.item_share_device_self
    ) {
    override fun convert(holder: BaseViewHolder, item: Device) {
        val ivDeviceIcon = holder.getView<ImageView>(R.id.iv_device_pic)
        ImageLoaderProxy.getInstance().displayImage(
            holder.itemView.context,
            item.deviceInfo?.mainImage?.imageUrl ?: "",
            R.drawable.icon_robot_placeholder,
            ivDeviceIcon
        )
        var deviceName = item.customName
        if (deviceName.isNullOrEmpty()) {
            deviceName = item.deviceInfo?.displayName
        }
        if (deviceName.isNullOrEmpty()) {
            deviceName = item.deviceInfo?.model
        }
        holder.setText(R.id.tv_device_name, deviceName)
        if (item.sharedTimes == 0) {
            holder.setText(R.id.tv_share_state, R.string.not_share)
            holder.setTextColor(R.id.tv_share_state, ContextCompat.getColor(context, R.color.common_textSecond))
        } else {
            holder.setText(R.id.tv_share_state, R.string.shared)
            holder.setTextColor(R.id.tv_share_state, ContextCompat.getColor(context, R.color.common_green1))
        }
        holder.getView<ConstraintLayout>(R.id.cl_item_container).setOnShakeProofClickListener {
            onItemClick?.invoke(
                item.did,
                deviceName,
                item.deviceInfo?.productId,
                !item.deviceInfo?.permit.isNullOrEmpty()
            )
        }
    }

}