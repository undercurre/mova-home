package com.dreame.movahome.ui.activity

import android.content.Context
import android.content.Intent
import android.dreame.module.LocalApplication
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.data.entry.ad.AdModelConfig
import android.dreame.module.ext.dp
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.CheckRootUtil
import android.dreame.module.util.DarkThemeUtils.getThemeSetting
import android.dreame.module.util.DarkThemeUtils.setApplicationDarkThemeStyle
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.toast.ToastUtils
import android.media.AudioManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.lifecycleScope
import com.airbnb.lottie.LottieAnimationView
import com.blankj.utilcode.util.BarUtils
import com.bumptech.glide.Glide
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.module.service.appwidget.IAppWidgetDeviceService
import com.dreame.movahome.MainApplication
import com.dreame.smartlife.R
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.ui.StyledPlayerView
import com.therouter.router.Route
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.util.concurrent.atomic.AtomicBoolean
import androidx.core.content.edit


/**
 * do nothing
 */
@Route(path = RoutPath.SPLASH_PAGE)
class SplashActivity : FragmentActivity() {

    companion object {
        const val SPLASH_AD_TYPE = "SPLASH_AD"
    }

    private val mHandler = Handler(Looper.getMainLooper())
    private var config: AdModelConfig? = null
    private var audioManager: AudioManager? = null

    private val isGotoNext = AtomicBoolean(false)

    private var player: ExoPlayer? = null

    private val ivSplashDreame: View by lazy {
        findViewById(R.id.iv_splash_dreame)
    }

    private val viewDefaultBg: View by lazy {
        findViewById(R.id.view_default_bg)
    }

    private val rlMediaBg: View by lazy {
        findViewById(R.id.rl_media_bg)
    }

    private val llSkip: LinearLayout by lazy {
        findViewById(R.id.ll_skip)
    }

    private val playerView: StyledPlayerView by lazy {
        findViewById(R.id.video_view)
    }
    private val lottieView: LottieAnimationView by lazy {
        findViewById(R.id.lottie_view)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        LogUtil.d("NFCActivity debug SplashActivity onCreate")
        super.onCreate(savedInstanceState)
        BarUtils.transparentStatusBar(this)
        BarUtils.transparentNavBar(this)
        setContentView(R.layout.activity_splash)
        initView()
        initData()
        MainApplication.setHasStartedSplash(true)
    }

    private fun initView() {
        val layoutParams = llSkip.layoutParams as ViewGroup.MarginLayoutParams
        layoutParams.setMargins(15.dp(), BarUtils.getStatusBarHeight() + 15.dp(), 15.dp(), 0)
        llSkip.layoutParams = layoutParams
    }

    override fun onDestroy() {
        super.onDestroy()
        player?.release()
    }

    fun initData() {
        lifecycleScope.launch {
            withContext(Dispatchers.IO) {
                // 设置页面模式
                val mode = getThemeSetting(this@SplashActivity)
                if (mode > 0) {
                    withContext(Dispatchers.Main) {
                        setApplicationDarkThemeStyle(mode)
                    }
                }
                kotlin.runCatching {
                    RouteServiceProvider.getService<IAppWidgetDeviceService>()
                        ?.flushAllWidget(applicationContext)
                }
            }
        }

        mHandler.postDelayed({ llSkip.visibility = View.VISIBLE }, 1000)
        llSkip.setOnClickListener { gotoNext() }

        val oAuthBean = AccountManager.getInstance()
            .getAccount(LocalApplication.getInstance().applicationContext)
        val countryCode = AreaManager.getCountryCode()

        val sp = getSharedPreferences("ad_splash", Context.MODE_PRIVATE)
        val appSplashConfig =
            sp.getString("flutter.${oAuthBean.uid}-${countryCode}-adSplash", "") ?: ""

        try {
            if (appSplashConfig.isNotEmpty()) {
                config = GsonUtils.fromJson(appSplashConfig, AdModelConfig::class.java)
            } else {
                LogUtil.d("initData config init appSplashConfig is empty")
            }
        } catch (e: Exception) {
            LogUtil.e("initData config init appSplashConfig error $e")
        }
        initLaunchView()
        if (!AccountManager.getInstance().isFirstLogin) {
            if (CheckRootUtil.isRooted(this)) {
                ToastUtils.show(this.getString(R.string.text_device_rooted))
            }
        }
    }

