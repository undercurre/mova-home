package com.dreame.feature.connect.device.scan.uiconfig

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.dreame.module.ext.decodeQuotedSSID
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.LogUtil
import android.net.wifi.WifiManager
import android.os.SystemClock
import android.view.View
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.dreame.feature.connect.device.scan.DevcieScanNearbyActivity
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDevcieScanNearbyBinding
import io.reactivex.Flowable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.internal.disposables.ListCompositeDisposable
import io.reactivex.schedulers.Schedulers
import java.util.concurrent.TimeUnit

class ScanNearByDeviceUiConfig(activity: DevcieScanNearbyActivity, binding: ActivityDevcieScanNearbyBinding) :
    DeviceUiConfig(activity, binding) {

    private var timestamp: Long = 0

    private val disposableContainer by lazy { ListCompositeDisposable() }

    override fun onActivityCreate() {
        super.onActivityCreate()
        binding.layoutScan.tvConfirm.setOnShakeProofClickListener {
            // 跳转到手动连接
            EventCommonHelper.eventCommonPageInsert(
                ModuleCode.PairNetNew.code,
                PairNetEventCode.ManualConnectAp.code,
                hashCode(),
                "", activity.viewModel.uiStates.value.productInfo?.realProductModel ?: activity.viewModel.uiStates.value.productInfo?.productModel ?: "",
                str1 = BuriedConnectHelper.currentSessionID()
            )
            activity.gotoMaunalConnect()
        }
//        binding.layoutScan.tvMaunal.setOnShakeProofClickListener {
//            // 跳转到手动连接
//            activity.gotoMaunalConnect()
//        }

        binding.layoutScan.tvScanAgain.setOnShakeProofClickListener {
            scanAgain()
            activity.scanAgain()
        }

    }

    override fun onScanStart() {
        timestamp = SystemClock.elapsedRealtime()
        if (binding.layoutScan.progressBar.progress < 100) {
            startSendCodeCountdown()
        }
    }

    override fun onShow() {
        binding.layoutScan.clRoot.visibility = View.VISIBLE
    }

    override fun onHide() {
        binding.layoutScan.clRoot.visibility = View.GONE
    }

    override fun onScanStop(nothing: Boolean) {
        cancelDisposable()
        scanNothing()
    }

    override fun onScanProgress(progress: Int) {

    }

    private fun startSendCodeCountdown(time: Int = 60) {
        val period: Long = 200
        val count = time.toLong() * (1000 / period)
        val slice = count / 100
        cancelDisposable()
        val disposable = Flowable.intervalRange(1, count, 0, period, TimeUnit.MILLISECONDS)
            .onBackpressureLatest()
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
            .doOnSubscribe {
                timestamp = SystemClock.elapsedRealtime()
            }
            .doOnNext {
                val progress = (it / slice).toInt()
                LogUtil.v("sunzhibin", "------------- $progress")
                if (binding.layoutScan.clRoot.visibility == View.VISIBLE && binding.layoutScan.progressBar.visibility == View.VISIBLE) {
                    binding.layoutScan.progressBar.progress = progress

//                    if (progress > 20 && BuildConfig.DEBUG) {
//                        binding.layoutScan.tvMaunal.visibility = View.VISIBLE
//                    }
                }
            }
            .doOnError {
                LogUtil.e("sunzhibin", "startSendCodeCountdown error: $it")
            }
            .doOnComplete {
                //
                timestamp = SystemClock.elapsedRealtime()
                scanNothing()
                cancelDisposable()
            }
            .subscribe()
        disposableContainer.add(disposable)
    }

    private fun scanNothing() {
        val wifiManager = activity.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val ssidList = if (ActivityCompat.checkSelfPermission(
                activity,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            wifiManager.scanResults.distinctBy { it.SSID }
                .map {
                    it.SSID.decodeQuotedSSID()
                }.joinToString(separator = ",")
        } else {
            DeviceScanCache.getWifiDeviceScan().value?.map {
                it.wifiName
            }?.joinToString(separator = ",") ?: ""
        }
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.ScanApFail.code, hashCode(),
            "", activity.viewModel.uiStates.value.productInfo?.realProductModel ?: activity.viewModel.uiStates.value.productInfo?.productModel ?: "",
            str1 = BuriedConnectHelper.currentSessionID(), str2 = ssidList
        )
        binding.layoutScan.tvContent.text = activity.getString(R.string.text_search_datasource_empty)
        binding.layoutScan.tvContent2.visibility = View.GONE
        binding.layoutScan.progressBar.progress = 100
        binding.layoutScan.tvScanAgain.visibility = View.VISIBLE
        binding.layoutScan.tvConfirm.visibility = View.VISIBLE
        binding.layoutScan.tvMaunal.visibility = View.GONE
        binding.layoutScan.ivDevice.setImageDrawable(ContextCompat.getDrawable(activity, R.drawable.ic_placeholder_device_scan_nothing))

        // activity finish scan
        activity.finishScan()
    }

    private fun scanAgain() {
        binding.layoutScan.tvContent.text = activity.getString(R.string.text_search_nearby_robot)
        binding.layoutScan.tvContent2.visibility = View.VISIBLE
        binding.layoutScan.tvScanAgain.visibility = View.GONE
        binding.layoutScan.tvConfirm.visibility = View.GONE
        binding.layoutScan.tvMaunal.visibility = View.GONE
        binding.layoutScan.progressBar.progress = 0
        binding.layoutScan.ivDevice.setImageDrawable(ContextCompat.getDrawable(activity, R.drawable.ic_placeholder_device_scan))

    }

    override fun onActivityStop() {
        super.onActivityStop()
        if (activity.isFinishing) {
            cancelDisposable()
        }
    }

    fun cancelDisposable() {
        disposableContainer.clear()
    }
}