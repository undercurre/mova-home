package com.dreame.feature.connect.device.scan.uiconfig

import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.ext.dp
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.view.GridSpaceItemDecoration
import android.view.View
import androidx.recyclerview.widget.GridLayoutManager
import com.dreame.feature.connect.device.scan.DevcieScanNearbyActivity
import com.dreame.feature.connect.device.scan.ScanNearbyDeviceAdapter
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDevcieScanNearbyBinding

class MultiNearByDeviceUiConfig(activity: DevcieScanNearbyActivity, binding: ActivityDevcieScanNearbyBinding) :
    DeviceUiConfig(activity, binding) {

    private val scanNearbyDeviceAdapter by lazy {
        ScanNearbyDeviceAdapter().apply {
            addChildClickViewIds(R.id.cb_switch)
        }
    }

    init {
        binding.layoutScanMulti.recyclerview.apply {
            layoutManager = GridLayoutManager(activity, 2, GridLayoutManager.VERTICAL, false)
            adapter = scanNearbyDeviceAdapter
            addItemDecoration(GridSpaceItemDecoration(2, 14.dp(), 7.dp(), false, 0))
        }
        scanNearbyDeviceAdapter.setOnItemClickListener { adapter, view, position ->
            val item = scanNearbyDeviceAdapter.getItem(position)
            scanNearbyDeviceAdapter.data.onEach {
                it.isSelect = false
            }
            item.isSelect = true
            scanNearbyDeviceAdapter.setList(scanNearbyDeviceAdapter.data)

            binding.layoutScanMulti.tvConfirm.isEnabled = true
        }
        scanNearbyDeviceAdapter.setOnItemChildClickListener { adapter, view, position ->
            val item = scanNearbyDeviceAdapter.getItem(position)
            scanNearbyDeviceAdapter.data.onEach {
                it.isSelect = false
            }
            item.isSelect = true
            scanNearbyDeviceAdapter.setList(scanNearbyDeviceAdapter.data)

            binding.layoutScanMulti.tvConfirm.isEnabled = true
        }

        binding.layoutScanMulti.tvConfirm.setOnShakeProofClickListener {
            val item = scanNearbyDeviceAdapter.data.find { it.isSelect }
            activity.gotoSelectConnect(item!!)
        }
    }

    override fun onShow() {
        binding.layoutScanMulti.clRoot.visibility = View.VISIBLE
        binding.layoutScanMulti.indicator.setIndex(4)
    }

    override fun onHide() {
        binding.layoutScanMulti.clRoot.visibility = View.GONE
    }

    override fun onScanUpdateList(list: List<DreameWifiDeviceBean>) {
        scanNearbyDeviceAdapter.setList(list)
    }

    override fun onScanStart() {
        super.onScanStart()
    }

    override fun onScanStop(nothing: Boolean) {
        if (!isStoped) {
            activity.scanAgain(10 * 1000)
        }
    }

}