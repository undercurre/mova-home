package com.dreame.feature.connect.device.connect

import android.app.PendingIntent
import android.app.PendingIntent.FLAG_IMMUTABLE
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.manager.LanguageManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.ScreenUtils
import android.dreame.module.view.CommonTitleView
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Message
import android.text.SpannableString
import android.text.Spanned
import android.text.style.ForegroundColorSpan
import android.text.style.UnderlineSpan
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.activity.viewModels
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.IconCompat
import com.therouter.router.Route
import com.therouter.TheRouter
import com.blankj.utilcode.util.NotificationUtils
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.device.connect.DeviceConnectUiAction.CurrentStepId
import com.dreame.feature.connect.device.connect.DeviceConnectUiAction.StartSmartStepHelperUiAction
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.feature.connect.trace.EventConnectPageHelper
import com.dreame.feature.connect.views.ManualConnectTipsDialog
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.res.event.EventUiMode
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.*
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDeviceConnectBinding
import com.zj.mvi.core.observeEvent
import org.greenrobot.eventbus.EventBus

/**
 * 设备配网页面
 */
@Route(path = RoutPath.DEVICE_CONNECT)
class DeviceConnectActivity : BaseActivity<ActivityDeviceConnectBinding>(), WeakHandler.MessageHandleCallback {

    private val viewModel by viewModels<DeviceConnectViewModel>()

    val handler by lazy { WeakHandler(this) }
    private var isManualConnect = false

    override fun initData() {
        handleInitData(intent)
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        handleBackPressed()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleInitData(intent)
        initView()
    }

