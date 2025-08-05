package com.dreame.feature.connect.device.trigger

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.content.Intent
import android.content.pm.PackageManager
import android.dreame.module.RoutPath
import android.dreame.module.base.permission.OnPermissionCallback2
import android.dreame.module.constant.ParameterConstants
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.manager.LanguageManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.util.toast.ToastUtils
import android.dreame.module.view.CommonTitleView
import android.os.Build
import android.provider.Settings
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import com.therouter.router.Route
import com.therouter.TheRouter
import com.dreame.feature.connect.config.step.bluetooth.BleDeviceScanner
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.feature.connect.views.TriggerDeviceApTipsPopupwindow
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.config.step.ScanType
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDevcieTriggerApBinding
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState


/**
 * 触发机器热点
 */
@Route(path = RoutPath.DEVICE_TRIGGER_AP)
class DeviceTriggerAPActivity : BaseActivity<ActivityDevcieTriggerApBinding>() {
    val viewModel by viewModels<DeviceTriggerViewModel>()

    val locPermission =
        listOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION, Permission.BLUETOOTH_SCAN, Permission.BLUETOOTH_CONNECT)
    val bluetoothPermission = listOf(Permission.BLUETOOTH_SCAN, Permission.BLUETOOTH_CONNECT)

    override fun initData() {
        val language = LanguageManager.getInstance().getLangTag(this)
        val productInfo = intent.getParcelableExtra<StepData.ProductInfo>(ExtraConstants.EXTRA_PRODUCT_INFO)
        viewModel.dispatchAction(DeviceTriggerUiAction.InitData(language, productInfo))
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
            str2 = PairNetPageId.TriggerWifiApPage.code
        )
    }

    override fun onStop() {
        super.onStop()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.ExitPage.code,
            hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = (aliveTime / 1000).toInt(),
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.TriggerWifiApPage.code
        )
    }

    override fun onRestart() {
        super.onRestart()
        viewModel.dispatchAction(DeviceTriggerUiAction.NewIntent)
    }

    override fun initView() {
        binding.indicator.setIndex(3)
    }

    override fun initListener() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }
        })
        binding.ctvStatus.setOnCheckedChangeListener { buttonView, isChecked ->
            viewModel.dispatchAction(DeviceTriggerUiAction.ClickReset(isChecked, false))
        }
        binding.tvConfirm.setOnShakeProofClickListener {
            viewModel.dispatchAction(DeviceTriggerUiAction.CheckStayTime)
        }
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, DeviceTriggerUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }
        viewModel.uiStates.observeState(
            this,
            DeviceTriggerUiState::isReset,
            DeviceTriggerUiState::isSettingView
        ) { isReset, isSettingView ->
            binding.tvConfirm.isEnabled = isReset
            if (isSettingView) {
                binding.ctvStatus.isChecked = isReset
            }
        }
        viewModel.uiStates.observeState(this, DeviceTriggerUiState::productImageUrl) {
            ImageLoaderProxy.getInstance().displayImage(this, it, binding.ivDevice)
        }
        viewModel.uiStates.observeState(this, DeviceTriggerUiState::productTitle, DeviceTriggerUiState::productIntro) { title, intro ->
            binding.tvContent.text = intro
        }

        viewModel.uiEvents.observeEvent(this) { action ->
            when (action) {
                is DeviceTriggerUiEvent.ShowToast -> {
                    ToastUtils.show(action.message)
                }

                is DeviceTriggerUiEvent.ShowStayTips -> {
                    showStayTips()
                }

                is DeviceTriggerUiEvent.OpenBluetooth -> {
                    checkBLeStatusBlock(action.forceOpen, action.again)
                }

                is DeviceTriggerUiEvent.GotoNext -> {
                    // 扫码配网
                    val isQrScan = viewModel.uiStates.value.productInfo?.enterOrigin == ParameterConstants.ORIGIN_QR
                    val isScan = viewModel.uiStates.value.productInfo?.enterOrigin == ParameterConstants.ORIGIN_SCAN
                    // 二维码配网
                    val isQrCode = viewModel.uiStates.value.productInfo?.extendScType?.contains(ScanType.QR_CODE_V2)
                        ?: false
                    // mcu 配网
                    val isMcu = viewModel.uiStates.value.productInfo?.extendScType?.contains(ScanType.MCU)
                        ?: false
                    val path = if (isQrScan) {
                        val deviceWifiName = viewModel.uiStates.value.productInfo?.deviceWifiName
                        if (deviceWifiName.isNullOrBlank()) {
                            RoutPath.DEVICE_SCAN_NEARYBY
                        } else {
                            RoutPath.DEVICE_QR_CONNECT_TIPS
                        }
                    } else if (isScan) {
                        RoutPath.DEVICE_CONNECT
                    } else if (isMcu) {
                        RoutPath.DEVICE_CONNECT
                    } else {
                        val model = viewModel.uiStates.value.productInfo?.productModel
                        if (isQrCode) RoutPath.DEVICE_QR_NET else RoutPath.DEVICE_SCAN_NEARYBY
                    }
                    TheRouter.build(path)
                        .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                        .navigation()
                }

                else -> {}
            }
        }
    }

    private fun showStayTips() {
        TriggerDeviceApTipsPopupwindow(this)
            .onCancelClick {
                viewModel.dispatchAction(DeviceTriggerUiAction.ClickReset(false, true))
            }
            .onConfirmClick {
                viewModel.dispatchAction(DeviceTriggerUiAction.CheckBluetoothOpen)
            }
            .url(viewModel.uiStates.value.productImageUrl ?: "")
            .showPopupWindow()
    }

    private fun checkBLeStatusBlock(forceOpen: Boolean, again: Boolean) {
        val permission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            bluetoothPermission
        } else {
            locPermission
        }
        if (XXPermissions.isGranted(this, permission)) {
            if (!again && !BleDeviceScanner.isOpen()) {
                showBleClosedDialog()
            } else {
                viewModel.dispatchAction(DeviceTriggerUiAction.ClickGotoNext)
            }
        } else if (forceOpen) {
            XXPermissions.with(this)
                .permission(permission)
                .request(object : OnPermissionCallback2 {
                    override fun onGranted(permissions: MutableList<String>, all: Boolean) {
                        if (all) {
                            if (!BleDeviceScanner.isOpen()) {
                                showBleClosedDialog()
                            }
                        }
                    }

                    override fun onDenied2(
                        permissions: MutableList<String>,
                        never: Boolean
                    ): Boolean {
                        showSettingDialog(permission)
                        return true
                    }
                })
        } else {
            viewModel.dispatchAction(DeviceTriggerUiAction.ClickGotoNext)
        }

    }

    private fun showBleClosedDialog() {
        // 蓝牙 关闭
        BottomConfirmDialog(this).show(getString(R.string.scanning_bluetooth_close),
            getString(R.string.text_goto_open),
            getString(R.string.cancel), { dialog: BottomConfirmDialog ->
                dialog.dismiss()
                if (!BleDeviceScanner.isOpen()) {
                    val granted = if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
                        checkSelfPermission(Manifest.permission.BLUETOOTH) == PackageManager.PERMISSION_GRANTED
                    } else {
                        XXPermissions.isGranted(this, Permission.BLUETOOTH_CONNECT)
                    }
                    if (granted) {
                        bluetoothLauncher.launch(Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE))
                    } else {
                        startActivity(Intent(Settings.ACTION_BLUETOOTH_SETTINGS))
                    }
                }
            }) { dialog: BottomConfirmDialog ->
            dialog.dismiss()
            // 不是只支持BLE配网，点击取消，则跳转下一页，输入密码

        }
    }

    /**
     * 请求位置权限
     * @param settingBlock      去设置页开启权限
     */
    private fun showSettingDialog(permission: List<String>) {
        val content = if (permission.containsAll(locPermission.toList())) {
            getString(
                R.string.common_permission_fail_3,
                getString(R.string.common_permission_location)
            )
        } else {
            getString(R.string.text_scan_ble_tips)
        }
        BottomConfirmDialog(this).show(
            content,
            getString(R.string.common_permission_goto),
            getString(R.string.cancel),
            {
                it.dismiss()
                // 去设置页开启权限
                XXPermissions.startPermissionActivity(this, permission)
            }, {
                it.dismiss()
                finish()
            }
        )
    }

    private val bluetoothLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->

    }

}