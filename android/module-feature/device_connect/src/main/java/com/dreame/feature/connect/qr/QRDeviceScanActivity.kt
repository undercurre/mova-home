package com.dreame.feature.connect.qr

import android.Manifest
import android.content.Context
import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.base.permission.OnPermissionCallback2
import android.dreame.module.constant.Constants
import android.dreame.module.ext.dp
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.manager.LanguageManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.permission.ShowPermissionDialog
import android.dreame.module.util.toast.ToastUtils
import android.os.Build
import android.os.Bundle
import android.os.Message
import android.os.VibrationEffect
import android.os.Vibrator
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup.MarginLayoutParams
import com.therouter.router.Route
import com.blankj.utilcode.util.BarUtils
import com.blankj.utilcode.util.LogUtils
import com.dreame.feature.connect.product.ProductSelectListActivity
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.config.step.WeakHandler
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityQrDeviceScanBinding
import com.dreame.smartlife.ui.activity.main.DeviceSannerDelegateImpl
import com.dreame.tools.step.qrcodecore.ui.cameraX.CameraxScanFragment
import com.dreame.tools.step.qrcodecore.ui.cameraX.api.OnScanResultCallback
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import com.zj.mvi.core.observeEvent

/**
 * 扫码配网 + 蓝牙 + Wi-Fi扫描配网
 */
@Route(path = RoutPath.DEVICE_PRODUCT_QR)
class QRDeviceScanActivity : BaseActivity<ActivityQrDeviceScanBinding>(), OnScanResultCallback {
    private val vibrator by lazy { getSystemService(Context.VIBRATOR_SERVICE) as Vibrator }

    private val viewModel by lazy { QRDeviceScanViewModel() }

    private var deviceSannerDelegateImpl: DeviceSannerDelegateImpl? = null
    private lateinit var cameraxScanFragment: CameraxScanFragment
    private val handler = WeakHandler(object : WeakHandler.MessageHandleCallback {
        override fun handleMessage(message: Message) {
        }
    })

    override fun onCreate(savedInstanceState: Bundle?) {
        // 需要在super.onCreate之前，在init中可能用到
        val onlyScan = intent.getBooleanExtra("onlyScan", false)
        if (!onlyScan) {
            deviceSannerDelegateImpl = DeviceSannerDelegateImpl(this)
            deviceSannerDelegateImpl?.initScanner()
        }
        super.onCreate(savedInstanceState)
        BarUtils.setStatusBarLightMode(this, false)
        BarUtils.setNavBarLightMode(this, true)
    }

    override fun onDestroy() {
        handler.removeCallbacksAndMessages(null)
        super.onDestroy()
    }

    override fun onBackPressed() {
        super.onBackPressed()
        handleBack()
    }

    private fun handleBack() {
        val preActivity = ActivityUtil.getInstance().preActivity()
        if (preActivity != null && !(preActivity is QRDeviceScanActivity)) {
            EventCommonHelper.eventCommonPageInsert(
                ModuleCode.PairNetNew.code,
                PairNetEventCode.CostTime.code,
                hashCode(),
                "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
                int1 = 2,
                int2 = 2,
                int5 = BuriedConnectHelper.calculateCostTime(),
                str1 = BuriedConnectHelper.currentSessionID(),
            )
        }
    }

    override fun initView() {
        binding.tvViewQr.text = String.format("%s%s", getString(R.string.check_where_qr), " >")
        binding.clScanDevice.visibility = View.INVISIBLE
        val scanType = intent.getIntExtra("scanType", 0)
        cameraxScanFragment = CameraxScanFragment.newInstance(90.dp(), true)
        supportFragmentManager.beginTransaction().add(R.id.fragment_container, cameraxScanFragment, "cameraXScan").commit()
        cameraxScanFragment.setResultCallback(this)

        if (scanType == 2) {
            // 商城条形码 扫描
            binding.tvViewQr.visibility = View.GONE
            binding.tvWhereQrcode.text = getString(R.string.scan_sn_code)
            binding.tvCenterTitle.text = ""
            binding.tvScan.visibility = View.GONE
            binding.tvTouch.visibility = View.GONE
            binding.tvWhereQrcode.post {
                val bottom = binding.tvWhereQrcode.bottom + 80.dp()
                cameraxScanFragment.setTopOffset(bottom)
            }
        } else {
            binding.tvViewQr.post {
                val bottom = binding.tvViewQr.bottom + 20.dp()
                cameraxScanFragment.setTopOffset(bottom)
            }
        }
        binding.ivLeft.setOnShakeProofClickListener {
            setResult(RESULT_CANCELED)
            finish()
        }
        binding.tvTouch.setOnShakeProofClickListener {
            startActivity(Intent(this, ProductSelectListActivity::class.java))
        }
        binding.tvViewQr.setOnShakeProofClickListener {
            viewModel.dispatchAction(QrDeviceScanUiAction.ViewQRPoistion)
        }

        val isShowNavBar = BarUtils.isNavBarVisible(this)
        val layoutParams = binding.tvScan.layoutParams as MarginLayoutParams
        val navigationBarHeight = BarUtils.getNavBarHeight()
        val minHeight = 32.dp()
        layoutParams.bottomMargin = if (isShowNavBar) {
            if (navigationBarHeight < minHeight) {
                val height = minHeight + (minHeight / 2)
                height
            } else {
                navigationBarHeight + 10.dp()
            }
        } else minHeight
        binding.tvScan.layoutParams = layoutParams
    }