    private fun handleInitData(intent: Intent) {
        val productInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(
                ExtraConstants.EXTRA_PRODUCT_INFO, StepData.ProductInfo::class.java
            )
        } else {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO)
        }
        val stepId = intent.getIntExtra(ExtraConstants.EXTRA_STEP, -1)
        val stepResult = intent.getBooleanExtra(ExtraConstants.EXTRA_STEP_RESULT, false)
        val pairQRKey = intent.getStringExtra(ExtraConstants.EXTRA_QR_PAIR_KEY)
        val pairClickTime = intent.getLongExtra(ExtraConstants.EXTRA_QR_PAIR_DI, 0)
        val did = intent.getStringExtra(ExtraConstants.EXTRA_PARAM_DID) ?: ""
        viewModel.dispatchAction(
            DeviceConnectUiAction.InitData(
                productInfo, did, stepId, stepResult, pairQRKey
            )
        )
        viewModel.dispatchAction(
            DeviceConnectUiAction.QrNetWaitCostTime(
                false, false, pairClickTime
            )
        )

    }

    override fun initView() {
        isManualConnect = false
        binding.titleView.setTitle(getString(R.string.device_connecting))

        // fixbug: huawei R10 上UI适配问题 获取屏幕实际高度, 1080*1920 并且包含导航栏,则调整按钮距底部高度
        val realScreenHeight = ScreenUtils.getRealScreenHeight(this)
        val contentHeight = ScreenUtils.getContentHeight(this)
        val currentNavigationBarHeight = ScreenUtils.getCurrentNavigationBarHeight(this)
        if (contentHeight != realScreenHeight || currentNavigationBarHeight > 0) {
            if (contentHeight < 1920) {
                val layoutParams = binding.layoutManual.btnSettingWifi.layoutParams as ConstraintLayout.LayoutParams
                layoutParams.bottomMargin = ScreenUtils.dp2px(this, 48F)
                // binding.layoutManual.btnSettingWifi.layoutParams = layoutParams

                val layoutParams2 = binding.layoutStep.btnFinish.layoutParams as ConstraintLayout.LayoutParams
                layoutParams2.bottomMargin = ScreenUtils.dp2px(this, 48F)
                binding.layoutStep.btnFinish.layoutParams = layoutParams2
            }
        }

        binding.layoutStep.clStep.visibility = View.VISIBLE
        binding.layoutStep.btnFinish.isEnabled = false
        val qrCode = viewModel.uiStates.value.productInfo?.extendScType?.contains(ScanType.QR_CODE_V2) ?: false
        binding.layoutManual.tvChangeQrnet.visibility = if (qrCode) View.VISIBLE else View.GONE
        binding.layoutStep.indicator.setIndex(5)
        binding.layoutManual.indicator.setIndex(4)

//        binding.layoutStep.tvFailReason.paint.apply {
//            flags = flags or Paint.UNDERLINE_TEXT_FLAG
//        }
        // manual ui
        binding.layoutManual.clManual.visibility = View.GONE
        settingTipsShow(this)
        viewModel.dispatchAction(StartSmartStepHelperUiAction)

    }

    private fun settingTipsShow(context: Context) {
        val modelReplace = modelReplace()
        val language = LanguageManager.getInstance().getLangTag(this)
        if ("zh" == language) {
            if (modelReplace.startsWith("dreame")) {
                binding.layoutManual.ivDevice.setAnimation(R.raw.dreame_maunal_connect)
            } else {
                binding.layoutManual.ivDevice.setAnimation(R.raw.maunal_connect)
            }
        } else {
            if (modelReplace.startsWith("dreame")) {
                binding.layoutManual.ivDevice.setAnimation(R.raw.dreame_maunal_connect_en)
            } else {
                binding.layoutManual.ivDevice.setAnimation(R.raw.maunal_connect_en)
            }
        }
        val textNotFound = getString(R.string.text_not_found, modelReplace)
        binding.layoutManual.tvWifiNoFound.text = SpannableString(textNotFound).apply {
            setSpan(UnderlineSpan(), 0, length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        }
        val spannableString = SpannableString(
            getString(R.string.text_manual_connect_1, modelReplace)
        ).apply {
            val index = indexOf(modelReplace)
            if (index != -1) {
                setSpan(
                    ForegroundColorSpan(
                        ContextCompat.getColor(
                            context, R.color.common_brandAccent2
                        )
                    ), index, index + modelReplace.length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
        }
        binding.layoutManual.tvTip2.text = spannableString
    }

    private fun modelReplace(): String {
        val productModel = if (StepData.deviceApName.isBlank()) {
            viewModel.uiStates.value.productInfo?.productModel ?: ""
        } else {
            StepData.deviceApName.replace("-", ".")
        }
        val indexMova = productModel.indexOf("mova.")
        val indexDreame = productModel.indexOf("dreame.")

        val modelReplace = if (indexMova != -1) {
            val startIndex = "mova.".length
            val index2 = productModel.indexOf(".", startIndex)
            productModel.substring(0, index2).replace(".", "-") + "-xxx"
        } else if (indexDreame != -1) {
            val startIndex = "dreame.".length
            val index2 = productModel.indexOf(".", startIndex)
            productModel.substring(0, index2).replace(".", "-") + "-xxx"
        } else {
            "mova-xxx-xxx"
        }
        return modelReplace
    }

    private fun handleBackPressed() {
        // 如何配网成功，返回首页
        val stepId = SmartStepHelper.instance.getCurrentStepId()
        val currentStepId = viewModel.uiStates.value.currentStepId
        if ((currentStepId == -1 || currentStepId == 1) && stepId != -1 && currentStepId != stepId) {
            EventConnectPageHelper.insertStepEntity(
                StepData.eventId,
                StepData.deviceId,
                StepData.productModel,
                StepData.stepModeDefault,
                2,
                if (isManualConnect) 1 else 0,
                stepId,
                StepData.enterOrigin
            )
        }
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.PageCostTime.code, 0,
            StepData.deviceId,
            StepData.deviceModel(),
            int1 = 2,
            int2 = BuriedConnectHelper.currentEnterType(),
            int3 = StepData.pairNetMethod /*获取配网方式*/,
            int5 = StepData.calculateConnectCostTime(),
            str1 = BuriedConnectHelper.currentSessionID(),
            rawStr = StepData.capabilities ?: ""
        )
        onStepDestroy()
        if (viewModel.uiStates.value.isFinishSuccess > 0) {
            gotoFlutterHomePage()
        } else if (viewModel.uiStates.value.isFinishSuccess <= 0) {
            if (viewModel.uiStates.value.isFinishSuccess == -2 || viewModel.uiStates.value.isFinishSuccess == 0) {
                gotoTriggerAp()
            } else {
                gotoPreStepPage()
            }
        }

        finish()
    }

    override fun initListener() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                handleBackPressed()
            }
        })
        /********************* 手动点击 *******************/
        binding.layoutManual.btnSettingWifi.setOnShakeProofClickListener {
            LogUtil.i("btnSettingWifi: ${SmartStepHelper.instance.isManualConnectStep()}")
            handler.sendEmptyMessage(CLICK_MANUAL_SETTING)
        }
        binding.layoutManual.tvChangeQrnet.setOnShakeProofClickListener {
            LogUtil.i("tvChangeQrnet: ${SmartStepHelper.instance.isManualConnectStep()}")
            EventCommonHelper.eventCommonPageInsert(
                ModuleCode.PairNetNew.code,
                PairNetEventCode.TogglePairType.code,
                hashCode(),
                StepData.deviceId,
                StepData.deviceModel(),
                int1 = 1,
                str1 = BuriedConnectHelper.currentSessionID()
            )
            TheRouter.build(RoutPath.DEVICE_QR_NET).withParcelable(
                ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo
            ).navigation()
        }
        binding.layoutManual.tvWifiNoFound.setOnShakeProofClickListener {
            LogUtil.i("tvWifiNoFound: ${SmartStepHelper.instance.isManualConnectStep()}")
            val productModel = viewModel.uiStates.value.productInfo?.productModel ?: ""
            val path = if (productModel.contains("vacuum")) {
                RoutPath.DEVICE_BOOT_UP
            } else {
                RoutPath.DEVICE_TRIGGER_AP
            }
            TheRouter.build(path).withParcelable(
                ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo
            ).navigation()
            finish()
        }
        binding.layoutManual.ivPlay.setOnShakeProofClickListener {
            if (!binding.layoutManual.ivDevice.isAnimating) {
                binding.layoutManual.ivDevice.playAnimation()
            }
        }
        /********************* 手动点击 *******************/


    }

    override fun observe() {
        viewModel.uiEvents.observeEvent(this) { event ->
            when (event) {
                is DeviceConnectUiEvent.StartSmartStepHelperUiEvent -> {
                    val stepId = event.stepId
                    SmartStepHelper.instance.startFirstPage(this, handler, stepId)
                }

                else -> {}
            }
        }
    }

    override fun onStart() {
        super.onStart()
        Log.d("connectActivity", "onStart: $this")
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.EnterPage.code,
            hashCode(),
            StepData.deviceId,
            StepData.deviceModel(),
            int1 = 0,
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.PairDeviceProcessPage.code
        )
    }

    override fun onResume() {
        super.onResume()
        Log.d("connectActivity", "onResume: $this")
    }

    override fun onStop() {
        super.onStop()
        Log.d("connectActivity", "onStop: $isFinishing  $this")
        if (isFinishing) {
            onStepDestroy()
        }
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.ExitPage.code,
            hashCode(),
            StepData.deviceId,
            StepData.deviceModel(),
            int1 = (aliveTime / 1000).toInt(),
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.PairDeviceProcessPage.code
        )
    }


    override fun onDestroy() {
        Log.d("connectActivity", "onDestroy: $isFinishing $this")
        onStepDestroy()
        super.onDestroy()
    }

    fun onStepDestroy() {
        SmartStepHelper.instance.onDestroy()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        SmartStepHelper.instance.onActivityResult(requestCode, resultCode, data)
    }

    override fun handleMessage(message: Message) {
        if (message.obj is StepResult) {
            val result = message.obj as StepResult
            handleStepResult(result)
        } else if (message.what == StepData.CODE_CURRENT_WIFI) {
            // 更新UI
            val stepId = SmartStepHelper.instance.getCurrentStepId()
            if (stepId == StepId.STEP_MANUAL_CONNECT) {
                val text = "${getString(R.string.text_current_wifi_prefix)}${message.obj as String}"
                val text1 = binding.layoutManual.tvWifiName.text
                if (!text.equals(text1)) {
                    binding.layoutManual.tvWifiName.text = text
                }
            }
        } else {
            SmartStepHelper.instance.handleMessage(message)
        }
    }

    private fun handleStepResult(result: StepResult) {
        val (stepName, state, stepId, canManualConnect) = result
        viewModel.dispatchAction(CurrentStepId(stepId, result))
        LogUtil.i("Step", "handleMessage: result: $result, state: $state ,stepId: $stepId")
        when (stepName) {
            StepName.STEP_CONNECT -> {
                stepConnectUI(state, stepId, canManualConnect)
            }

            StepName.STEP_MAUNAL -> {
                LogUtil.i(
                    "Step", "handleMessage: result: $result, state: $state ,stepId: $stepId stepName :$stepName"
                )
                if (state == StepState.SUCCESS) {
                    dismissMaunalDialog()
                } else if (state == StepState.FAILED) {
                    showMaunalDialog()
                } else if (state == StepState.START) {
                    // 手动连接，发送连接成功通知
                    sendMaunalConnectSuccess()
                }

            }

            StepName.STEP_TRANSFORM -> {
                stepTransformUI(state, stepId, canManualConnect)
            }

            StepName.STEP_PAIR -> {
                stepPairUI(state, false)
            }

            StepName.STEP_QR_NET_PAIR -> {
                stepQrNetPairUI(state)
            }

            StepName.STEP_CHECK -> {
                // 如果是配网码配网则，
                if (viewModel.uiStates.value.stepId == StepId.STEP_QR_NET_PAIR) {
                    stepQrNetPairUI(state)
                } else {
                    stepPairUI(state, true)
                }
            }

            else -> {}
        }
    }

    private fun sendMaunalConnectSuccess() {
        val channelConfig = NotificationUtils.ChannelConfig(
            "connect_default", "ConnectDefault", NotificationUtils.IMPORTANCE_HIGH
        ).setShowBadge(false).setImportance(NotificationUtils.IMPORTANCE_HIGH)
        val activity = PendingIntent.getActivity(
            this, 199, Intent(this, DeviceConnectActivity::class.java), FLAG_IMMUTABLE
        )
        NotificationUtils.notify(1, channelConfig) {
            //                      it.setContent(RemoteViews(this.packageName,R.layout.))
            it.setLargeIcon(BitmapFactory.decodeResource(resources, R.mipmap.ic_launcher))
                .setSmallIcon(IconCompat.createWithResource(this, R.drawable.notifi_small_icon)).setAutoCancel(true)
                .setChannelId("connect_default").setBadgeIconType(NotificationCompat.BADGE_ICON_NONE)
                .setContentTitle(getString(R.string.app_name)).setContentText(getString(R.string.text_local_notification)).setShowWhen(true)
                .setWhen(System.currentTimeMillis()).setContentIntent(activity).setCategory(NotificationCompat.CATEGORY_MESSAGE)
                .setPriority(NotificationCompat.PRIORITY_HIGH).setVibrate(longArrayOf(0, 1000, 500, 1000))
        }
    }

    private var manualConnectTipsDialog: ManualConnectTipsDialog? = null
    private fun showMaunalDialog() {
        val modelReplace = modelReplace()
        if (manualConnectTipsDialog?.isShowing == true) {
            manualConnectTipsDialog?.dismiss()
        }
        manualConnectTipsDialog = ManualConnectTipsDialog(this)
        val language = LanguageManager.getInstance().getLangTag(this)
        val rawRes = if ("zh" == language) {
            if (modelReplace.startsWith("dreame")) {
                R.raw.dreame_maunal_connect
            } else {
                R.raw.maunal_connect
            }
        } else {
            if (modelReplace.startsWith("dreame")) {
                R.raw.dreame_maunal_connect_en
            } else {
                R.raw.maunal_connect_en
            }
        }
        manualConnectTipsDialog?.setApName(modelReplace)?.setAnimation(rawRes)?.showPopupWindow()
    }

    private fun dismissMaunalDialog() {
        if (manualConnectTipsDialog?.isShowing == true) {
            manualConnectTipsDialog?.dismiss()
            manualConnectTipsDialog = null
        }
    }

    private fun gotoStepFailInfo(step: Int) {
        val intent = Intent(intent).apply {
            putExtra("step", step)
            putExtra(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
            component = ComponentName(this@DeviceConnectActivity, StepFailInfoActivity::class.java)
        }
        startActivity(intent)
    }

    private fun gotoRouterPassword() {
        TheRouter.build(RoutPath.DEVICE_ROUTER_PASSWORD)
            .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo).navigation()
        finish()
    }

    private fun gotoTriggerAp() {
        TheRouter.build(RoutPath.DEVICE_TRIGGER_AP).withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
            .navigation()
        finish()
    }

    private fun gotoPreStepPage() {
        val productInfo = viewModel.uiStates.value.productInfo
        val path =
            if (productInfo?.productModel?.contains(".toothbrush.") == true || productInfo?.extendScType?.contains(ScanType.MCU) == true) {
                RoutPath.DEVICE_BOOT_UP
            } else {
                RoutPath.DEVICE_ROUTER_PASSWORD
            }
        TheRouter.build(path).withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo)
            .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            .navigation()
        finish()
    }

    private fun gotoFlutterHomePage() {
        onStepDestroy()
        // 等待
        RouteServiceProvider.getService<IFlutterBridgeService>()?.sendMessage("resetApp")
        RouteServiceProvider.getService<IFlutterBridgeService>()?.gotoFlutterPluginActivity()
        finish()
    }

    /**
     * 二维码配网
     */
    private fun stepQrNetPairUI(state: StepState) {
        if (binding.layoutManual.clManual.visibility != View.GONE) {
            binding.layoutManual.clManual.visibility = View.GONE
        }
        if (binding.layoutStep.clStep.visibility != View.VISIBLE) {
            binding.layoutStep.clStep.visibility = View.VISIBLE
        }
        if (binding.layoutStep.llStep1.visibility != View.VISIBLE) {
            binding.layoutStep.llStep1.visibility = View.VISIBLE
        }
        if (binding.layoutStep.llStep2.visibility != View.GONE) {
            binding.layoutStep.llStep2.visibility = View.GONE
        }
        if (binding.layoutStep.llStep3.visibility != View.GONE) {
            binding.layoutStep.llStep3.visibility = View.GONE
        }
        binding.layoutStep.nsvStep.pageScroll(View.FOCUS_DOWN)
        val ctx = DarkThemeUtils.createConfigurationContext(applicationContext)
        when (state) {
            StepState.START -> {
                viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(0))
                binding.layoutStep.llStep1.visibility = View.VISIBLE
                binding.layoutStep.tvStep1.setText(getString(R.string.query_devices_state))
                binding.layoutStep.tvStep1.setTextColor(
                    ContextCompat.getColor(
                        ctx, R.color.common_textLoading
                    )
                )
                binding.layoutStep.ivStep1.visibility = View.GONE
            }

            StepState.SUCCESS -> {
                LogUtil.d("配网码配网耗时：--------- end success --------- ")
                viewModel.dispatchAction(
                    DeviceConnectUiAction.QrNetWaitCostTime(
                        success = true, finish = true
                    )
                )
                binding.titleView.setTitle(getString(R.string.pair_success))
                binding.layoutStep.pbStep1.visibility = View.GONE
                binding.layoutStep.ivStep1.visibility = View.VISIBLE
                binding.layoutStep.ivStep1.setImageDrawable(
                    ContextCompat.getDrawable(
                        ctx, R.drawable.icon_step_success
                    )
                )
                binding.layoutStep.tvStep1.setText(getString(R.string.query_devices_state_success))
                binding.layoutStep.tvStep1.setTextColor(
                    ContextCompat.getColor(
                        ctx, R.color.common_textSuccess
                    )
                )
                viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(1))
                binding.layoutStep.btnFinish.setText(getString(R.string.complete))
                binding.layoutStep.btnFinish.setBackground(
                    ContextCompat.getDrawable(
                        ctx, R.drawable.common_selector_btn_r24
                    )
                )
                binding.layoutStep.btnFinish.setTextColor(
                    ContextCompat.getColor(
                        this, R.color.common_selector_btn
                    )
                )
                binding.layoutStep.btnFinish.isEnabled = true
                viewModel.dispatchAction(DeviceConnectUiAction.SaveWifiIInfo)
                binding.layoutStep.btnFinish.setOnShakeProofClickListener {
                    gotoFlutterHomePage()
                }
                EventBus.getDefault().post(EventMessage(EventCode.ADD_DEVICE_SUCCESS, StepData.deviceId))
                // 通知flutter
                RouteServiceProvider.getService<IFlutterBridgeService>()?.devicePairSuccess()
                EventConnectPageHelper.insertStepEntity(
                    StepData.eventId,
                    StepData.deviceId,
                    StepData.productModel,
                    StepData.stepModeDefault,
                    0,
                    if (isManualConnect) 1 else 0,
                    StepId.STEP_CHECK_DEVICE_ONLINE_STATE,
                    StepData.enterOrigin
                )
            }

            StepState.FAILED -> {
                LogUtil.d("配网码配网耗时：--------- end false --------- ")
                viewModel.dispatchAction(
                    DeviceConnectUiAction.QrNetWaitCostTime(
                        success = false, finish = true
                    )
                )
                binding.titleView.setTitle(getString(R.string.pair_failure))
                viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(-1))
                binding.layoutStep.pbStep1.visibility = View.GONE
                binding.layoutStep.ivStep1.visibility = View.VISIBLE
                binding.layoutStep.ivStep1.setImageDrawable(
                    ContextCompat.getDrawable(
                        ctx, R.drawable.icon_step_failed
                    )
                )
                binding.layoutStep.tvStep1.setText(getString(R.string.query_devices_state_failed))
                binding.layoutStep.tvStep1.setTextColor(
                    ContextCompat.getColor(
                        ctx, R.color.common_red1
                    )
                )
                binding.layoutStep.btnFinish.setText(getString(R.string.retry))
                binding.layoutStep.btnFinish.setBackground(
                    ContextCompat.getDrawable(
                        ctx, R.drawable.common_shape_btn_enable_r24
                    )
                )
                binding.layoutStep.btnFinish.setTextColor(
                    ContextCompat.getColor(
                        this, R.color.common_btnText
                    )
                )
                binding.layoutStep.btnFinish.isEnabled = true
                binding.layoutStep.btnFinish.setOnShakeProofClickListener {
                    gotoRouterPassword()
                }
                binding.layoutStep.tvFailReason.visibility = View.VISIBLE
                binding.layoutStep.tvFailReason.setOnShakeProofClickListener {
                    gotoStepFailInfo(3)
                }
                EventConnectPageHelper.insertStepEntity(
                    StepData.eventId,
                    StepData.deviceId,
                    StepData.productModel,
                    StepData.stepModeDefault,
                    0,
                    if (isManualConnect) 1 else 0,
                    StepId.STEP_CHECK_DEVICE_ONLINE_STATE,
                    StepData.enterOrigin
                )
            }

            else -> {
            }
        }
    }


    /**
     * 第三步
     */
    private fun stepPairUI(state: StepState, stepFinish: Boolean) {
        stepConnectUI(StepState.SUCCESS, 0, false)
        stepTransformUI(StepState.SUCCESS, 0, false)
        if (binding.layoutManual.clManual.visibility != View.GONE) {
            binding.layoutManual.clManual.visibility = View.GONE
        }
        if (binding.layoutStep.clStep.visibility != View.VISIBLE) {
            binding.layoutStep.clStep.visibility = View.VISIBLE
        }
        if (binding.layoutStep.llStep1.visibility != View.VISIBLE) {
            binding.layoutStep.llStep1.visibility = View.VISIBLE
        }
        if (binding.layoutStep.llStep2.visibility != View.VISIBLE) {
            binding.layoutStep.llStep2.visibility = View.VISIBLE
        }
        if (binding.layoutStep.llStep3.visibility != View.VISIBLE) {
            binding.layoutStep.llStep3.visibility = View.VISIBLE
        }
        binding.layoutStep.nsvStep.pageScroll(View.FOCUS_DOWN)
        val ctx = DarkThemeUtils.createConfigurationContext(applicationContext)

        when (state) {
            StepState.START -> {
                viewModel.dispatchAction(
                    DeviceConnectUiAction.WaitCostTime(
                        success = false, finish = false
                    )
                )
                viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(0))
                binding.layoutStep.pbStep3.visibility = View.VISIBLE
                binding.layoutStep.ivStep3.visibility = View.GONE

                binding.layoutStep.ivStep3.visibility = View.GONE
                binding.layoutStep.tvStep3.setText(getString(R.string.query_devices_state))
                binding.layoutStep.tvStep3.setTextColor(
                    ContextCompat.getColor(
                        this, R.color.common_textLoading
                    )
                )
            }

            StepState.SUCCESS -> {
                if (stepFinish) {
                    viewModel.dispatchAction(
                        DeviceConnectUiAction.WaitCostTime(
                            success = true, finish = true
                        )
                    )
                    binding.titleView.setTitle(getString(R.string.pair_success))
                    binding.layoutStep.pbStep3.visibility = View.GONE
                    binding.layoutStep.ivStep3.visibility = View.VISIBLE
                    binding.layoutStep.ivStep3.setImageDrawable(
                        ContextCompat.getDrawable(
                            ctx, R.drawable.icon_step_success
                        )
                    )
                    binding.layoutStep.tvStep3.setText(getString(R.string.query_devices_state_success))
                    binding.layoutStep.tvStep3.setTextColor(
                        ContextCompat.getColor(
                            this, R.color.common_textSuccess
                        )
                    )
                    viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(1))
                    binding.layoutStep.btnFinish.setText(getString(R.string.complete))
                    binding.layoutStep.btnFinish.setBackground(
                        ContextCompat.getDrawable(
                            ctx, R.drawable.common_selector_btn_r24
                        )
                    )
                    binding.layoutStep.btnFinish.setTextColor(
                        ContextCompat.getColor(
                            this, R.color.common_selector_btn
                        )
                    )
                    binding.layoutStep.btnFinish.isEnabled = true
                    viewModel.dispatchAction(DeviceConnectUiAction.SaveWifiIInfo)
                    binding.layoutStep.btnFinish.setOnShakeProofClickListener {
                        gotoFlutterHomePage()
                    }
                    EventBus.getDefault().post(EventMessage(EventCode.ADD_DEVICE_SUCCESS, StepData.deviceId))
                    // 通知flutter
                    RouteServiceProvider.getService<IFlutterBridgeService>()?.devicePairSuccess()
                    EventConnectPageHelper.insertStepEntity(
                        StepData.eventId,
                        StepData.deviceId,
                        StepData.productModel,
                        StepData.stepModeDefault,
                        0,
                        if (isManualConnect) 1 else 0,
                        StepId.STEP_CHECK_DEVICE_ONLINE_STATE,
                        StepData.enterOrigin
                    )
                }
            }

            StepState.FAILED -> {
                viewModel.dispatchAction(
                    DeviceConnectUiAction.WaitCostTime(
                        success = false, finish = true
                    )
                )
                binding.titleView.setTitle(getString(R.string.pair_failure))
                viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(-1))
                binding.layoutStep.pbStep3.visibility = View.GONE
                binding.layoutStep.ivStep3.visibility = View.VISIBLE
                binding.layoutStep.ivStep3.setImageDrawable(
                    ContextCompat.getDrawable(
                        ctx, R.drawable.icon_step_failed
                    )
                )
                binding.layoutStep.tvStep3.setTextColor(
                    ContextCompat.getColor(
                        this, R.color.common_red1
                    )
                )
                binding.layoutStep.tvStep3.setText(getString(R.string.query_devices_state_failed))
                binding.layoutStep.btnFinish.setText(getString(R.string.retry))
                binding.layoutStep.btnFinish.setBackground(
                    ContextCompat.getDrawable(
                        ctx, R.drawable.common_shape_btn_enable_r24
                    )
                )
                binding.layoutStep.btnFinish.setTextColor(
                    ContextCompat.getColor(
                        this, R.color.common_selector_btn
                    )
                )
                binding.layoutStep.btnFinish.isEnabled = true
                binding.layoutStep.btnFinish.setOnShakeProofClickListener {
                    gotoPreStepPage()
                }
                binding.layoutStep.tvFailReason.visibility = View.VISIBLE
                binding.layoutStep.tvFailReason.setOnShakeProofClickListener {
                    gotoStepFailInfo(3)
                }
                EventConnectPageHelper.insertStepEntity(
                    StepData.eventId,
                    StepData.deviceId,
                    StepData.productModel,
                    StepData.stepModeDefault,
                    1,
                    if (isManualConnect) 1 else 0,
                    StepId.STEP_CHECK_DEVICE_PAIR_STATE,
                    StepData.enterOrigin
                )
            }

            else -> {
            }
        }
    }

    /**
     * 第二步
     */
    private fun stepTransformUI(state: StepState, stepId: Int, canManualConnect: Boolean) {
        stepConnectUI(StepState.SUCCESS, 0, false)
        if (binding.layoutManual.clManual.visibility != View.GONE) {
            binding.layoutManual.clManual.visibility = View.GONE
        }
        if (binding.layoutStep.clStep.visibility != View.VISIBLE) {
            binding.layoutStep.clStep.visibility = View.VISIBLE
        }
        if (binding.layoutStep.llStep1.visibility != View.VISIBLE) {
            binding.layoutStep.llStep1.visibility = View.VISIBLE
        }
        if (binding.layoutStep.llStep2.visibility != View.VISIBLE) {
            binding.layoutStep.llStep2.visibility = View.VISIBLE
        }
        if (binding.layoutStep.llStep3.visibility != View.GONE) {
            binding.layoutStep.llStep3.visibility = View.GONE
        }
        binding.layoutStep.nsvStep.pageScroll(View.FOCUS_DOWN)
        val ctx = DarkThemeUtils.createConfigurationContext(applicationContext)
        when (state) {
            StepState.START -> {
                viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(0))
                binding.layoutStep.pbStep2.visibility = View.VISIBLE
                binding.layoutStep.ivStep2.visibility = View.GONE

                binding.layoutStep.ivStep2.visibility = View.GONE
                binding.layoutStep.tvStep2.setText(getString(R.string.sending_data_to_device))
                binding.layoutStep.tvStep2.setTextColor(
                    ContextCompat.getColor(
                        this, R.color.common_textLoading
                    )
                )

            }

            StepState.SUCCESS -> {
                viewModel.dispatchAction(
                    DeviceConnectUiAction.WaitCostTime(
                        success = false, finish = false
                    )
                )
                binding.layoutStep.pbStep2.visibility = View.GONE
                binding.layoutStep.ivStep2.visibility = View.VISIBLE
                binding.layoutStep.ivStep2.setImageDrawable(
                    ContextCompat.getDrawable(
                        ctx, R.drawable.icon_step_success
                    )
                )
                binding.layoutStep.tvStep2.setText(getString(R.string.send_data_to_device_success))
                binding.layoutStep.tvStep2.setTextColor(
                    ContextCompat.getColor(
                        this, R.color.common_textSuccess
                    )
                )

            }

            StepState.FAILED -> {
                // manual ui
                viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(-2))
                binding.titleView.setTitle(getString(R.string.text_connect_device_hotspot))
                binding.layoutStep.clStep.visibility = View.GONE
                binding.layoutManual.clManual.visibility = View.VISIBLE
                binding.layoutManual.ivPlay.performClick()
                val text = "${getString(R.string.text_current_wifi_prefix)}${SmartStepHelper.instance.currentWifiName()}"
                binding.layoutManual.tvWifiName.text = text
                isManualConnect = true
            }

            StepState.STOP -> {
                binding.titleView.setTitle(getString(R.string.pair_failure))
                viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(-1))
                binding.layoutStep.pbStep2.visibility = View.GONE
                binding.layoutStep.ivStep2.visibility = View.VISIBLE
                binding.layoutStep.ivStep2.setImageDrawable(
                    ContextCompat.getDrawable(
                        ctx, R.drawable.icon_step_failed
                    )
                )
                binding.layoutStep.tvStep2.setTextColor(
                    ContextCompat.getColor(
                        this, R.color.common_red1
                    )
                )
                binding.layoutStep.tvStep2.setText(getString(R.string.send_data_to_device_failed))
                binding.layoutStep.btnFinish.setText(getString(R.string.retry))
                binding.layoutStep.btnFinish.setBackground(
                    ContextCompat.getDrawable(
                        ctx, R.drawable.common_shape_btn_enable_r24
                    )
                )
                binding.layoutStep.btnFinish.setTextColor(
                    ContextCompat.getColor(
                        this, R.color.common_selector_btn
                    )
                )
                binding.layoutStep.btnFinish.isEnabled = true
                binding.layoutStep.btnFinish.setOnShakeProofClickListener {
                    gotoPreStepPage()
                }
                binding.layoutStep.tvFailReason.visibility = View.VISIBLE
                binding.layoutStep.tvFailReason.setOnShakeProofClickListener {
                    gotoStepFailInfo(2)
                }
                EventConnectPageHelper.insertStepEntity(
                    StepData.eventId,
                    StepData.deviceId,
                    StepData.productModel,
                    StepData.stepModeDefault,
                    1,
                    if (isManualConnect) 1 else 0,
                    stepId,
                    StepData.enterOrigin
                )
            }
        }
    }

    /**
     * 第一步
     */
    private fun stepConnectUI(state: StepState, stepId: Int, canManualConnect: Boolean) {
        if (binding.layoutManual.clManual.visibility != View.GONE) {
            binding.layoutManual.clManual.visibility = View.GONE
        }
        if (binding.layoutStep.clStep.visibility != View.VISIBLE) {
            binding.layoutStep.clStep.visibility = View.VISIBLE
        }
        if (binding.layoutStep.llStep1.visibility != View.VISIBLE) {
            binding.layoutStep.llStep1.visibility = View.VISIBLE
        }
        if (binding.layoutStep.llStep2.visibility != View.GONE) {
            binding.layoutStep.llStep2.visibility = View.GONE
        }
        if (binding.layoutStep.llStep3.visibility != View.GONE) {
            binding.layoutStep.llStep3.visibility = View.GONE
        }
        binding.titleView.setTitle(getString(R.string.device_connecting))
        val ctx = DarkThemeUtils.createConfigurationContext(applicationContext)
        when (state) {
            StepState.START -> {
                binding.layoutStep.tvStep1.setText(getString(R.string.phone_connecting_device))
                binding.layoutStep.tvStep1.setTextColor(
                    ContextCompat.getColor(
                        ctx, R.color.common_textLoading
                    )
                )
                viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(0))
                binding.layoutStep.ivStep1.visibility = View.GONE
                binding.layoutStep.pbStep1.visibility = View.VISIBLE
            }

            StepState.SUCCESS -> {
                binding.layoutStep.pbStep1.visibility = View.GONE
                binding.layoutStep.ivStep1.visibility = View.VISIBLE
                binding.layoutStep.ivStep1.setImageDrawable(
                    ContextCompat.getDrawable(
                        ctx, R.drawable.icon_step_success
                    )
                )
                binding.layoutStep.tvStep1.setText(getString(R.string.phone_connect_device_success))
                binding.layoutStep.tvStep1.setTextColor(
                    ContextCompat.getColor(
                        ctx, R.color.common_textSuccess
                    )
                )

            }

            StepState.FAILED -> {
                if (canManualConnect) {
                    // manual ui
                    viewModel.dispatchAction(DeviceConnectUiAction.ConnectStatus(-2))
                    binding.titleView.setTitle(getString(R.string.text_connect_device_hotspot))
                    binding.layoutStep.clStep.visibility = View.GONE
                    binding.layoutManual.clManual.visibility = View.VISIBLE
                    binding.layoutManual.ivPlay.performClick()
                    val text = "${getString(R.string.text_current_wifi_prefix)}${SmartStepHelper.instance.currentWifiName()}"
                    binding.layoutManual.tvWifiName.text = text
                    isManualConnect = true
                } else {
                    binding.layoutStep.pbStep1.visibility = View.GONE
                    binding.layoutStep.ivStep1.visibility = View.VISIBLE
                    binding.layoutStep.ivStep1.setImageDrawable(
                        ContextCompat.getDrawable(
                            ctx, R.drawable.icon_step_failed
                        )
                    )
                    binding.layoutStep.tvStep1.setText(getString(R.string.phone_connect_device_failed))

                    binding.layoutStep.btnFinish.setText(getString(R.string.retry))
                    binding.layoutStep.btnFinish.setBackground(
                        ContextCompat.getDrawable(
                            ctx, R.drawable.common_shape_btn_enable_r24
                        )
                    )
                    binding.layoutStep.btnFinish.setTextColor(
                        ContextCompat.getColor(
                            ctx, R.color.common_selector_btn
                        )
                    )
                    binding.layoutStep.btnFinish.isEnabled = true
                    binding.layoutStep.btnFinish.setOnShakeProofClickListener {
                        gotoPreStepPage()
                    }
                    binding.layoutStep.tvFailReason.visibility = View.VISIBLE
                    binding.layoutStep.tvFailReason.setOnShakeProofClickListener {
                        gotoStepFailInfo(1)
                    }

                }
            }

            else -> {
            }
        }
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        val isDark = DarkThemeUtils.isDarkTheme(baseContext.applicationContext)
        // 通知Flutter 刷新changeAppTheme
        // 暗黑适配参考文档:[https://www.cnblogs.com/baiqiantao/p/14495880.html#%E7%9B%91%E5%90%AC%E6%B7%B1%E8%89%B2%E6%A8%A1%E5%BC%8F%E7%8A%B6%E6%80%81%E6%94%B9%E5%8F%98]
        DarkThemeUtils.changeThemeMode(this)
        EventBus.getDefault().post(EventUiMode(isDark))
        updateUI(isDark)
    }

    private fun updateUI(isDark: Boolean) {
        val ctx = DarkThemeUtils.createConfigurationContext(applicationContext)
        window.setBackgroundDrawable(ContextCompat.getDrawable(ctx, R.color.common_layoutBg))
        binding.titleView.findViewById<ImageView>(R.id.iv_left).setImageDrawable(ContextCompat.getDrawable(ctx, R.drawable.icon_back_black))
        binding.titleView.findViewById<TextView>(R.id.tv_center_title).setTextColor(ContextCompat.getColor(ctx, R.color.common_textMain))
        binding.titleView.findViewById<TextView>(R.id.tv_center_subtitle).setTextColor(ContextCompat.getColor(ctx, R.color.common_textMain))
        binding.layoutStep.tvTips.setTextColor(ContextCompat.getColor(ctx, R.color.common_textMain))
        binding.layoutStep.tvFailReason.setTextColor(ContextCompat.getColor(ctx, R.color.common_text_second))
        binding.layoutStep.btnFinish.setTextColor(ContextCompat.getColor(ctx, R.color.common_selector_btn))
        binding.layoutStep.btnFinish.setBackground(ContextCompat.getDrawable(ctx, R.drawable.common_selector_btn_r24))
        // 重新刷一下UI
        binding.layoutManual.tvWifiName.setTextColor(ContextCompat.getColor(ctx, R.color.common_textMain))
        binding.layoutManual.tvTip1.setTextColor(ContextCompat.getColor(ctx, R.color.common_textMain))
        binding.layoutManual.tvTip2.setTextColor(ContextCompat.getColor(ctx, R.color.common_textMain))
        binding.layoutManual.tvTip3.setTextColor(ContextCompat.getColor(ctx, R.color.common_textMain))
        binding.layoutManual.tvWifiNoFound.setTextColor(ContextCompat.getColor(ctx, R.color.common_textMain))
        settingTipsShow(ctx)
        binding.layoutManual.tvChangeQrnet.setTextColor(ContextCompat.getColor(ctx, R.color.common_text_main))
        binding.layoutManual.tvChangeQrnet.setBackground(ContextCompat.getDrawable(ctx, R.drawable.common_shape_btn_second_r8))

        handleStepResult(viewModel.uiStates.value.stepResult ?: StepResult(StepName.STEP_CONNECT, StepState.START))
    }
}