package com.dreame.module.base.mvi

import android.content.Context
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.StatusBarUtil
import android.dreame.module.util.SuperStatusUtil
import android.dreame.module.view.dialog.CustomProgressDialog
import android.graphics.Color
import android.os.Bundle
import android.os.SystemClock
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.viewbinding.ViewBinding
import com.dreame.module.base.ext.inflateBindingWithGeneric

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/07/30
 *     desc   :
 *     version: 1.0
 * </pre>
 */

abstract class BaseActivity<VB : ViewBinding> : AppCompatActivity() {

    private var loading: CustomProgressDialog? = null

    protected val binding: VB by lazy {
        inflateBindingWithGeneric(layoutInflater)
    }
    protected var aliveTime = 0L
    override fun attachBaseContext(newBase: Context?) {
        super.attachBaseContext(LanguageManager.getInstance().setLocal(newBase))
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)
        setStatusBar()
        initData()
        initView()
        initListener()
        observe()
    }

    override fun onStart() {
        super.onStart()
        aliveTime = SystemClock.elapsedRealtime()
    }

    override fun onStop() {
        super.onStop()
        aliveTime = SystemClock.elapsedRealtime() - aliveTime
    }

    private fun setStatusBar() {
        SuperStatusUtil.hieStatusBarAndNavigationBar(window.decorView)
        val isDark = DarkThemeUtils.isDarkTheme(this)
        SuperStatusUtil.setStatusBar(this, false, isDark, Color.TRANSPARENT)
        try {
            val statusBarId = resources.getIdentifier("view_status_bar", "id", packageName)
            val status = findViewById<View>(statusBarId)
            if (status != null) {
                val lp = status.layoutParams
                lp.height = StatusBarUtil.getStatusBarHeight(this)
                status.layoutParams = lp
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }

    protected fun showLoading() {
        loading?.apply {
            dismiss()
        }
        loading = null
        loading = CustomProgressDialog(this)
        loading?.show()
    }

    protected fun dismissLoading() {
        loading?.dismiss()
        loading = null
    }


    protected abstract fun initData()

    protected abstract fun initView()

    open fun initListener() {}

    protected abstract fun observe()

}