package com.dreame.feature.connect.device.scan.uiconfig

import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.view.View
import com.dreame.feature.connect.device.scan.DevcieScanNearbyActivity
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDevcieScanNearbyBinding

class OneNearByDeviceUiConfig(activity: DevcieScanNearbyActivity, binding: ActivityDevcieScanNearbyBinding) : DeviceUiConfig(activity, binding) {
    override fun onShow() {
        binding.layoutScanOne.clRoot.visibility = View.VISIBLE
        binding.layoutScanOne.indicator.setIndex(4)
    }

    override fun onHide() {
        binding.layoutScanOne.clRoot.visibility = View.GONE

    }

    override fun onScanUpdateList(list: List<DreameWifiDeviceBean>) {

        val ivDevice = binding.layoutScanOne.ivDevice
        val tvContent = binding.layoutScanOne.tvContent

        list.firstOrNull()?.let { device ->
            ImageLoaderProxy.getInstance().displayImage(activity, device.product_pic_url, R.drawable.icon_robot_placeholder, ivDevice)
            val newName = device.product_model?.replace(".", "-")?.let {
                device.wifiName?.replace(it, "")
            }

            val showName = "${(device.name ?: "")}${newName}"
            tvContent.text = showName

            binding.layoutScanOne.tvConfirm.setOnShakeProofClickListener {
                activity.gotoSelectConnect(device)
            }
        }
    }

    override fun onScanStart() {
        super.onScanStart()
    }

    override fun onScanStop(nothing: Boolean) {
        super.onScanStop(nothing)

        // 重新扫描
        if (!isStoped) {
            activity.scanAgain(10 * 1000)
        }
    }


}