    private fun initLaunchView() {
        val currentTimeStamp = System.currentTimeMillis()

        if (config == null) {
            // 如果不延时直接跳转，设置的启动背景图会一直等到 flutter 引擎加载完成
            mHandler.postDelayed({ gotoNext() }, 0)
            return
        }

        config?.let {
            if (it.adModel.picFilePath == null ||
                it.adModel.endDateTimeStamp < 0 ||
                currentTimeStamp >= it.adModel.endDateTimeStamp ||
                !File(it.adModel.picFilePath!!.appendFlutterPath()).exists()
            ) {
                mHandler.postDelayed({ gotoNext() }, 0)
                return
            }

            // 是否展示过广告
            if (it.popShowTime <= 0) {
                showSplashAd(it.adModel.picFilePath!!)
                it.popShowTime = it.adModel.nextShowDay
                saveAdConfig()
                return
            }

            // 排除showAgain为0，即不再展示的情况
            val showAgain = it.adModel.showAgain
            if (showAgain == 0 && it.isClicked) {
                mHandler.postDelayed({ gotoNext() }, 0)
                return
            }

            // 正常按周期展示广告
            val nextShowTime = it.adModel.nextShowDay
            // 再一次到了广告展示频率周期内
            if (currentTimeStamp in (it.popShowTime + 1) until nextShowTime) {
                showSplashAd(it.adModel.picFilePath!!)
                it.popShowTime = it.adModel.nextShowDay
                saveAdConfig()
            } else {
                mHandler.postDelayed({ gotoNext() }, 0)
            }
        }
    }

    private fun showSplashAd(path: String) {
        rlMediaBg.visibility = View.VISIBLE
        viewDefaultBg.visibility = View.GONE

        val iv = findViewById<ImageView>(R.id.iv_dreame)
        iv.visibility = View.VISIBLE
        iv.setOnClickListener {
            config?.let {
                it.isClicked = true
                saveAdConfig()
                gotoNext(true)
            }
        }
        Glide.with(this)
            .load(path.appendFlutterPath())
            .into(iv)

        mHandler.postDelayed({
            gotoNext()
        }, 2000)
    }

    private fun gotoNext(isAdClicked: Boolean = false) {
        if (!isGotoNext.compareAndSet(false, true)) return
        val args: MutableMap<String, Any> = when {
            isAdClicked -> {
                config?.let {
                    try {
                        mutableMapOf(
                            "schemeType" to SPLASH_AD_TYPE,
                            "ext" to GsonUtils.toJson(it.adModel)
                        )
                    } catch (e: Exception) {
                        LogUtil.d("GsonUtils.toJson adModel error = ${e.message}")
                        mutableMapOf()
                    }
                } ?: mutableMapOf()
            }

            else -> {
                mutableMapOf()
            }
        }

        startActivity(
            RouteServiceProvider.getService<IFlutterBridgeService>()
                ?.openMainFlutter(this, "/root", args)
        )
        finish()
        overridePendingTransition(0, 0)
    }

    override fun attachBaseContext(newBase: Context?) {
        super.attachBaseContext(LanguageManager.getInstance().setLocal(newBase))
    }

    private fun saveAdConfig() {
        if (config == null) {
            return
        }

        val oAuthBean = AccountManager.getInstance()
            .getAccount(LocalApplication.getInstance().applicationContext)
        val countryCode = AreaManager.getCountryCode()
        val sp = getSharedPreferences("ad_splash", Context.MODE_PRIVATE)

        sp.edit {
            putString(
                "flutter.${oAuthBean.uid}-${countryCode}-adSplash",
                GsonUtils.toJson(config)
            )
        }
    }

    private fun String.appendFlutterPath(): String {
        val flutterPath = applicationContext.getDir("flutter", Context.MODE_PRIVATE).absolutePath
        return "$flutterPath/$this"
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        LogUtil.d("NFCActivity debug SplashActivity onNewIntent")
    }
}