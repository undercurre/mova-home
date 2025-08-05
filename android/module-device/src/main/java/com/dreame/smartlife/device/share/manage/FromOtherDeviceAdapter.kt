package com.dreame.smartlife.device.share.manage

import android.dreame.module.data.entry.Device
import android.dreame.module.data.getString
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.graphics.Color
import android.widget.Button
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.daimajia.swipe.SwipeLayout
import com.daimajia.swipe.implments.SwipeItemRecyclerMangerImpl
import com.daimajia.swipe.interfaces.SwipeAdapterInterface
import com.daimajia.swipe.interfaces.SwipeItemMangerInterface
import com.daimajia.swipe.util.Attributes
import com.dreame.smartlife.device.DateFormatTimeUtil
import com.dreame.smartlife.device.R

class FromOtherDeviceAdapter(
    val onItemClick: ((did: String?, pid: String?, deviceName: String?, devicePic: String?) -> Unit)?,
    val statusButtonClick: ((item: Device) -> Unit)? = null,
    val deleteClick: ((did: String?) -> Unit)? = null
) :
    BaseQuickAdapter<Device, BaseViewHolder>(
        R.layout.item_share_device_from_other
    ), SwipeAdapterInterface, SwipeItemMangerInterface {

    companion object {
        private const val STATUS_TO_CONFIRM = 0
        private const val STATUS_CONFIRMED = 1
    }

    var mItemManger = SwipeItemRecyclerMangerImpl(this)

    override fun convert(holder: BaseViewHolder, item: Device) {
        mItemManger.bindView(holder.itemView, holder.layoutPosition)
        val swipeLayout = holder.getView<SwipeLayout>(R.id.sl_container)
        swipeLayout.close(false)

        val ivDeviceIcon = holder.getView<ImageView>(R.id.iv_device_pic)
        val tvDeviceName = holder.getView<TextView>(R.id.tv_device_name)
        val tvDeviceDes = holder.getView<TextView>(R.id.tv_device_des)
        val tvDeviceTime = holder.getView<TextView>(R.id.tv_device_time)
        val btnOperation = holder.getView<TextView>(R.id.tv_operation)


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
        tvDeviceName.text = deviceName

        var displayMasterName = item.masterName
        if (displayMasterName.isNullOrEmpty()) {
            displayMasterName = item.masterUid
        }
        val des = String.format(context.getString(R.string.share_from), displayMasterName)
        tvDeviceDes.text = des
        tvDeviceTime.text = DateFormatTimeUtil.dateFormatFromGMT(item.updateTime)
        if (item.sharedStatus == STATUS_TO_CONFIRM) {
//            btnOperation.setBackgroundResource(R.drawable.shape_devicelist_wait_for_accept)
            btnOperation.setTextColor(ContextCompat.getColor(context, R.color.common_warn1))
            btnOperation.text = getString(R.string.waiting_receive)
        } else {
//            btnOperation.setBackgroundResource(R.drawable.shape_devicelist_accepted)
//            btnOperation.setTextColor(Color.parseColor("#55E53C"))
            btnOperation.setTextColor(ContextCompat.getColor(context, R.color.common_green1))
            btnOperation.text = getString(R.string.already_accept)
        }
        btnOperation.setOnShakeProofClickListener {
            if (item.sharedStatus == STATUS_TO_CONFIRM) {
                statusButtonClick?.invoke(item)
            } else {
                if (!item.deviceInfo?.permit.isNullOrEmpty()) {
                    onItemClick?.invoke(
                        item.did,
                        item.deviceInfo?.productId,
                        deviceName,
                        item.deviceInfo?.mainImage?.imageUrl
                    )
                }
            }
        }
        holder.getView<RelativeLayout>(R.id.rl_cancel_share).setOnShakeProofClickListener {
            deleteClick?.invoke(item.did)
        }
        holder.getView<ConstraintLayout>(R.id.cl_item_container).setOnShakeProofClickListener {
            if (!item.deviceInfo?.permit.isNullOrEmpty()) {
                onItemClick?.invoke(
                    item.did,
                    item.deviceInfo?.productId,
                    deviceName,
                    item.deviceInfo?.mainImage?.imageUrl
                )
            }
        }
    }


    override fun getSwipeLayoutResourceId(position: Int): Int = R.id.sl_container
    override fun openItem(position: Int) {
        mItemManger.openItem(position)
    }

    override fun closeItem(position: Int) {
        mItemManger.closeItem(position)
    }

    override fun closeAllExcept(layout: SwipeLayout?) {
        mItemManger.closeAllExcept(layout)
    }

    override fun closeAllItems() {
        mItemManger.closeAllItems()
    }

    override fun getOpenItems(): MutableList<Int> {
        return mItemManger.getOpenItems()
    }

    override fun getOpenLayouts(): MutableList<SwipeLayout> {
        return mItemManger.getOpenLayouts()
    }

    override fun removeShownLayouts(layout: SwipeLayout?) {
        mItemManger.removeShownLayouts(layout)
    }

    override fun isOpen(position: Int): Boolean {
        return mItemManger.isOpen(position)
    }

    override fun getMode(): Attributes.Mode {
        return mItemManger.getMode()
    }

    override fun setMode(mode: Attributes.Mode?) {
        return mItemManger.setMode(mode)
    }
}