    override fun initListener() {
        binding.ivLeft.setOnShakeProofClickListener {
            handleBack()
            finish()
        }
        deviceSannerDelegateImpl?.block = { show, bean ->
            viewModel.dispatchAction(QrDeviceScanUiAction.NearbyDevice(bean))
            if (show) {
                binding.clScanDevice.visibility = View.VISIBLE
                ImageLoaderProxy.getInstance().displayImage(this@QRDeviceScanActivity, bean?.imageUrl, binding.ivDevice)
                binding.tvDeviceName.text = bean?.name ?: ""
            } else {
                binding.clScanDevice.visibility = View.INVISIBLE
            }
        }
        binding.clScanDevice.setOnShakeProofClickListener {
            viewModel.dispatchAction(QrDeviceScanUiAction.NearbyDeviceClick)
        }
    }

    override fun observe() {

        viewModel.uiEvents.observeEvent(this) { event ->
            when (event) {
                is QRDeviceScanUiEvent.ShowToast -> {
                    ToastUtils.show(event.message)
                }

                is QRDeviceScanUiEvent.RestQrScan -> {
                    // 重置扫描
                    cameraxScanFragment.startSpotAndShowRect()
                }

                is QRDeviceScanUiEvent.ManualConnect -> {
                    startActivity(Intent(this, ProductSelectListActivity::class.java))
                }

                is QRDeviceScanUiEvent.ShowFailedDialog -> {
                    showFailedDialog()
                }

                is QRDeviceScanUiEvent.QrCodeAddPluginList -> {
                    // 扫码添加插件列表
                    setResult(RESULT_OK, Intent().putExtra(Constants.EXTRA_RESULT, event.result))
                    finish()
                }

                is QRDeviceScanUiEvent.BarcodeSuccess -> {
                    // 扫码SN码
                    setResult(RESULT_OK, Intent().putExtra(Constants.EXTRA_RESULT, event.result))
                    finish()
                }

                else -> {

                }
            }
        }
    }

    override fun initData() {
        val scanType = intent.getIntExtra("scanType", 0)
        val fromHome = intent.getBooleanExtra("fromHome", false)
        val filterQrCode = "ADD_PLUGIN" != intent.getStringExtra("operation")
        val language = LanguageManager.getInstance().getLangTag(this@QRDeviceScanActivity)
        if (scanType == 2) {
            // 商城条形码 扫描
            viewModel.dispatchAction(QrDeviceScanUiAction.InitData(language, false, false, scanType))
        } else {
            viewModel.dispatchAction(QrDeviceScanUiAction.InitData(language, fromHome, filterQrCode, 0))
            deviceSannerDelegateImpl?.startScanDevice(clear = false)
        }
    }

