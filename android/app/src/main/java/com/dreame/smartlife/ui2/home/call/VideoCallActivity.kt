package com.dreame.smartlife.ui2.home.call

import android.content.Context
import android.content.Intent
import android.dreame.module.RouteServiceProvider
import android.dreame.module.bean.DeviceListBean
import android.dreame.module.constant.Constants
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.rn.RNDebugActivity
import android.dreame.module.rn.load.RnActivity
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.GsonUtils
import android.os.Build
import android.os.CountDownTimer
import android.os.VibrationEffect
import android.os.Vibrator
import android.text.TextUtils
import androidx.activity.OnBackPressedCallback
import androidx.activity.viewModels
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.databinding.ActivityVideoCallBinding
import com.dreame.smartlife.viewmodel.MonitorViewModel
import org.greenrobot.eventbus.EventBus


class VideoCallActivity : BaseActivity<ActivityVideoCallBinding>() {
    private val monitorViewModel by viewModels<MonitorViewModel>()

    private var device: DeviceListBean.Device? = null
    private var countDown: CountDownTimer? = null
    private lateinit var vibrator: Vibrator

    override fun initData() {
        vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        device = intent?.getParcelableExtra(Constants.KEY_DEVICE)
        onBackPressedDispatcher.addCallback(object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
            }
        })
        startVibrator()
        autoDismiss()
    }

    override fun initView() {
        val displayName: String = if (!TextUtils.isEmpty(device?.customName)) {
            device?.customName ?: ""
        } else {
            device?.deviceInfo?.displayName ?: ""
        }
        binding.tvName.text = displayName
        binding.ivNegative.setOnShakeProofClickListener {
            device?.let {
                monitorViewModel.acceptOrRejectCall(false, it, { finish() }, { finish() })
            }
        }
        binding.ivPositive.setOnShakeProofClickListener {
            device?.let {
                monitorViewModel.acceptOrRejectCall(true, it, {
                    val preActivity = ActivityUtil.getInstance().mActivityStack[1]
                    if (preActivity is RnActivity || preActivity is RNDebugActivity) {
                        preActivity.finish()
                    }
                    val ext = mutableMapOf(
                        "did" to device?.did,
                        "model" to device?.model,
                        "extra" to mutableMapOf("type" to "videoCall")
                    )
                    RouteServiceProvider.getService<IFlutterBridgeService>()
                        ?.sendSchemeEvent("DEVICE", GsonUtils.toJson(ext))
                    finish()
                })
            }
        }
        startService(Intent(this, VideoCallService::class.java).apply {
            putExtra(Constants.KEY_NAME, displayName)
        })
    }

    override fun observe() {

    }

    override fun finish() {
        vibrator.cancel()
        countDown?.cancel()
        countDown = null
        stopService(Intent(this, VideoCallService::class.java))
        super.finish()
    }

    private fun startVibrator() {
        val DELAY = 0
        val VIBRATE = 800
        val SLEEP = 800
        val START = 0
        val vibratePattern = longArrayOf(DELAY.toLong(), VIBRATE.toLong(), SLEEP.toLong())
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createWaveform(vibratePattern, START))
        } else {
            vibrator.vibrate(vibratePattern, START)
        }
    }

    private fun autoDismiss() {
        countDown = DismissTimer(70 * 1000, 1000).apply {
            start()
        }
    }

    private inner class DismissTimer(millisInFuture: Long, countDownInterval: Long) :
        CountDownTimer(millisInFuture, countDownInterval) {
        override fun onTick(millisUntilFinished: Long) {
        }

        override fun onFinish() {
            finish()
        }

    }
}