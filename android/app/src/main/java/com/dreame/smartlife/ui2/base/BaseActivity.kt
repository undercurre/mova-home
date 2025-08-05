package com.dreame.smartlife.ui2.base

import android.content.Context
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.StatusBarUtil
import android.dreame.module.util.SuperStatusUtil
import android.dreame.module.view.dialog.CustomProgressDialog
import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.viewbinding.ViewBinding
import com.dreame.smartlife.R
import java.lang.reflect.ParameterizedType

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

    private var loading:CustomProgressDialog? = null

    protected val binding: VB by lazy {
        val type = javaClass.genericSuperclass as ParameterizedType
        val aClass = type.actualTypeArguments[0] as Class<*>
        val method = aClass.getDeclaredMethod("inflate", LayoutInflater::class.java)
        method.invoke(null, layoutInflater) as VB
    }

    override fun attachBaseContext(newBase: Context) {
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


    private fun setStatusBar() {
        SuperStatusUtil.hieStatusBarAndNavigationBar(window.decorView)
        val isDark = DarkThemeUtils.isDarkTheme(this)
        SuperStatusUtil.setStatusBar(this, false, isDark, Color.TRANSPARENT)
        val status = findViewById<View>(R.id.view_status_bar)
        if (status != null) {
            val lp = status.layoutParams
            lp.height = StatusBarUtil.getStatusBarHeight(this)
            status.layoutParams = lp
        }
    }

    protected fun showLoading(){
        loading?.apply {
            dismiss()
        }
        loading = null
        loading = CustomProgressDialog(this)
        loading?.show()
    }

    protected fun dismissLoading(){
        loading?.dismiss()
        loading = null
    }

    protected abstract fun initData()

    protected abstract fun initView()

    open fun initListener() {}

    protected abstract fun observe()

    override fun onDestroy() {
        super.onDestroy()
    }
}