    private fun checkCameraPermission(checkPermission: Boolean = true) {
        if (viewModel.uiStates.value.isCheckFirst) {
            viewModel.dispatchAction(QrDeviceScanUiAction.SettingIsCheckFirst(false))
        }

        if (XXPermissions.isGranted(this, Manifest.permission.CAMERA)) {
            cameraxScanFragment.startSpotAndShowRect()
        } else if (checkPermission) {
            ShowPermissionDialog.showPermissionDialog(
                baseContext,
                R.string.Toast_SystemServicePermission_CameraPhoto,
                {
                    cameraxScanFragment.stopSpotAndShowRect()
                },
                {
                    XXPermissions.with(this)
                        .permission(Permission.CAMERA)
                        .request(object : OnPermissionCallback2 {
                            override fun onGranted(permissions: List<String>, all: Boolean) {
                                if (all) {
                                    cameraxScanFragment.startSpotAndShowRect()
                                }
                            }

                            override fun onDenied2(
                                permissions: List<String>,
                                never: Boolean
                            ): Boolean {
                                cameraxScanFragment.stopSpotAndShowRect()
                                if (never) {
                                    showPermissionDialog(getString(R.string.common_permission_camera), Permission.CAMERA)
                                } else {
                                    ToastUtils.show(getString(R.string.get_permission_error))
                                }
                                // do nothing
                                return true
                            }
                        })
                })
        }
    }

    override fun onResume() {
        super.onResume()
        checkCameraPermission(viewModel.uiStates.value.isCheckFirst)
    }

    override fun onPause() {
        super.onPause()
        cameraxScanFragment.stopSpotAndShowRect()
    }

    override fun onStart() {
        super.onStart()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.EnterPage.code,
            hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = 0,
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.QRScanPage.code
        )
        BuriedConnectHelper.updateEnterType(0)
    }

    override fun onStop() {
        super.onStop()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.EnterPage.code,
            hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = (aliveTime / 1000).toInt(),
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.QRScanPage.code
        )
    }

    override fun onScanQRCodeSuccess(originResultList: List<String>, resultList: List<String>) {
        if (resultList.isNotEmpty()) {
            startVibrator()
        } else {
            // 没有匹配规则的二维码
            if (originResultList.isNotEmpty()) {
                //
                val list = originResultList.filter {
                    it.startsWith("https://app.mova-tech.com") || it.startsWith("http://app.mova-tech.com/") || it.startsWith("http://app.trouver-tech.com/")
                }
                if (list.isNotEmpty()) {
                    // toast 当前二维码无设备信息，请手动添加设备
                    ToastUtils.show(getString(R.string.current_device_nuInfo))
                    handler.postDelayed({
                        cameraxScanFragment.startSpotAndShowRect()
                    }, 1500)
                } else {
                    // toast 无法识别该二维码，请扫描设备上的二维码或尝试手动添加
                    ToastUtils.show(getString(R.string.qr_recognize_error))
                    handler.postDelayed({
                        cameraxScanFragment.startSpotAndShowRect()
                    }, 1500)
                }
            }
            return
        }
        if (resultList.size == 1) {
            onScanTouchSuccess(resultList[0])
        } else {
            // 多个不处理

        }
    }

    //
    override fun onScanTouchSuccess(result: String) {
        LogUtils.i("onScanTouchSuccess result: $result")
        cameraxScanFragment.stopSpotAndShowRect()
        viewModel.dispatchAction(QrDeviceScanUiAction.OnQRScanTouchSuccess(result))
    }

    private fun startVibrator() {
        val DELAY = 0
        val VIBRATE = 200
        val SLEEP = 100
        val START = -1
        val vibratePattern = longArrayOf(DELAY.toLong(), VIBRATE.toLong(), SLEEP.toLong())
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createWaveform(vibratePattern, START))
        } else {
            vibrator.vibrate(vibratePattern, START)
        }
    }


    private fun showFailedDialog() {
        BottomConfirmDialog(this).show(
            getString(R.string.qr_recognize_error),
            getString(R.string.retry),
            getString(R.string.qr_text_add_manually),
            {
                it.dismiss()
                cameraxScanFragment.startSpotAndShowRect()
            }, {
                it.dismiss()
                setResult(RESULT_CANCELED)
                finish()
            }
        )
    }

    private fun showPermissionDialog(permissionName: String = getString(R.string.common_permission_storage), vararg permission: String) {
        BottomConfirmDialog(this).show(
            getString(
                R.string.common_permission_fail_3,
                permissionName
            ),
            getString(R.string.common_permission_goto),
            getString(R.string.cancel),
            {
                it.dismiss()
                // 去设置页开启权限
                viewModel.dispatchAction(QrDeviceScanUiAction.FromSettingPage)
                XXPermissions.startPermissionActivity(
                    this,
                    permission
                )
            }, {
                LogUtils.d("onGranted: permission cancel setting to STEP_MANUAL_CONNECT")
                it.dismiss()
            }
        )

    }

    override fun dispatchTouchEvent(ev: MotionEvent?): Boolean {
        return super.dispatchTouchEvent(ev)
    }
}
